 /*
    <FUNCTION>
        ������ SQL�� Ȱ���Ͽ� �Ϸ��� SQL ó���� �����ϰ�, 
        ���� ����� ���� ������ ��ȯ�� �� �ִ� ������ SQL
        
        [ǥ����]
            CREATE FUNCTION �Լ���
            (
                �Ű������� 1 Ÿ��,
                �Ű������� 2 Ÿ��,
                ...
            )
            RETURN ������Ÿ�� 
            IS
                ����� (���� ����)
            BEGIN
                ����� (���� ���� : �ݺ���, ��� ���)
                
                RETRUN ��ȯ��; -- ���ν����� �ٸ��� RETURN ������ �߰��ȴ�.
            EXCEPTION
                ����ó����
            END [�Լ���];
            /
*/

SET SERVEROUTPUT ON;

DESC EMP;
-- EMP ���̺� �����͸� �Է��ϴ� �͸��� ����� �ۼ��غ��ϴ�.

DECLARE
    V_E_ID      EMP.EMP_ID%TYPE;
    V_E_NAME    EMP.EMP_NAME%TYPE;
    V_E_NO      EMP.EMP_NO%TYPE;
    V_E_JCODE   EMP.JOB_CODE%TYPE;
BEGIN
    V_E_ID      := '&���';
    V_E_NAME    := '&�����';
    V_E_NO      := '&�ֹι�ȣ';
    V_E_JCODE   := '&���޹�ȣ';
    
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
    V_E_ID      := '&���';
    V_E_NAME    := '&�����';
    V_E_NO      := '&�ֹι�ȣ';
    V_E_JCODE   := '&���޹�ȣ'; 
    
    -- JOB ���̺� ���� �Է��� JOB_CODE�� �� ���� �ִ��� �� 
    SELECT COUNT(*) INTO V_CNT FROM JOB WHERE JOB_CODE = V_E_JCODE;
    
    IF (V_CNT = 0) THEN
        DBMS_OUTPUT.PUT_LINE('JOB_CODE�� �߸� �Է��߽��ϴ�.');
    ELSE
        INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE) 
                    VALUES (V_E_ID, V_E_NAME, V_E_NO, V_E_JCODE);
        DBMS_OUTPUT.PUT_LINE(V_E_NAME || ' ����� �߰��Ǿ����ϴ�.');
    END IF;
END;
/

-- �Է¹��� JCODE�� ��� ������ �ڵ����� Ȯ�� (��ȿ�� �˻� = Validation Check)

SELECT * FROM EMP ORDER BY EMP_ID;
UPDATE EMP SET EMP_NAME = '�̹�2' WHERE EMP_ID = '101';

-- ����� �Է¹޾Ƽ� �޿��� ����ϴ� �Լ��� ����ٸ� ?

CREATE OR REPLACE FUNCTION FN_GET_SALARY 
(
    P_EMP_ID EMP.EMP_ID%TYPE
)
--RETURN NUMBER
RETURN VARCHAR2
IS -- �����
--    V_SALARY EMP.SALARY%TYPE;
    V_SALARY VARCHAR2(20);
--    V_SALARY NUMBER;
BEGIN -- �����
     -- �޿��� ��ȸ �� ������ ���
    SELECT SALARY
--    SELECT TO_CHAR(V_SALARY, 'L99,999,999') 
        --> ���⼭ �ٲٷ��� RETURN Ÿ�Կ� ���缭 IS Ÿ�Ե� �ٲ��ָ� �ȴ� 
    INTO V_SALARY
    FROM EMP
    WHERE EMP_ID = P_EMP_ID;
    -- ��ȯ��
    -- ��� ������ �ٲ��ֱ� ���� NUMBER���� VARCHAR2�� �ٲ㺸����.
    RETURN TO_CHAR(V_SALARY, 'L99,999,999');
    
    DBMS_OUTPUT.PUT_LINE(P_EMP_ID ||' ����� �޿��� '|| V_SALARY);
END;
/

-- 201�� ��� �޿� ��ȸ
SELECT FN_GET_SALARY('201') FROM DUAL;

-- ��� �޿� ��ȸ
SELECT FN_GET_SALARY(EMP_ID) FROM EMP;

-- �ֹε�� ��ȣ�� �Է� �޾Ƽ� ������ ��ȯ�ϴ� �Լ� ����
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
    DBMS_OUTPUT.PUT_LINE('����');
    ELSE
    DBMS_OUTPUT.PUT_LINE('����');
    END IF;
RETURN V_GENDER;
END;
/

--> ������ ��
SELECT DECODE(SUBSTR(EMP_NO,8,1) ,'1','M' ,'2','F' ,'Ȯ�κҰ�') ����
FROM EMP;

CREATE OR REPLACE FUNCTION FN_GET_GENDER
(P_EMP_NO   EMP.EMP_NO%TYPE)
RETURN CHAR  
IS 
    V_GENDER CHAR(12);  -- 'Ȯ�κҰ�' �ѱ� �־��ַ��� ��
BEGIN
    SELECT DECODE(SUBSTR(P_EMP_NO,8,1) ,'1','M' ,'2','F' ,'Ȯ�κҰ�') ����
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

-- �ֹι�ȣ�� �޾Ƽ� ���̸� ��ȯ�ϴ� �Լ� ����
-- ���� Ÿ���� EMP ���̺��� ��ȸ������ ���������δ� ����� ���Ƿ� ������⶧����(DUAL)
-- EMP ���̺��� ���� ���� �ƴ� ���� �ؽ�Ʈ�� �־ �ȴ�.
-- RETURN ���� ���ϴ� �������� ���缭 ����ص� �ȴ�. 
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


-- ����� �Է¹޾� �ش� ����� ���ʽ��� �����ϴ� ������ ����ϰ� �����ϴ� �Լ��� ����

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
    DBMS_OUTPUT.PUT_LINE('���ʽ��� �����?�����.����侾');
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

-- ���� ����
VARIABLE V_CALC NUMBER;
-- �Լ� ����
-- ���� ������ ������ �Լ��� ��ȯ���� ����
EXEC :V_CALC := FN_BONUS_CALC('200');
PRINT V_CALC;
-- ���⼭�� DBMS ~ �� �� ���� : �̰� ���� ���ο����� �����ϴٱ�














