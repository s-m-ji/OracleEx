/*
    <SUBQUERY>
    �ϳ��� SQL�� �ȿ� ���Ե� �� �ٸ� SQL���� ���Ѵ�.
    ���� ����(���� ����)�� �����ϴ� ������ �ϴ� ������
*/

/*
    [���� ���� ����]
    5. SELECT       ��ȸ�� �÷�
    1. FROM         ���̺�
    2. WHERE        ���ǽ�
    3. GROUP BY     �׷� ����
    4. HAVING       �׷� ���ǽ�
    6. ORDER BY     ���� ����
*/

-- ���ö ����� ���� �μ������� ��ȸ
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE EMP_NAME = '���ö'
;

-- ���������� () ��ȣ�� ����
-- �񱳰��� ��� Ÿ���� ��ġ�ؾ��Ѵ�

-- ���������� ������ ��� ���� ��� �� ������ ���� ���������� �з���

-- <������ ��������> =====================================================
--   �������� ��ȸ ��� ���� ��� �� ������ 1��
--      �񱳿����� ��� ���� (=, !=, <>, ^=, <, >, <=, >=)
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMP
                    WHERE EMP_NAME = '���ö'
    );

-- ������ 1) �� ������ ��� �޿����� �޿��� ���� �޴� ������, �����ڵ�, �޿��� ��ȸ
--      ��������: �� ������ ��� �޿�
SELECT ROUND(AVG(SALARY))
FROM EMP
;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMP
WHERE SALARY < (
                SELECT ROUND(AVG(SALARY))
                FROM EMP
        );

-- ������ 2) ���� �޿��� �޴� ������ ���, �̸�, ���� �ڵ�, �޿�, �Ի��� ��ȸ
--      ��������: ���� �޿� ��ȸ
SELECT MIN(SALARY)
FROM EMP;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMP
WHERE SALARY = (
        SELECT MIN(SALARY)
        FROM EMP
    );

-- ������ 3) ���ö ����� �޿����� �� ���� �޿��� �޴� ����� ���, �����, �μ���, ���� �ڵ�, �޿��� ��ȸ
--      ��������: ���ö ����� �޿��� ��ȸ
SELECT SALARY
FROM EMP
WHERE EMP_NAME = '���ö'
;
--      ����Ŭ ����
SELECT EMP_ID ���, EMP_NAME �����, DEPT_TITLE �μ���, JOB_CODE �����ڵ�, SALARY �޿�
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SALARY > (
    SELECT SALARY
    FROM EMP
    WHERE EMP_NAME = '���ö'
);
--      ANSI ����
SELECT EMP_ID ���, EMP_NAME �����, DEPT_TITLE �μ���, EMP.JOB_CODE �����ڵ�, TO_CHAR(SALARY, 'L99,999,999') �޿�
FROM EMP, DEPT, JOB
WHERE DEPT_CODE = DEPT_ID
AND EMP.JOB_CODE = JOB.JOB_CODE
AND SALARY > (
    SELECT SALARY
    FROM EMP
    WHERE EMP_NAME = '���ö'
);

-- ������4) �μ��� �޿��� ���� ���� ū �μ��� �μ��ڵ�, �޿��� ��ȸ
--      ��������1) : �μ��� �޿��� �� ��ȸ
SELECT DEPT_CODE �μ��ڵ�, SUM(SALARY) �޿���      -- SUM(SALARY)�� ���� �Լ��� ���� �� �� ����. 
FROM EMP
GROUP BY DEPT_CODE;

--      ��������2) �μ��� �޿��� �հ� �� �ִ밪�� ����      -- SELECT������ DEPT_CODE, MAX(SUM(SALARY)�� ���� �� �� ��� ���������� �б���
SELECT MAX(SUM(SALARY)) �޿����ִ�      
FROM EMP
GROUP BY DEPT_CODE
;

SELECT DEPT_CODE �μ��ڵ�, SUM(SALARY)�޿���
FROM EMP
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY)) �޿����ִ�      
    FROM EMP
    GROUP BY DEPT_CODE
);

