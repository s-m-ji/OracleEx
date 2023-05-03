-- EMP ���̺� ����
CREATE TABLE EMP_DUP
AS SELECT * FROM EMP;

-- EMP_DUP ���̺� ��ȸ
SELECT * FROM EMP_DUP; 

/* 
    <PROCEDURE>
        PL/SQL ���� �����ϴ� ��ü�̴�.
        �ʿ��� ������ ������ ������ �ٽ� �Է��� �ʿ� ���� �����ϰ� ȣ���ؼ� ���� ����� ���� �� �ִ�.
        Ư�� ������ ó���ϱ⸸ �ϰ� ������� ��ȯ���� �ʴ´�.
        
        [ǥ����]
            CREATE PROCEDURE ���ν�����
            (
                �Ű����� 1 [IN/OUT] ������Ÿ�� [:=DEFAULT ��],
                �Ű����� 2 [IN/OUT] ������Ÿ�� [:=DEFAULT ��],
                ...
                * DEFUALT�� IN, IN/OUT �� �� ������ ����.
            )
            IS [AS]
                �����
            BEGIN
                �����
            EXCEPTION
                ����ó����
            END [���ν�����];
            /
            
        [������]
            EXECUTE(EXEC) ���ν�����[(�Ű���1, �Ű���2, ...)];
*/

-- EMP_DUP���̺��� �����͸� ��� �����ϴ� ���ν��� ����
CREATE OR REPLACE PROCEDURE PROC_DEL_EMP_DUP
IS
BEGIN
    DELETE FROM EMP_DUP;
    COMMIT;
END;
/
-- ���ν��� ���� (EXECUTE EXEC)
EXEC PROC_DEL_EMP_DUP;

-- �Ű������� �ִ� ���ν����� ���������
-- ���� ���ν����� ��� ���� �� ȣ�� ������ �̿��Ͽ� ���ν����� ������ �� �ֽ��ϴ�
-- �͸��� ���ν����� ��� ������� ����
CREATE OR REPLACE PROCEDURE PROC_DEL_EMP_ID
(P_EMP_ID EMP.EMP_ID%TYPE)
IS
    -- ��������
    RES NUMBER;
BEGIN
    -- �����ۼ�
    DELETE FROM EMP
    WHERE EMP_ID = P_EMP_ID;    
    RES := SQL%ROWCOUNT;

    INSERT INTO PROC_RES VALUES ('PROC_DEL_EMP_ID', RES||'�� �����Ǿ����ϴ�.', SYSDATE);
        
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(RES||'�� �����Ǿ����ϴ�.');
    
END;
/
SELECT * FROM EMP ORDER BY 1;

EXEC PROC_DEL_EMP_ID('102');
EXEC PROC_DEL_EMP_ID('101');
EXEC PROC_DEL_EMP_ID('300');

EXEC PROC_DEL_EMP_ID('&���');

INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) VALUES ('100', '�̹�', '123', 'J1');

CREATE TABLE PROC_RES(
    PROC_NAME   VARCHAR2(100)
    , RES       VARCHAR2(1000)
    , REG_DATE  DATE
);
SELECT * FROM PROC_RES;

-- ���ν����� �����ϴ� ������ ��ųʸ�
SELECT * FROM USER_SOURCE;

-- ��������� �޾Ƽ� ������̺� �Է��ϴ� ���ν����� ����
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
            
    RES := SQL%ROWCOUNT || '�� ���ԵǾ����ϴ�.';
    
    INSERT INTO PROC_RES VALUES('PROC_INS_EMP', RES, SYSDATE);
END;
/
EXEC PROC_INS_EMP('&���', '&�̸�', '&�ֹι�ȣ', '&�����ڵ�');

SELECT * FROM PROC_RES;
SELECT * FROM EMP ORDER BY 1;

/*
    2) IN/OUT �Ű������� �ִ� ���ν���
    IN �Ű����� : ���ν��� ���ο��� ���� ����
    OUT �Ű����� : ���ν��� ȣ���(�ܺ�)���� ���� ���� ����� ����
*/

-- ����� �Է� �޾Ƽ� �����, �޿�, ���ʽ��� OUT �Ű������� ��� ���ô�.
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

