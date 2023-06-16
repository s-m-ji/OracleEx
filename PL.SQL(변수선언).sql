/* 
    <PL/SQL>
        ����Ŭ ��ü�� ����Ǿ� �ִ� ������ ���� SQL ���� ������ ������ ����, ���� ó��(IF), �ݺ� ó��(LOOP, FOR, WHILE) ���� �����Ѵ�.
        (�ټ��� SQL ���� ������� ���� �� �� �ִ�)
        
        [PL/SQL�� ����]
            1) �����(DECLAER SECTION)
                DECLARE�� ����, ������ ����� ���� �� �ʱ�ȭ�ϴ� �κ��̴�.
                ��������
            2) �����(EXECUTABLE SECTION) 
                BEGIN�� ����, SQL ��, ���(����, �ݺ���) ���� ������ ����ϴ� �κ��̴�.
            3) ���� ó����(EXCEPTION SECTION) 
                EXCEPTION�� ����, ���� �߻� �� �ذ��ϱ� ���� ������ ����ϴ� �κ��̴�.
                ��������

*/

SET SERVEROUTPUT ON;
-- ���ν����� ����Ͽ� ����ϴ� ������ ȭ�鿡 �����ֵ��� �����ϴ� ȯ�� ����
-- �ϳ��� ���Ǹ��� ����Ǵ� ���̹Ƿ� ����Ŭ ���� ��/ ��ũ��Ʈ ���� �� ���� ����������Ѵ�. 

SET SERVEROUTPUT OFF;
-- ��� ��� ����

SET TIMING ON;
-- ��� ���� �� �� �ҿ�ð� ǥ��

-- �ϳ��� ���
    -- �����(��������)
    DECLARE
        -- ������ ����Ÿ��
        vi_num NUMBER;
        
    -- �����
    BEGIN
        vi_num := 100;
        -- ���� ���� �� �ʱ�ȭ���� ������ NULL���� �Ҵ�Ǿ� �ƹ��͵� �� ���δ�.
        
        DBMS_OUTPUT.PUT_LINE('�Ӵ��׼Ŀ�!');
        -- ������ SET SERVEROUTPUT ON; ���� ȯ�漳���� ������ ������ ��µ��� �ʴ´�.
        
        DBMS_OUTPUT.PUT_LINE('vi_num : ' || vi_num);
        DBMS_OUTPUT.PUT_LINE(VI_NUM);               
        -- �������� �ҹ��ڷ� ����������, ����ο��� �빮�ڷ� �����ص� ������ �ȴ�
    
    -- ���ܺ�(��������)
    END;
/    
-- / : �ϳ��� PL/SQL ������ ���� �ǹ��ϴ� ǥ��
-- �� �������� ���� ���� PL/SQL ������ �ִ� ��� /�� �̿��ؼ� ������

-- ���� ���� ��ϵ��� �̸��� ��� �͸�������, �̸��� �ο��ϸ� ���ν���/ �Լ� ������� ���� ������ �� �ִ�. (���̺�, ��� ����)

DECLARE
--    PI CONSTANT NUMBER;    
    -- ����� ����� ���ÿ� �ʱ�ȭ�� �����ؾ��Ѵ�.
    PI CONSTANT NUMBER := 3.14;
    
BEGIN
    PI := 2.14;
    -- ����� ���� ���� �� ���� ����.
    
    DBMS_OUTPUT.PUT_LINE('PI : '||PI);
END;
/

/*
    ���� ���� : radius = 5, pi(���) = 3.14
*/

DECLARE
   -- ���� ����� ���ÿ� �ʱ�ȭ ����
   radius NUMBER := 5;
   -- ����� ����� ���ÿ� �ʱ�ȭ �ʼ�
   pi CONSTANT NUMBER := 3.14; 
BEGIN
    radius := 10;
    DBMS_OUTPUT.PUT_LINE('���� �ѷ� : '|| pi * radius * 2);
END;
/

---------- ����1) eid, ename�� ������ �����ϰ� �ʱ�ȭ�Ͽ� �Ʒ��� ���� ���
--    eid : 999
--    ename : ������


DECLARE
    eid NUMBER := 999;
    ename VARCHAR2(20) := '������';
BEGIN

-- SQL���� �̿��Ͽ� ��ȸ�� ����� ������ ���
    SELECT EMP_ID, EMP_NAME
    INTO eid, ename     
    FROM EMP
    WHERE EMP_ID = '200';

/* 1. �Ķ���͸� �Է� �޴� ���
    ����� ���� �����Ͱ� �Է� â�� �߰�, ����ڷκ��� �Է� ���� ������ ���� ����
    WHERE EMP_ID = &���;
    
    2. SELECT���� ��ȸ ����� ������ ��� ���
    SELECT ��ȸ�� �÷���, ...
    INTO ���� ������, ... 
        -- INTO�� ��� �� ������ : �÷��� ����, Ÿ�Կ� �°� ������ ����
*/
-- & : ����ڷκ��� �Է¹��� ������ ��ü
    SELECT EMP_ID, EMP_NAME
    INTO eid, ename     
    FROM EMP
    WHERE EMP_ID = &���;

    DBMS_OUTPUT.PUT_LINE('eid : '|| eid);
    DBMS_OUTPUT.PUT_LINE('ename : '|| ename);
END;
/

RENAME EMPLOYEE TO EMP;
RENAME DEPARTMENT TO DEPT;

SELECT EMP_ID, EMP_NAME
FROM EMP
WHERE EMP_ID = '200';


DECLARE
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
BEGIN

-- SQL���� �̿��Ͽ� ��ȸ�� ����� ������ ���
    SELECT EMP_ID, EMP_NAME
    INTO eid, ename     
    FROM EMP
    WHERE EMP_ID = '200';

    DBMS_OUTPUT.PUT_LINE('eid : '|| eid);
    DBMS_OUTPUT.PUT_LINE('ename : '|| ename);
END;
/

/*
< PL/SQL �����(DECLAER SECTION) >
        ���� �� ����� ������ ���� ����
        ����� ���ÿ� �ʱ�ȭ�� ����
    
    < ���� �� ����� Ÿ�� >
        1) �Ϲ� Ÿ�� ���� 
            - SQL Ÿ�� (NUMBER, CHAR, VARCHAR2, DATE ��)
        2) ���۷��� Ÿ�� ���� 
            - PL/SQL Ÿ�� (���̺��� �÷�Ÿ���� ����)
        3) ROW Ÿ�� ����
            - PL/SQL Ÿ�� (�ϳ��� ���̺��� ��� �÷��� ���� �Ѳ����� ������ �� �ִ� ����)
        
    1) �Ϲ� Ÿ�� ������ ���� �� �ʱ�ȭ
            [ǥ����]
                ������ [CONSTANT] �ڷ���(ũ��) [:= ��];
      �ڷ��� : NUMBER, CHAR, VARCHAR2 �� SQL
      
      
    2) ���۷��� Ÿ�� ���� ���� �� �ʱ�ȭ
        [ǥ����]
            ������ ���̺��.�÷���%TYPE;
        
        - ������ Ÿ���� �����ϴµ�
            ���̺��� �÷��� ������ Ÿ���� �����Ͽ� ����
*/

---------- ����2) ������� �Է¹޾Ƽ� ���, �����, �޿�������
-- ���� eid, ename, sal ������ ���� �� ���

DECLARE 
    eid EMP.EMP_ID%TYPE; 
    ename EMP.EMP_NAME%TYPE;
--    sal EMP.SALARY%TYPE;
    sal VARCHAR2(50);   --> TO_CHAR�� ���� ���� ���� Ÿ������ ����
BEGIN
    SELECT EMP_ID, EMP_NAME, TO_CHAR(SALARY, 'L99,999,999')
    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_NAME = '&�����';
    -- �Է°��� �����϶��� ���������, ����Ÿ���̸� ' '(Ȭ����ǥ)�� ��������Դ�..
    
    DBMS_OUTPUT.PUT_LINE('eid : '||eid);
    DBMS_OUTPUT.PUT_LINE('ename : '||ename);
    DBMS_OUTPUT.PUT_LINE('sal : '||sal);