-- �μ��� ��ձ޿��� ���� ���� �μ��� �μ� �ڵ�� ��� �޿��� ��ȸ
SELECT MIN(AVG(SALARY))    
FROM EMP
GROUP BY DEPT_CODE
;    
SELECT DEPT_CODE �μ��ڵ�, ROUND(AVG(SALARY)) ��ձ޿�
FROM EMP
GROUP BY DEPT_CODE
HAVING AVG(SALARY) = (
    SELECT MIN(AVG(SALARY))    
    FROM EMP
    GROUP BY DEPT_CODE
);

-- ���������� WHERE���Ӹ� �ƴ϶� SELECT/FROM/HAVING�������� ����� �����ϴ�.
SELECT DEPT_CODE �μ��ڵ�   
        , ( SELECT DEPT_TITLE                           -- DEPT_TITLE�� ��ȸ�ϱ� ���� ���������� �����
            FROM DEPT
            WHERE DEPT_ID = DEPT_CODE ) �μ���             -- ���������� ���� ���̺�(EMP)�� ���� �÷����� �������� ���
        , ROUND(AVG(SALARY)) ��ձ޿�
FROM EMP
GROUP BY DEPT_CODE
HAVING AVG(SALARY) = (
    SELECT MIN(AVG(SALARY))    
    FROM EMP
    GROUP BY DEPT_CODE
);

-- ������5) ������ ����� ���� �μ��� �μ����� ���, �����, ��ȭ��ȣ, ���޸�, �μ���, �Ի��� ��ȸ (��, ������ ������ ����)
--      ��������: ������ ����� �����ִ� �μ� ��ȸ
SELECT DEPT_TITLE
FROM DEPT
JOIN EMP ON (DEPT_ID = DEPT_CODE)
WHERE EMP_NAME = '������'
;
--      �Ǵ� (* EMP ���̺� DEPT_CODE��� Ű�� �ִ�.)
SELECT DEPT_CODE
FROM EMP
WHERE EMP_NAME = '������'
;
        -- ����Ŭ ����
SELECT EMP_ID ���, EMP_NAME �����, PHONE ��ȭ��ȣ
    , JOB_NAME ���޸�, DEPT_TITLE �μ���, HIRE_DATE �Ի���
FROM EMP, DEPT, JOB
WHERE DEPT_ID = DEPT_CODE
AND EMP.JOB_CODE = JOB.JOB_CODE
AND DEPT_TITLE = 
        (SELECT DEPT_TITLE
            FROM DEPT
            JOIN EMP ON (DEPT_ID = DEPT_CODE)
            WHERE EMP_NAME = '������'
        )
AND EMP_NAME ^= '������'
;
        -- ANSI ����
SELECT EMP_ID ���, EMP_NAME �����, PHONE ��ȭ��ȣ
    , JOB_NAME ���޸�, DEPT_TITLE �μ���, HIRE_DATE �Ի���
FROM EMP
JOIN DEPT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE DEPT_CODE = 
        (SELECT DEPT_CODE
            FROM EMP
            WHERE EMP_NAME = '������'
        )
AND EMP_NAME ^= '������'
;

/*
    <������ ��������> =====================================================
    ���������� ��ȸ ��� ���� �������� ��
    
    IN / NOT IN (��������)
    �������� ������� �ϳ��� ��ġ�ϸ� TRUE�� ����
    -> WHERE������ ������ ������ ��� TRUE (������տ� ����)
    
    ANY 
    �������� ���� �� �� ���� �����ϸ� TRUE
        ANY (��, ��, �� ..) -> ������ OR�� ���δ�.
    
    * IN�� �ٸ��� : �񱳿����ڸ� �Բ� ����� �� �ִ�.
        E.G) SALARY = ANY(...) IN�� ���� ���
             SALARY != ANY(...) NOT IN�� ���� ���
             SALARY > ANY (10000000, 2000000, 3000000) �ּҰ� ���� ũ�� TRUE
             SALARY < ANY (10000000, 2000000, 3000000) �ִ밪 ���� ������ TRUE
             
    ALL 
    �������� ���� ��ο� ���Ͽ� �����ؾ� TRUE
        ALL (��, ��, �� ..) -> ������ AND�� ���δ�.
        
        E.G) SALARY > ANY (10000000, 2000000, 3000000) �ּҰ� ���� ũ�� TRUE
             SALARY < ANY (10000000, 2000000, 3000000) �ִ밪 ���� ������ TRUE
*/

