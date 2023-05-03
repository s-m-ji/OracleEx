/*
    <PL/SQL ����ó����(EXCEPTION SECTION)>
        ���ܶ� ���� �� �߻��ϴ� ������ ���ϰ� PL/SQL ������ �߻��� ���ܸ� ����ó���ο��� �ڵ������� ó���� �����ϴ�.

        [ǥ����]
            DECLARE
                ...
            BEGIN
                ...
            EXCEPTION
                WHEN ���ܸ� 1 THEN ����ó������ 1;
                WHEN ���ܸ� 2 THEN ����ó������ 2;
                ...
                WHEN OTHERS THEN ����ó������;
                
        * ����Ŭ���� �̸� ���ǵǾ� �ִ� ����
          - NO_DATA_FOUND : SELECT ���� ���� ����� �� �൵ ���� ��쿡 �߻��Ѵ�.
          - TOO_MANY_ROWS : �� ���� ���ϵǾ�� �ϴµ� SELECT ������ ���� ���� ���� ������ �� �߻��Ѵ�. 
          - ZERO_DIVIDE   : ���ڸ� 0���� ���� �� �߻��Ѵ�.
          - DUP_VAL_ON_INDEX : UNIQUE ���� ������ ���� �÷��� �ߺ��� �����Ͱ� INSERT �� �� �߻��Ѵ�.
*/
DECLARE
    result NUMBER;
BEGIN
    result := 10 / &����;
    DBMS_OUTPUT.PUT_LINE('��� : ' || result);
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('������ ���� �� 0���� ���� �� ����');
END;
/
/*
    < ����� ���� ���� >
    - ����ڰ� ���ܸ� ���� ���� �ϰ� ���
    - �ʼ���üũ, ��ȿ���˻� ���
    - �����̸��� �ο��ϹǷ� �ڵ带 �б� ���ϰ� ���ְ� ���� �ľǵ� ���� ����
    
    �����
    1. EXCEPTION Ÿ���� ������ ���� �մϴ�.
    2. �޼��� ó����� RAISE EXCEPTIONŸ�� ������
    3. EXCEPTION�� ���� ó��
    
    �ǽ�.
    1. ������̺� �ű� ����� �߰��ϴ� ���ν����� �����غ��ô�
        �Ķ���� : ���, �̸�, �ֹι�ȣ, �����ڵ�, �μ���ȣ, �Ի���
    
    2. �μ���ȣ�� ���°�� ����� ���� ���ܸ� �߻� ���� ���ô�    
*/

/*
    �ý��� ����ó�� �ڵ�� �޼����� �Է��ϴ� ���
    1. �Ķ���� �߰� �Ի���(YYYYMM)
    2. MM > 12 �� ���  ���� �߻� | NOT BETWEEN 1 MM AND 12 
*/

CREATE OR REPLACE PROCEDURE PROC_INS_EMP 
(
    P_E_ID          EMP.EMP_ID%TYPE
    , P_E_NAME      EMP.EMP_NAME%TYPE
    , P_E_NO        EMP.EMP_NO%TYPE    
    , P_JCODE       EMP.JOB_CODE%TYPE
    , P_DCODE       EMP.DEPT_CODE%TYPE
    , P_HDATE       VARCHAR2    -- YYYYMM �������� ���� ��
)
IS
   V_RES VARCHAR2(100);
   -- ����� ���� ���ܸ� ����
   -- ������ EXCEPTION;
   EX_INVALID_JOB_CODE EXCEPTION;
   PRAGMA EXCEPTION_INIT(EX_INVALID_JOB_CODE, -20000); 
   
   EX_INVALID_DEPT_CODE EXCEPTION;
   PRAGMA EXCEPTION_INIT (EX_INVALID_DEPT_CODE, -20001);
   
   V_CNT NUMBER := 0;
   
BEGIN
    -- ��ȿ�� üũ
    
    -- ���� �ڵ尡 ��ȿ���� ���� ���
    -- �Ķ���ͷ� �Ѿ�� JOB_CODE�� JOB ���̺� ��ϵ� �ڵ����� Ȯ��
    --> JOB_NAME�� ��ϵ� ���� �ƴϸ� NO_DATA_FOUND ���� �߻�(��ȸ�� �����Ͱ� ���� ���)
    -- ��ȿ�������� JOB_CODE�� ������ �Ǵ� : ���� �߻�
        -- RAISE ���ܸ� (IS���� ������..!)
    SELECT COUNT(*) INTO V_CNT FROM JOB WHERE JOB_CODE = P_JCODE;     
    IF V_CNT = 0 THEN   
        RAISE EX_INVALID_JOB_CODE;   
        RAISE_APPLICATION_ERROR (-20000, '');
    END IF; 
    
    -- �μ� �ڵ尡 ��ȿ���� ���� ���
    SELECT COUNT(*) INTO V_CNT FROM DEPT WHERE DEPT_ID = P_DCODE;
    IF V_CNT = 0 THEN
