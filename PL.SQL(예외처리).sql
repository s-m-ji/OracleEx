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
   EX_INVALID_DEPT_CODE EXCEPTION;
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
    END IF; 
    
    -- 부서 코드가 유효하지 않은 경우
    SELECT COUNT(*) INTO V_CNT FROM DEPT WHERE DEPT_ID = P_DCODE;
    IF V_CNT = 0 THEN
        RAISE EX_INVALID_DEPT_CODE;
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
     WHEN EX_INVALID_DEPT_CODE THEN
        DBMS_OUTPUT.PUT_LINE('DEPT_CODE 이상하다.');
    -- 예외 이름을 모를 때 사용 
    WHEN OTHERS THEN
        -- 시스템 예외: 오라클에 이미 정의되어있는 예외
        DBMS_OUTPUT.PUT_LINE('다른게 이상하다.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '||SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '||SQLERRM);
        -- 오류 라인을 출력
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);        
END;
/

EXEC PROC_INS_EMP('301', '김춘추', '111111-11', 'J1', 'D1', '202301');
SELECT * FROM EMP ORDER BY 1 DESC;