-- ������1) �� �μ��� �ְ� �޿��� �޴� ������ �̸�, �����ڵ�, �μ��ڵ�, �޿� ��ȸ
--      ��������: �켱 �� �μ��� �ְ� �޿� ��ȸ
SELECT DEPT_CODE, MAX(SALARY)
FROM EMP
GROUP BY DEPT_CODE
;

--      ���� ��ȸ�� �޿��� �޴� ����� ��ȸ
SELECT EMP_NAME �̸�, JOB_CODE �����ڵ�, NVL(DEPT_CODE,' ') �μ��ڵ�, SALARY �޿�
        ,( SELECT JOB_NAME
            FROM JOB
            WHERE EMP.JOB_CODE = JOB.JOB_CODE
        ) ���޸�
        ,NVL((SELECT DEPT_TITLE
            FROM DEPT
            WHERE DEPT_CODE = DEPT_ID
        ), '*�μ� ����*') �μ���
-- ��ȸ�� �÷��� �پ��ϱ� ������ ���������� GROUP���� �����ʴ´�.
FROM EMP
WHERE SALARY IN (
    SELECT MAX(SALARY)      -- �������� WHERE���� SALARY�� ã�� ������ �������� SELECT������ SALARY�� �����
    FROM EMP
    GROUP BY DEPT_CODE
);

-- ������2-1) �� ������ ���, �̸�, �μ��ڵ�, ����(�Ŵ���/���)�� ��ȸ 
--      ��������: *�Ŵ����� ����� ����� ��ȸ (*�ߺ� ����) 
--          �ϴ� �Ŵ��� �÷��� ���� �ߺ����� �ʰ� ��� ��ȸ
SELECT DISTINCT MANAGER_ID
FROM EMP
;
--          �Ŵ��� �÷� �� �� ���� ����� �ִ� ���� �߸��� 
SELECT DISTINCT MANAGER_ID
FROM EMP
WHERE MANAGER_ID IS NOT NULL
ORDER BY MANAGER_ID
;

--      1. �Ŵ����� �ش��ϴ� ����� ���, �����, �μ��ڵ�, ����(�Ŵ���) ��ȸ
--          UNION
--      2. ����� �ش��ϴ� ����� ���, �����, �μ��ڵ�, ����(���) ��ȸ
SELECT EMP_ID ���, EMP_NAME �����, NVL(DEPT_CODE, '**�μ�����**') �μ��ڵ�, '�Ŵ���' ����
FROM EMP
WHERE EMP_ID IN (
        SELECT DISTINCT MANAGER_ID
        FROM EMP
        WHERE MANAGER_ID IS NOT NULL
    )
    UNION
SELECT EMP_ID ���, EMP_NAME �����, NVL(DEPT_CODE, '**�μ�����**') �μ��ڵ�, '���' ����
FROM EMP
WHERE EMP_ID NOT IN (
        SELECT DISTINCT MANAGER_ID
        FROM EMP
        WHERE MANAGER_ID IS NOT NULL
    )
ORDER BY ����
;

