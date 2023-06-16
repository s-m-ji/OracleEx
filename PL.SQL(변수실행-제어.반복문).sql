/*
    <PL/SQL �����(EXECUTABLE SECTION)>
        1) ���ù�
          1-1) ���� IF ����
            [ǥ����]
                IF ���ǽ� THEN
                    ���� ����
                END IF;
                * END IF;�� IF�� ����� �������� �� ����ؾ��Ѵ� ! 
*/
---------- ����5) 
-- ����� �Է¹��� �� �ش� ����� ���, �̸�, �޿�, ���ʽ��� ���
-- ��, ���ʽ��� ���� �ʴ� ����� ���ʽ� ��� ���� '���ʽ��� ���޹��� �ʴ� ����Դϴ�.'��� ������ ����Ѵ�

SELECT EMP_ID, EMP_NAME, SALARY, NVL(TO_CHAR(BONUS,0), '���ʽ��� ���޹��� �ʴ� ����Դϴ�.')
FROM EMP;

DECLARE 
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    bon EMP.BONUS%TYPE;
--    bon VARCHAR2(100)%TYPE;
--    emp_info EMP%ROWTYPE;

BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
    INTO eid, ename, sal, bon
    FROM EMP
    WHERE EMP_ID = &���;
    
    DBMS_OUTPUT.PUT_LINE('eid : ' || eid);
    DBMS_OUTPUT.PUT_LINE('ename : ' || ename);
    DBMS_OUTPUT.PUT_LINE('sal : ' || sal);
    
    IF bon IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� �ʴ� ����Դϴ�.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('bon : ' || bon);
    
--    DBMS_OUTPUT.PUT_LINE('bon : '|| TO_CHAR(NVL(bon,0),'0.9'));
--    DBMS_OUTPUT.PUT_LINE('bon : '|| TO_CHAR(bon,'0.9');
    -- ��ȿ���� ���� �������� ���ڸ� ���

END;
/

/*
        1-2) IF ~ ELSE ����
          [ǥ����]
            IF ���ǽ� THEN
                ���� ����
            ELSE 
                ���� ����
            END IF;
*/

---------- ����6) ���ʽ� ���ο� ���� �޼����� ���
DECLARE 
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    bon EMP.BONUS%TYPE;

BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
    INTO eid, ename, sal, bon
    FROM EMP
    WHERE EMP_ID = &���;
    
    IF bon IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� �ʴ� ����Դϴ�.');
    ELSE
    DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹޴� ����Դϴ�.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('bon : ' || bon);
END;
/

/*
        1-3) IF ~ ELSIF ~ ELSE ����
          [ǥ����]
            IF ���ǽ� THEN
                ���� ����
            ELSIF ���ǽ� THEN
                ���� ����
            ...
            [ELSE
                ���� ����]
            END IF;
            
            *ELSEIF(X) , ELSIF(O) �Ǽ����� �ʵ��� ~~~
*/

---------- ����7) 
-- ����ڿ��� ������ �Է¹޾� SCORE ������ ������ �� ������ �Էµ� ������ ���� GRADE ������ �����Ѵ�.
--  90�� �̻��� 'A'
--  80�� �̻��� 'B'
--  70�� �̻��� 'C'
--  60�� �̻��� 'D'
--  60�� �̸��� 'F'
-- ����� '����� ������ 95���̰�, ������ A�����Դϴ�.'�� ���� ����Ѵ�.

DECLARE
    score NUMBER := &����;
    grade CHAR(1);
BEGIN                       
-- ������ () ���� ���� ������� �� �۵��ϴ� �� ���� AS ()ó��
    IF (score >= 90) THEN
    grade := 'A';
    ELSIF (score >= 80) THEN
    grade := 'B';
    ELSIF (score >= 70) THEN
    grade := 'C';
    ELSIF (score >= 60) THEN
    grade := 'D';
    ELSIF (score < 60) THEN
    grade := 'F';
    
    DBMS_OUTPUT.PUT_LINE('����� ������ '||score||'�̰�, ������ '||grade||'���� �Դϴ�.');
    END IF;
END;
/

-- ����� �Է¹޾Ƽ� ���, �̸�, �޿��� ���
DECLARE
    -- ���� ���� (Ÿ�� ���� Ȥ�� ���� ���̺��� �ִٸ� �ش� �÷� Ÿ������ ���°� ������.)
    eid NUMBER;
    ename VARCHAR2(50);
    sal NUMBER;
    
BEGIN 
    eid := &���;
    -- ��ȸ����� ������ ���
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_ID = eid;
    
    -- ����ϱ�
    DBMS_OUTPUT.PUT_LINE('eid : ' || eid);
    DBMS_OUTPUT.PUT_LINE('ename : ' || ename);
    DBMS_OUTPUT.PUT_LINE('sal : ' || sal);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        INSERT INTO TB_ERR 
            VALUES ('PROC_GET_SALARY_GRADE', 'E001', eid || '��(��) �³���? �����ȣ�� Ȯ�����ּ���.', SYSDATE);   
            -- �޿� ����� ���ϱ� ���� ���� ����
            
    DBMS_OUTPUT.PUT_LINE('�����ȣ�� Ȯ�����ּ���');
