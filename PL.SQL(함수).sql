 /*
    <FUNCTION>
        절차형 SQL을 활용하여 일련의 SQL 처리를 수행하고, 
        수행 결과를 단일 값으로 반환할 수 있는 절차형 SQL
        
        [표현법]
            CREATE FUNCTION 함수명
            (
                매개변수명 1 타입,
                매개변수명 2 타입,
                ...
            )
            RETURN 데이터타입 
            IS
                선언부 (변수 정의)
            BEGIN
                실행부 (로직 구현 : 반복문, 제어문 등등)
                
                RETRUN 반환값; -- 프로시저랑 다르게 RETURN 구문이 추가된다.
            EXCEPTION
                예외처리부
            END [함수명];
            /
*/

SET SERVEROUTPUT ON;

DESC EMP;
-- EMP 테이블에 데이터를 입력하는 익명의 블록을 작성해봅니다.

DECLARE
    V_E_ID      EMP.EMP_ID%TYPE;
    V_E_NAME    EMP.EMP_NAME%TYPE;
    V_E_NO      EMP.EMP_NO%TYPE;
    V_E_JCODE   EMP.JOB_CODE%TYPE;
BEGIN
    V_E_ID      := '&사번';
    V_E_NAME    := '&사원명';
    V_E_NO      := '&주민번호';
    V_E_JCODE   := '&직급번호';
    
    INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) VALUES (V_E_ID, V_E_NAME, V_E_NO, V_E_JCODE);
END;
/

DECLARE
    V_E_ID      EMP.EMP_ID%TYPE;
    V_E_NAME    EMP.EMP_NAME%TYPE;
    V_E_NO      EMP.EMP_NO%TYPE;
    V_E_JCODE   EMP.JOB_CODE%TYPE;
    
    V_CNT       NUMBER;
BEGIN
    V_E_ID      := '&사번';
    V_E_NAME    := '&사원명';
    V_E_NO      := '&주민번호';
    V_E_JCODE   := '&직급번호'; 
    
    -- JOB 테이블에 내가 입력한 JOB_CODE가 몇 개나 있는지 셈 
    SELECT COUNT(*) INTO V_CNT FROM JOB WHERE JOB_CODE = V_E_JCODE;
    
    IF (V_CNT = 0) THEN
        DBMS_OUTPUT.PUT_LINE('JOB_CODE를 잘못 입력했습니다.');
    ELSE
        INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) 
                    VALUES (V_E_ID, V_E_NAME, V_E_NO, V_E_JCODE);
        DBMS_OUTPUT.PUT_LINE(V_E_NAME || ' 사원이 추가되었습니다.');
    END IF;
END;
/

-- 입력받은 JCODE가 사용 가능한 코드인지 확인 (유효성 검사 = Validation Check)

SELECT * FROM EMP ORDER BY EMP_ID;
UPDATE EMP SET EMP_NAME = '미미2' WHERE EMP_ID = '101';

-- 사번을 입력받아서 급여를 출력하는 함수를 만든다면 ?

CREATE OR REPLACE FUNCTION FN_GET_SALARY 
(
    P_EMP_ID EMP.EMP_ID%TYPE
)
--RETURN NUMBER
RETURN VARCHAR2
IS -- 선언부
--    V_SALARY EMP.SALARY%TYPE;
    V_SALARY VARCHAR2(20);
--    V_SALARY NUMBER;
BEGIN -- 실행부
     -- 급여를 조회 후 변수에 담기
    SELECT SALARY
--    SELECT TO_CHAR(V_SALARY, 'L99,999,999') 
        --> 여기서 바꾸려면 RETURN 타입에 맞춰서 IS 타입도 바꿔주면 된다 
    INTO V_SALARY
    FROM EMP
    WHERE EMP_ID = P_EMP_ID;
    -- 반환값
    -- 출력 형식을 바꿔주기 위해 NUMBER에서 VARCHAR2로 바꿔보았음.
    RETURN TO_CHAR(V_SALARY, 'L99,999,999');
    
    DBMS_OUTPUT.PUT_LINE(P_EMP_ID ||' 사원의 급여는 '|| V_SALARY);
END;
/

-- 201번 사원 급여 조회
SELECT FN_GET_SALARY('201') FROM DUAL;

-- 사원 급여 조회
SELECT FN_GET_SALARY(EMP_ID) FROM EMP;

-- 주민등록 번호를 입력 받아서 성별을 반환하는 함수 생성
--CREATE FN_GET_GENDER(EMP_NO)

