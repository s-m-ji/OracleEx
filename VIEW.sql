/*
    <VIEW>
    SELECT 문을 저장할 수 있는 객체 (논리적인 가상 테이블)
    데이터를 저장하고있지 않으며 테이블에 대한 SQL만 저장되어있어
    VIEW 접근할 때 SQL을 수행하면서 결과값을 가져온다.
    
    표현법
        CREATE [OR REPLACE] VIEW 뷰名
        AS 서브쿼리;
        - 이미 있는 뷰라면 OR REPLACE를 꼭 써서 재정의해줌: 기존 객체가 존재하는 경우 수정(덮어쓰기)
*/

-- 문제) 한국에서 근무하는 직원의 사번, 이름, 부서명, 급여, 근무 국가명을 조회
SELECT EMP_ID 사번, EMP_NAME 이름, DEPT_TITLE 부서명, TO_CHAR(SALARY, 'L9,999,999') 급여, NATIONAL_NAME 근무국가명
FROM EMP E, DEPT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
AND NATIONAL_NAME = '한국'
;
-- 뷰 생성 ========================================================
CREATE /*OR REPLACE*/ VIEW V_EMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMP E, DEPT D, LOCATION L, NATIONAL N
    WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND D.LOCATION_ID = L.LOCAL_CODE(+)
    AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
;
SELECT * FROM V_EMP WHERE NATIONAL_NAME = '러시아';
-- VIEW는 가상 테이블이기 때문에 실제 데이터가 담겨있는건 아님. 
-- 결과 집합을 확인하기 위한 용도랄까? => 사용 빈도가 높은 서브쿼리를 뷰로 저장해두면 유용하다.

-- 문제) 총무부에서 근무하는 직원의 사원명, 급여를 조회
SELECT EMP_NAME 사원명, SALARY 급여
FROM V_EMP
WHERE DEPT_TITLE = '총무부';

-- VIEW에 대한 결과 조회도 가넝함
SELECT * FROM USER_VIEWS;

-- 사원의 사번, 이름, 성별, 근무년수를 조회할 수 있는 뷰를 생성
SELECT EMP_ID 사번, EMP_NAME 사원명 
        , DECODE(SUBSTR(EMP_NO,8,1),'1','남', '2','여' ,'3','남', '4','여', '') 성별
        , ROUND((SYSDATE - HIRE_DATE)/365) || '년' 근무년수
        , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) || '년' 근무년수2
        , TO_CHAR(SYSDATE,'YYYY') - ('19'||SUBSTR(EMP_NO,1,2)) || '세' 나이
FROM EMP
;

CREATE VIEW V_EMP_01
AS SELECT EMP_ID 사번, EMP_NAME 사원명 
        , DECODE(SUBSTR(EMP_NO,8,1),'1','남', '2','여' ,'3','남', '4','여', '') 성별
        , ROUND((SYSDATE - HIRE_DATE)/365) || '년' 근무년수
    FROM EMP
; 
-- 만약 VIEW 생성 시에 OR REPLACE를 안 썼다면 DROP하고 다시 만들어도 된다. 
DROP VIEW V_EMP_01;
SELECT * FROM V_EMP_01;
SELECT * FROM V_EMP_01 WHERE 사원명 = '선동일';

-- 별칭 주기 2)
CREATE VIEW V_EMP_02 ("사번2", "사원명2", "성별2", "근무년수2")
AS SELECT EMP_ID 사번, EMP_NAME 사원명 
        , DECODE(SUBSTR(EMP_NO,8,1),'1','남', '2','여' ,'3','남', '4','여', '') 성별
        , ROUND((SYSDATE - HIRE_DATE)/365) || '년' 근무년수
    FROM EMP
;
DROP VIEW V_EMP02;
SELECT * FROM V_EMP_02;
-- 서브쿼리 컬럼에 이미 별칭이 있지만, 뷰를 생성하면서 다시 부여하면 재정의된다. 

/* <VIEW를 이용해서 DML 사용>
    뷰를 통해 데이터를 변경하게 되면 실제 데이터가 담겨있는 기본 테이블에도 적용된다.
*/
CREATE VIEW V_JOB AS SELECT * FROM JOB;
SELECT * FROM V_JOB;
-- VIEW를 통해 테이블에 INSERT 
INSERT INTO V_JOB VALUES ('J8', '인턴');
-- VIEW를 통해 테이블에 UPDATE
UPDATE V_JOB SET JOB_NAME='알바' WHERE JOB_CODE='J8';
-- VIEW를 통해 테이블에 DELETE
DELETE V_JOB WHERE JOB_NAME='알바';

