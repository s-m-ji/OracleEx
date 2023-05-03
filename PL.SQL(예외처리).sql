/*
    <PL/SQL 예외처리부(EXCEPTION SECTION)>
        예외란 실행 중 발생하는 오류를 뜻하고 PL/SQL 문에서 발생한 예외를 예외처리부에서 코드적으로 처리가 가능하다.

        [표현법]
            DECLARE
                ...
            BEGIN
                ...
            EXCEPTION
                WHEN 예외명 1 THEN 예외처리구문 1;
                WHEN 예외명 2 THEN 예외처리구문 2;
                ...
                WHEN OTHERS THEN 예외처리구문;
                
        * 오라클에서 미리 정의되어 있는 예외
          - NO_DATA_FOUND : SELECT 문의 수행 결과가 한 행도 없을 경우에 발생한다.
          - TOO_MANY_ROWS : 한 행이 리턴되어야 하는데 SELECT 문에서 여러 개의 행을 리턴할 때 발생한다. 
          - ZERO_DIVIDE   : 숫자를 0으로 나눌 때 발생한다.
          - DUP_VAL_ON_INDEX : UNIQUE 제약 조건을 가진 컬럼에 중복된 데이터가 INSERT 될 때 발생한다.
*/
DECLARE
    result NUMBER;
BEGIN
    result := 10 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || result);
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('나누기 연산 시 0으로 나눌 수 없음');
END;
/
/*
    < 사용자 정의 예외 >
    - 사용자가 예외를 직접 정의 하고 사용
    - 필수값체크, 유효성검사등에 사용
    - 예외이름을 부여하므로 코드를 읽기 편하게 해주고 로직 파악도 수월 해짐
    
    사용방법
    1. EXCEPTION 타입의 변수를 선언 합니다.
    2. 메세지 처리대신 RAISE EXCEPTION타입 변수명
    3. EXCEPTION절 에서 처리
    
    실습.
    1. 사원테이블에 신규 사원을 추가하는 프로시저를 생성해봅시다
        파라메터 : 사번, 이름, 주민번호, 직급코드, 부서번호, 입사년월
    
    2. 부서번호가 없는경우 사용자 정의 예외를 발생 시켜 봅시다    
*/

/*
    시스템 오류처럼 코드와 메세지를 입력하는 방법
    1. 파라미터 추가 입사일(YYYYMM)
    2. MM > 12 일 경우  오류 발생 | NOT BETWEEN 1 MM AND 12 
*/

CREATE OR REPLACE PROCEDURE PROC_INS_EMP 
(
    P_E_ID          EMP.EMP_ID%TYPE
    , P_E_NAME      EMP.EMP_NAME%TYPE
    , P_E_NO        EMP.EMP_NO%TYPE    
    , P_JCODE       EMP.JOB_CODE%TYPE
    , P_DCODE       EMP.DEPT_CODE%TYPE
    , P_HDATE       VARCHAR2    -- YYYYMM 형식으로 넣을 것
)
IS
   V_RES VARCHAR2(100);
   -- 사용자 정의 예외를 선언
   -- 변수명 EXCEPTION;
   EX_INVALID_JOB_CODE EXCEPTION;
   PRAGMA EXCEPTION_INIT(EX_INVALID_JOB_CODE, -20000); 
   
   EX_INVALID_DEPT_CODE EXCEPTION;
   PRAGMA EXCEPTION_INIT (EX_INVALID_DEPT_CODE, -20001);
   
   V_CNT NUMBER := 0;
   
BEGIN
    -- 유효성 체크
    
    -- 직급 코드가 유효하지 않은 경우
    -- 파라미터로 넘어온 JOB_CODE가 JOB 테이블에 등록된 코드인지 확인
    --> JOB_NAME에 등록된 값이 아니면 NO_DATA_FOUND 예외 발생(조회된 데이터가 없는 경우)
    -- 유효하지않은 JOB_CODE는 오류로 판단 : 예외 발생
        -- RAISE 예외명 (IS에서 선언한..!)
    SELECT COUNT(*) INTO V_CNT FROM JOB WHERE JOB_CODE = P_JCODE;     
    IF V_CNT = 0 THEN   
        RAISE EX_INVALID_JOB_CODE;   
        RAISE_APPLICATION_ERROR (-20000, '');
    END IF; 
    
    -- 부서 코드가 유효하지 않은 경우
    SELECT COUNT(*) INTO V_CNT FROM DEPT WHERE DEPT_ID = P_DCODE;
    IF V_CNT = 0 THEN