-- ������2-2) SELECT ���� ���� ������ �̿��ϴ� ���
--      �Ŵ��� ����� 200���� ����� ��� ��ȸ -> 200�� �Ŵ������� �����Ǵ� ����� �������
SELECT EMP_ID
FROM EMP
WHERE MANAGER_ID = 200;
--      �Ŵ��� ���� ������ �����ϴ� ��� ���� �����Ͽ� ǥ����, �ƴϸ� 0
SELECT (SELECT COUNT(*) FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID) FROM EMP;
--      �Ŵ��� ���� ������ �ش� ����� �ߺ� �����ϰ� ǥ����
SELECT (SELECT DISTINCT MANAGER_ID FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID) FROM EMP;

SELECT EMP_ID ���
        -- MANAGER_ID�� ��ϵ� EMP_ID ���� ��ȸ
        , ( SELECT COUNT(*) FROM EMP ���� WHERE ����.MANAGER_ID = ����.EMP_ID ) ��ȸ
        -- ������������ ���� �÷����� �տ� ���̺��� ������� ������ �⺻������ �������� FROM�� ���̺��� ��ȸ�ؿ´�.
        -- �������� ���̺��� �����Ϸ��� �������� FROM�� ���̺�� ����ؾ��Ѵ�.
        -- ���� �����ؿ��� ����/�������� ���̺��� ���� �ٲ㾲�� ������ ���� ������ �ʴ´�. -> ����
FROM EMP ����;

SELECT EMP_ID ���, EMP_NAME �����
--      CASE ���� Ȱ���Ͽ� ���� ��� ���� 0���� ũ�� �Ŵ���, �ƴϸ� ������� ���
        , CASE WHEN (SELECT COUNT(*) FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID) > 0 
            THEN '�Ŵ���' ELSE '���' END ����1
--      DECODE �Լ� Ȱ���Ͽ� �ߺ��� ������ �Ŵ��� ����� NULL�̸� ���, �ƴϸ� �Ŵ����� ���            
        , DECODE((SELECT DISTINCT MANAGER_ID FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID )
            ,'', '���', '�Ŵ���') ����2
        , NVL(DEPT_CODE, '**�μ�����**') �μ��ڵ�
FROM EMP
--ORDER BY ����              -- �������� ���� ��Ī�� ��ȸ ���� �������� ����� �� ��� �翬�� ������ ����.. 
;

-- ������3) �븮 �����ӿ��� ���� ������ �ּ� �޿����� ���� �޴� ������ ���, �̸�, ���޸�, �޿��� ��ȸ
--      ��������: ���� ������ �޿� ����
SELECT MIN(SALARY)
FROM EMP
WHERE JOB_CODE = 'J5'
;
--      ANSI ����
SELECT EMP_ID ���, EMP_NAME �̸�, JOB_NAME ���޸�, SALARY �޿�
FROM EMP
JOIN JOB USING (JOB_CODE)
WHERE JOB_CODE = 'J6' 
AND SALARY > ANY( SELECT MIN(SALARY)
                    FROM EMP
                    WHERE JOB_CODE = 'J5')
;
--      ����Ŭ ����
SELECT EMP_ID ���, EMP_NAME �̸�, JOB_NAME ���޸�, SALARY �޿�
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND EMP.JOB_CODE = 'J6'   
AND SALARY > ANY (SELECT MIN(SALARY)
                    FROM EMP
                    WHERE JOB_CODE = 'J5')
;

-- ������4) ���� �����ӿ��� ���� ������ �ִ�޿����� �� ���� �޴� ������ ���, �̸�, ���޸�, �޿��� ��ȸ
--      ��������: ���� ���޵��� �ִ�޿��� ��ȸ
SELECT MAX(SALARY)
FROM EMP
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '����'
;

SELECT EMP_ID ���, EMP_NAME �̸�, JOB_NAME ���޸�, SALARY �޿�
FROM EMP E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND J.JOB_NAME = '����'
AND SALARY > ANY (
            SELECT MAX(SALARY)
            FROM EMP
            JOIN JOB USING (JOB_CODE)
            WHERE JOB_NAME = '����')
;


