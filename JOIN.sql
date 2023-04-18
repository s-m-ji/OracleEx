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
--  : �� ���̺� �� ���ʿ� ����� ���̺� �÷� ���� �������� JOIN�� ����
--      JOIN ������ ��ġ�����ʾƵ� ��� ����ϰڴٴ� ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
LEFT OUTER JOIN DEPT ON (DEPT_CODE = DEPT_ID);      
-- EMP�� ��� ����ϰ����
-- JOIN�� �������� LEFT/RIGHT 
-- JOIN ���� OUTER�� ���� ������ (������ �ڵ带 ���� �����ص� ������)

-- 2) RIGHT [OUTER] JOIN 
--  : �� ���̺� �� �����ʿ� ����� ���̺� �÷� ���� �������� JOIN�� ����
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
--  : �� ���̺��� ��� ���� �������� ��� ��µǵ��� JOIN�� ����
--      JOIN ������ ��ġ�����ʾƵ� ��� ����ϰڴٴ� ��
-- ��ȸ ���� ������ 21�� + EMP�� NULL�� 2�� + ����� �������� ���� �μ��ڵ� 3�� = ��� �� 26�� ��ȸ
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP
FULL JOIN DEPT ON (DEPT_CODE = DEPT_ID);

SELECT DEPT_ID �μ��ڵ�, DEPT_TITLE �μ���, L.LOCAL_CODE �����ڵ�, LOCAL_NAME ������ 
FROM DEPT D
JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE);

SELECT DEPT_ID �μ��ڵ�2, DEPT_TITLE �μ���2, L.LOCAL_CODE �����ڵ�2, LOCAL_NAME ������2
FROM DEPT D, LOCATION L
WHERE LOCATION_ID = LOCAL_CODE;
--WHERE LOCATION_ID = LOCAL_CODE(+);

/*
    4. ī�׽þ� ��(CATESIAN PRODUCT) ���� ����(CROSS JOIN)
    ���εǴ� ��� ���̺��� �� ����� ���μ��� ��� ���ε� �����Ͱ� �˻��ȴ�.
    ���̺��� ����� ��� ������ ����� ������ ��� -> ����ȭ ���� ��
*/

SELECT COUNT(*) FROM EMP;   -- ��� 23��
SELECT COUNT(*) FROM DEPT;   -- 9�� �μ�

SELECT EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE 
FROM EMP, DEPT
ORDER BY EMP_ID;       
-- ��ȸ ��� 23 * 9 = 207 ��
-- ���ٸ� ������ ������� �ʾұ� ������ 
-- �� ���� ����� ���� �ٸ� �μ��� ����Ǿ� 9���� ��ȸ�Ǵ� ���� �� �� ����.

SELECT COUNT(*) 
--SELECT EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE 
FROM EMP
CROSS JOIN DEPT
ORDER BY EMP_ID;

/*
    5. �� ����(NON EQUAL JOIN)
    ���� ���ǿ� ��ȣ(=)�� ������� �ʴ� ���ι��� �� �����̶�� �Ѵ�.
    ������ �÷� ���� ��ġ�ϴ� ��찡 �ƴ�,
    ���� ������ ���ԵǴ� ����� �����ϴ� ����̴�.
    (= �̿ܿ� �� ������ >, <, >=, <=, BETWEEN AND, IN, NOT IN ���� ���)
    ANSI �������δ� JOIN ON ������ ��� ����(USING ��� �Ұ�)
*/
-- �޿� ��� ���̺� ����
CREATE TABLE SAL_GRADE (
    SAL_LEVEL CHAR(2 BYTE)
    , MIN_SAL NUMBER
    , MAX_SAL NUMBER
);
COMMENT ON COLUMN SAL_GRADE.SAL_LEVEL IS '�޿����';
COMMENT ON COLUMN SAL_GRADE.MIN_SAL IS '�ּұ޿�';
COMMENT ON COLUMN SAL_GRADE.MAX_SAL IS '�ִ�޿�';
COMMENT ON TABLE SAL_GRADE IS '�޿����';

