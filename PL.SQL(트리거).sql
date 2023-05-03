/*
    <TRIGGER>
        ���̺��� INSERT, UPDATE, DELETE �� DML ������ ���ؼ� ����� ���
        �ڵ����� ����� ������ �����س��� ��ü�̴�.
        
        * Ʈ������ ����
          1) SQL ���� ���� �ñ⿡ ���� �з�
            - BEFORE TRIGGER : �ش� SQL ���� ���� ���� Ʈ���Ÿ� �����Ѵ�.
            - AFTER TRIGGER : �ش� SQL ���� ���� �Ŀ� Ʈ���Ÿ� �����Ѵ�.
          
          2) SQL ���� ���� ������ �޴� �࿡ ���� �з�
            - ���� Ʈ���� : �ش� SQL ���� �� ���� Ʈ���Ÿ� �����Ѵ�.
            - �� Ʈ���� : �ش� SQL ���� ������ �޴� �ึ�� Ʈ���Ÿ� �����Ѵ�.
            
        [ǥ����]
            CREATE OR REPLACE TRIGGER Ʈ���Ÿ�
            BEFORE|AFTER INSERT|UPDATE|DELETE ON ���̸�
            [FOR EACH ROW]  --> �⺻�� ���� Ʈ���� / EACH ���� �� Ʈ����
            DECLARE
                �����
            BEGIN
                �����
            EXCEPTION
                ����ó����
            END;
            /
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRG_EMP_IST
AFTER INSERT ON EMP
BEGIN
    DBMS_OUTPUT.PUT_LINE('���� ����� ��ϵǾ����ϴ� ���R');
END;
/
DESC EMP;
SELECT MAX(EMP_ID)+1 FROM EMP;

INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES((SELECT MAX(EMP_ID)+1 FROM EMP)
                , '������', '123456-1234567', 'J9' );

UPDATE EMP SET DEPT_CODE = NULL WHERE DEPT_CODE = 'D1';
SELECT * FROM EMP WHERE DEPT_CODE = 'D1';
-- TODO �ٽ� Ȯ���غ�����
CREATE OR REPLACE TRIGGER TRG_DEPT_DEL
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('��� ������ ������Ʈ �Ǿ�����');
    -- FOR EACH ROW ������ ���� �� Ʈ���ſ����� �� �� �ִ� �͵�
    -- :0LD     ���̺��� ����Ǳ� �� ������
    -- :NEW     ���̺��� ����� �� ������
    DBMS_OUTPUT.PUT_LINE('���� ��' ||:0LD.DEPT_CODE||'���� ��' ||:NEW.DEPT_CODE);
END;
/

DROP TRIGGER TRG_DEPT_DEL;

-- ���̺��� ������ �����Ͽ� HISTORY ���̺��� ����
CREATE TABLE EMP_HISTORY
AS
    SELECT EMP.*, SYSDATE AS "REGDATE" FROM EMP WHERE 1<0;
SELECT * FROM EMP_HISTORY;

-- EMP ���̺� ������Ʈ �۾��� �Ͼ ��
-- ���������� �߻��� ���� ���� ������ EMP_HISTORY ���̺� �Է�
CREATE OR REPLACE TRIGGER TRG_EMP_UDT
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    INSERT INTO EMP_HISTORY (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES(:OLD.EMP_ID, :OLD.EMP_NAME, :OLD.EMP_NO, :OLD.JOB_CODE);
END;
/

UPDATE EMP SET EMP_NAME = '�̹�»' WHERE EMP_ID = '105';
SELECT * FROM EMP WHERE EMP_ID = '105';
SELECT * FROM EMP_HISTORY;






