/*
<DML(data manipulation language)>
    ������ ���� ���� ���̺� ���� ����(insert) ����(update) ����(delete)�ϴ� �����̴�.

    <insert>
    [ǥ����]
        1) insert into ���̺�� values (��, ��, ... ��);
            ���̺� �ִ� ��� �÷��� ���� �Է��� �� ���
        2) insert into ���̺��(�÷���, �÷���, ... �÷���) values(��,��, ... ��);
            ������ �÷��� ���� ���� �Է��� �� ���
            
    <update>
    [ǥ����]
        update ���̺��
        set �÷��� = �����Ϸ��� ��,
            �÷��� = �����Ϸ��� ��, ...
        [where ����];
        
    *** where���� �����ϰԵǸ� ���̺��� ��� ����  ����, �����ǹǷ�
    �� ���� �����͸� ó���Ϸ����� �� Ȯ���ؾ��Ѵ�... ���渶�̱�
        
    <where> ���ǹ�
    �÷��� = ã�� ��
        
*/
desc book;

insert into book values(5,'��ü�� �Բ� �ϴ� ��å2','�۰�2', 'n', sysdate, null); 

select * from book;

-- ����ڰ� å�� �뿩�� ��� isrent = y, editdate = ����ð���¥
-- 3�� å�� �뿩�Ѵٰ� �� ���?

update book
set isrent = 'n', editdate = sysdate
where no = 3;

-- ���� �����ϱ� ��, �������� ���� Ȯ�� �� ������ �����մϴ�.
select count(*)
from book
where no =3;
---------------------------------------------------------------------------------------------------
/*
    <INSERT>
    ���̺� ���ο� ���� �߰��ϴ� ����
        INSERT INTO ���̺�� (��������);
*/
-- ���̺� ��ü�� ����
CREATE TABLE EMP_01 AS SELECT * FROM EMP;
SELECT * FROM EMP_01;

-- ���̺� ������ ���� (������ X)
CREATE TABLE EMP_02 AS SELECT * FROM EMP WHERE 1<0;
SELECT * FROM EMP_02;

-- ���̺��� �Ϻ� ������(Ư�� �÷���) ����
CREATE TABLE EMP_03 AS SELECT EMP_ID, EMP_NAME FROM EMP WHERE 1<0;
SELECT * FROM EMP_03;

CREATE TABLE EMP_COPY (
    EMP_ID NUMBER
    , EMP_NAME VARCHAR2(30)
    , DEPT_TITLE VARCHAR2(50)
);

-- ���������� �̿��ؼ� �����͸� �Է��ϱ�
INSERT INTO EMP_COPY (
            SELECT EMP.EMP_ID, EMP_NAME, DEPT_TITLE
            FROM EMP
            LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID))
;
SELECT * FROM EMP_COPY;
ROLLBACK;
DROP TABLE EMP_01;
DROP TABLE EMP_02;
DROP TABLE EMP_03;
DROP TABLE EMP_COPY;

-- ���������� �̿��ؼ� ���̺��� �����ϱ�
CREATE TABLE EMP_COPY 
AS ( SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMP, DEPT
    WHERE DEPT_CODE = DEPT_ID )
;

-- AS �ڿ����� ���������� ()��ȣ�� �����ʾƵ� ������ �ȴ� ! 
--CREATE TABLE EMP_COPY 
--AS  SELECT EMP_ID, EMP_NAME, DEPT_TITLE
--    FROM EMP, DEPT
--    WHERE DEPT_CODE = DEPT_ID(+)
--;

CREATE TABLE EMP_INFO
-- ���̺� ���� �� AS ���������� �������� �÷��� ��Ī�� �޸� �װ� �÷����� �ȴ�. 
AS ( SELECT EMP_ID ���, EMP_NAME �����, JOB_NAME ���޸�, DEPT_TITLE �μ���
        FROM EMP
        LEFT JOIN JOB USING(JOB_CODE)           
        LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID))
;
SELECT * FROM EMP_INFO ORDER BY ���;

-- EMP_INFO ���̺� ��ü ������ ����� 
DELETE FROM EMP_INFO;

