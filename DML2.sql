/*
    <INSERT>
    테이블에 새로운 행을 추가하는 구문
        INSERT INTO 테이블명 (서브쿼리);
*/
-- 테이블 전체를 복사
CREATE TABLE EMP_01 AS SELECT * FROM EMP;
SELECT * FROM EMP_01;

-- 테이블 구조를 복사 (데이터 X)
CREATE TABLE EMP_02 AS SELECT * FROM EMP WHERE 1<0;
SELECT * FROM EMP_02;

-- 테이블에서 일부 구조만(특정 컬럼만) 복사
CREATE TABLE EMP_03 AS SELECT EMP_ID, EMP_NAME FROM EMP WHERE 1<0;
SELECT * FROM EMP_03;

CREATE TABLE EMP_COPY (
    EMP_ID NUMBER
    , EMP_NAME VARCHAR2(30)
    , DEPT_TITLE VARCHAR2(50)
);

-- 서브쿼리를 이용해서 데이터를 입력하기
INSERT INTO EMP_COPY (
            SELECT EMP.EMP_ID, EMP_NAME, DEPT_TITLE
            FROM EMP
            LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID))
;
SELECT * FROM EMP_COPY;
ROLLBACK;
DROP TABLE EMP_01;
DROP TABLE EMP_02;
DROP TABLE EMP_03;
DROP TABLE EMP_COPY;

-- 서브쿼리를 이용해서 테이블을 생성하기
CREATE TABLE EMP_COPY 
AS ( SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMP, DEPT
    WHERE DEPT_CODE = DEPT_ID )
;

-- AS 뒤에서는 서브쿼리를 ()괄호로 묶지않아도 생성이 된다 ! 
--CREATE TABLE EMP_COPY 
--AS  SELECT EMP_ID, EMP_NAME, DEPT_TITLE
--    FROM EMP, DEPT
--    WHERE DEPT_CODE = DEPT_ID(+)
--;

CREATE TABLE EMP_INFO
-- 테이블 생성 시 AS 서브쿼리로 가져오는 컬럼에 별칭을 달면 그게 컬럼명이 된다. 
AS ( SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명
        FROM EMP
        LEFT JOIN JOB USING(JOB_CODE)           
        LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID))
;
SELECT * FROM EMP_INFO ORDER BY 사번;

-- EMP_INFO 테이블 전체 데이터 지우기 
DELETE FROM EMP_INFO;

-- EMP 테이블에서 특정 데이터만 복사해 넣기
INSERT INTO EMP_INFO (사번, 사원명)
            ( SELECT EMP_ID, EMP_NAME FROM EMP )
;

/*
    <INSERT ALL>
    하나의 쿼리를 이용해서 두 개 이상 테이블에 INSERT
    INSERT ALL을 이용해서 여러 개 테이블에 데이터를 한번에 삽입
    
    표현법
        [WHEN 조건1 THEN]
            INTO 테이블명1[(컬럼, 컬럼, ...)] VALURES(값, 값, ...)
        [WHEN 조건2 THEN]
            INTO 테이블명2[(컬럼, 컬럼, ...)] VALURES(값, 값, ...)
        서브쿼리;
*/

-- EMP테이블의 구조를 복사하여 테이블을 생성
-- EMP_DEPT: EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
-- EMP_MANAGER: EMP_ID, EMP_NAME, MANAGER_ID
CREATE TABLE EMP_DEPT 
AS ( SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE
    FROM EMP 
    LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
    WHERE 2<0)
;
DROP TABLE EMP_DEPT;
SELECT * FROM EMP_DEPT;
DELETE FROM EMP_DEPT;

CREATE TABLE EMP_MANAGER 
AS ( SELECT EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME 
    FROM EMP
    JOIN JOB USING (JOB_CODE)
    WHERE 1=2)      -- 데이터는 제외하고 테이블 구조만 복사할 때 WHERE절에 FALSE 조건 사용하기  
;
DROP TABLE EMP_MANAGER;
SELECT * FROM EMP_MANAGER;
DELETE FROM EMP_MANAGER;

INSERT ALL
--  VALUES (컬럼, ...)은 다 아래의 서브쿼리에서 조회된 컬럼으로 가져오는 것
    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID)
    
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
        FROM EMP
        WHERE DEPT_CODE = 'D1'
;

SELECT * FROM EMP_DEPT A, EMP_MANAGER B;
SELECT * FROM EMP_DEPT A, EMP_MANAGER B WHERE A.EMP_ID = B.EMP_ID;

INSERT ALL
    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE)
    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME)
    
        SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE, E.HIRE_DATE, E.MANAGER_ID, E.JOB_CODE, J.JOB_NAME
        FROM EMP E, DEPT D, JOB J
        WHERE E.DEPT_CODE = D.DEPT_ID(+)
        AND E.JOB_CODE = J.JOB_CODE(+)
;

