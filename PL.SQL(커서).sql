/*
    <CURSOR> 
        Ư�� SQL������ ó����������� ��� �ִ� ������ ����Ű�� ������
        Ŀ���� �̿��Ͽ� SQL������ ó��������տ� ���� �� �� �ִ�
        
    <������ Ŀ��>
        ����Ŭ ���ο��� �ڵ����� �����Ǵ� Ŀ��
        PL/SQL ��Ͽ��� SQL������ ���� �ɶ����� �ڵ����� ����
        Ŀ���� �Ӽ��� �����Ͽ� �������� ������ �� �� �ִ�
        
        - ������Ŀ���� �Ӽ�
            Ŀ����%ISOPEN   : FALSE
            Ŀ����%FOUND    : ��� ������ 1�� �̻��� ���
            Ŀ����%NOTFOUND : ��� ������ 0���� ���
            Ŀ����%ROWCOUNT : �ֱ� ����� ������ ����� ��
            
    <����� Ŀ��>
        ����ڰ� ���� �����Ͽ� ����ϴ� Ŀ��
        SQL������ ������տ� ���� �Ͽ� Ŀ�� ��� �� ���� ������ ��Ÿ�� ó�� ����� ���������� ������ �����ϴ�.
        
        Ŀ������(DECLARE)
            ��
        Ŀ������(OPEN)
            ��
        Ŀ������ ������ ��������(FATCH)    --  
            ��                            �ӡ� �ݺ�  
        ������ó�� (������ ��/��� ���)                    --
            ��
        Ŀ���ݱ�(CLOSE)
        
        [Ŀ�� �Ӽ�]
            Ŀ����%ISOPEN   : Ŀ���� OPEN ������ ��� TRUE, �ƴϸ� FALSE
            Ŀ����%FOUND    : Ŀ�� ������ �����ִ� ROW ���� �� �� �̻��� ��� TRUE, �ƴϸ� FALSE
            Ŀ����%NOTFOUND : Ŀ�� ������ �����ִ� ROW ���� ���ٸ� TURE, �ƴϸ� FALSE
            Ŀ����%ROWCOUNT : SQL ó�� ����� ���� ��(ROW)�� ��
        
        [��� ���]
            1) CURSOR Ŀ���� IS ..          : Ŀ�� ����
            2) OPEN Ŀ����;                 : Ŀ�� ����
            3) FETCH Ŀ���� INTO ����, ...   : Ŀ������ ������ ����(�� �྿ �����͸� �����´�.)
            4) CLOSE Ŀ����                 : Ŀ�� �ݱ�
        
        [ǥ����]
            CURSOR Ŀ���� IS [SELECT ��]
            
            OPEN Ŀ����;
            FETCH Ŀ���� INTO ����;
            ...
            
            CLOSE Ŀ����;
*/

/*
    ������̺� ��ϵ� ����� ����� �̸��� ����ϴ� �͸��� ���ν��� (���� X)
*/DECLARE
    -- 1. Ŀ�� ����
    CURSOR C1 IS
    (
        SELECT
            EMP_ID,
            EMP_NAME
        FROM
            EMP
    );
                -- ���� ����
    EID   EMP.EMP_ID%type;
    ENAME EMP.EMP_NAME%type;
BEGIN
    -- 2. Ŀ�� ����
 OPEN C1 ;
        LOOP
            -- 3. ��ġ : ���� ���� �о ������ ����ش�.
            FETCH C1 INTO EID, ENAME;
            -- 4. �ݺ����� Ż�� ~~~~~
            --      Ŀ�� ������ �ڷᰡ ��� FETCH�Ǿ� ���� ������ �������� ������ Ż��
            EXIT WHEN C1%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('��� : '||EID);
            DBMS_OUTPUT.PUT_LINE('����� : '||ENAME);
            
        END LOOP;
    -- 5. Ŀ�� Ŭ����
    CLOSE C1;
END;
/

-- �޿��� 3000000 �̻��� ����� ���, �̸�, �޿��� ���
DECLARE
    CURSOR C2 IS
        (SELECT EMP_ID, EMP_NAME, SALARY
            FROM EMP
            WHERE SALARY >= 3000000);
    V_EID   EMP.EMP_ID%TYPE;
    V_ENAME EMP.EMP_NAME%TYPE;
    V_ESAL  EMP.SALARY%TYPE;
    V_CNT   NUMBER; 
    