/*
    <���߿� ���� ����> =====================================================
    ��ȸ ��� ���� �� �������� ������ �÷� ���� ���� ���� ��
*/
-- ���߿�1) ������ ����� ���� �μ� �ڵ�, ���� ���� �ڵ忡 �ش��ϴ� ����� ��ȸ
--      ��������: ������ ����� �μ� �ڵ�, ���� �ڵ� ��ȸ
SELECT DEPT_CODE �μ��ڵ�, JOB_CODE �����ڵ�
FROM EMP
WHERE EMP_NAME = '������'
;

SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE DEPT_CODE = (
            SELECT DEPT_CODE �μ��ڵ�
            FROM EMP
            WHERE EMP_NAME = '������')
AND JOB_CODE = (
            SELECT JOB_CODE �����ڵ�
            FROM EMP
            WHERE EMP_NAME = '������'
            )
;
-- ���߿� �������� (�÷�1, �÷�2, ...)�� ����ؼ� �ϳ��� ������ �ۼ��ϱ�
-- �÷��� ������ŭ ���� ������  => �������� �� WHERE���� ���� �÷��� ������ Ÿ���� �����ϰ� ����

--      �÷����� �ٷ� �������� ���
SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE (DEPT_CODE, JOB_CODE) = (('D5', 'J5'))        
;
--          ��ȸ�Ǵ� ������� ���� ������ �� ��ȣ(=) ��� (* �׷��� �̰� ���߿�/�������̶�� �����ص�����...?)

--      ��������1�� �������� ���
SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE (DEPT_CODE, JOB_CODE) IN (                    -- ��ȸ�Ǵ� ������� �� ������ �������϶��� IN ���
                            SELECT DEPT_CODE, JOB_CODE      
                            FROM EMP
                            WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5')
;
--      ��������2�� �������� ���
SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE (DEPT_CODE, JOB_CODE) IN (            
                            SELECT DEPT_CODE, JOB_CODE  
                            FROM EMP
                            WHERE EMP_NAME = '������')
;

-- ���߿�2) �ڳ��� ����� ���� �ڵ尡 ��ġ�ϸ鼭 ���� ����� ������ �ִ� ����� ���, �̸�, �����ڵ�, ������, ��ȸ
--      ��������: �ڻ���� �����ڵ�� �������� ��ȸ
SELECT JOB_CODE �����ڵ�, MANAGER_ID ������
FROM EMP
WHERE EMP_NAME = '�ڳ���'
;


SELECT EMP_ID ���, EMP_NAME �̸�, JOB_CODE �����ڵ�, MANAGER_ID ������
FROM EMP
WHERE (JOB_CODE, MANAGER_ID) IN (
                            SELECT JOB_CODE, MANAGER_ID
                            FROM EMP
                            WHERE EMP_NAME = '�ڳ���') 
    AND EMP_NAME != '�ڳ���'               -- �������� �ڳ��� ������ ������ �� �ֵ��� �������� �߰��ߴ�.
;

/*
    <������ ���߿� ���� ����> =====================================================
    ���������� ��ȸ ������� ������, �������� ���
*/
-- ������ ���߿�1) �� ���޺��� �ּ� �޿��� �޴� ������� ���, �̸�, �����ڵ�, �޿� ��ȸ
--      ��������: �� ���޺� �ּ� �޿� ��ȸ
SELECT JOB_CODE �����ڵ�, MIN(SALARY) �ּұ޿�
FROM EMP
GROUP BY JOB_CODE
ORDER BY JOB_CODE
;
SELECT EMP_ID ���, EMP_NAME �̸�
--          DECODE �Լ��� Ȱ���ؼ� �����ڵ忡 ���� ���޸��� ǥ��
        , DECODE(JOB_CODE, 'J1', '��ǥ', 'J2', '�λ���', 'J3', '����'
                        , 'J3', '����', 'J5', '����', 'J6', '��ǥ', '���') �����ڵ�
        , JOB_CODE �����ڵ�, SALARY �޿�         
