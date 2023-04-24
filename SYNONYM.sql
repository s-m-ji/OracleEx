/*
    <SYNONYM>
    �����ͺ��̽� ��ü�� ���� ��Ī, ���Ǿ�
    CREATE OR REPLACE [PUBLIC] SYNONYM
    - PUBLIC ������� ������ �⺻�� PRIVATE���� ������
*/
-- �ó�� ����
CREATE OR REPLACE SYNONYM REGIONS FOR HR.REGIONS;
CREATE OR REPLACE PUBLIC SYNONYM P_REGIONS FOR HR.REGIONS;
-- => PUBLIC ������ ���� �ο����� �ʾƵ� JUNGANG(�Ϲݻ����)���������� ��ȸ�� �ȴ�.?

-- �ó�� ��ȸ
SELECT * FROM REGIONS;

-- �ó�� ����
DROP PUBLIC SYNONYM P_REGIONS;

-- ���� �ο�
GRANT SELECT ON REGIONS TO JUNGANG;
GRANT SELECT ON P_REGIONS TO PUBLIC;

-- ���� ȸ��
REVOKE SELECT ON REGIONS FROM JUNGANG;
REVOKE SELECT ON P_REGIONS FROM PUBLIC;

-- ����ڰ� ���� ������ Ȯ��
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'JUNGANG';

-- HR������ ���̺��� ���� ������ Ȯ��
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'HR';

-- ����ڰ� ���� ������ Ȯ��
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'JUNGANG';


/*
    JUNGANG ���� ��ũ��Ʈ���� ��ȸ�غô� ���� ���

    SELECT * FROM REGIONS;
    SELECT * FROM P_REGIONS;
    
    SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'JUNGANG';
    SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'JUNGANG';
    SELECT * FROM DBA_TAB_PRIVS WHERE GRANTEE = 'HR';

*/









