/*
    <VIEW>
    SELECT ���� ������ �� �ִ� ��ü (������ ���� ���̺�)
    �����͸� �����ϰ����� ������ ���̺� ���� SQL�� ����Ǿ��־�
    VIEW ������ �� SQL�� �����ϸ鼭 ������� �����´�.
    
    ǥ����
        CREATE [OR REPLACE] VIEW ��٣
        AS ��������;
        - �̹� �ִ� ���� OR REPLACE�� �� �Ἥ ����������: ���� ��ü�� �����ϴ� ��� ����(�����)
*/

-- ����) �ѱ����� �ٹ��ϴ� ������ ���, �̸�, �μ���, �޿�, �ٹ� �������� ��ȸ
SELECT EMP_ID ���, EMP_NAME �̸�, DEPT_TITLE �μ���, TO_CHAR(SALARY, 'L9,999,999') �޿�, NATIONAL_NAME �ٹ�������
FROM EMP E, DEPT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
AND NATIONAL_NAME = '�ѱ�'
;
-- �� ���� ========================================================
CREATE /*OR REPLACE*/ VIEW V_EMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMP E, DEPT D, LOCATION L, NATIONAL N
    WHERE E.DEPT_CODE = D.DEPT_ID(+)
    AND D.LOCATION_ID = L.LOCAL_CODE(+)
    AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
;
SELECT * FROM V_EMP WHERE NATIONAL_NAME = '���þ�';
-- VIEW�� ���� ���̺��̱� ������ ���� �����Ͱ� ����ִ°� �ƴ�. 
-- ��� ������ Ȯ���ϱ� ���� �뵵����? => ��� �󵵰� ���� ���������� ��� �����صθ� �����ϴ�.

-- ����) �ѹ��ο��� �ٹ��ϴ� ������ �����, �޿��� ��ȸ
SELECT EMP_NAME �����, SALARY �޿�
FROM V_EMP
WHERE DEPT_TITLE = '�ѹ���';

-- VIEW�� ���� ��� ��ȸ�� ������
SELECT * FROM USER_VIEWS;

-- ����� ���, �̸�, ����, �ٹ������ ��ȸ�� �� �ִ� �並 ����
SELECT EMP_ID ���, EMP_NAME ����� 
        , DECODE(SUBSTR(EMP_NO,8,1),'1','��', '2','��' ,'3','��', '4','��', '') ����
        , ROUND((SYSDATE - HIRE_DATE)/365) || '��' �ٹ����
        , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) || '��' �ٹ����2
        , TO_CHAR(SYSDATE,'YYYY') - ('19'||SUBSTR(EMP_NO,1,2)) || '��' ����
FROM EMP
;

CREATE VIEW V_EMP_01
AS SELECT EMP_ID ���, EMP_NAME ����� 
        , DECODE(SUBSTR(EMP_NO,8,1),'1','��', '2','��' ,'3','��', '4','��', '') ����
        , ROUND((SYSDATE - HIRE_DATE)/365) || '��' �ٹ����
    FROM EMP
; 
-- ���� VIEW ���� �ÿ� OR REPLACE�� �� ��ٸ� DROP�ϰ� �ٽ� ���� �ȴ�. 
DROP VIEW V_EMP_01;
SELECT * FROM V_EMP_01;
SELECT * FROM V_EMP_01 WHERE ����� = '������';

-- ��Ī �ֱ� 2)
CREATE VIEW V_EMP_02 ("���2", "�����2", "����2", "�ٹ����2")
AS SELECT EMP_ID ���, EMP_NAME ����� 
        , DECODE(SUBSTR(EMP_NO,8,1),'1','��', '2','��' ,'3','��', '4','��', '') ����
        , ROUND((SYSDATE - HIRE_DATE)/365) || '��' �ٹ����
    FROM EMP
;
DROP VIEW V_EMP02;
SELECT * FROM V_EMP_02;
-- �������� �÷��� �̹� ��Ī�� ������, �並 �����ϸ鼭 �ٽ� �ο��ϸ� �����ǵȴ�. 

/* <VIEW�� �̿��ؼ� DML ���>
    �並 ���� �����͸� �����ϰ� �Ǹ� ���� �����Ͱ� ����ִ� �⺻ ���̺��� ����ȴ�.
*/
CREATE VIEW V_JOB AS SELECT * FROM JOB;
SELECT * FROM V_JOB;
-- VIEW�� ���� ���̺� INSERT 
INSERT INTO V_JOB VALUES ('J8', '����');
-- VIEW�� ���� ���̺� UPDATE
UPDATE V_JOB SET JOB_NAME='�˹�' WHERE JOB_CODE='J8';
-- VIEW�� ���� ���̺� DELETE
DELETE V_JOB WHERE JOB_NAME='�˹�';

/*
    <DML �������� VIEW ������ �Ұ����� ���>
*/
-- 1) VIEW ���ǿ� ���Ե��� �ʴ� �÷��� �����ϴ� ���
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_CODE FROM JOB;
SELECT * FROM V_JOB;