FROM EMP
WHERE (JOB_CODE, SALARY) IN ( SELECT JOB_CODE , MIN(SALARY) 
                                FROM EMP
                                GROUP BY JOB_CODE )
ORDER BY JOB_CODE
;

-- ������ ���߿�2) �� �μ��� �ּұ޿��� �޴� ������� ���, �̸�, �μ���, �޿� ��ȸ (* �μ��� ���� ����� �μ��������� ��ȸ)
--          ��������: �� �μ��� �ּ� �޿� ��ȸ
--              ����� ���⼭�� �� 7���� ��ȸ������
SELECT NVL(DEPT_CODE, '**�μ�����**'), MIN(SALARY)     
FROM EMP
GROUP BY DEPT_CODE
;
--              ���⼭�� 6���� ��ȸ�� : ���� NULL�̸� ������տ��� ���ܵǾ� ����
--                  ���̺��� JOIN�ؼ� �ٸ� ���̺��� �����͸� �����. 
SELECT EMP_ID ���, EMP_NAME �̸�, SALARY �޿�, NVL(DEPT_TITLE, '**�μ�����**') �μ���
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID(+)
--      NVL�Լ��� NULL�� ġȯ���� ��� ����/���� ���� �÷��� ������ �����ϰ� ���������
AND (NVL(DEPT_CODE, '**�μ�����**'), SALARY) IN ( SELECT NVL(DEPT_CODE, '**�μ�����**'), MIN(SALARY)
                                                FROM EMP
                                                GROUP BY DEPT_CODE )
;
--                  ���̺��� JOIN���� �ʰ� ���������� �̿��ؼ� �ٸ� ���̺��� �����͸� �����. 
SELECT EMP_ID ���, EMP_NAME �̸�,  SALARY �޿� , NVL((SELECT DEPT_TITLE FROM DEPT WHERE DEPT_CODE = DEPT_ID),'**�μ�����**') �μ���
FROM EMP
WHERE (NVL(DEPT_CODE, '**�μ�����**'), SALARY) IN ( SELECT NVL(DEPT_CODE, '**�μ�����**'), MIN(SALARY)      
                                                    FROM EMP
                                                    GROUP BY DEPT_CODE )
;

/*
    <�ζ��� ��>
    FROM ���� ���������� �����ϰ�, ���������� ������ ����� ���̺� ��� ����Ѵ�.
    1) �ζ��� �並 Ȱ���� TOP-N �м�
*/

-- �� ���� �� �޿��� ���� ���� ��� 5�� ����, �̸�, �޿� ��ȸ
-- FROM -> SELECET(������ ��������) -> ORDER BY (������� ������ ����)
SELECT ROWNUM, E.*
FROM (
        SELECT ROWNUM RN, EMP_NAME, SALARY  -- �׷��� ROWNUM�� RN�̶�� ��Ī�� �ٿ��־���
        FROM EMP
        ORDER BY SALARY DESC
    ) E
--WHERE ROWNUM > 5 AND ROWNUM < 10         -- ROWNUM�� ù��°�� ������ 1�ε� ������ 5���� ũ�ٰ��ϸ� ROWNUM�� �ƿ� ���� �� ���� 
WHERE ROWNUM <= 5
;

-- �μ��� ��ձ޿��� ���� 3�� �μ��� �μ��ڵ�, ��ձ޿� ��ȸ
SELECT ROWNUM RN, SUB.*
FROM (
        SELECT DEPT_CODE, ROUND(AVG(SALARY)) ��ձ޿�
        FROM EMP
        GROUP BY DEPT_CODE
        ORDER BY ��ձ޿� DESC
    ) SUB
WHERE RN <= 3                                    -- TODO RN ��Ī�� �����Ǭ��..?????????????????? -> ���� ���� ������ ���� ���� ���� ��Ī�� �� �� ����
;