-- EMP ���̺��� Ư�� �����͸� ������ �ֱ�
INSERT INTO EMP_INFO (���, �����)
            ( SELECT EMP_ID, EMP_NAME FROM EMP )
;

/*
    <INSERT ALL>
    �ϳ��� ������ �̿��ؼ� �� �� �̻� ���̺� INSERT
    INSERT ALL�� �̿��ؼ� ���� �� ���̺� �����͸� �ѹ��� ����
    
    ǥ����
        [WHEN ����1 THEN]
            INTO ���̺��1[(�÷�, �÷�, ...)] VALUES(��, ��, ...)
        [WHEN ����2 THEN]
            INTO ���̺��2[(�÷�, �÷�, ...)] VALUES(��, ��, ...)
        ��������;
*/

-- EMP���̺��� ������ �����Ͽ� ���̺��� ����
-- EMP_DEPT: EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
-- EMP_MANAGER: EMP_ID, EMP_NAME, MANAGER_ID
CREATE TABLE EMP_DEPT 
AS ( SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE
    FROM EMP 
    LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
    WHERE 2<0)
;
DROP TABLE EMP_DEPT;
SELECT * FROM EMP_DEPT;
DELETE FROM EMP_DEPT;

CREATE TABLE EMP_MANAGER 
AS ( SELECT EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME 
    FROM EMP
    JOIN JOB USING (JOB_CODE)
    WHERE 1=2)      -- �����ʹ� �����ϰ� ���̺� ������ ������ �� WHERE���� FALSE ���� ����ϱ�  
;
DROP TABLE EMP_MANAGER;
SELECT * FROM EMP_MANAGER;
DELETE FROM EMP_MANAGER;

INSERT ALL
--  VALUES (�÷�, ...)�� �� �Ʒ��� ������������ ��ȸ�� �÷����� �������� ��
    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID)
    
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
        FROM EMP
        WHERE DEPT_CODE = 'D1'
;

SELECT * FROM EMP_DEPT A, EMP_MANAGER B;
SELECT * FROM EMP_DEPT A, EMP_MANAGER B WHERE A.EMP_ID = B.EMP_ID;

INSERT ALL
    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE)
    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME)
    
        SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE, E.HIRE_DATE, E.MANAGER_ID, E.JOB_CODE, J.JOB_NAME
        FROM EMP E, DEPT D, JOB J
        WHERE E.DEPT_CODE = D.DEPT_ID(+)
        AND E.JOB_CODE = J.JOB_CODE(+)
;

--INSERT ALL
--    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE)
--    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME)
--    
--         SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE, E.HIRE_DATE, E.MANAGER_ID, E.JOB_CODE, J.JOB_NAME
--        FROM EMP E, DEPT D, JOB J
--        WHERE E.DEPT_CODE = D.DEPT_ID(+)
--        AND E.JOB_CODE = J.JOB_CODE(+)
--        
--            MINUS                       -- ������ ������Ų �����͸� ���������� ã�Ƽ� �߰����־���...
--        
--        SELECT E.EMP_ID, E.EMP_NAME, E.DEPT_CODE, D.DEPT_TITLE, E.HIRE_DATE, E.MANAGER_ID, E.JOB_CODE, J.JOB_NAME
--        FROM EMP E, DEPT D, JOB J
--        WHERE E.DEPT_CODE = D.DEPT_ID
--        AND E.JOB_CODE = J.JOB_CODE
--;
        
INSERT ALL
WHEN DEPT_CODE = 'D1' THEN
    INTO EMP_DEPT VALUES (EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE,  HIRE_DATE)
WHEN JOB_CODE = 'J1' THEN
    INTO EMP_MANAGER VALUES (EMP_ID, EMP_NAME, MANAGER_ID, JOB_CODE, JOB_NAME)
    
        SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, HIRE_DATE, MANAGER_ID, E.JOB_CODE, JOB_NAME
        FROM EMP E, DEPT D, JOB J
        WHERE E.DEPT_CODE = D.DEPT_ID(+)
        AND E.JOB_CODE = J.JOB_CODE(+)
;