-- ���� V_JOB�� �÷��� 1���ε� 2�� ���� ���������ϸ� ���� �߻�
INSERT INTO V_JOB VALUES ('J8', '����');
-- ���� V_JOB�� JOB_NAME�̶�� �÷��� ���µ� ���� �����Ϸ����ϸ� ���� �߻�
UPDATE V_JOB SET JOB_NAME = '���ϴ� ���';
-- ���ǿ� ��ġ�ϴ� �����Ͱ� ���� ��� '0�� �� ��(��) �����Ǿ����ϴ�.' ��ũ��Ʈ ���
DELETE FROM V_JOB WHERE JOB_CODE = 'J10';

-- 2) �信 ���Ե��� ���� �÷� �� �⺻ ���̺� NOT NULL ���� ������ ������ ��� 
CREATE OR REPLACE VIEW V_JOB
AS SELECT JOB_NAME FROM JOB;

DROP VIEW V_JOBE;
SELECT * FROM V_JOB;

INSERT INTO V_JOB VALUES ('�˹�');     -- 'NULL�� ("JUNGANG"."JOB"."JOB_CODE") �ȿ� ������ �� �����ϴ�' => �ֳĒD DML���� ���� ���̺� JOB�� �����ϱ⶧���Գ״� 

-- 3) ��� ǥ�������� ���ǵ� ���
-- ���, �����, �޿�, �޿�*12
CREATE OR REPLACE VIEW V_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 ����
    FROM EMP
;
SELECT * FROM V_EMP_SAL;

-- ��������� ���� �÷��� ����/���� �Ұ�
INSERT INTO V_EMP_SAL VALUES (001, '��彺Ź', 3000000, 36000000);
-- ��������� ������ �÷��� ���� ���� 
UPDATE V_EMP_SAL SET SALARY = 800000000 WHERE EMP_ID = 200;

-- 4) �׷��Լ��� GROUP BY���� ������ ���
CREATE OR REPLACE VIEW V
AS SELECT NVL(DEPT_CODE, '*�μ�����*') �μ��ڵ�
        , TO_CHAR(SUM(SALARY),'L999,999,999') �հ�
        , TO_CHAR(ROUND(AVG(SALARY)),'L999,999,999') ���
    FROM EMP
    GROUP BY DEPT_CODE
;
SELECT * FROM V;

-- 5) DISTINCT�� ������ ���
-- &
-- 6) JOIN�� ����ؼ� ���� ���� ���̺��� ����� ��� 
-- VIEW�� ������ ���� ������ DML���� ����Ͽ� �����͸� ������ ���� ����. 

/*
    <VIEW> �ɼ� ^_^
    CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW ���̸�
    AS ��������
    [WITH CHECK OPTION]
    [WITH READ ONLY];       
    
    - OR REPLACE ������ ������ �䰡 ������ ����� ������ �űԷ� �����Ѵ�.
    - FORCE ���������� ����� ���̺��� �������� �ʾƵ� �䰡 �����ȴ�.
    - NOFORCE ���������� ����� ���̺��� �����ؾ����� �䰡 �����ȴ�. (�⺻��)
    - WITH CHECK OPTION ���������� ����� ���ǿ� �������� �ʴ� ������ �����ϴ� ��� ������ �߻���Ų��.
    - WITH READ OLNY �信 ���� ��ȸ�� �����ϴ�(DML ��� �Ұ�)
*/

CREATE OR REPLACE VIEW V_EMP_01
AS
SELECT EMP_NAME, SALARY, HIRE_DATE FROM EMP;
SELECT * FROM V_EMP_01;

-- 2) FORCE|NOFORCE
-- �������̺� TT�� �����غ�
CREATE OR REPLACE FORCE VIEW V_EMP_02
  AS
    SELECT TCODE, TNAME, TCONTENT FROM TT;
SELECT * FROM V_EMP_02;

-- ���̺��� �����ϰ� �� ���ĺ��� ��ȸ ����
CREATE TABLE TT (
    TCODE NUMBER
    , TNAME VARCHAR2(10)
    , TCONTENT VARCHAR2(20)
);

-- 3) WITH CHECK OPTION
-- �޿��� 300���� �̻��� ����� 
CREATE OR REPLACE VIEW V_EMP_03
  AS 
    SELECT * FROM EMP WHERE SALARY >= 3000000
WITH CHECK OPTION;
SELECT * FROM V_EMP_03;
UPDATE V_EMP_03 SET SALARY = 200 WHERE EMP_ID=200;

-- 4) WITH READ ONLY (�б� ����)
CREATE VIEW V_DEPT_01 
AS SELECT * FROM DEPT WITH READ ONLY; 

SELECT * FROM V_DEPT_01;
SELECT * FROM USER_VIEWS;

INSERT INTO V_DEPT_01 VALUES ('D0', '���ñٹ���', '��������');
