/*
    <DML 구문으로 VIEW 조작이 불가능한 경우>
*/
-- 1) VIEW 정의에 포함되지 않는 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE FROM JOB;
SELECT * FROM V_JOB;

-- 현재 V_JOB은 컬럼이 1개인데 2개 값을 넣으려고하면 오류 발생
INSERT INTO V_JOB VALUES ('J8', '인턴');
-- 현재 V_JOB은 JOB_NAME이라는 컬럼이 없는데 값을 수정하려고하면 오류 발생
UPDATE V_JOB SET JOB_NAME = '일하는 사람';
-- 조건에 일치하는 데이터가 없을 경우 '0개 행 이(가) 삭제되었습니다.' 스크립트 출력
DELETE FROM V_JOB WHERE JOB_CODE = 'J10';

-- 2) 뷰에 포함되지 않은 컬럼 중 기본 테이블에 NOT NULL 제약 조건이 지정된 경우 
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_NAME FROM JOB;

DROP VIEW V_JOBE;
SELECT * FROM V_JOB;

INSERT INTO V_JOB VALUES ('알바');     -- 'NULL을 ("JUNGANG"."JOB"."JOB_CODE") 안에 삽입할 수 없습니다' => 왜냐묭 DML문은 실제 테이블 JOB을 수정하기때문입네당 

-- 3) 산술 표현식으로 정의된 경우
-- 사번, 사원명, 급여, 급여*12
CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
    FROM EMP
;
SELECT * FROM V_EMP_SAL;

-- 산술연산이 사용된 컬럼을 삽입/수정 불가
INSERT INTO V_EMP_SAL VALUES (001, '우드스탁', 3000000, 36000000);
-- 산술연관과 무관한 컬럼은 수정 가능 
UPDATE V_EMP_SAL SET SALARY = 800000000 WHERE EMP_ID = 200;

-- 4) 그룹함수나 GROUP BY절을 포함한 경우
CREATE OR REPLACE VIEW V
AS SELECT NVL(DEPT_CODE, '*부서없음*') 부서코드
        , TO_CHAR(SUM(SALARY),'L999,999,999') 합계
        , TO_CHAR(ROUND(AVG(SALARY)),'L999,999,999') 평균
    FROM EMP
    GROUP BY DEPT_CODE
;
SELECT * FROM V;

-- 5) DISTINCT를 포함한 경우
-- &
-- 6) JOIN을 사용해서 여러 개의 테이블을 사용한 경우 
-- VIEW를 생성할 수는 있지만 DML문을 사용하여 데이터를 조작할 수는 없다. 

/*
    <VIEW> 옵션 ^_^
    CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰이름
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];       
    
    - OR REPLACE 기존에 동일한 뷰가 있으면 덮어쓰고 없으면 신규로 생성한다.
    - FORCE 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성된다.
    - NOFORCE 서브쿼리에 기술된 테이블이 존재해야지만 뷰가 생성된다. (기본값)
    - WITH CHECK OPTION 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
    - WITH READ OLNY 뷰에 대한 조회만 가능하다(DML 사용 불가)
*/

CREATE OR REPLACE VIEW V_EMP_01
AS
SELECT EMP_NAME, SALARY, HIRE_DATE FROM EMP;
SELECT * FROM V_EMP_01;

-- 2) FORCE|NOFORCE
-- 더미테이블 TT를 가정해봄
CREATE OR REPLACE FORCE VIEW V_EMP_02
  AS
    SELECT TCODE, TNAME, TCONTENT FROM TT;
SELECT * FROM V_EMP_02;

-- 테이블을 생성하고 난 이후부터 조회 가능
CREATE TABLE TT (
    TCODE NUMBER
    , TNAME VARCHAR2(10)
    , TCONTENT VARCHAR2(20)
);

-- 3) WITH CHECK OPTION
-- 급여가 300만원 이상인 사원들 
CREATE OR REPLACE VIEW V_EMP_03
  AS 
    SELECT * FROM EMP WHERE SALARY >= 3000000
WITH CHECK OPTION;
SELECT * FROM V_EMP_03;
UPDATE V_EMP_03 SET SALARY = 200 WHERE EMP_ID=200;

-- 4) WITH READ ONLY (읽기 전용)
CREATE VIEW V_DEPT_01 
AS SELECT * FROM DEPT WITH READ ONLY; 

SELECT * FROM V_DEPT_01;
SELECT * FROM USER_VIEWS;

INSERT INTO V_DEPT_01 VALUES ('D0', '재택근무부', '집에가요');
















