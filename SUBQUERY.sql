/*
    <SUBQUERY>
    �ϳ��� SQL�� �ȿ� ���Ե� �� �ٸ� SQL���� ���Ѵ�.
    ���� ����(���� ����)�� �����ϴ� ������ �ϴ� ������
*/

-- ���ö ����� ���� �μ������� ��ȸ
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE EMP_NAME = '���ö'
;

-- ���������� () ��ȣ�� ����
-- �񱳰��� ��� Ÿ���� ��ġ�ؾ��Ѵ�

-- ���������� ������ ��� ���� ��� �� ������ ���� ���������� �з���

-- 1) ������ �������� : �������� ��ȸ ��� ���� ��� �� ������ 1��
--      �񱳿����� ��� ���� (=, !=, <>, ^=, <, >, <=, >=)
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMP
                    WHERE EMP_NAME = '���ö'
    );

-- 1) �� ������ ��� �޿����� �޿��� ���� �޴� ������, �����ڵ�, �޿��� ��ȸ
-- �� ������ ��� �޿�
SELECT ROUND(AVG(SALARY))
FROM EMP
;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMP
WHERE SALARY < (
                SELECT ROUND(AVG(SALARY))
                FROM EMP
        );

-- 2) ���� �޿��� �޴� ������ ���, �̸�, ���� �ڵ�, �޿�, �Ի��� ��ȸ
-- ���� �޿� ��ȸ
SELECT MIN(SALARY)
FROM EMP;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMP
WHERE SALARY = (
        SELECT MIN(SALARY)
        FROM EMP
    );

/*
    [���� ���� ����]
    5. SELECT       ��ȸ�� �÷�
    1. FROM         ���̺�
    2. WHERE        ���ǽ�
    3. GROUP BY     �׷� ����
    4. HAVING       �׷� ���ǽ�
    6. ORDER BY     ���� ����
*/




