--        RAISE EX_INVALID_DEPT_CODE;
        RAISE_APPLICATION_ERROR (-20001, '');   --> 어차피 메세지는 테이블에서 가져올거라 여긴 공백으로 둬도 됨.
    END IF;
        
    -- 입사일 유효성 체크
    -- MM의 최소 범위를 01이 아니라 1이라고 하면 ????????
    --==>> 그럼 입력 형식도 '202301'이 아니라 '20231'이라고 써야함
    --==>> 참고로 결과 집합 내 날짜 형식은 오라클 기본 설정에 따라 나오는거라서 상관없음 
    IF SUBSTR(P_HDATE,5,2) NOT BETWEEN '01' AND '12' THEN
    -- 프로시저를 사용한 오류 처리
    -- 파라미터로 오류코드와 메세지를 입력
    -- 코드는 20000 ~ 20999까지 사용 가능
    RAISE_APPLICATION_ERROR(-20000, 'HIRE_DATE 이상하다.');
    END IF;
    
    INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, HIRE_DATE) 
        VALUES (P_E_ID, P_E_NAME, P_E_NO, P_JCODE, P_DCODE, TO_DATE(P_HDATE, 'YYYYMM'));            
    V_RES := SQL%ROWCOUNT || '건 삽입되었습니다.';
    INSERT INTO PROC_RES VALUES('PROC_INS_EMP', V_RES, SYSDATE);
   