-- INSERT ALL ���� ����)
-- EMP ���̺��� �Ի����� �������� 
-- �÷�: EMP_ID, EMP_NAME, HIRE_DATE, SALARY
-- 2000�� 1�� 1�� ������ �Ի��� ����� ������ EMP_OLD ���̺� �����ϰ�
-- 2000�� 1�� 1�� ���Ŀ� �Ի��� ����� ������ EMP_NEW ���̺� �����Ѵ�.

INSERT ALL
WHEN TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') < '2000-01-01' THEN
--WHEN HIRE_DATE < '2000-01-01' THEN
    INTO EMP_OLD (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= TO_DATE('20000101', 'YY/MM/DD') THEN
--WHEN HIRE_DATE >= '2000-01-01' THEN
    INTO EMP_NEW (EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    
    SELECT  EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMP
;

CREATE TABLE EMP_OLD 
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMP
    WHERE 1=0
;

CREATE TABLE EMP_NEW 
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMP
    WHERE 1=0
;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

DROP TABLE EMP_OLD;
DROP TABLE EMP_NEW;
DROP TABLE EMP_INFO;
DROP TABLE EMP_COPY;
DROP TABLE EMP_DEPT;
DROP TABLE EMP_MANAGER;

/*
    <UPDATE>
    ���̺� ��ϵ� �����͸� �����ϴ� ����
    
    ǥ����
        UPDATE ���̺��
        SET �÷��� = ������ ��,
            �÷��� = ������ ��,
            ...
        [WHERE ����];
    - SET������ ���� ���� �÷��� �޸�(,)�� �����ؼ� ���� ���ÿ� ������ �� �ִ�.
    - WHERE���� �����ϸ� ��� ���� �����Ͱ� ����ȴ�.
*/

CREATE TABLE DEPT_COPY AS SELECT * FROM DEPT;

-- DEPT_COPY ���̺��� DEPT_ID�� 'D9'�� �μ����� '������ȹ��'���� ����
UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��'
WHERE DEPT_ID = 'D9';

CREATE TABLE EMP_SALARY AS SELECT * FROM EMP;
SELECT * FROM EMP_SALARY;

-- EMP_SALARY ���̺��� ���ö ����� �޿��� 1,000,000���� ����
UPDATE EMP_SALARY SET SALARY = 1000000 WHERE EMP_NAME = '���ö';
DROP TABLE EMP_SALARY;

-- ��� ����� �޿��� ���� �޿����� 10���� �λ��� �ݾ�(����*1.1)���� ����
--SELECT 
--UPDATE EMP_SALARY SET SALARY = SALARY*1.1 �λ�޿�
--    SELECT SALARY FROM EMP WHERE EMP.EMP_ID = EMP_SALARY.EMP_ID 
--;

-- ����Ű ����
-- EMP ���̺� ����Ű�� �߰�
-- JOB_CODE, DEPT_CODE

ALTER TABLE EMP ADD CONSTRAINT EMP_DEPT_CODE_FK
    FOREIGN KEY(DEPT_CODE) REFERENCES DEPT(DEPT_ID);

-- ���ö ����� �μ��ڵ带 D0�� ������Ʈ
-- FK ���� ����: UPDATE���� ����ȴ�.
UPDATE EMP SET DEPT_CODE = 'D0' WHERE EMP_NAME = '���ö';
-- PK ��������
UPDATE EMP SET EMP_ID = NULL;

-- ���� ����� �޿��� ���ʽ���
-- ����� ����� �����ϰ� ����
--      1) ����� ����� �޿��� ���ʽ��� ��ȸ
SELECT SALARY, BONUS
FROM EMP_SALARY
WHERE EMP_NAME = '�����';

--      2) ������ ���������� ������ �÷��� ����
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY FROM EMP_SALARY WHERE EMP_NAME = '�����')
    , BONUS = (SELECT BONUS FROM EMP_SALARY WHERE EMP_NAME = '�����')
WHERE  EMP_NAME = '����'
;

--      3) ���߿� ���������� ����Ͽ� �ѹ��� ����
UPDATE EMP_SALARY
--FROM EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '�����')
WHERE EMP_NAME = '����'
;