--        RAISE EX_INVALID_DEPT_CODE;
        RAISE_APPLICATION_ERROR (-20001, '');   --> ������ �޼����� ���̺��� �����ðŶ� ���� �������� �ֵ� ��.
    END IF;
        
    -- �Ի��� ��ȿ�� üũ
    -- MM�� �ּ� ������ 01�� �ƴ϶� 1�̶�� �ϸ� ????????
    --==>> �׷� �Է� ���ĵ� '202301'�� �ƴ϶� '20231'�̶�� �����
    --==>> ����� ��� ���� �� ��¥ ������ ����Ŭ �⺻ ������ ���� �����°Ŷ� ������� 
    IF SUBSTR(P_HDATE,5,2) NOT BETWEEN '01' AND '12' THEN
    -- ���ν����� ����� ���� ó��
    -- �Ķ���ͷ� �����ڵ�� �޼����� �Է�
    -- �ڵ�� 20000 ~ 20999���� ��� ����
    RAISE_APPLICATION_ERROR(-20000, 'HIRE_DATE �̻��ϴ�.');
    END IF;
    
    INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, DEPT_CODE, HIRE_DATE) 
        VALUES (P_E_ID, P_E_NAME, P_E_NO, P_JCODE, P_DCODE, TO_DATE(P_HDATE, 'YYYYMM'));            
    V_RES := SQL%ROWCOUNT || '�� ���ԵǾ����ϴ�.';
    INSERT INTO PROC_RES VALUES('PROC_INS_EMP', V_RES, SYSDATE);
   
