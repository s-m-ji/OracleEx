-- EMP 테이블 복사
CREATE TABLE EMP_DUP
AS SELECT * FROM EMP;

-- EMP_DUP 테이블 조회
SELECT * FROM EMP_DUP; 

/* 
    <PROCEDURE>
        PL/SQL 문을 저장하는 객체이다.
        필요할 때마다 복잡한 구문을 다시 입력할 필요 없이 간단하게 호출해서 실행 결과를 얻을 수 있다.
        특정 로직을 처리하기만 하고 결과값을 반환하지 않는다.
        
        [표현법]
            CREATE PROCEDURE 프로시저명
            (
                매개변수 1 [IN/OUT] 테이터타입 [:=DEFAULT 값],
                매개변수 2 [IN/OUT] 테이터타입 [:=DEFAULT 값],
                ...
                * DEFUALT는 IN, IN/OUT 둘 다 쓸수도 있음.
            )
            IS [AS]
                선언부
            BEGIN
                실행부
            EXCEPTION
                예외처리부
            END [프로시저명];
            /
            
        [실행방법]
            EXECUTE(EXEC) 프로시저명[(매개값1, 매개값2, ...)];
*/

-- EMP_DUP테이블의 데이터를 모두 삭제하는 프로시저 생성
CREATE OR REPLACE PROCEDURE PROC_DEL_EMP_DUP
IS
BEGIN
    DELETE FROM EMP_DUP;
    COMMIT;
END;
/
-- 프로시저 실행 (EXECUTE EXEC)
EXEC PROC_DEL_EMP_DUP;

-- 매개변수가 있는 프로시저를 만들어봐요우
-- 저장 프로시저의 경우 생성 후 호출 문장을 이용하여 프로시저를 실행할 수 있습니당
-- 익명의 프로시저의 경우 저장되지 않음
CREATE OR REPLACE PROCEDURE PROC_DEL_EMP_ID
(P_EMP_ID EMP.EMP_ID%TYPE)
IS
    -- 변수선언
    RES NUMBER;
BEGIN
    -- 로직작성
    DELETE FROM EMP
    WHERE EMP_ID = P_EMP_ID;    
    RES := SQL%ROWCOUNT;

    INSERT INTO PROC_RES VALUES ('PROC_DEL_EMP_ID', RES||'건 삭제되었습니다.', SYSDATE);
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(RES||'건 삭제되었습니다.');
    
END;
/
SELECT * FROM EMP ORDER BY 1;

EXEC PROC_DEL_EMP_ID('102');
EXEC PROC_DEL_EMP_ID('101');
EXEC PROC_DEL_EMP_ID('300');

EXEC PROC_DEL_EMP_ID('&사번');

INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) VALUES ('100', '미미', '123', 'J1');

CREATE TABLE PROC_RES(
    PROC_NAME   VARCHAR2(100)
    , RES       VARCHAR2(1000)
    , REG_DATE  DATE
);
SELECT * FROM PROC_RES;

-- 프로시저를 관리하는 데이터 딕셔너리
SELECT * FROM USER_SOURCE;

-- 사원정보를 받아서 사원테이블에 입력하는 프로시저를 생성
CREATE OR REPLACE PROCEDURE PROC_INS_EMP 
(
    P_E_ID      EMP.EMP_ID%TYPE
    ,P_E_NAME    EMP.EMP_NAME%TYPE
    ,P_E_NO      EMP.EMP_NO%TYPE
    ,P_JCODE   EMP.JOB_CODE%TYPE
)
IS
    RES VARCHAR2(100);
BEGIN
    INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) 
            VALUES (P_E_ID, P_E_NAME, P_E_NO, P_JCODE);
            
    RES := SQL%ROWCOUNT || '건 삽입되었습니다.';
    
    INSERT INTO PROC_RES VALUES('PROC_INS_EMP', RES, SYSDATE);
END;
/
EXEC PROC_INS_EMP('&사번', '&이름', '&주민번호', '&직급코드');

SELECT * FROM PROC_RES;
SELECT * FROM EMP ORDER BY 1;

/*
    2) IN/OUT 매개변수가 있는 프로시저
    IN 매개변수 : 프로시저 내부에서 사용될 변수
    OUT 매개변수 : 프로시저 호출부(외부)에서 사용될 값을 담아줄 변수
*/