INSERT INTO SAL_GRADE VALUES ('S1',6000000,1000000);
INSERT INTO SAL_GRADE VALUES ('S2',5000000,5999999);
INSERT INTO SAL_GRADE VALUES ('S3',4000000,4999999);
INSERT INTO SAL_GRADE VALUES ('S4',3000000,3999999);
INSERT INTO SAL_GRADE VALUES ('S5',2000000,2999999);
INSERT INTO SAL_GRADE VALUES ('S6',1000000,1999999);

SELECT EMP_NAME, TO_CHAR(SALARY,'L999,999,999'), SAL_LEVEL
FROM EMP E, SAL_GRADE S
--WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL
WHERE MIN_SAL < SALARY
AND SALARY < MAX_SAL
ORDER BY EMP_ID
;

UPDATE SAL_GRADE SET MAX_SAL = 3500000 WHERE SAL_LEVEL = 'S5';
UPDATE SAL_GRADE SET MAX_SAL = 2999999 WHERE SAL_LEVEL = 'S5';
-- ������ ��ġ�� �� ��� �翬�� ���� �ߺ��Ǿ� ���´�. (����� 3,400,000�� ���� S4,S5 �� �� ���Ե�)
SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, TO_CHAR(SALARY,'L999,999,999'), SAL_LEVEL
FROM EMP
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL)
;

SELECT * FROM SAL_GRADE;

/*
    6. ��ü ����(SELF JOIN)
    ���� ���̺��� �ٽ� �ѹ� �����ϴ� ��쿡 ����Ѵ�.
    -- SELECT���� ���� ��� �÷��� ���̺��� ����ؾ��Ѵ�.
*/
-- MANAGER_ID : �Ŵ��� ���
SELECT E.EMP_ID ���, E.EMP_NAME �����, E.DEPT_CODE �μ��ڵ�, E.MANAGER_ID �Ŵ����ڵ�
    , M.EMP_ID �Ŵ������ , M.EMP_NAME �Ŵ�����
FROM EMP E, EMP M
WHERE E.MANAGER_ID = M.EMP_ID(+);   -- �Ŵ������ ��� ��ȸ�ϱ� ����


-- ���������� Ǯ��ô�
-- ���ʽ��� �޴� ����� ���, �����, ���ʽ�, �μ��� ��ȸ
SELECT EMP_ID ���, EMP_NAME �����, BONUS ���ʽ�, DEPT_TITLE �μ���
FROM EMP, DEPT
WHERE BONUS IS NOT NULL
AND DEPT_CODE = DEPT_ID;

SELECT EMP_ID ���, EMP_NAME �����, BONUS ���ʽ�, DEPT_TITLE �μ���
FROM EMP
--JOIN DEPT ON (DEPT_CODE = DEPT_ID AND BONUS > 0);
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
AND BONUS IS NOT NULL;

-- �λ�����ΰ� �ƴ� ����� �����, �μ���, �޿� ��ȸ
SELECT EMP_NAME �����, DEPT_TITLE �μ���, SALARY �޿�
FROM EMP, DEPT
WHERE NVL(DEPT_TITLE, '�μ�����') ^= '�λ������'         
AND DEPT_CODE = DEPT_ID(+);
-- �μ� �ڵ尡 NULL�� ����� �λ�����ΰ� �ƴ��� �ʳ���..?
--> �⺻������ NULL�� �����ϰ� ��ȯ/��ȸ�Ǳ� ������
--> ���� NULL���� �����ϰ�ʹٸ� NVL()�Լ��� �̿��ϰų�, OR�� �������� �߰����ָ� �ȴ�.

SELECT EMP_NAME �����, DEPT_TITLE �μ���, SALARY �޿�
FROM EMP
--LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID AND DEPT_TITLE <> '�λ������');
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE <> '�λ������'
OR DEPT_TITLE IS NULL;   

SELECT EMP_NAME �����, DEPT_TITLE �μ���, SALARY �޿�
FROM EMP
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
--WHERE DEPT_TITLE IS NULL OR DEPT_TITLE NOT IN ('�λ������')
--WHERE NVL(DEPT_TITLE, '�μ� ����') != '�λ������' OR DEPT_TITLE NOT IN ('�λ������')
WHERE DEPT_TITLE NOT IN ('�λ������') AND NVL(DEPT_TITLE, '�μ� ����') != '�λ������' 
;

SELECT COUNT(*)
FROM EMP, DEPT
WHERE DEPT_TITLE = '�λ������'
AND DEPT_CODE = DEPT_ID;

SELECT * FROM EMP;


-- ���, �����, �μ���, ������, ������ ��ȸ
SELECT EMP_ID ���, EMP_NAME �μ���, DEPT_TITLE �μ���, LOCAL_NAME ������, NATIONAL_NAME ������
FROM EMP E, DEPT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE = N.NATIONAL_CODE(+);

SELECT EMP_ID ���, EMP_NAME �����, DEPT_TITLE �μ���, LOCAL_NAME ������, NATIONAL_NAME ������
FROM EMP E
LEFT JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
;

-- ���, �����, �μ���, ������, ������, �޿���� ��ȸ
SELECT EMP_ID ���, EMP_NAME �����, DEPT_TITLE �μ���, LOCAL_NAME ������, NATIONAL_NAME ������, SAL_LEVEL �޿����
FROM EMP E, DEPT D, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
AND SALARY BETWEEN MIN_SAL AND MAX_SAL;     

SELECT EMP_ID ���, EMP_NAME �����, DEPT_TITLE �μ���, LOCAL_NAME ������, NATIONAL_NAME ������, SAL_LEVEL �޿����
FROM EMP E
LEFT JOIN DEPT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
LEFT JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

SELECT E.EMP_ID ���, E.EMP_NAME �����, E.DEPT_CODE �μ��ڵ�, E.MANAGER_ID �Ŵ����ڵ�, M.EMP_ID �Ŵ������ , M.EMP_NAME �Ŵ�����
FROM EMP E
    LEFT JOIN EMP M ON (E.MANAGER_ID = M.EMP_ID); 
--       JOIN EMP M ON (E.MANAGER_ID = M.EMP_ID(+));   -- ANSI���� (+) ����� �ȴ� � ��쿣 ^_^ �ǳ�����...
--  LEFT JOIN EMP M ON (E.MANAGER_ID = M.EMP_ID(+));   -- �Դٰ� �̷��� LEFT, (+) ���ÿ� ��� �ȴ� � ��쿣 ^_^ �ǳ�����...


-- ���սǽ�����
-- 1. ������ �븮�̸鼭 ASIA �������� �ٹ��ϴ� ������ ���, �����, ���޸�, �μ���, �ٹ�����, �޿� ��ȸ

SELECT EMP_ID ���, EMP_NAME �����, JOB_NAME ���޸�, DEPT_TITLE �μ���, LOCAL_NAME �ٹ�����, SALARY �޿�
FROM EMP E, DEPT D, JOB J, LOCATION L
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND LOCATION_ID = LOCAL_CODE
AND JOB_NAME = '�븮' AND LOCAL_NAME LIKE 'ASIA%'
;

SELECT EMP_ID ���, EMP_NAME �����, JOB_NAME ���޸�, DEPT_TITLE �μ���, LOCAL_NAME �ٹ�����, SALARY �޿�
FROM EMP E
LEFT JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB B USING (JOB_CODE)
LEFT JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '�븮' AND LOCAL_NAME LIKE 'ASIA%'
;

