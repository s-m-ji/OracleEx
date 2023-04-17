-- create table test(col varchar2(10));
-- ���̺�� ����
RENAME EMPLOYEE TO EMP;
RENAME DEPARTMENT TO DEPT;

/*
    <JOIN>
    �� �� �̻��� ���̺��� �����͸� ��ȸ�ϰ��� �� �� ����ϴ� �����̴�.
    
    1. � ����(EQUAL JOIN) / ���� ����(INNER JOIN)
    �����Ű�� �÷��� ���� ��ġ�ϴ� ��鸸 ���εǾ ��ȸ�Ѵ�. 
    (��ġ�ϴ� ���� ���� ���� ��ȸX)
    
        1) ����Ŭ ���� ����
            SELECT �÷�, �÷� ...
            FROM ���̺�1, ���̺�2
            WHERE ���̺�1.�÷��� = ���̺�2.�÷���;
            
            - FROM���� ��ȸ�ϰ����ϴ� �÷����� ,(�޸�)�� �����Ͽ� ����
            - WHERE���� ��Ī ��ų �÷��� ���� ������ ����

        2) ANSI ǥ�� ����
                 * ANSI �̱� ���� ǥ�� ��ȸ(American National Standards Institute)
            SELECT �÷�, �÷�...
            FROM ���̺�1
            [INNER] JOIN ���̺�2 ON (���̺�1.�÷Ÿ� = ���̺�2.�÷���);
            [INNER] JOIN ���̺�2 USING (�÷���);
            
            -- FROM������ ������ �Ǵ� ���̺��� ���
            -- JOIN���� ���� ��ȸ�ϰ��� �ϴ� ���̺��� ��� �� ������ ���
            -- ���ῡ ����Ϸ��� �÷����� ���ٸ� ON�� ��� USING�� ��� ����
*/

-- �� ������� ���, �����, �μ��ڵ�, �μ����� ��ȸ
SELECT COUNT(*) FROM EMP; -- �� 23��
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMP;    -- DEPT_CODE

SELECT COUNT(*) FROM DEPT; -- �� 9��
SELECT DEPT_ID, DEPT_TITLE FROM DEPT;            -- DEPT_ID

-- 1) ========== ����Ŭ ���� ���� ==========================================

    -- 1. ������ �÷����� �ٸ� ���
SELECT * FROM EMP, DEPT                         -- �޸�(,)�� ���̺� ������ ����
WHERE DEPT_CODE = DEPT_ID                       -- �� 21�� * -2���� �����̹Ƿ� ������ ����� ã�ư�����
;    
-- [INNER] JOIN : ���� ���ǿ� �����ϴ� ���� ��ȸ (LIKE ������)
-- �տ� �ƹ��͵� ���� ������ �⺻�� INNER JOIN�̴�.

-- EMP(��� ���̺�)���� ������ ������ ã��
--  1) ������ �̿� 
--  ��ü ����� ������� - JOIN���� ������� = ��ġ���� �ʴ� �� ��ȸ
SELECT * FROM EMP
    MINUS
SELECT EMP.*                                     -- EMP(��� ���̺�)�� ���� ��� �÷��� ��ȸ
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID;                      --  DEPT_CODE�� NULL�� ����� 2�� �־���

-- DEPT(�μ� ���̺�)���� ������ ���� �μ��ڵ� ã��
-- JOIN ��� �ߺ� ����
SELECT DISTINCT(DEPT_ID)                                  
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID;

SELECT * 
FROM DEPT 
WHERE DEPT_ID NOT IN (
    SELECT DISTINCT(DEPT_ID)                                  
    FROM EMP, DEPT
    WHERE DEPT_CODE = DEPT_ID
);                                              -- ����� �������� ���� �μ� (D3,D4,D7)

SELECT * FROM EMP, DEPT                        
WHERE DEPT_CODE = DEPT_ID(+)                    -- LEFT OUTER JOIN : ����(DEPT_CODE)�� �ش��ϴ� ���� ��� ã�� �ʹٸ� �����ʿ�(+) ���̱�               
;

SELECT * FROM EMP, DEPT                        
WHERE DEPT_CODE(+) = DEPT_ID                   -- RIGHT OUTER JOIN : ������(DEPT_ID)�� �ش��ϴ� ���� ��� ã�� �ʹٸ� ���ʿ�(+) ���̱�               
;

-- * ����Ŭ ���������� FULL OUTER JOIN : �÷���(+) = �÷���(+) �� ��������������

    -- 2. ������ �÷����� ���� ���
    --  SELECT���� ���� �÷����� � ���̺��� ������ ���

-- ���� ����
-- �� ������� ���, �����, ���� �ڵ�, ���޸��� ��ȸ
SELECT EMP_ID, EMP_NAME, EMP.JOB_CODE, JOB_NAME
FROM EMP
JOIN JOB ON (EMP.JOB_CODE = JOB.JOB_CODE);

-- ���̺� ��Ī �༭ ��ȸ�ϱ�
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME       
FROM EMP E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
-- ���̺� ��Ī�� ����� ��� SELECT�� WHERE�������� ��Ī�� �̿��ؼ� �����ؾ��Ѵ�. E.JOB_CODE (O), EMP.JOB_CODE (X)

SELECT * FROM EMP, JOB
WHERE EMP.JOB_CODE(+) = JOB.JOB_CODE;

-- ========== ANSI ǥ�� ���� ==========================================
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
JOIN DEPT ON (DEPT_ID = DEPT_CODE);

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME         -- USING�� ����� ��� ���̺� �̸� ����ϸ� �ȵȴ�. E.JOB_CODE (X), EMP.JOB_CODE (X)
FROM EMP E
JOIN JOB USING (JOB_CODE);
-- USING���� �� �κ��� �ĺ��ڸ� ���� �� ���� / USING���� ���� �÷��� ���̺� �̸��� �տ� ���� �� ����

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMP E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE); 

-- EMP���̺�� JOB���̺��� �����Ͽ� ������ �븮�� �����
-- ���, �����, ���޸�, �޿��� ��ȸ

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY  
FROM EMP E, JOB J
--WHERE JOB_NAME = '�븮';
WHERE E.JOB_CODE = 'J6';
-- �̰͵� JOIN ������ ���� ������ ������ ���� �����°� !

SELECT * FROM EMP, DEPT;        
-- �̷��� JOIN ������ ���� ������ ��� 1��� ��� �μ��� ������� ��������� �����ֱ⶧����
--    23*9 = 207���� ���� ���´�. (ī�׽þ� ����)

-- ����Ŭ �������� �� �� *******************
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
--AND JOB_NAME = '�븮'; �̷��� NAME���� �Ÿ��ų�, �Ʒ��� ���� CODE�� ���͸��ϰų�
AND EMP.JOB_CODE = 'J6';

-- ANSI �������� �� �� *******************
SELECT EMP_ID, EMP_NAME, J.JOB_NAME, SALARY
FROM EMP E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
--WHERE J.JOB_NAME = '�븮';
WHERE E.JOB_CODE = 'J6';

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMP
JOIN JOB USING (JOB_CODE)
--WHERE JOB_NAME = '�븮';
WHERE JOB_CODE = 'J6';

/*
    2. ���� JOIN
    �������� ���̺��� �����ϴ� ��쿡 ���
    - ANSI ������ ���� ��쿡�� ���� ���� ������ �߿��ϴ�.
    - ����Ŭ ���������� FROM������ ���̺��� ��õǾ��ֱ� ������ ������ �ٲ㵵 ������� ������ ���� �ʴ´�.
*/
-- ���, �����, �μ���, ������ ��ȸ
SELECT * FROM EMP;          -- DEPT_CODE
SELECT * FROM DEPT;         -- DEPT_ID  LOCATION_ID
SELECT * FROM LOCATION;     -- LOCAL_CODE

SELECT * FROM EMP, DEPT, LOCATION
WHERE DEPT_CODE = DEPT_ID           -- �÷����� �ٸ��ٸ� �տ� ���̺���� ��������ʾƵ� ����
AND LOCATION_ID = LOCAL_CODE
;

-- ����Ŭ ����
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMP, DEPT, LOCATION
--WHERE DEPT_CODE = DEPT_ID
--AND LOCATION_ID = LOCAL_CODE;
WHERE LOCATION_ID = LOCAL_CODE 
AND DEPT_CODE = DEPT_ID;

-- ANSI ����
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)       -- �̷��� ������ �ٲ� ��� ����� ã�� �� ������.
--JOIN DEPT ON (DEPT_CODE = DEPT_ID);


/*
    3. �ܺ� ����(OUTER JOIN)
    ���̺� �� JOIN �� ���ǿ� ��ġ�����ʴ� �൵ ��� ���Խ��Ѽ� ��ȸ
    ������ �Ǵ� ���̺��� �����ؾ��Ѵ�.(LEFT/RIGHT/(+))
*/
-- ������ ��� 2���� ��� ����ϰ�ʹٸ� ? EMP ���̺� ���� ��� ����ϵ��� �� 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP, DEPT
WHERE EMP.DEPT_CODE = DEPT.DEPT_ID(+);

-- 1) LEFT [OUTER] JOIN 
--  : �� ���̺� �� ���ʿ� ����� ���̺� �÷��� �������� JOIN�� ����
--      JOIN ������ ��ġ�����ʾƵ� ��� ����ϰڴٴ� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
LEFT OUTER JOIN DEPT ON (DEPT_CODE = DEPT_ID);      
-- EMP�� ��� ����ϰ����
-- JOIN�� �������� LEFT/RIGHT 
-- JOIN ���� OUTER�� ���� ������ (������ �ڵ带 ���� �����ص� ������)

-- 2) RIGHT [OUTER] JOIN 
--  : �� ���̺� �� �����ʿ� ����� ���̺� �÷��� �������� JOIN�� ����
--      JOIN ������ ��ġ�����ʾƵ� ��� ����ϰڴٴ� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
RIGHT JOIN DEPT ON (DEPT_CODE = DEPT_ID); 
-- DEPT�� ��� ����ϰ����

-- �����, �μ���, �޿� ����ϵ� �μ����̺��� ��� �����Ͱ� ��µǵ���... 
-- ����Ŭ ����
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP, DEPT
WHERE EMP.DEPT_CODE(+) = DEPT.DEPT_ID;
-- ANSI ����
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP
RIGHT JOIN DEPT ON (DEPT_CODE = DEPT_ID);

-- 3) FULL [OUTER] JOIN 
--  : �� ���̺� ����� ���̺� �÷��� �������� ��� ��µǵ��� JOIN�� ����
--      JOIN ������ ��ġ�����ʾƵ� ��� ����ϰڴٴ� ��
-- ��ȸ ���� ������ 21�� + EMP�� NULL�� 2�� + ����� �������� ���� �μ��ڵ� 3�� = ��� �� 26�� ��ȸ
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP
FULL JOIN DEPT ON (DEPT_CODE = DEPT_ID);






