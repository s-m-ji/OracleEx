/*
    <PL/SQL 실행부(EXECUTABLE SECTION)>
        1) 선택문
          1-1) 단일 IF 구문
            [표현법]
                IF 조건식 THEN
                    실행 문장
                END IF;
                * END IF;로 IF문 블록이 끝났음을 꼭 명시해야한다 ! 
*/
---------- 문제5) 
-- 사번을 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스를 출력
-- 단, 보너스를 받지 않는 사원은 보너스 출력 전에 '보너스를 지급받지 않는 사원입니다.'라는 문구를 출력한다

SELECT EMP_ID, EMP_NAME, SALARY, NVL(TO_CHAR(BONUS,0), '보너스를 지급받지 않는 사원입니다.')
FROM EMP;

DECLARE 
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    bon EMP.BONUS%TYPE;
--    bon VARCHAR2(100)%TYPE;
--    emp_info EMP%ROWTYPE;

BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    INTO eid, ename, sal, bon
    FROM EMP
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('eid : ' || eid);
    DBMS_OUTPUT.PUT_LINE('ename : ' || ename);
    DBMS_OUTPUT.PUT_LINE('sal : ' || sal);
    
    IF bon IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('bon : ' || bon);
    
--    DBMS_OUTPUT.PUT_LINE('bon : '|| TO_CHAR(NVL(bon,0),'0.9'));
--    DBMS_OUTPUT.PUT_LINE('bon : '|| TO_CHAR(bon,'0.9');
    -- 유효하지 않은 정수부의 숫자를 출력

END;
/

/*
        1-2) IF ~ ELSE 구문
          [표현법]
            IF 조건식 THEN
                실행 문장
            ELSE 
                실행 문장
            END IF;
*/

---------- 문제6) 보너스 여부에 따라 메세지만 출력
DECLARE 
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    bon EMP.BONUS%TYPE;

BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO eid, ename, sal, bon
    FROM EMP
    WHERE EMP_ID = &사번;
    
    IF bon IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE
    DBMS_OUTPUT.PUT_LINE('보너스를 지급받는 사원입니다.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('bon : ' || bon);
END;
/

/*
        1-3) IF ~ ELSIF ~ ELSE 구문
          [표현법]
            IF 조건식 THEN
                실행 문장
            ELSIF 조건식 THEN
                실행 문장
            ...
            [ELSE
                실행 문장]
            END IF;
            
            *ELSEIF(X) , ELSIF(O) 실수하지 않도록 ~~~
*/

---------- 문제7) 
-- 사용자에게 점수를 입력받아 SCORE 변수에 저장한 후 학점은 입력된 점수에 따라 GRADE 변수에 저장한다.
--  90점 이상은 'A'
--  80점 이상은 'B'
--  70점 이상은 'C'
--  60점 이상은 'D'
--  60점 미만은 'F'
-- 출력은 '당신의 점수는 95점이고, 학점은 A학점입니다.'와 같이 출력한다.

DECLARE
    score NUMBER := &점수;
    grade CHAR(1);
BEGIN                       
-- 조건은 () 기입 여부 상관없이 잘 작동하는 것 같당 AS ()처럼
    IF (score >= 90) THEN
    grade := 'A';
    ELSIF (score >= 80) THEN
    grade := 'B';
    ELSIF (score >= 70) THEN
    grade := 'C';
    ELSIF (score >= 60) THEN
    grade := 'D';
    ELSIF (score < 60) THEN
    grade := 'F';
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 '||score||'이고, 학점은 '||grade||'학점 입니다.');
    END IF;
END;
/

-- 사번을 입력받아서 사번, 이름, 급여를 출력
DECLARE
    -- 변수 선언 (타입 지정 혹은 참조 테이블이 있다면 해당 컬럼 타입으로 쓰는게 안정적.)
    eid NUMBER;
    ename VARCHAR2(50);
    sal NUMBER;
    
BEGIN 
    eid := &사번;
    -- 조회결과를 변수에 담기
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_ID = eid;
    
    -- 출력하기
    DBMS_OUTPUT.PUT_LINE('eid : ' || eid);
    DBMS_OUTPUT.PUT_LINE('ename : ' || ename);
    DBMS_OUTPUT.PUT_LINE('sal : ' || sal);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        INSERT INTO TB_ERR 
            VALUES ('PROC_GET_SALARY_GRADE', 'E001', eid || '이(가) 맞나요? 사원번호를 확인해주세요.', SYSDATE);   
            -- 급여 등급을 정하기 위해 임의 설정
            
    DBMS_OUTPUT.PUT_LINE('사원번호를 확인해주세요');