-- 70�����̸鼭 �����̰� ���� �� ���� ������ �����, �ֹι�ȣ, �μ���, ���޸� ��ȸ
SELECT EMP_NAME �����, EMP_NO �ֹι�ȣ, DEPT_TITLE �μ���, JOB_NAME ���޸�
FROM EMP E
LEFT JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB B USING (JOB_CODE)
WHERE EMP_NAME LIKE '��%'            -- ���� �� ��  
AND (SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4')        -- ����
AND SUBSTR(EMP_NO,1,2) LIKE '7%'    -- 70����
;

SELECT EMP_NAME �����, EMP_NO �ֹι�ȣ, DEPT_TITLE �μ���, JOB_NAME ���޸�
FROM EMP E, JOB J, DEPT D
WHERE DEPT_CODE = DEPT_ID(+)            -- 
AND E.JOB_CODE = J.JOB_CODE             -- ��� ����� ������ �����ֱ⿡ (+)�� �ʿ䰡 ������
WHERE EMP_NAME LIKE '��%'              -- ���� �� ��  
AND SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4'          
AND EMP_NO LIKE '7%'    -- 70���� ���1)
--AND SUBSTR(EMP_NO,1,1) = '7'    -- 70���� ���2)

-- TODO ���� '-' �ٷ� ���ڸ� ���ڸ� ��������� �Ѵٸ� ???????????????????????
;

SELECT SUBSTR((TO_CHAR(SYSDATE, 'YYYY') - SUBSTR(EMP_NO,1,2)),3) FROM EMP;


-- ���ʽ��� �޴� ������ �����, ���ʽ�, ����, �μ���, �ٹ������� ��ȸ
-- �μ� �ڵ尡 ���� ����� ��µ� �� �ְ� OUTER JOIN ���
-- ���� : ���޿� * 12 ���ڸ� �޸��� ǥ��
-- NULL�� ' '���� ġȯ

SELECT EMP_NAME �����, NVL(BONUS,0) ���ʽ�, TO_CHAR(SALARY*12, '999,999,999') ����, NVL(DEPT_TITLE, ' ') �μ���, NVL(LOCAL_NAME, ' ') �ٹ�����
FROM EMP E 
LEFT OUTER JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT OUTER JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS <> 0
ORDER BY EMP_NAME;

SELECT EMP_NAME �����, BONUS ���ʽ�, TO_CHAR(SALARY*12, '999,999,999') ����, DEPT_TITLE �μ���, LOCAL_NAME �ٹ�����
FROM EMP E, DEPT D, LOCATION L
WHERE DEPT_CODE = DEPT_ID(+)            -- �ϴ� E.DEPT_CODE ���� ������� ��� ��ȸ�ؾ��ϱ� ������ (+) ���� 
AND LOCATION_ID = LOCAL_CODE(+)         -- LOCATION_ID�� DEPT�� ������ �Ǿ��ֱ� ������ �Ʒ����� (+) ���� ���� ? 
AND BONUS IS NOT NULL
;

-- �ѱ��� �Ϻ����� �ٹ��ϴ� ������ �����, �μ���, �ٹ�����, �ٹ������� ��ȸ
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMP E, DEPT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND NATIONAL_NAME IN ('�ѱ�' , '�Ϻ�')
;

SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMP E
JOIN DEPT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING (NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('�ѱ�' , '�Ϻ�')
;

-- �� �μ��� ��� �޿��� ��ȸ�Ͽ� �μ���, ��� �޿�(���� ó��)�� ��ȸ
-- �μ� ��ġ�� �� �� ����� ��յ� ���� �����Բ� �ۼ�

SELECT NVL(DEPT_TITLE,'- �μ� ���� -') �μ���, TO_CHAR(ROUND(AVG(SALARY)),'999,999,999')��ձ޿� 
FROM EMP, DEPT
--WHERE DEPT_CODE(+) = DEPT_ID
WHERE DEPT_CODE = DEPT_ID(+)
GROUP BY DEPT_TITLE
ORDER BY DEPT_TITLE
;

SELECT NVL(DEPT_TITLE,'- �μ� ���� -') �μ���, TO_CHAR(ROUND(AVG(SALARY)),'999,999,999')��ձ޿� 
FROM EMP
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
ORDER BY ��ձ޿� DESC
;


-- �� �μ��� �� �޿��� ���� 1,000���� �̻��� �μ���, �޿��� �� ��ȸ
SELECT DEPT_TITLE �μ���, TO_CHAR(SUM(SALARY),'L999,999,999') �޿���
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= '10000000'
ORDER BY �޿���
;
SELECT DEPT_TITLE �μ���, TO_CHAR(SUM(SALARY),'L99,999,999') �޿���
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= 10000000
ORDER BY �޿��� DESC
;

--
SELECT EMP_ID, EMP_NAME, JOB_NAME, 
    DECODE(SAL_LEVEL, 'S1','���', 'S2','���',
                      'S3','�߱�', 'S4','�߱�',  
                      'S5','�ʱ�', 'S6','�ʱ�', '��.��.��') �޿����
FROM EMP
JOIN JOB ON (EMP.JOB_CODE = JOB.JOB_CODE)
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL)
;

SELECT EMP_ID ���, EMP_NAME �����, JOB_NAME ���޸�, SAL_LEVEL �޿����,
    CASE WHEN SAL_LEVEL IN ('S1', 'S2') THEN '���'
         WHEN SAL_LEVEL IN ('S3', 'S4') THEN '�߱�'
         WHEN SAL_LEVEL IN ('S5') THEN '�ʱ�'
         ELSE '��.��.��' END ����
FROM EMP, JOB, SAL_GRADE
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND SALARY BETWEEN MIN_SAL AND MAX_SAL
ORDER BY EMP_ID
;

-- ���ʽ��� ���� �ʴ� ���� �� ���� �ڵ尡 J4 �Ǵ� J7�� ������ �����, ���޸�, �޿� ��ȸ
SELECT EMP_NAME, JOB_NAME, JOB_CODE, SALARY
FROM EMP
LEFT JOIN JOB USING (JOB_CODE)
WHERE BONUS IS NULL
AND JOB_CODE IN ('J4', 'J7')
;

SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND BONUS IS NULL
AND JOB.JOB_CODE IN ('J4', 'J7')
;

-- �μ��� �ִ� ������ �����, ���޸�, �μ���, �ٹ�����
SELECT EMP_NAME �����, JOB_NAME ���޸�, DEPT_TITLE �μ���, LOCAL_NAME �ٹ�����
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
;

SELECT EMP_NAME �����, JOB_NAME ���޸�, DEPT_TITLE �μ���, LOCAL_NAME �ٹ�����
FROM EMP, DEPT, JOB, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND EMP.JOB_CODE = JOB.JOB_CODE
AND LOCATION_ID = LOCAL_CODE
;

-- �ؿܿ������� �ٹ��ϴ� ���� �� 2013-01-01 ���� �Ի����� �����, ���޸�, �μ� �ڵ�, �μ����� ��ȸ
SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM EMP E, JOB J, DEPT D
WHERE E.JOB_CODE = J.JOB_CODE
AND DEPT_CODE = DEPT_ID
AND DEPT_TITLE LIKE '�ؿܿ���%'
AND HIRE_DATE >= '20130101'
;
--AND HIRE_DATE >= '2013-01-01'     -- ��¥ ������ ���������ϱ��... DATE Ÿ������ �ڵ�����ȯ �Ǳ� ������ �������.
--;

SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM EMP
JOIN JOB USING (JOB_CODE)
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_ID IN ('D5', 'D6', 'D7')
AND HIRE_DATE >= '13/01/01'
;

-- �̸��� '��'�ڰ� ����ִ� ������ ���, �����, ���޸��� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND EMP_NAME LIKE '%��%'
;
-- �ַ� �Խñ� ��ȸ �� ���� ���ȴ�. (~�� �����ϰ��ִ�)
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMP
JOIN JOB USING (JOB_CODE)
WHERE EMP_NAME LIKE '%��%'
;


