SELECT DEPT_CODE, ROUND(AVG(SALARY)) ��ձ޿�
        FROM EMP
        GROUP BY DEPT_CODE
        ORDER BY ��ձ޿� DESC;

-- 2) WITH�� �̿��� ���
    -- ���� ���������� ������ ���� ��� �ߺ� �ۼ��� ���ϱ� ���� �����
WITH TOPN_SAL AS (
    SELECT DEPT_CODE �μ��ڵ�, TRUNC(AVG(SALARY)) ��ձ޿�
    FROM EMP
    GROUP BY DEPT_CODE
    ORDER BY 2 DESC
)

SELECT ROWNUM, �μ��ڵ�, ��ձ޿�
FROM TOPN_SAL
WHERE ROWNUM <= 3
;

/*
    <RANK �Լ�>
    ǥ����
        RANK() OVER(���� ����) / DENSE_RANK() OVER(���� ����) 
        - ������ ���� ��� ������ ������ �ο�
        - ������ ���� ���� ������ ������ŭ �ǳ� �ٰ� ������ �ο�
        - ���� ������ �� ���� �����ؼ� ������ ������ ���� �ִ�. 
*/
SELECT RANK() OVER (ORDER BY SALARY DESC) AS RN, EMP_NAME, SALARY   -- RN�� 19,19,21�� ��� : 2����ŭ �ǳʶٱ� (19+2=21)
FROM EMP    
;
SELECT DENSE_RANK() OVER (ORDER BY SALARY DESC, EMP_NAME) AS RN, EMP_NAME, SALARY     -- RN�� 19,19,20�� ���
FROM EMP                                            -- -> DENSE_RANK() : ������ ���� ������ ����� ������ 1�� ����
;

SELECT RANK() OVER (ORDER BY SALARY DESC) AS RN
        , DENSE_RANK() OVER (ORDER BY SALARY DESC) AS DRN
        , EMP_NAME, SALARY
FROM EMP
-- RANK�Լ��� WHERE���� �� �� ���� ������ ���� ������ �ʿ��� ��� ���������� ��´�.
-- WHERE RANK() OVER (ORDER BY SALARY DESC) <= 3;
;

SELECT *
FROM ( SELECT RANK() OVER (ORDER BY SALARY DESC) AS RN
                , DENSE_RANK() OVER (ORDER BY SALARY DESC) AS DRN
                , EMP_NAME, SALARY
        FROM EMP )
WHERE RN <= 3
;

/*
    ��� ����
    ���������� �÷� �� �ϳ��� ���� ���������� ���ǿ� �̿�
    IN, NOT IN, EXISTS, NOT EXISTS
    
    ���� ���� : ���������� ��� �����Ͽ� �����͸� ����  IN, EXISTS
    ��Ƽ ���� : ���������� ��� �����Ͽ� �����͸� ����  NOT IN, NOT EXISTS
*/

SELECT *
FROM DEPT
WHERE NOT EXISTS (
                SELECT * 
                FROM EMP
                WHERE DEPT.DEPT_ID = EMP.DEPT_CODE      --> �� ���Ǹ� ������ ��µȴ�
)            
;   --> ����� ���� ���� ���� �μ� 3��


SELECT *
FROM EMP
WHERE NOT EXISTS (
                SELECT 1       --> ��� �� ���������� SELECT�������� �� ��ȸ�ϵ� �������
                FROM DEPT
                WHERE DEPT.DEPT_ID = EMP.DEPT_CODE      --> �� ���Ǹ� ������ ��µȴ�
)            
;   --> �μ��� ���� ���� ���� ��� 2��

SELECT *
FROM EMP
WHERE EMP.DEPT_CODE NOT IN (
                SELECT DEPT.DEPT_ID 
                FROM DEPT
                WHERE DEPT.DEPT_ID = EMP.DEPT_CODE     
)            
;  

SELECT *
FROM EMP
WHERE DEPT_CODE IN (
                SELECT DEPT_ID 
                FROM DEPT
)            
;  












