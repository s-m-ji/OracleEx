/*  
    ������ ����
        �����ڵ�� �����ڵ带 �̿��ؼ� TREE ���·� ��ȸ
        E.G) ȸ�� ������, �޴� ���
        
        MANAGER_ID : �Ŵ��� ���
        ROOT NODE : �ֻ��� ���
        
        0. LEVEL
            ���� ���� ������ ���� ��� DEPTH�� ǥ���ϴ� �ǻ��÷� (ROOT=1)
                (�ǻ��÷�: ���̺��� �÷��� �ƴ����� �÷�ó�� ����)       
        1. ������ ������ ����
            ORDER SIBLINGS BY �÷��� (������ ������ ������ �ʰ� ����)
        2. �ֻ��� ��� ��ȯ
            CONNECT_BY_ROOT �÷���
        3. ������ ����̸� 1, �ƴϸ� 0
            CONNECT_BY_ISLEAF
        4. ������ �������� ��Ʈ���� ������ �ڽ��� ����� ����� ��θ� ��ȯ
            SYS_CONNECT_BY_PATH(�÷���, '������')
*/

SELECT EMP_ID, MANAGER_ID, EMP_NAME, LEVEL
        , LPAD(' ', (LEVEL-1)*3) || EMP_NAME AS "��������"       -- ROOT�� ������ ������������ 3ĭ�� �鿩����
        , CONNECT_BY_ROOT EMP_NAME AS "ROOTNAME"                -- 1DEPTH�� �������� ROOT�� �̸��� ǥ��
        , CONNECT_BY_ISLEAF AS "ISLEAF"                         -- ���������� 1, �ƴϸ� 0
        , SYS_CONNECT_BY_PATH(EMP_NAME, '>') AS "INFO"          -- ������ �������� ��Ʈ���~�ڽű��� ����� ���·� ��ȯ
FROM EMP
-- ��Ʈ ����� ���� �Ǵ� �� (������ ���� �����Ѵ� !)                  
START WITH MANAGER_ID IS NULL
-- CONNECT BY PRIOR (���� �����)EMP_ID = (���� �����)MANAGER_ID     -- ���� ���� EMP_ID�� MANAGER_ID�� ���� �ֵ��� ������ ��´�.
-- ���� ���踦 ��� 
CONNECT BY PRIOR EMP_ID = MANAGER_ID
--ORDER BY EMP_NAME                                             -- �̷��� �Ϲ����� ORDER BY�� �� ��� ���� �͸������
ORDER SIBLINGS BY EMP_NAME                                      -- �� �������� ���� ��������.
;

-- 
SELECT JOB_NAME
        , LPAD(' ', (LEVEL-1)*5) || JOB_NAME ��������
        , LPAD(' ', (LEVEL-1)*2.5) || DEPT_TITLE ��������2
        , SYS_CONNECT_BY_PATH(EMP_NAME, '> ')
FROM EMP, JOB, DEPT
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND DEPT_CODE = DEPT_ID
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMP_ID = MANAGER_ID
;