END;
/

SELECT EMP_ID, EMP_NAME, SALARY
--    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_NAME = '�ڳ���';


---------- ����3) ���� ������� JOB_NAME���� ���� ���
DECLARE 
    eid EMP.EMP_ID%TYPE; 
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    jname JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
    INTO eid, ename, sal, jname
--    FROM EMP
--    JOIN JOB USING (JOB_CODE)
    FROM EMP, JOB
    WHERE EMP.JOB_CODE = JOB.JOB_CODE
    AND EMP_NAME = '&�����';
    
    DBMS_OUTPUT.PUT_LINE('eid : '||eid);
    DBMS_OUTPUT.PUT_LINE('ename : '||ename);
    DBMS_OUTPUT.PUT_LINE('sal : '||sal);
    DBMS_OUTPUT.PUT_LINE('jname : '||jname);
END;
/
--> ������ ���� �� ������ ���̺�� ��Ī�� ���ԵǸ� ��ȸ�ؿ� �� �򰥸� : ���� �߻�

/*
        3) ROW Ÿ�� ���� ���� �� �ʱ�ȭ
            [ǥ����]
                ������ ���̺��%ROWTYPE;
                
            - �ϳ��� ���̺��� ���� �÷��� ���� �Ѳ����� ������ �� �ִ� ������ �ǹ��Ѵ�.
            - ��� �÷��� ��ȸ�ϴ� ��쿡 ����ϱ� ���ϴ�.
             
            * ERROR : ���̺��̸��� ���� �������� ������ �߻�
            * ��ȸ �ÿ��� ������.�÷��� ���� ���� ������
*/

DECLARE
    e EMP%ROWTYPE;
BEGIN
    SELECT * INTO e
    FROM EMP
    WHERE EMP_ID = 218;

    -- ������.�÷������� ���� ����
    -- ���̺� ��� ���� �־�ξ��� ������ ID, NAME ����� ���ϴ� ���� ��� ������ �� ����
    DBMS_OUTPUT.PUT_LINE('��� : ' || e.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('����� : ' || e.EMP_NAME);
END;
/

-- �л� ��� ���̺� ���� (���̺��� ������ ����)
CREATE TABLE TB_STUDENT_BK
AS SELECT * FROM TB_STUDENT WHERE 1 > 5;

SELECT * FROM TB_STUDENT_BK;
DROP TABLE TB_STUDENT_BK;

---------- ����4) 
/*
    �ǽ�
    ��������
        student_info : TB_STUDENT���̺��� ��� �÷������� ��� �ֽ��ϴ�
        
    1. �й��� A213046�� �л��� ������ ��ȸ�Ͽ� ������ ���
    2. �л��� ������ TB_STUDENT_BK���̺� �Է�
*/

DECLARE
    student_info TB_STUDENT%ROWTYPE;
BEGIN
    SELECT * INTO student_info
    FROM TB_STUDENT
    WHERE STUDENT_NO = 'A213046';
      
    INSERT INTO TB_STUDENT_BK VALUES student_info;
    
/*    INSERT INTO TB_STUDENT_BK VALUES ( student_info.STUDENT_NO
                                         student_info.STUDENT_NAME      
                                         ...   );
*/
    
--    DBMS_OUTPUT.PUT_LINE('STUDENT_NO : ' || student_info.STUDENT_NO);
--    DBMS_OUTPUT.PUT_LINE('STUDENT_NAME : ' || student_info.STUDENT_NAME);
--    DBMS_OUTPUT.PUT_LINE('STUDENT_ADDRESS : ' || student_info.STUDENT_ADDRESS);
    
    DBMS_OUTPUT.PUT_LINE('STUDENT_��� ���� : ' || student_info."*");
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '�� ó���Ǿ����ϴ�.');
END;
/

INSERT INTO TB_STUDENT_BK VALUES
    (
    SELECT * 
--    INTO student_info
    FROM TB_STUDENT
    WHERE STUDENT_NO = 'A213046');