--INSERT ALL
--    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE)
--    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME)
--    
--         SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE, E.HIRE_DATE, E.MANAGER_ID, E.JOB_CODE, J.JOB_NAME
--        FROM EMP E, DEPT D, JOB J
--        WHERE E.DEPT_CODE = D.DEPT_ID(+)
--        AND E.JOB_CODE = J.JOB_CODE(+)
--        
--            MINUS                       -- 위에서 누락시킨 데이터를 차집합으로 찾아서 추가해주었음...
--        
--        SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE, E.HIRE_DATE, E.MANAGER_ID, E.JOB_CODE, J.JOB_NAME
--        FROM EMP E, DEPT D, JOB J
--        WHERE E.DEPT_CODE = D.DEPT_ID
--        AND E.JOB_CODE = J.JOB_CODE
--;
        
INSERT ALL
WHEN DEPT_CODE = 'D1' THEN
    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE)
WHEN JOB_CODE = 'J1' THEN
    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME)
    
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, HIRE_DATE, MANAGER_ID, E.JOB_CODE, JOB_NAME
        FROM EMP E, DEPT D, JOB J
        WHERE E.DEPT_CODE = D.DEPT_ID(+)
        AND E.JOB_CODE = J.JOB_CODE(+)
;

-- INSERT ALL 연습 문제)
-- EMP 테이블의 입사일을 기준으로 
-- 컬럼: EMP_ID, EMP_NAME, HIRE_DATE, SALARY
-- 2000년 1월 1일 이전에 입사한 사원의 정보는 EMP_OLD 테이블에 삽입하고
-- 2000년 1월 1일 이후에 입사한 사원의 정보는 EMP_NEW 테이블에 삽입한다.

INSERT ALL
WHEN TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') < '2000-01-01' THEN
--WHEN HIRE_DATE < '2000-01-01' THEN
    INTO EMP_OLD (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= TO_DATE('20000101', 'YY/MM/DD') THEN
--WHEN HIRE_DATE >= '2000-01-01' THEN
    INTO EMP_NEW (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    
    SELECT  EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMP
;

CREATE TABLE EMP_OLD 
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMP
    WHERE 1=0
;

CREATE TABLE EMP_NEW 
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMP
    WHERE 1=0
;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

DROP TABLE EMP_OLD;
DROP TABLE EMP_NEW;
DROP TABLE EMP_INFO;
DROP TABLE EMP_COPY;
DROP TABLE EMP_DEPT;
DROP TABLE EMP_MANAGER;

/*
    <UPDATE>
    테이블에 기록된 데이터를 수정하는 구문
    
    표현법
        UPDATE 테이블명
        SET 컬럼명 = 변경할 값,
            컬럼명 = 변경할 값,
            ...
        [WHERE 조건];
    - SET절에서 여러 개의 컬럼을 콤마(,)로 나열해서 값을 동시에 변경할 수 있다.
    - WHERE절을 생략하면 모든 행의 데이터가 변경된다.
*/

CREATE TABLE DEPT_COPY AS SELECT * FROM DEPT;

-- DEPT_COPY 테이블에서 DEPT_ID가 'D9'인 부서명을 '전략기획팀'으로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

CREATE TABLE EMP_SALARY AS SELECT * FROM EMP;
SELECT * FROM EMP_SALARY;

-- EMP_SALARY 테이블에서 노옹철 사원의 급여를 1,000,000으로 변경
UPDATE EMP_SALARY SET SALARY = 1000000 WHERE EMP_NAME = '노옹철';
DROP TABLE EMP_SALARY;

-- 모든 사원의 급여를 기존 급여에서 10프로 인상한 금액(기존*1.1)으로 변경
--SELECT 
--UPDATE EMP_SALARY SET SALARY = SALARY*1.1 인상급여
--    SELECT SALARY FROM EMP WHERE EMP.EMP_ID = EMP_SALARY.EMP_ID 
--;

-- 참조키 생성
-- EMP 테이블에 참조키를 추가
-- JOB_CODE, DEPT_CODE

ALTER TABLE EMP ADD CONSTRAINT EMP_DEPT_CODE_FK
    FOREIGN KEY(DEPT_CODE) REFERENCES DEPT(DEPT_ID);

-- 노옹철 사원의 부서코드를 D0로 업데이트
-- FK 삽입 제한: UPDATE에도 적용된다.
UPDATE EMP SET DEPT_CODE = 'D0' WHERE EMP_NAME = '노옹철';
-- PK 제약조건
UPDATE EMP SET EMP_ID = NULL;

-- 방명수 사원의 급여와 보너스를
-- 유재식 사원과 동일하게 변경
--      1) 유재식 사원의 급여와 보너스를 조회
SELECT SALARY, BONUS
FROM EMP_SALARY
WHERE EMP_NAME = '유재식';

--      2) 단일행 서브쿼리를 각각의 컬럼에 적용
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_NAME = '유재식')
    , BONUS = (SELECT BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
WHERE  EMP_NAME = '방명수'
;

--      3) 다중열 서브쿼리를 사용하여 한번에 적용
UPDATE EMP_SALARY
--FROM EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수'
;

SELECT * FROM EMP_SALARY WHERE EMP_NAME IN ('유재식','방명수');