-- ���ε� ������ ���� (VARIABLE, VAR)
-- VARIABLE|VAR ������ Ÿ��(����)
-- �������� �������� ���ϱ� ������ ����.. �⺻ ������ Ÿ������ �������־���.
--VARIABLE V_EMP_NAME  EMP.EMP_NAME%TYPE;
VAR V_EMP_NAME  VARCHAR2(30);
VAR V_SALARY    NUMBER;
--VAR V_BONUS     EMP.BONUS%TYPE;
VAR V_BONUS     NUMBER;

-- �ڵ����� ��� ?
--SET AUTOPRINT ON;
SET SERVEROUTPUT ON;
SET AUTOPRINT OFF;

-- ���ν��� ����
-- ���ε庯���� ���� ����
-- EXEC :������ := '��';
EXEC :V_EMP_NAME := '�Ǹ�ī��';
PRINT V_EMP_NAME;
-- ���ε� ������ :������ ���·� ���� ����
EXEC PROC_SEL_EMP_ID('200', :V_EMP_NAME, :V_SALARY, :V_BONUS);

-- ���� ��� ���ε庯���� ���
PRINT V_EMP_NAME;
PRINT V_SALARY;
PRINT V_BONUS;
-- TODO �Ʒ� ���������� ���߿� �غ��ڱ�..
/*
    �ǽ�
    �⵵�� ������ ����� �л��� �����Ͽ� ���б��� ���� �մϴ�
    
    1. �⵵�� ��������� 4.5 �̻��� �л��� �а���, �⵵�б�, �й�, �̸�, ��������� ��ȸ �ϴ� ������ �ۼ� �մϴ�.
    2. �� ������ �������� ���б� ���̺��� ���� �մϴ�.
    3. �⵵(200101)�� �Է� �ް� ���б��� �޴� �л��� ���� ��ȯ�ϴ� ���ν����� ���� �մϴ�. 
        ���б����̺��� �����͸� ��� �����մϴ�
        ���б��� �޴� �л��� ��ȸ�� ���� �մϴ�.
        ���б� �޴� �л��� ���� OUT ������ �����ϰ� ��� �մϴ�.
*/

--SELECT DEPARTMENT_NAME, STUDENT_NO, STUDENT_NAME, AVG(POINT)
--FROM 


-- IN �����ڵ�
-- IN ���޸�
-- OUT ó�����(���?)
-- ���ν����� PROC_UPT_TITLE
-- �Ķ���ͷ� ���� ���� �����ڵ��� ���޸��� ����

CREATE OR REPLACE PROCEDURE PROC_UPT_TITLE 
(
    P_JCODE     IN JOB.JOB_CODE%TYPE        --> ���ν������� ���� �޾ƿðŶ� IN
    , P_JNAME   IN JOB.JOB_NAME%TYPE
    , RES       OUT VARCHAR2                --> OUT ���� �޾ƿ������� / ���ν��� �ܺη� ���� ������
)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('P_JCODE : '||P_JCODE);
    DBMS_OUTPUT.PUT_LINE('P_JNAME : '||P_JNAME);
    DBMS_OUTPUT.PUT_LINE('RES : '||RES);
    
    UPDATE JOB 
    SET JOB_NAME = P_JNAME
    WHERE JOB_CODE = P_JCODE;
    
    RES := SQL%ROWCOUNT || '�� ó���Ǿ���!';
    
    DBMS_OUTPUT.PUT_LINE('P_JCODE : '||P_JCODE);
    DBMS_OUTPUT.PUT_LINE('P_JNAME : '||P_JNAME);
    DBMS_OUTPUT.PUT_LINE('RES : '||RES);
END;
/

-- �Ʒ� ������ ���� �ǽ��� �غ��ҽ��ϴ�.
-- 1. ���ν��� ����
-- 2. ���� ���� (OUT �Ķ������ ���� Ȯ���غ�����)
VAR RES VARCHAR2(100);
-- 3. ���ν��� ����
--      ���� �� :������
EXEC PROC_UPT_TITLE(:P_JCODE, :P_JNAME);
EXEC PROC_UPT_TITLE('J1', 'ȸ�� ����', :RES);
-- 4. ������ ��� (OUT �Ķ���ͷκ��� ����� ���� ���)
PRINT RES;
SELECT * FROM JOB;