END;
/

CREATE TABLE TB_ERR (
    PLSQL_NAME VARCHAR2(100)
    , ERR_CODE CHAR(4)
    , ERR_MSG VARCHAR2(4000)
    , REG_DATE DATE
);

SELECT * FROM TB_ERR;


DECLARE
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    grade CHAR(1);
BEGIN
    eid := &���;
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_ID = eid;
    
--    IF sal BETWEEN 2000000 AND 3000000 THEN 
--    grade := 'E';
--    ELSIF sal BETWEEN 3000000 AND 4000000 THEN 
--    grade := 'D';
--    ELSIF sal BETWEEN 4000000 AND 5000000 THEN 
--    grade := 'C';
--    ELSIF sal BETWEEN 5000000 AND 6000000 THEN 
--    grade := 'B';
--    ELSIF sal > 6000000 THEN 
--    grade := 'A';
--    END IF;   
    
--    IF sal > 6000000 THEN 
--    grade := 'A';
--    ELSIF sal BETWEEN 5000000 AND 6000000 THEN 
--    grade := 'B';
--    ELSIF sal BETWEEN 4000000 AND 5000000 THEN 
--    grade := 'C';
--    ELSIF sal BETWEEN 3000000 AND 4000000 THEN 
--    grade := 'D';
--    ELSIF sal BETWEEN 2000000 AND 3000000 THEN 
--    grade := 'E';
--    END IF;
    
-- ���� ��谡 ���ļ� �ߺ����� ���� ���� �ִٸ� ���Ե� �ڵ� ������ ���缭 ���� �� �з��ȴ�.

    IF sal BETWEEN 2000000 AND 2999999 THEN 
    grade := 'E';
    ELSIF sal BETWEEN 3000000 AND 3999999 THEN 
    grade := 'D';
    ELSIF sal BETWEEN 4000000 AND 4999999 THEN 
    grade := 'C';
    ELSIF sal BETWEEN 5000000 AND 5999999 THEN 
    grade := 'B';
    ELSIF sal > 6000000 THEN 
    grade := 'A';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('SALARY_GRADE : '|| grade);
END;
/
UPDATE EMP SET SALARY = 3000000 WHERE EMP_ID = 210; 

/*
        1-4) CASE ����
          [ǥ����]
            CASE �� ���
                 WHEN �񱳰�1 THEN �����1
                 WHEN �񱳰�2 THEN �����2
                 ...
                 [ELSE �����]
            END;
*/
-- ����� �Է¹��� �Ŀ� ����� ��� �÷� �����͸� EMP�� �����ϰ� DEPT_CODE�� ���� �˸´� �μ��� ����Ѵ�.
-- e : EMP���̺��� ROWTYPE ����
-- dname : �μ��̸�

SELECT EMP_ID, DEPT_TITLE
FROM EMP
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM DEPT;

DECLARE
    e EMP%ROWTYPE;
    dname DEPT.DEPT_TITLE%TYPE;
--    eid CHAR(2);
BEGIN
--    eid := &���;
    SELECT *
    INTO e
    FROM EMP 
    WHERE EMP_ID = &���; 

--    dname := CASE e.DEPT_CODE
--                    WHEN 'D1' THEN '�λ������'
--                    WHEN 'D2' THEN 'ȸ�������'
--                    WHEN 'D3' THEN '�����ú�'
--                    WHEN 'D4' THEN '����������'
--                    WHEN 'D5' THEN '�ؿܿ���1��'
--                    WHEN 'D6' THEN '�ؿܿ���2��'
--                    WHEN 'D7' THEN '�ؿܿ���3��'
--                    WHEN 'D8' THEN '���������'
--                    WHEN 'D9' THEN '�ѹ���'                    
--            END;

-- 3���� �ٹ� �з�: D1,2,3�� ���� / D4,5,6�� ���� / D7,8,9�� �߰� 

   dname := CASE 
        WHEN e.DEPT_CODE IN ('D1','D2','D3') THEN '�����ٹ�'
        WHEN e.DEPT_CODE IN ('D4','D5','D6') THEN '���ıٹ�'
        WHEN e.DEPT_CODE IN ('D7','D8','D9') THEN '�߰��ٹ�'
        END;   
            
--     DBMS_OUTPUT.PUT_LINE(eid ||'�� '|| dname ||'�Դϴ�.');       
     DBMS_OUTPUT.PUT_LINE('dname : ' || dname);     
   
END;
/