-- 사번을 입력 받아서 사원명, 급여, 보너스를 OUT 매개변수에 담아 봅시다.
CREATE OR REPLACE PROCEDURE PROC_SEL_EMP_ID
(   P_E_ID          IN EMP.EMP_ID%TYPE
    , P_E_NAME      IN EMP.EMP_NAME%TYPE
    , P_SALARY    OUT EMP.SALARY%TYPE
    , P_BONUS       OUT EMP.BONUS%TYPE
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('P_E_ID : '||P_E_ID);
    DBMS_OUTPUT.PUT_LINE('P_E_NAME : '||P_E_NAME);

    SELECT EMP_NAME, SALARY, BONUS
    INTO P_E_NAME, P_SALARY, P_BONUS
    FROM EMP
    WHERE EMP_ID = P_E_ID;
END;
/

-- 바인드 변수를 선언 (VARIABLE, VAR)
-- VARIABLE|VAR 변수명 타입(길이)
-- 참조변수 형식으로 쓰니까 오류가 나서.. 기본 데이터 타입으로 지정해주었다.
--VARIABLE V_EMP_NAME  EMP.EMP_NAME%TYPE;
VAR V_EMP_NAME  VARCHAR2(30);
VAR V_SALARY    NUMBER;
--VAR V_BONUS     EMP.BONUS%TYPE;
VAR V_BONUS     NUMBER;

-- 자동으로 출력 ?
--SET AUTOPRINT ON;
SET SERVEROUTPUT ON;
SET AUTOPRINT OFF;

-- 프로시저 실행
-- 바인드변수에 값을 설정
-- EXEC :변수명 := '값';
EXEC :V_EMP_NAME := '실리카겔';
PRINT V_EMP_NAME;
-- 바인드 변수는 :변수명 형태로 참조 가능
EXEC PROC_SEL_EMP_ID('200', :V_EMP_NAME, :V_SALARY, :V_BONUS);

-- 실행 결과 바인드변수를 출력
PRINT V_EMP_NAME;
PRINT V_SALARY;
PRINT V_BONUS;
-- TODO 아래 연습문제는 나중에 해보자구..
/*
    실습
    년도별 성적이 우수한 학생을 선발하여 장학금을 지급 합니다
    
    1. 년도별 평균학점이 4.5 이상인 학생의 학과명, 년도분기, 학번, 이름, 평균학점을 조회 하는 쿼리를 작성 합니다.
    2. 위 쿼리를 바탕으로 장학금 테이블을 생성 합니다.
    3. 년도(200101)를 입력 받고 장학금을 받는 학생의 수를 반환하는 프로시저를 생성 합니다. 
        장학금테이블의 데이터를 모두 삭제합니다
        장학금을 받는 학생을 조회후 삽입 합니다.
        장학금 받는 학생의 수를 OUT 변수에 저장하고 출력 합니다.
*/

--SELECT DEPARTMENT_NAME, STUDENT_NO, STUDENT_NAME, AVG(POINT)
--FROM 


-- IN 직급코드
-- IN 직급명
-- OUT 처리결과(몇건?)
-- 프로시저명 PROC_UPT_TITLE
-- 파라미터로 전달 받은 직급코드의 직급명을 변경

CREATE OR REPLACE PROCEDURE PROC_UPT_TITLE 
(
    P_JCODE     IN JOB.JOB_CODE%TYPE        --> 프로시저에서 값을 받아올거라 IN
    , P_JNAME   IN JOB.JOB_NAME%TYPE
    , RES       OUT VARCHAR2                --> OUT 값을 받아오지않음 / 프로시저 외부로 값을 저장함
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('P_JCODE : '||P_JCODE);
    DBMS_OUTPUT.PUT_LINE('P_JNAME : '||P_JNAME);
    DBMS_OUTPUT.PUT_LINE('RES : '||RES);
    
    UPDATE JOB 
    SET JOB_NAME = P_JNAME
    WHERE JOB_CODE = P_JCODE;
    
    RES := SQL%ROWCOUNT || '건 처리되었음!';
    
    DBMS_OUTPUT.PUT_LINE('P_JCODE : '||P_JCODE);
    DBMS_OUTPUT.PUT_LINE('P_JNAME : '||P_JNAME);
    DBMS_OUTPUT.PUT_LINE('RES : '||RES);
END;
/

-- 아래 순서와 같이 실습을 해보았습니다.
-- 1. 프로시저 생성
-- 2. 변수 선언 (OUT 파라미터의 값을 확인해보고자)
VAR RES VARCHAR2(100);
-- 3. 프로시저 실행
--      실행 시 :변수명
EXEC PROC_UPT_TITLE(:P_JCODE, :P_JNAME);
EXEC PROC_UPT_TITLE('J1', '회사 내꺼', :RES);
-- 4. 변수값 출력 (OUT 파라미터로부터 저장된 값을 출력)
PRINT RES;
SELECT * FROM JOB;