END;
/

CREATE TABLE TB_ERR (
    PLSQL_NAME VARCHAR2(100)
    , ERR_CODE CHAR(4)
    , ERR_MSG VARCHAR2(4000)
    , REG_DATE DATE
);

SELECT * FROM TB_ERR;


DECLARE
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    grade CHAR(1);
BEGIN
    eid := &사번;
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_ID = eid;
    
--    IF sal BETWEEN 2000000 AND 3000000 THEN 
--    grade := 'E';
--    ELSIF sal BETWEEN 3000000 AND 4000000 THEN 
--    grade := 'D';
--    ELSIF sal BETWEEN 4000000 AND 5000000 THEN 
--    grade := 'C';
--    ELSIF sal BETWEEN 5000000 AND 6000000 THEN 
--    grade := 'B';
--    ELSIF sal > 6000000 THEN 
--    grade := 'A';
--    END IF;   
    
--    IF sal > 6000000 THEN 
--    grade := 'A';
--    ELSIF sal BETWEEN 5000000 AND 6000000 THEN 
--    grade := 'B';
--    ELSIF sal BETWEEN 4000000 AND 5000000 THEN 
--    grade := 'C';
--    ELSIF sal BETWEEN 3000000 AND 4000000 THEN 
--    grade := 'D';
--    ELSIF sal BETWEEN 2000000 AND 3000000 THEN 
--    grade := 'E';
--    END IF;
    
-- 조건 경계가 겹쳐서 중복으로 들어가는 값이 있다면 기입된 코드 순서에 맞춰서 실행 시 분류된다.

    IF sal BETWEEN 2000000 AND 2999999 THEN 
    grade := 'E';
    ELSIF sal BETWEEN 3000000 AND 3999999 THEN 
    grade := 'D';
    ELSIF sal BETWEEN 4000000 AND 4999999 THEN 
    grade := 'C';
    ELSIF sal BETWEEN 5000000 AND 5999999 THEN 
    grade := 'B';
    ELSIF sal > 6000000 THEN 
    grade := 'A';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('SALARY_GRADE : '|| grade);
END;
/
UPDATE EMP SET SALARY = 3000000 WHERE EMP_ID = 210; 

/*
        1-4) CASE 구문
          [표현법]
            CASE 비교 대상
                 WHEN 비교값1 THEN 결과값1
                 WHEN 비교값2 THEN 결과값2
                 ...
                 [ELSE 결과값]
            END;
*/
-- 사번을 입력받은 후에 사원의 모든 컬럼 데이터를 EMP에 대입하고 DEPT_CODE에 따라 알맞는 부서를 출력한다.
-- e : EMP테이블의 ROWTYPE 변수
-- dname : 부서이름

SELECT EMP_ID, DEPT_TITLE
FROM EMP
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM DEPT;

DECLARE
    e EMP%ROWTYPE;
    dname DEPT.DEPT_TITLE%TYPE;
--    eid CHAR(2);
BEGIN
--    eid := &사번;
    SELECT *
    INTO e
    FROM EMP 
    WHERE EMP_ID = &사번; 

--    dname := CASE e.DEPT_CODE
--                    WHEN 'D1' THEN '인사관리부'
--                    WHEN 'D2' THEN '회계관리부'
--                    WHEN 'D3' THEN '마케팅부'
--                    WHEN 'D4' THEN '국내영업부'
--                    WHEN 'D5' THEN '해외영업1부'
--                    WHEN 'D6' THEN '해외영업2부'
--                    WHEN 'D7' THEN '해외영업3부'
--                    WHEN 'D8' THEN '기술지원부'
--                    WHEN 'D9' THEN '총무부'                    
--            END;

-- 3교대 근무 분류: D1,2,3은 오전 / D4,5,6은 오후 / D7,8,9는 야간 

   dname := CASE 
        WHEN e.DEPT_CODE IN ('D1','D2','D3') THEN '오전근무'
        WHEN e.DEPT_CODE IN ('D4','D5','D6') THEN '오후근무'
        WHEN e.DEPT_CODE IN ('D7','D8','D9') THEN '야간근무'
        END;   
            
--     DBMS_OUTPUT.PUT_LINE(eid ||'은 '|| dname ||'입니다.');       
     DBMS_OUTPUT.PUT_LINE('dname : ' || dname);     
   
END;
/