/* 2) �ݺ���
          2-1) BASIC LOOP
            [ǥ����]
                LOOP
                �ݺ������� �����ų ����
                
                [�ݺ����� �������� ���ǹ� �ۼ�]
                    1) IF ���ǽ� THEN 
                          EXIT;
                       END IF
                       
                    2) EXIT WHEN ���ǽ�;
                END LOOP;
*/
-- 1~5���� ���������� 1�� �����ϴ� ���� ���
-- ����Ÿ���� ������ ���� NUM = 1
DECLARE
    num NUMBER := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(num);
        num := num + 1;
        
--        IF num > 5 THEN EXIT; 
--        END IF;
        
        EXIT WHEN num > 5;
        
    END LOOP;
END;
/

/*
        2-2) WHILE LOOP
          [ǥ����]
            WHILE ���ǽ�
            LOOP
                �ݺ������� ������ ����;
            END LOOP;
*/
-- 1 ~ 5���� ���������� 1�� �����ϴ� ���� ���
DECLARE 
    num NUMBER := 1;
BEGIN
    WHILE num < 6
        LOOP
        DBMS_OUTPUT.PUT_LINE(num);
        num := num + 1;
    END LOOP;
END;
/

-- 2�� ����ϱ�
DECLARE 
    num NUMBER := 1;
BEGIN
    WHILE num <= 9
        LOOP
        DBMS_OUTPUT.PUT_LINE('2*'||num||' = '||num*2);
        num := num+1;
    END LOOP;
END;
/
-- 2 ~ 9�� ��� ���
DECLARE     
    i NUMBER := 2;
    num NUMBER := 1;
BEGIN
    WHILE i <= 9
        LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        WHILE num <= 9
            LOOP
            DBMS_OUTPUT.PUT_LINE(i||'*'||num||' = '||i*num);
            num := num+1;
         END LOOP;
         i := i+1;
         num := 1;
    END LOOP;
END;
/

/*
        3) FOR LOOP
          [ǥ����]
            FOR ���� IN [REVERSE] �ʱⰪ..������
            LOOP
                �ݺ������� ������ ����;
            END LOOP;
            
            *REVERSE �� ��� ����->�ʱ� ������ �����
*/
-- 1 ~ 5���� ���������� 1�� �����ϴ� ���� ���

--DECLARE
BEGIN
    FOR num IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(num);
    END LOOP;
END;
/

CREATE TABLE TEST(
    NUM NUMBER
    , REG_DATE DATE
);

SELECT * FROM TEST;
DELETE TEST;

-- 1���� 10���� ���̺� �����ͷ� ���� ��
BEGIN
    FOR i IN 1..10
    LOOP
        INSERT INTO TEST VALUES (i, SYSDATE);
   END LOOP;  
END;
/
-- 1���� 10���� ¦���� ���̺� �����ͷ� ���� ��
BEGIN
    FOR i IN 1..10
    LOOP
--        IF MOD (i,2)=0 THEN     -- ������ �Լ�
--            INSERT INTO TEST VALUES (i, SYSDATE);
--        END IF;
        
        INSERT INTO TEST VALUES (i, SYSDATE);
        IF MOD (i,2)=0 THEN        -- ¦���� Ŀ�� �ƴϸ� �ѹ�
            COMMIT;
            ELSE ROLLBACK;
        END IF;
   END LOOP;  
END;
/

/* 
    Ÿ�� ���� ����
        ���ڵ� Ÿ���� ���� ����� �ʱ�ȭ
        ���� �� ���

    ���ڵ� Ÿ�� ����
        TYPE Ÿ�Ը� IS RECORD (�÷��� Ÿ��, �÷��� Ÿ��, ...)  
*/
-- ������� �Ű������� �޾Ƽ�
-- ���, �̸�, �μ���, ���޸��� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMP E, DEPT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND EMP_NAME = &�����;

DECLARE 
-- ������ ���ڵ� Ÿ������ ����
    TYPE EMP_RECORD_TYPE IS RECORD (           
        eid EMP.EMP_ID%TYPE
        , ename EMP.EMP_NAME%TYPE
        , dtitle DEPT.DEPT_TITLE%TYPE
        , jname JOB.JOB_NAME%TYPE
    ); 
    
    emp_RECORD EMP_RECORD_TYPE;
BEGIN 
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
--    INTO eid, ename, dtitle, jname
    INTO EMP_RECORD
    FROM EMP E, DEPT D, JOB J
    WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND E.JOB_CODE = J.JOB_CODE(+)
    AND EMP_NAME = '&�����';
    
--    DBMS_OUTPUT.PUT_LINE(eid ||' '|| ename ||' '|| dtitle ||' '|| jname);
    DBMS_OUTPUT.PUT_LINE(emp_RECORD.eid ||' '|| 
                        emp_RECORD.ename ||' '|| 
                        emp_RECORD.dtitle ||' '|| 
                        emp_RECORD.jname);
END;
/