SELECT * FROM EMP_SALARY WHERE EMP_NAME IN ('�����','����');

-- EMP_SALARY ���̺���
-- ���ö, ������, ������, �ϵ��� �����
-- �޿��� �μ��ڵ带 ����� ����� �����ϰ� ����
-- �� ���� �� ���� �����ʹ� ������� �̸� Ȯ���غ��°� ���� ^_^
UPDATE EMP_SALARY
SET (SALARY, DEPT_CODE) = ( SELECT SALARY, DEPT_CODE
                            FROM EMP_SALARY
                            WHERE EMP_NAME = '�����')
WHERE EMP_NAME IN ('���ö','������','������','�ϵ���')
;
SELECT EMP_NAME, SALARY, DEPT_CODE FROM EMP_SALARY WHERE EMP_NAME IN  ('�����', '���ö','������','������','�ϵ���');

-- EMP_SALARY ���̺���
-- ASIA �������� �ٹ��ϴ� �������� ���ʽ��� 0.3���� ����
--     ���� ASIA �������� �ٹ��ϴ� ���� ��ȸ
SELECT * FROM EMP_SALARY
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID 
                FROM EMP_SALARY
                JOIN DEPT ON (DEPT_CODE = DEPT_ID)
                JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                WHERE LOCAL_NAME LIKE 'ASIA%');

/*
    <DELETE>
    ���̺� ��ϵ� �����͸� �����ϴ� ���� (�� ������ ������)
    
    ǥ����
        DELETE [FROM] ���̺��
        [WHERE ���ǽ�];
        - WHERE���� �������� ������ ��ü ���� �����ȴ�.
*/
-- EMP_SALARY ���̺���
-- �ӽ�ȯ ����� ������ �����
SELECT * FROM EMP_SALARY WHERE EMP_NAME = '�ӽ�ȯ';
DELETE EMP_SALARY WHERE EMP_NAME = '�ӽ�ȯ';
ROLLBACK;
-- ����Ű ���������� ���� ���ѿ� �ɸ� (�ڽ����̺��� ������� �ڵ�� ���� �Ұ�)
DELETE DEPT WHERE DEPT_ID = 'D1';

/*
    <TRUNCATE>
    ���̺� ��ü ���� ������ �� ����ϴ� ��������
    DELETE���� ���� �ӵ��� �� ������.
    �׷��� ���� ���� ���ð� �Ұ����ϰ�, ROLLBACK�� �Ұ����ϴ�.
    
    ǥ����
        TRUNCATE TABLE ���̺��;
*/
TRUNCATE TABLE EMP_SALARY;

/*
    <MERGE>
    ������ ���� �� ���� ���̺��� �ϳ��� ���̺�� ��ġ�� ����
    �� ���̺��� �����ϴ� ������ ���� �����ϸ� UPDATE, �ƴϸ� INSERT
*/
-- EMP ���̺��� �����ؼ� 2���� ���̺� �����
CREATE TABLE EMP_M01 AS SELECT * FROM EMP;
CREATE TABLE EMP_M02 AS SELECT * FROM EMP WHERE JOB_CODE = 'J4';
SELECT * FROM EMP_M01;
SELECT * FROM EMP_M02;
INSERT INTO EMP_M02 VALUES(999,'������','621235-1985634','sun_di@or.kr','01099546325','D9',	'J1',8000000,0.3,'',SYSDATE,'','');
UPDATE EMP_M02 SET SALARY = 0;

CREATE TABLE EMP_COPY AS SELECT * FROM EMP WHERE 1>2;
SELECT * FROM EMP_COPY;

MERGE INTO EMP_M01
-- ����: ����� ��ġ������ Ȯ��
USING EMP_M02 ON (EMP_M01.EMP_ID = EMP_M02.EMP_ID)
-- ��ġ�ϴ� ����� ������ UPDATE (������Ʈ �� �÷��� ���� ������.)
WHEN MATCHED THEN 
    UPDATE SET
    EMP_M01.EMP_NAME = EMP_M02.EMP_NAME
    , EMP_M01.EMP_NO = EMP_M02.EMP_NO
    , EMP_M01.EMAIL = EMP_M02.EMAIL
    , EMP_M01.PHONE = EMP_M02.PHONE
    , EMP_M01.SALARY = EMP_M02.SALARY