BEGIN
    OPEN C2; 
        LOOP
            FETCH C2 INTO V_EID, V_ENAME, V_ESAL;
            EXIT WHEN C2%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(V_EID||' '|| V_ENAME ||' '||V_ESAL);       
            
        END LOOP;
    CLOSE C2;
    V_CNT := C2%ROWCOUNT;
--    DBMS_OUTPUT.PUT_LINE('�� '|| V_CNT || '�� ��ȸ �Ϸ�');
    DBMS_OUTPUT.PUT_LINE('�� '|| C2%ROWCOUNT || '�� ��ȸ �Ϸ�');
END;
/

-- �μ����̺� ��ü �����͸� ��ȸ �� ����ϴ� ���ν��� (���� O)

-- �̸� PROC_CURSOR_DEPT 
-- V_DEPT DEPT ���̺��� ��� �÷��� ��� 
-- Ŀ�� C1�� �μ� ���̺��� ��� ������ ��ȸ 

CREATE OR REPLACE PROCEDURE PROC_CURSOR_DEPT
IS 
    V_DEPT  DEPT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPT;
BEGIN
    OPEN C1;
        LOOP
        -- TODO ������ ������ �ѹ��� �� ��ȸ�ؿ� ���� ������?
            FETCH C1 INTO V_DEPT.DEPT_ID, V_DEPT.DEPT_TITLE, V_DEPT.LOCATION_ID;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(V_DEPT.DEPT_ID ||' '|| V_DEPT.DEPT_TITLE ||' '|| V_DEPT.LOCATION_ID);
        END LOOP;
    CLOSE C1;
END;
/
EXEC PROC_CURSOR_DEPT;

/*
    FOR IN LOOP�� �̿��� Ŀ�� ���
        
        FOR ~ IN:
        CURSOR�� ������ �ʿ䰡 ������,
        CURSOR�� OPEN, CLOSE, FETCH�� �ڵ����� ������.
        
        FOR ������ IN (����)
        ���� ����������κ��� �� �Ǿ� �о� ������ ����ش�.    
*/

CREATE OR REPLACE PROCEDURE PROC_CURSOR_DET_TITLE
IS
--    V_DEPT    DEPT.DEPT_TITLE%TYPE;
    V_DEPT    DEPT%ROWTYPE;
    -- DEPT�� ��ü ���� ��ȸ�ؿ��°Ŷ� ��������.
BEGIN
--    FOR V_DEPT IN (SELECT * FROM DEPT)
    FOR V_DEPT IN (SELECT DEPT_TITLE FROM DEPT)
    LOOP
--        DBMS_OUTPUT.PUT_LINE(V_DEPT.DEPT_TITLE);
        DBMS_OUTPUT.PUT_LINE(V_DEPT.DEPT_ID||' - '||V_DEPT.DEPT_TITLE);
    END LOOP;
END;
/
EXEC PROC_CURSOR_DET_TITLE;

-- ����� ���, �̸�, �μ��� ��� (���ڵ� Ÿ���� ���� / Ȥ�� ������ 3�� ����)
CREATE OR REPLACE PROCEDURE PROC_EMP_INFO
IS
    TYPE E_RECORD_T IS RECORD(
        EID         EMP.EMP_ID%TYPE    
        EID         EMP.EMP_ID%TYPE    
        , ENAME     EMP.EMP_NAME%TYPE    
        , DTITLE    DEPT.DEPT_TITLE%TYPE    
    );
    -- ���ڵ带 ������ Ÿ������ ���� : �׷� ���⼭�� 3������ ���Ե� 
    V_INFO  E_RECORD_T;
BEGIN
    FOR V_INFO IN( SELECT EMP_ID, EMP_NAME, DEPT_TITLE
                    FROM EMP E, DEPT D
                    WHERE E.DEPT_CODE = D.DEPT_ID(+))
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_INFO.EMP_ID||' '||V_INFO.EMP_NAME||' '||V_INFO.DEPT_TITLE);
    END LOOP;
END;
/
EXEC PROC_EMP_INFO;

-- TRIGGER
