/* 2) 반복문
          2-1) BASIC LOOP
            [표현법]
                LOOP
                반복적으로 실행시킬 구문
                
                [반복문을 빠져나갈 조건문 작성]
                    1) IF 조건식 THEN 
                          EXIT;
                       END IF
                       
                    2) EXIT WHEN 조건식;
                END LOOP;
*/
-- 1~5까지 순차적으로 1씩 증가하는 값을 출력
-- 숫자타입의 변수를 생성 NUM = 1
DECLARE
    num NUMBER := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(num);
        num := num + 1;
        
--        IF num > 5 THEN EXIT; 
--        END IF;
        
        EXIT WHEN num > 5;
        
    END LOOP;
END;
/

/*
        2-2) WHILE LOOP
          [표현법]
            WHILE 조건식
            LOOP
                반복적으로 실행할 구문;
            END LOOP;
*/
-- 1 ~ 5까지 순차적으로 1씩 증가하는 값을 출력
DECLARE 
    num NUMBER := 1;
BEGIN
    WHILE num < 6
        LOOP
        DBMS_OUTPUT.PUT_LINE(num);
        num := num + 1;
    END LOOP;
END;
/

-- 2단 출력하기
DECLARE 
    num NUMBER := 1;
BEGIN
    WHILE num <= 9
        LOOP
        DBMS_OUTPUT.PUT_LINE('2*'||num||' = '||num*2);
        num := num+1;
    END LOOP;
END;
/
-- 2 ~ 9단 모두 출력
DECLARE     
    i NUMBER := 2;
    num NUMBER := 1;
BEGIN
    WHILE i <= 9
        LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        WHILE num <= 9
            LOOP
            DBMS_OUTPUT.PUT_LINE(i||'*'||num||' = '||i*num);
            num := num+1;
         END LOOP;
         i := i+1;
         num := 1;
    END LOOP;
END;
/

/*
        3) FOR LOOP
          [표현법]
            FOR 변수 IN [REVERSE] 초기값..최종값
            LOOP
                반복적으로 실행할 구문;
            END LOOP;
            
            *REVERSE 쓸 경우 최종->초기 순서로 실행됨
*/
-- 1 ~ 5까지 순차적으로 1씩 증가하는 값을 출력

--DECLARE
BEGIN
    FOR num IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(num);
    END LOOP;
END;
/

CREATE TABLE TEST(
    NUM NUMBER
    , REG_DATE DATE
);

SELECT * FROM TEST;
DELETE TEST;

-- 1부터 10까지 테이블에 데이터로 넣을 때
BEGIN
    FOR i IN 1..10
    LOOP
        INSERT INTO TEST VALUES (i, SYSDATE);
   END LOOP;  
END;
/
-- 1부터 10까지 짝수만 테이블에 데이터로 넣을 때
BEGIN
    FOR i IN 1..10
    LOOP
--        IF MOD (i,2)=0 THEN     -- 나누기 함수
--            INSERT INTO TEST VALUES (i, SYSDATE);
--        END IF;
        
        INSERT INTO TEST VALUES (i, SYSDATE);
        IF MOD (i,2)=0 THEN        -- 짝수면 커밋 아니면 롤백
            COMMIT;
            ELSE ROLLBACK;
        END IF;
   END LOOP;  
END;
/

/* 
    타입 변수 선언
        레코드 타입의 변수 선언과 초기화
        변수 값 출력

    레코드 타입 선언
        TYPE 타입명 IS RECORD (컬럼명 타임, 컬럼명 타입, ...)  
*/
-- 사원명을 매개변수로 받아서
-- 사번, 이름, 부서명, 직급명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMP E, DEPT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND EMP_NAME = &사원명;

DECLARE 
-- 변수를 레코드 타입으로 지정
    TYPE EMP_RECORD_TYPE IS RECORD (           
        eid EMP.EMP_ID%TYPE
        , ename EMP.EMP_NAME%TYPE
        , dtitle DEPT.DEPT_TITLE%TYPE
        , jname JOB.JOB_NAME%TYPE
    ); 
    
    emp_RECORD EMP_RECORD_TYPE;
BEGIN 
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
--    INTO eid, ename, dtitle, jname
    INTO EMP_RECORD
    FROM EMP E, DEPT D, JOB J
    WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE(+)
    AND EMP_NAME = '&사원명';
    
--    DBMS_OUTPUT.PUT_LINE(eid ||' '|| ename ||' '|| dtitle ||' '|| jname);
    DBMS_OUTPUT.PUT_LINE(emp_RECORD.eid ||' '|| 
                        emp_RECORD.ename ||' '|| 
                        emp_RECORD.dtitle ||' '|| 
                        emp_RECORD.jname);
END;
/