-- ��ġ�ϴ� ����� ������ INSERT
WHEN NOT MATCHED THEN
    INSERT VALUES (EMP_M02.EMP_ID, EMP_M02.EMP_NAME, EMP_M02.EMP_NO, EMP_M02.EMAIL
                    , EMP_M02.PHONE, EMP_M02.DEPT_CODE, EMP_M02.JOB_CODE, EMP_M02.SALARY
                    , EMP_M02.BONUS, EMP_M02.MANAGER_ID
                    , EMP_M02.HIRE_DATE ,EMP_M02.ENT_DATE, EMP_M02.ENT_YN
);

CREATE TABLE EMP1 AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMP;
CREATE TABLE EMP2 AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMP WHERE 1<0;

UPDATE EMP2 SET BONUS = 100;
SELECT * FROM EMP2;
SELECT * FROM EMP1;

MERGE INTO EMP1 USING EMP2 ON (EMP1.EMP_ID = EMP2.EMP_ID)
WHEN MATCHED THEN
    UPDATE SET EMP1.EMP_NAME = EMP2.EMP_NAME, EMP1.SALARY = EMP2.SALARY,  EMP1.BONUS = EMP2.BONUS
WHEN NOT MATCHED THEN 
    INSERT VALUES (EMP2.EMP_ID, EMP2.EMP_NAME, EMP2.SALARY, EMP2.BONUS);
---------------------------------------------------------------------------------------------------
/*
    DML
*/
-- Ex1) ���� ���� ���̺� �Ʒ��� ���� �����͸� �Է��Ͻÿ�.
-- 01 �����ʼ�, 02 ��������, 03 ���缱��, 04 ������, 05 �����ʼ�
DELETE TB_CLASS_TYPE;
SELECT * FROM TB_CLASS_TYPE;
ALTER TABLE TB_CLASS_TYPE ADD CLASS_TYPE_NO NUMBER;
INSERT INTO TB_CLASS_TYPE VALUES ('�����ʼ�','01');
INSERT INTO TB_CLASS_TYPE VALUES ('��������','02');
INSERT INTO TB_CLASS_TYPE VALUES ('���缱��','03');
INSERT INTO TB_CLASS_TYPE VALUES ('������','04');
INSERT INTO TB_CLASS_TYPE VALUES ('�����ʼ�','05');

-- Ex2) �л����� ������ ���ԵǾ� �ִ� �л��Ϲ����� ���̺��� ������� �Ѵ�.
-- �Ʒ� ������ �����Ͽ� ������ SQL ���� �ۼ��Ͻÿ�. (���������� �̿��Ͻÿ�)
-- �й�, �л��̸�, �ּ�
/*
    ���������� �̿��ؼ� ���̺��� �����Ѵ�.
    ���������� ����������� ���̺��� ����
    CREATE TABLE ���̺��
        AS (��������)
*/
CREATE TABLE TB_�л��Ϲ�����(�й�, �л��̸�, �ּ�) 
    AS
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS 
FROM TB_STUDENT;

SELECT * FROM TB_�л��Ϲ�����;
DELETE FROM TB_�л��Ϲ�����;

INSERT INTO TB_�л��Ϲ�����
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS 
FROM TB_STUDENT;

-- Ex3) ������а� �л����� �������� ���ԵǾ� �ִ� �а����� ���̺��� ������� �Ѵ�.
-- �Ʒ� ������ �����Ͽ� ������ SQL ���� �ۼ��Ͻÿ�.
-- �й�, �а��̸�, ����⵵, �����̸�
SELECT STUDENT_NO �й�, DEPARTMENT_NAME �а��̸�
        ,CASE WHEN SUBSTR(STUDENT_SSN,8,1) IN (1,2)
                THEN '19'||SUBSTR(STUDENT_SSN,1,2)
                WHEN SUBSTR(STUDENT_SSN,8,1) IN (3,4)
                THEN '20'||SUBSTR(STUDENT_SSN,1,2)
            ELSE ' ' END ����⵵
        , NVL(PROFESSOR_NAME,'RYN') �����̸�
FROM TB_STUDENT
LEFT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR ON (PROFESSOR_NO = COACH_PROFESSOR_NO)
WHERE DEPARTMENT_NAME = '������а�'
;

SELECT STUDENT_NO �й�, DEPARTMENT_NAME �а��̸�
FROM TB_STUDENT S, TB_DEPARTMENT D
WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO;

-- �а� 1���� ����/�л��� ������ ����Ǿ�����
-- �׷��� ����/�л� ���忡���� 1���� �а����� ����
SELECT *    
FROM TB_DEPARTMENT
JOIN TB_PROFESSOR USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '������а�'
;

-- Ex4) �� �а����� ������ 10% ������Ű�� �Ǿ���. �̿� ����� SQL ���� �ۼ��Ͻÿ�.
-- (��, �ݿø��� ����Ͽ� �Ҽ��� �ڸ����� ������ �ʵ��� �Ѵ�.)
SELECT DEPARTMENT_NAME ||'�� ' �а�, '������ '||ROUND(CAPACITY)||'������ �����Ǿ����ϴ�.' ����
FROM TB_DEPARTMENT;

UPDATE TB_DEPARTMENT
SET CAPACITY = CAPACITY*1.1
;

-- Ex5) �й� A413042�� �ڰǿ� �л��� �ּҰ� "����� ���α� ���ε� 181-21"�� ����Ǿ��ٰ� �Ѵ�.
-- �ּ����� �����ϱ� ���� ����� SQL ���� �ۼ��Ͻÿ�.
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�, STUDENT_ADDRESS �ּ�
FROM TB_STUDENT
WHERE STUDENT_NO = 'A413042'
;
UPDATE TB_STUDENT
SET STUDENT_ADDRESS = '����� ���α� ���ε� 181-21'
WHERE STUDENT_NO = 'A413042'
;
ROLLBACK;

-- Ex6) �ֹε�Ϲ�ȣ ��ȣ���� ���� �л����� ���̺��� �ֹι�ȣ ���ڸ��� �������� �ʱ�� �����Ͽ���.
-- �� ������ �ݿ��� ������ SQL ������ �ۼ��Ͻÿ�.
SELECT STUDENT_SSN, RPAD(SUBSTR(STUDENT_SSN, 1,8),14,'*'), SUBSTR(STUDENT_SSN, 1,8) || '******'
FROM TB_STUDENT
;
UPDATE TB_STUDENT
SET STUDENT_SSN = RPAD(SUBSTR(STUDENT_SSN, 1,8),14, '*')
;
-- Ex7) ���а� ����� �л��� 2005�� 1�б⿡ �ڽ��� ������ '�Ǻλ�����' ������ 
-- �߸��Ǿ��ٴ� ���� �߰��ϰ�� ������ ��û�Ͽ���.
-- ��� ������ Ȯ�� ���� ��� �ش� ������ ������ 3.5�� ����Ű�� �����Ǿ���. ������ SQL ���� �ۼ��Ͻÿ�
SELECT STUDENT_NAME, STUDENT_NO, DEPARTMENT_NAME, TERM_NO, CLASS_NAME, POINT
FROM TB_GRADE
JOIN TB_STUDENT USING (STUDENT_NO)
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_CLASS USING (CLASS_NO)
WHERE STUDENT_NAME = '�����'
AND DEPARTMENT_NAME = '���а�'
AND TERM_NO = '200501'
AND CLASS_NAME = '�Ǻλ�����'
;

UPDATE TB_GRADE
SET POINT = '3.5'
WHERE TERM_NO = '200501'
AND STUDENT_NO = (SELECT STUDENT_NO 
                    FROM TB_STUDENT 
                    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
                    WHERE STUDENT_NAME = '�����'
                    AND DEPARTMENT_NAME = '���а�')
AND CLASS_NAME = (SELECT CLASS_NAME 
                    FROM TB_CLASS 
                    WHERE CLASS_NAME = '�Ǻλ�����')
;
ROLLBACK;