EXCEPTION 
    -- WHEN ���ܸ�
    WHEN EX_INVALID_JOB_CODE THEN
        DBMS_OUTPUT.PUT_LINE('JOB_CODE �̻��ϴ�.');
        
        -- TODO EX_INVALID_JOB_CODE ������ �ڵ�� �� Ȯ��
        -- ���� �α׸� ���̺� �����ϴ� ���ν����� ȣ��
        PROC_ERROR_LOG('PROC_INS_EMP', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        
     WHEN EX_INVALID_DEPT_CODE THEN
        DBMS_OUTPUT.PUT_LINE('DEPT_CODE �̻��ϴ�.');
        
        -- ���� �α׸� ���̺� �����ϴ� ���ν����� ȣ��
        PROC_ERROR_LOG('PROC_INS_EMP', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        
        
    -- ���� �̸��� �� �� ��� 
    WHEN OTHERS THEN
        -- �ý��� ����: ����Ŭ�� �̹� ���ǵǾ��ִ� ����
        DBMS_OUTPUT.PUT_LINE('�ٸ��� �̻��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '||SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '||SQLERRM);
        
        -- ���� ������ ���
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
        
        -- ���� �α׸� ���̺� �����ϴ� ���ν����� ȣ��
        PROC_ERROR_LOG('PROC_INS_EMP', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        -- OTHERS�� ��쿡�� �α� ����� �� �� �ֵ��� ���� ���ν��� �� ȣ��    
END;
/
-- ��ȿ���� ���� �����ڵ� �׽�Ʈ
-- ��ȿ���� ���� �μ��ڵ� �׽�Ʈ
-- ��ȿ���� ���� �Ի��� �׽�Ʈ
EXEC PROC_INS_EMP('301', '������', '111111-11', 'J1', 'D1', '202301');
EXEC PROC_INS_EMP('302', '������', '111111-11', 'J', 'D1', '202301');
SELECT * FROM EMP ORDER BY 1 DESC;
SELECT * FROM ERROR_LOG ORDER BY 1 DESC; 

SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE PROC_EXCEPTION
IS
    -- ���� �̸��� ����
    EX_TEST EXCEPTION;
    -- ���� �ڵ带 �̸��� ����
    PRAGMA EXCEPTION_INIT(EX_TEST, -20000);                 
    -- �̹� ���ǵ� �ý��� ������ȣ�� �����غô���
--          �޼��� ���� ���ǵ� ������ ��µ� 'ORA-01843: ������ ���� �������մϴ�.'
--    PRAGMA EXCEPTION_INIT(EX_TEST, -1843);
    -- RAISE_APPLICATION_ERROR�� �������� ������ ���ܰ� ����Ǳ⿡ �ڵ� �����ֱ�.
    
BEGIN
    -- ���� �߻�
--    RAISE EX_TEST;
    -- �����ڵ忡 �޼����� �߰� -> ���� �߻�
    RAISE_APPLICATION_ERROR(-20000, '!���� �߻� �޼���!');      
    
EXCEPTION
    -- EXCEPTION�� �߻����� �� ó��
    WHEN EX_TEST THEN
        DBMS_OUTPUT.PUT_LINE('�ߺ� ������ �߻��ߴ�!');  
        
        DBMS_OUTPUT.PUT_LINE(SQLCODE);  
        -- ���� �ڵ带 ���
        DBMS_OUTPUT.PUT_LINE(SQLERRM);  
        -- ���� �޼����� ���
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);  
        -- ������ �߻��� ������ ���   
        
        PROC_ERROR_LOG('PROC_EXCEPTION', SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        -- ���� �α׸� ���̺� �����ϴ� ���ν����� ȣ��
END;
/
-- ���ν��� ���� (�Ű������� ���� ���� �̸��� ��� ��)
EXEC PROC_EXCEPTION;
SELECT * FROM ERROR_LOG; 

-- ���ν��� ���� �Ŀ��� �� �����Ǹ�.. ������ ������ ���� �ִٿ�..

/*
    <���� ��~��~~��~~~>
    ����ó���� �������� �����غ��ڿ�
    �������̺��� �����ϰ� ���� �߻� �� ���̺� �α׸� ���ܺ��ôٿ�
*/

-- 1. ���̺� ����
-- ���� �̷��� ����� ���� ���̺��� ����
CREATE TABLE ERROR_LOG(
    ERROR_SEQ       NUMBER                  -- ���� ������
    , ERROR_NAME    VARCHAR2(80)            -- ���α׷���
    , ERROR_CODE    NUMBER                  -- ���� �ڵ�
    , ERROR_MESSAGE VARCHAR2(300)           -- ���� �޼���
    , ERROR_LINE    VARCHAR2(100)           -- ���� ����
    , ERROR_DATE    DATE DEFAULT SYSDATE    -- �����߻����� 
);

-- 2. ������ ����
-- CREATE SEQUENCE SEQ_ERROR_LOG START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_ERROR_LOG;
DROP SEQUENCE SEQ_ERROR_LOG;

-- 3. ���ν��� ����
-- ���α׷���, �����ڵ�, �����޼���, ���������� �Ķ���ͷ� �޾Ƽ� �������̺� �Է��ϴ� ���ν����� �ۼ�
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
    -- ����� ���� ���� �ڵ带 ��ȸ�Ͽ� �޼��� ������ ��´�.
    -- �����ڵ尡 ��ϵ��� ���� ��� (ERROR_CODE�� ���� �ڵ��� ���)
    --      ���ܰ� �߻��ǹǷ� ������ ���մ�. ���� BEGIN ~ END
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
        
    -- ���̺� ���� �Է��ϰ� ���� �׻� Ŀ���� �ؾ��ϴϱ�..! �������� ������
    COMMIT;     
END;
/
-- ���ν��� ����
EXEC PROC_ERROR_LOG('�׽�Ʈ7 ERROR_NAME','123456789','�׽�Ʈ7 ERROR_MESSAGE','�׽�Ʈ7 ERROR_LINE');
-- ���̺� ��ȸ
SELECT * FROM ERROR_LOG;
-- ������ ��ȸ
SELECT SEQ_ERROR_LOG.NEXTVAL FROM DUAL;
SELECT SEQ_ERROR_LOG.CURRVAL FROM DUAL;

/*
    (����)
    ���� �� ����� ���� ���� ���� �ڵ尡 �ǵ�ġ�ʰ� �ߺ����� ���Ǹ鼭 ���� �̽��� �����ϱ� ���ؼ�
    ���� �ڵ常 ����� ���̺�, �޼����� ����� ���̺��� ������ �����Ͽ� ���� �����ؿͼ� �α� ���̺� ����Ѵٱ�..
*/

-- ���� �ڵ�� �޼����� �����Ͽ� ���
CREATE TABLE ERROR_USER_DEFINE(
    ERROR_CODE          NUMBER PRIMARY KEY      -- ���� �ڵ�
    , ERROR_MESSAGE     VARCHAR2(300)           -- ���� �޼���
    , CREATE_DATE       DATE DEFAULT SYSDATE    -- �������
);

SELECT * FROM ERROR_USER_DEFINE;

INSERT INTO ERROR_USER_DEFINE (ERROR_CODE, ERROR_MESSAGE) VALUES (-20000, '�����ڵ尡 �̻��ϴ�');
INSERT INTO ERROR_USER_DEFINE (ERROR_CODE, ERROR_MESSAGE) VALUES (-20001, '�μ��ڵ尡 �̻��ϴ�');
INSERT INTO ERROR_USER_DEFINE (ERROR_CODE, ERROR_MESSAGE) VALUES (-20002, '������ ���� �̻��ϴ�');
COMMIT;

SELECT ERROR_MESSAGE FROM ERROR_USER_DEFINE WHERE ERROR_CODE = -20000;
