EXCEPTION 
    -- WHEN 예외명
    WHEN EX_INVALID_JOB_CODE THEN
        DBMS_OUTPUT.PUT_LINE('JOB_CODE 이상하다.');
        
        -- TODO EX_INVALID_JOB_CODE 선생님 코드랑 비교 확인
        -- 오류 로그를 테이블에 저장하는 프로시저를 호출
        PROC_ERROR_LOG('PROC_INS_EMP', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        
     WHEN EX_INVALID_DEPT_CODE THEN
        DBMS_OUTPUT.PUT_LINE('DEPT_CODE 이상하다.');
        
        -- 오류 로그를 테이블에 저장하는 프로시저를 호출
        PROC_ERROR_LOG('PROC_INS_EMP', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        
        
    -- 예외 이름을 모를 때 사용 
    WHEN OTHERS THEN
        -- 시스템 예외: 오라클에 이미 정의되어있는 예외
        DBMS_OUTPUT.PUT_LINE('다른게 이상하다.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '||SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '||SQLERRM);
        
        -- 오류 라인을 출력
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
        
        -- 오류 로그를 테이블에 저장하는 프로시저를 호출
        PROC_ERROR_LOG('PROC_INS_EMP', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        -- OTHERS인 경우에도 로그 기록이 될 수 있도록 각각 프로시저 다 호출    
END;
/
-- 유효하지 않은 직급코드 테스트
-- 유효하지 않은 부서코드 테스트
-- 유효하지 않은 입사일 테스트
EXEC PROC_INS_EMP('301', '김춘추', '111111-11', 'J1', 'D1', '202301');
EXEC PROC_INS_EMP('302', '김한주', '111111-11', 'J', 'D1', '202301');
SELECT * FROM EMP ORDER BY 1 DESC;
SELECT * FROM ERROR_LOG ORDER BY 1 DESC; 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE PROC_EXCEPTION
IS
    -- 예외 이름을 정의
    EX_TEST EXCEPTION;
    -- 예외 코드를 이름과 연결
    PRAGMA EXCEPTION_INIT(EX_TEST, -20000);                 
    -- 이미 정의된 시스템 오류번호로 연결해봤더니
--          메세지 또한 정의된 것으로 출력됨 'ORA-01843: 지정한 월이 부적합합니다.'
--    PRAGMA EXCEPTION_INIT(EX_TEST, -1843);
    -- RAISE_APPLICATION_ERROR엔 마지막에 정의한 예외가 연결되기에 코드 맞춰주기.
    
BEGIN
    -- 예외 발생
--    RAISE EX_TEST;
    -- 오류코드에 메세지를 추가 -> 예외 발생
    RAISE_APPLICATION_ERROR(-20000, '!오류 발생 메세지!');      
    
EXCEPTION
    -- EXCEPTION이 발생했을 때 처리
    WHEN EX_TEST THEN
        DBMS_OUTPUT.PUT_LINE('삐빕 오류가 발생했다!');  
        
        DBMS_OUTPUT.PUT_LINE(SQLCODE);  
        -- 오류 코드를 출력
        DBMS_OUTPUT.PUT_LINE(SQLERRM);  
        -- 오류 메세지를 출력
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
        -- 오류가 발생한 라인을 출력   
        
        PROC_ERROR_LOG('PROC_EXCEPTION', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        -- 오류 로그를 테이블에 저장하는 프로시저를 호출
END;
/
-- 프로시저 실행 (매개변수가 없을 때는 이름만 적어도 됨)
EXEC PROC_EXCEPTION;
SELECT * FROM ERROR_LOG; 

-- 프로시저 수정 후에는 꼭 재정의를.. 저장을 깜빡할 때가 있다우..

/*
    <현장 노~하~~우~~~>
    예외처리의 공통모듈을 생성해보자우
    예외테이블을 정의하고 예외 발생 시 테이블에 로그를 남겨봅시다우
*/

-- 1. 테이블 생성
-- 오류 이력을 남기기 위한 테이블을 생성
CREATE TABLE ERROR_LOG(
    ERROR_SEQ       NUMBER                  -- 에러 시퀀스
    , ERROR_NAME    VARCHAR2(80)            -- 프로그램명
    , ERROR_CODE    NUMBER                  -- 에러 코드
    , ERROR_MESSAGE VARCHAR2(300)           -- 에러 메세지
    , ERROR_LINE    VARCHAR2(100)           -- 에러 라인
    , ERROR_DATE    DATE DEFAULT SYSDATE    -- 에러발생일자 
);

-- 2. 시퀀스 생성
-- CREATE SEQUENCE SEQ_ERROR_LOG START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ERROR_LOG;
DROP SEQUENCE SEQ_ERROR_LOG;

-- 3. 프로시저 생성
-- 프로그램명, 오류코드, 오류메세지, 오류라인을 파라미터로 받아서 예외테이블에 입력하는 프로시저를 작성
CREATE OR REPLACE PROCEDURE PROC_ERROR_LOG
(
    P_ERROR_NAME ERROR_LOG.ERROR_NAME%TYPE    
    , P_ERROR_CODE ERROR_LOG.ERROR_CODE%TYPE    
    , P_ERROR_MESSAGE ERROR_LOG.ERROR_MESSAGE%TYPE 
    , P_ERROR_LINE ERROR_LOG.ERROR_LINE%TYPE 
)
IS
    V_ERR_MSG ERROR_LOG.ERROR_MESSAGE%TYPE;
BEGIN
    -- 사용자 정의 예외 코드를 조회하여 메세지 변수에 담는다.
    -- 예외코드가 등록되지 않은 경우 (ERROR_CODE가 없는 코드일 경우)
    --      예외가 발생되므로 블럭으로 감쌌다. 내부 BEGIN ~ END
    BEGIN
        SELECT ERROR_MESSAGE 
        INTO V_ERR_MSG 
        FROM ERROR_USER_DEFINE 
        WHERE ERROR_CODE = P_ERROR_CODE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        V_ERR_MSG := P_ERROR_MESSAGE;
    END;
    INSERT INTO ERROR_LOG VALUES 
--        (SEQ_ERROR_LOG.NEXTVAL, P_ERROR_NAME, P_ERROR_CODE, P_ERROR_MESSAGE, P_ERROR_LINE, SYSDATE);
        (SEQ_ERROR_LOG.NEXTVAL, P_ERROR_NAME, P_ERROR_CODE, V_ERR_MSG, P_ERROR_LINE, SYSDATE);
        
    -- 테이블에 값을 입력하고 나면 항상 커밋을 해야하니까..! 잊지말고 적어주
    COMMIT;     
END;
/
-- 프로시저 실행
EXEC PROC_ERROR_LOG('테스트7 ERROR_NAME','123456789','테스트7 ERROR_MESSAGE','테스트7 ERROR_LINE');
-- 테이블 조회
SELECT * FROM ERROR_LOG;
-- 시퀀스 조회
SELECT SEQ_ERROR_LOG.NEXTVAL FROM DUAL;
SELECT SEQ_ERROR_LOG.CURRVAL FROM DUAL;

/*
    (참고)
    협업 시 사용자 정의 예외 오류 코드가 의도치않게 중복으로 사용되면서 생길 미스를 방지하기 위해서
    보통 코드만 기록한 테이블, 메세지만 기록한 테이블을 별도로 생성하여 값을 참조해와서 로그 테이블에 기록한다구..
*/

-- 오류 코드와 메세지를 정의하여 사용
CREATE TABLE ERROR_USER_DEFINE(
    ERROR_CODE          NUMBER PRIMARY KEY      -- 에러 코드
    , ERROR_MESSAGE     VARCHAR2(300)           -- 에러 메세지
    , CREATE_DATE       DATE DEFAULT SYSDATE    -- 등록일자
);

SELECT * FROM ERROR_USER_DEFINE;

INSERT INTO ERROR_USER_DEFINE (ERROR_CODE, ERROR_MESSAGE) VALUES (-20000, '직급코드가 이상하다');
INSERT INTO ERROR_USER_DEFINE (ERROR_CODE, ERROR_MESSAGE) VALUES (-20001, '부서코드가 이상하다');
INSERT INTO ERROR_USER_DEFINE (ERROR_CODE, ERROR_MESSAGE) VALUES (-20002, '지정한 월이 이상하다');
COMMIT;

SELECT ERROR_MESSAGE FROM ERROR_USER_DEFINE WHERE ERROR_CODE = -20000;
















