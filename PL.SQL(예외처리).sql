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
   EX_INVALID_DEPT_CODE EXCEPTION;
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
    END IF; 
    
    -- �μ� �ڵ尡 ��ȿ���� ���� ���
    SELECT COUNT(*) INTO V_CNT FROM DEPT WHERE DEPT_ID = P_DCODE;
    IF V_CNT = 0 THEN
        RAISE EX_INVALID_DEPT_CODE;
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
     WHEN EX_INVALID_DEPT_CODE THEN
        DBMS_OUTPUT.PUT_LINE('DEPT_CODE �̻��ϴ�.');
    -- ���� �̸��� �� �� ��� 
    WHEN OTHERS THEN
        -- �ý��� ����: ����Ŭ�� �̹� ���ǵǾ��ִ� ����
        DBMS_OUTPUT.PUT_LINE('�ٸ��� �̻��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR CODE: '||SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR MESSAGE: '||SQLERRM);
        -- ���� ������ ���
        DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);        
END;
/

EXEC PROC_INS_EMP('301', '������', '111111-11', 'J1', 'D1', '202301');
SELECT * FROM EMP ORDER BY 1 DESC;































