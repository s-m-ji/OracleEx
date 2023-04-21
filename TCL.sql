/*
    <TCL (Transaction Control Language)>
        Ʈ������� �����ϴ� ���
        
        * Ʈ�����
        - �ϳ��� ������ �۾� ����
            ����) ATM���� ������ ���
                1. ī�� ����
                2. �޴� ����
                3. �ݾ� Ȯ�� �� ����
                4. ���¿��� �ݾ� ����   -50000
                5. ���� ����          +50000
                6. ����
        - ������ �۾����� ��� �ϳ��� �۾� ������ ����
        - �ϳ��� Ʈ��������� �̷���� �۾����� �ݵ�� �ѹ��� �Ϸᰡ �Ǿ����
        - �׷��� ������ �۾� ��~��~~
        - �������� �������(DML)�� ��� �ϳ��� Ʈ����ǿ� ��� ó���Ѵ�.
            - Ʈ����� ���� 
            - COMMIT Ʈ����� ���� ó�� �� ����
            - ROLLBACK Ʈ����� ���
            - SAVEPOINT �ӽ�����(�� ��ġ�� �̵�)
*/

-- ���, �����, �μ���
CREATE TABLE EMP_01 
  AS 
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE 
    FROM EMP 
   LEFT  JOIN DEPT ON (DEPT_CODE = DEPT_ID)
;
DROP TABLE EMP_01;

select * FROM EMP_01 ORDER BY EMP_ID;

-- 200�� ��� ����
DELETE FROM EMP_01 WHERE EMP_ID  IN (200);

-- SAVEPOINT ����
SAVEPOINT SP;

-- 201�� ��� ����
DELETE FROM EMP_01 WHERE EMP_ID  IN (201);

-- SP �������� ���ư��� : 201�� ��� ���� ��
ROLLBACK TO SP;

-- ���� ��� ������ ���� �� ���̺��� �ϳ� �����ϸ�?
-- DDL ������ �����ϴ� ���� ���� �޸� ���ۿ� �ӽ� ����� ��������� DB�� Ŀ�ԵǸ鼭
-- ������ ���� ������ �ѹ��� �ȵȴ�..
























