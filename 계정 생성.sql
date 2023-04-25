-- ����� ���� ����
create user jungang identified by 1234;

-- ����� ���� ����
-- ����� ������ ������Ʈ�� �����Ǿ� ������ ������Ʈ�� �Բ� ������ �� �ֵ���
DROP USER JUNGANG CASCADE;

--  create session ���� ������Ͽ� ���� �Ұ� 
-- (������ �����Ѵٰ� �ؼ� ������ �ٷ� �־����� ���� �ƴ�)
conn jungang/1234;

-- ����ڰ� ���� ���� Ȯ��
select * from dba_sys_privs where grantee = 'JUNGANG'; -- �빮�ڷ� �ۼ��ؾ���

-- ����� ������ ���� �ο�
grant create session to jungang;
-- ������ ������ ������ ���̺� ���� ��� �ٸ� �۾��� �� �� ����

-- ��(ROLE) : �ϳ� �̻��� �������� �̷���� ����ü
--      ����Ŭ���� �̸� �����ص� �͵� ������ ����ڰ� ���� ������ ���� ����
--      connect : ���� ����, resource : ������Ʈ ���� ���� 
grant connect, resource, create view to jungang;
-- ���� �ο� �� �������� - �������ؾ� �ش� �������� ���̺��� ������ �� �ִ�.

-- ����Ŭ���� �̸� �����ص� ROLE
select * from dba_roles;

-- ROLE ��ϵ� ������ Ȯ��
select grantee, privilege 
from dba_sys_privs 
where grantee = 'CONNECT' or grantee = 'RESOURCE';  -- �빮�ڷ� �ۼ��ؾ��� (�ҹ��ڷ� �ۼ��ϸ� �÷� ���� ������ �ʴ´�)

-- ����ڰ� ���� ���� Ȯ��
select * from dba_sys_privs where grantee = 'JUNGANG';

-- ����ڰ� ���� �� Ȯ��
select * from dba_role_privs where grantee = 'JUNGANG';    

-- DBA ��� �ý��� ������ �ο��� ��
grant dba to JUNGANG;

/*
    <������ ��ųʸ�>
    �ڿ��� ȿ�������� �����ϱ� ���� �پ��� ��ü���� ������ �����ϴ� �ý��� ���̺�
    ����ڰ� ��ü�� �����ϰų� ��ü�� �����ϴ� ���� �۾��� �� ��
    �����ͺ��̽��� ���ؼ� �ڵ����� ���ŵǴ� ���̺�
    �����Ϳ� ���� �����Ͱ� ����Ǿ� �ִٰ� �ؼ� ��Ÿ �����Ͷ�� ��
    
    DBA_XXX : �����ڸ� ���� ������ ��ü�� ���� ���� ��ȸ          
    USER_XXX : ������ ������ ��ü�� ���� ���� ��ȸ                 
    ALL_XXX : ���� ���� �Ǵ� ������ �ο����� ��ü�� ���� ���� ��ȸ    
    
    - dba_sys_privs : ���� ����ڰ� �ѿ� �ο��� �ý��� ����(privilege) ����
    - dba_role_privs : ����� �� �ѿ� �Ҵ�� �� Ȯ��
    - user_constraints : ���������� Ȯ��
*/

-- ���� ȸ��
revoke connect, resource from JUNGANG;
revoke dba from JUNGANG;

grant connect, resource to JUNGANG;
grant dba to JUNGANG;
---------------------------------------------------------------------------------------------------
SELECT * FROM book; 

-- �ڵ� Ŀ�� ����
-- 1. ���� ���¸� Ȯ��
-- ������ �ڵ� Ŀ���� �������� �ʴ´ٰ� �Ͻʴϴٿ��..
SHOW AUTOCOMMIT;

-- 2. �ڵ�Ŀ�� ����
SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;