CREATE OR REPLACE FUNCTION FN_GET_GENDER (P_EMP_NO EMP.EMP_NO%TYPE)
RETURN VARCHAR
IS
    V_GENDER VARCHAR(10);   
    V_EMP_NO EMP.EMP_NO%TYPE;
BEGIN
    SELECT EMP_NO
    INTO V_EMP_NO
    FROM EMP
    WHERE EMP_NO = P_EMP_NO;
    
    IF SUBSTR(EMP_NO,8,1) IN (2,4) THEN
    DBMS_OUTPUT.PUT_LINE('여자');
    ELSE
    DBMS_OUTPUT.PUT_LINE('남자');
    END IF;
RETURN V_GENDER;
END;
/

--> 슨생님 답
SELECT DECODE(SUBSTR(EMP_NO,8,1) ,'1','M' ,'2','F' ,'확인불가') 성별
FROM EMP;

CREATE OR REPLACE FUNCTION FN_GET_GENDER
(P_EMP_NO   EMP.EMP_NO%TYPE)
RETURN CHAR  
IS 
    V_GENDER CHAR(12);  -- '확인불가' 한글 넣어주려고 함
BEGIN
    SELECT DECODE(SUBSTR(P_EMP_NO,8,1) ,'1','M' ,'2','F' ,'확인불가') 성별
    INTO V_GENDER
    FROM DUAL;
--    FROM EMP
--    WHERE EMP_NO = P_EMP_NO;
RETURN V_GENDER;
END;
/

SELECT FN_GET_GENDER2('621235-1985634') FROM DUAL;
SELECT FN_GET_GENDER('621235-2985634') FROM DUAL;
SELECT FN_GET_GENDER2(EMP_NO) FROM EMP;

-- 주민번호를 받아서 나이를 반환하는 함수 생성
-- 변수 타입은 EMP 테이블을 조회했지만 실질적으로는 사용자 정의로 만들었기때문에(DUAL)
-- EMP 테이블의 실제 값이 아닌 더미 텍스트로 넣어도 된다.
-- RETURN 값을 원하는 형식으로 맞춰서 출력해도 된다. 
CREATE OR REPLACE FUNCTION FN_GET_AGE(P_EMP_NO EMP.EMP_NO%TYPE)
RETURN NUMBER
IS
--    V_AGE NUMBER;
BEGIN
--    SELECT EXTRACT(YEAR FROM SYSDATE) - ('19'||SUBSTR(P_EMP_NO,1,2))
--    INTO V_AGE
--    FROM DUAL;
--RETURN V_AGE;
RETURN EXTRACT(YEAR FROM SYSDATE) - ('19'||SUBSTR(P_EMP_NO,1,2));
END;
/
SELECT FN_GET_AGE('821235-1985634') FROM DUAL;


-- 사번을 입력받아 해당 사원의 보너스를 포함하는 연봉을 계산하고 리턴하는 함수를 생성

CREATE OR REPLACE FUNCTION FN_RETURN_SALARY(P_EMP_ID EMP.EMP_ID%TYPE)
RETURN NUMBER
IS 
    V_SALARY NUMBER;
    V_BONUS EMP.BONUS%TYPE;
BEGIN
    SELECT (SALARY+SALARY*NVL(BONUS,0))*12
    INTO V_SALARY
    FROM EMP
    WHERE EMP_ID = P_EMP_ID;
    
    IF V_BONUS IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('보너스가 없어요?없어요.없어요씨');
    END IF;
RETURN V_SALARY;
END;
/
SELECT (SALARY+SALARY*BONUS)*12
FROM EMP;
SELECT FN_RETURN_SALARY('200')FROM DUAL;

CREATE OR REPLACE FUNCTION FN_BONUS_CALC
(P_EMP_ID EMP.EMP_ID%TYPE)
RETURN NUMBER
IS
    V_SAL EMP.SALARY%TYPE;
    V_BONUS EMP.BONUS%TYPE;
BEGIN
    SELECT SALARY, NVL(BONUS,0)
    INTO V_SAL, V_BONUS
    FROM EMP
    WHERE EMP_ID = P_EMP_ID;
    
    RETURN 12*(V_SAL+(V_SAL*V_BONUS));
END;
/
SELECT FN_BONUS_CALC('200') FROM DUAL;
SELECT EMP_NAME, FN_BONUS_CALC('200') FROM EMP;

-- 변수 선언
VARIABLE V_CALC NUMBER;
-- 함수 실행
-- 내가 선언한 변수에 함수의 반환값을 저장
EXEC :V_CALC := FN_BONUS_CALC('200');
PRINT V_CALC;
-- 여기서는 DBMS ~ 쓸 수 없음 : 이건 로직 내부에서만 가능하다구