-- EMP_SALARY 테이블에서
-- 노옹철, 전형돈, 정중하, 하동운 사원의
-- 급여와 부서코드를 유재식 사원과 동일하게 변경
-- ※ 변경 전 기존 데이터는 어땠는지를 미리 확인해보는게 좋다 ^_^
UPDATE EMP_SALARY
SET (SALARY, DEPT_CODE) = ( SELECT SALARY, DEPT_CODE
                            FROM EMP_SALARY
                            WHERE EMP_NAME = '유재식')
WHERE EMP_NAME IN ('노옹철','전형돈','정중하','하동운')
;
SELECT EMP_NAME, SALARY, DEPT_CODE FROM EMP_SALARY WHERE EMP_NAME IN  ('유재식', '노옹철','전형돈','정중하','하동운');

-- EMP_SALARY 테이블에서
-- ASIA 지역에서 근무하는 직원들의 보너스를 0.3으로 변경
--     먼저 ASIA 지역에서 근무하는 직원 조회
SELECT * FROM EMP_SALARY
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID 
                FROM EMP_SALARY
                JOIN DEPT ON (DEPT_CODE = DEPT_ID)
                JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                WHERE LOCAL_NAME LIKE 'ASIA%');

/*
    <DELETE>
    테이블에 기록된 데이터를 삭제하는 구문 (행 단위로 삭제함)
    
    표현법
        DELETE [FROM] 테이블명
        [WHERE 조건식];
        - WHERE절을 제시하지 않으면 전체 행이 삭제된다.
*/
-- EMP_SALARY 테이블에서
-- 임시환 사원의 데이터 지우기
SELECT * FROM EMP_SALARY WHERE EMP_NAME = '임시환';
DELETE EMP_SALARY WHERE EMP_NAME = '임시환';
ROLLBACK;
-- 참조키 제약조건의 삭제 제한에 걸림 (자식테이블에서 사용중인 코드는 삭제 불가)
DELETE DEPT WHERE DEPT_ID = 'D1';

/*
    <TRUNCATE>
    테이블에 전체 행을 삭제할 때 사용하는 구문으로
    DELETE보다 수행 속도가 더 빠르다.
    그러나 별도 조건 제시가 불가능하고, ROLLBACK이 불가능하다.
    
    표현법
        TRUNCATE TABLE 테이블명;
*/
TRUNCATE TABLE EMP_SALARY;

/*
    <MERGE>
    구조가 같은 두 개의 테이블을 하나의 테이블로 합치는 구문
    두 테이블에서 지정하는 조건의 값이 존재하면 UPDATE, 아니면 INSERT
*/
-- EMP 테이블을 복사해서 2개의 테이블 만들기
CREATE TABLE EMP_M01 AS SELECT * FROM EMP;
CREATE TABLE EMP_M02 AS SELECT * FROM EMP WHERE JOB_CODE = 'J4';
SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;
INSERT INTO EMP_M02 VALUES(999,'스누피','621235-1985634','sun_di@or.kr','01099546325','D9',	'J1',8000000,0.3,'',SYSDATE,'','');
UPDATE EMP_M02 SET SALARY = 0;

CREATE TABLE EMP_COPY AS SELECT * FROM EMP WHERE 1>2;
SELECT * FROM EMP_COPY;

MERGE INTO EMP_M01
-- 조건: 사번이 일치는지를 확인
USING EMP_M02 ON (EMP_M01.EMP_ID = EMP_M02.EMP_ID)
-- 일치하는 사번이 있으면 UPDATE (업데이트 할 컬럼은 내가 기입함.)
WHEN MATCHED THEN 
    UPDATE SET
    EMP_M01.EMP_NAME = EMP_M02.EMP_NAME
    , EMP_M01.EMP_NO = EMP_M02.EMP_NO
    , EMP_M01.EMAIL = EMP_M02.EMAIL
    , EMP_M01.PHONE = EMP_M02.PHONE
    , EMP_M01.SALARY = EMP_M02.SALARY
-- 일치하는 사번이 없으면 INSERT
WHEN NOT MATCHED THEN
    INSERT VALUES (EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL
                    , EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SALARY
                    , EMP_M02.BONUS, EMP_M02.MANAGER_ID
                    , EMP_M02.HIRE_DATE ,EMP_M02.ENT_DATE, EMP_M02.ENT_YN
);

CREATE TABLE EMP1 AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMP;
CREATE TABLE EMP2 AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMP WHERE 1<0;

UPDATE EMP2 SET BONUS = 100;
SELECT * FROM EMP2;
SELECT * FROM EMP1;

MERGE INTO EMP1 USING EMP2 ON (EMP1.EMP_ID = EMP2.EMP_ID)
WHEN MATCHED THEN
    UPDATE SET EMP1.EMP_NAME = EMP2.EMP_NAME, EMP1.SALARY = EMP2.SALARY,  EMP1.BONUS = EMP2.BONUS
WHEN NOT MATCHED THEN 
    INSERT VALUES (EMP2.EMP_ID, EMP2.EMP_NAME, EMP2.SALARY, EMP2.BONUS);














