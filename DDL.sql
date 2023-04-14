/*
    < DDL(DATA DEFINITION LANGUAGE) >
    - ������ ���Ǿ�
    - ����Ŭ���� �����ϴ� ��ü�� ����/����/�����ϴ� ������ ���� ��ü�� �����Ѵ�.
    - �ַ� DB ������, �����ڰ� ����Ѵ� (*������ �ۼ����ָ� �����ڰ� ������ �ۼ��ϰ� ����)
       
   [alter]
    - ����Ŭ���� �����ϴ� ��ü�� �����ϴ� ����
    
    ���̺� ����
    alter table ���̺�� ������ ����;
    
    * ������ ����
        1) �÷��߰�/����/����
        2) �������� �߰�/����   
        *���������� ���� �Ұ���(���� �� ���߰�) *�ٸ� not null�� ������ ������.  *�̸��� ���� ������ �˾Ƽ� ������.. 
        3) ���̺��/�÷���/�������Ǹ� ����
*/

-- ���̺� �����Ͽ� �����ϱ� 
create table dept_copy
as select * from dept;
--as select DEPARTMENT_ID from dept;                -- ���� ���ϴ� �÷��� ���� ����
--as select * from dept where DEPARTMENT_ID=70;     -- ���� ���ϴ� ���� �������θ� ���� ���� 
--as select DEPARTMENT_ID dept_id from dept;        -- ���� ���ϴ� ��Ī���� ���� ���� 
--as select * from dept where 0>1;                  -- ������ true�� �ƴ� ���� ������ ���� �Ұ�

-- ���̺� �����ϱ� 
drop table dept_copy;

-- ���̺� ��ȸ�ϱ�
select * from dept_copy;

/*
    1) �÷� �߰�/����/����
        �߰�: alter table ���̺�� add �÷��� ������Ÿ�� [default �⺻��]; 
        --> �߰� �� ���̺� '��'�ǿ� ���� �������� �߰� �ȴ�. 
        - �⺻�� �Է����� ������ null�� ä���� / �Է� �� ��� ���� ���� ������ �ʱ�ȭ.
*/
    alter table dept_copy add cname varchar2(20); 
    alter table dept_copy add dname varchar2(20) default '�����';

/*
    2) �÷� ����(modify)
        - ������ Ÿ�� ����
            alter table ���̺�� modify �÷��� ������ ������ Ÿ��;
        - �⺻�� ����
            alter tlable ���̺�� modify �÷��� default ������ ��;        
*/

    alter table dept_copy modify DEPARTMENT_NAME varchar2(100);
    alter table dept_copy modify dname varchar2(1);
    -- �����Ϸ��� �ڷ����� ũ�⺸�� ū ���� ������ ��� ���� �߻� : �Ϻ� ���� �ʹ� Ŀ�� �� ���̸� ���� �� ����

    alter table dept_copy modify cname number;
    -- ��ϵ� ���� �ϳ��� ���� ����� ������ Ÿ�� ���� ����

    -- ���� ������ ������
    alter table dept_copy modify DEPARTMENT_NAME varchar2(50)
                        modify dname default '������';

select * from dept_copy;

/*
    3) �÷� ����(drop column)
        alter table ���̺�� drop column �÷���;
        - ������ ���� ��ϵǾ��־ ����
        - ������ �÷��� ���� �Ұ��� (*DDL ������ �ѹ����� ���� �Ұ�)
        - ���̺��� �ּ� 1�� �̻� �÷��� �����ؾ��ϸ�
        - �����ϰ� �ִ� �÷��� �ִٸ� ���� �Ұ���
*/

    alter table dept_copy drop column DEPARTMENT_NAME; 
    alter table dept_copy drop column PARENT_ID;
    alter table dept_copy drop column MANAGER_ID;
    alter table dept_copy drop column CREATE_DATE;
    alter table dept_copy drop column UPDATE_DATE ;
    alter table dept_copy drop column CNAME ;
    alter table dept_copy drop column DNAME ;

    insert into dept_copy values (default);

    alter table dept rename column DEPARTMENT_ID to dept_id; 
    alter table dept rename column DEPARTMENT_NAME to dept_name;
    alter table emp rename column EMPLOYEE_ID to emp_id;
    alter table emp rename column DEPARTMENT_ID to dept_id;
    alter table JOB_HISTORY rename column EMPLOYEE_ID to emp_id;
    alter table job_history rename column DEPARTMENT_ID to dept_id;
    
    alter table sales rename column employee_id to emp_id;
    
    /*
    2) �������� �߰�/����
        2-1) �������� �߰�
        primary key : (unique + notnull) �ĺ�Ű
            alter table�� add [constraint �������Ǹ�] primary key(�÷���);
        unique :
            alter table�� add [constraint �������Ǹ�] unique(�÷���);
        check :
            alter table�� add [constraint �������Ǹ�] check(�÷��� ���� ����);
        not null :
            alter table�� modify �÷��� [constraint �������Ǹ�] not null;
    */

-- dept_copy ���̺� �ٽ� �����
-- dept_id pk
-- dept_name unique
-- update_date not null

drop table dept_copy;

create table dept_copy(
    dept_id varchar2(10)
    , create_date number , dept_name number

    );

-- TODO
alter table dept_copy
    add CONSTRAINT dept_copy_dept_id_pk PRIMARY KEY (dept_id)       --> dept_copy_dept_id_pk �̰� �׳� �������Ǹ� : ���״�� ���� !
    add CONSTRAINT dept_copy_dept_name_uq unique (dept_name)
    modify create_date CONSTRAINT dept_copy_create_date_nn not null;

-- �ۼ��� ���� ���� Ȯ��
select uc.constraint_name, uc.constraint_type, uc.table_name, ucc.column_name
from user_constraint uc
    join user_cons_columns ucc      --> join : ���̺��� ��ĥ �� �� / �÷����� ��ĥ ��쿡�� ��Ī�� �տ� �ּ� �����ϵ����Ѵ�.
        on uc.constraint_name = ucc.constraint_name
        -- �˻��Ϸ��� ���̺��
        where ucc.table_name = 'dept_copy';                         ----->>>>> TODO ���̺� �Ǵ� �䰡 ���������ʽ��ϴ�..? ���渶�̱�
        
-- constraint_type (c:check, p:primary key, u:unique)

-- pk: null �Է��� �Ұ����ϰ� �ߺ��� ���� ����� �� ����.
insert into dept_copy (dept_id, dept_name, create_name)
    values(10,'�׽�Ʈ',sysdate);   -- ����ũ ���� ���ǿ� �ɸ� 
    
alter table dept_copy drop constraint dept_copy_dept_id_pk;

alter table dept_copy modify create_date null;

/*
    3) ���̺��/�÷���/�������Ǹ� ����
    3-1) �÷��� ����
        alter table ���̺�� rename column �����÷��� to ������ �÷���;
        
    3-2) ���������� �̸� ����
        alter table ���̺�� rename constraint �����������Ǹ� to ������ �������Ǹ�;
        
    3-3) ���̺�� ����
        1) alter table ���̺�� rename to ������ ���̺��;
        2) rename ���� ���̺�� to ������ ���̺��;
*/

-- �⺻Ű ���� ���� ���� �� �����Ͱ� �̹� �ߺ��� ��� : ������ �� �����ϴ�. - �߸��� �⺻Ű�Դϴ�. �����߻�

alter table dept_copy add CONSTRAINT dept_copy_dept_id PRIMARY KEY (dept_id);

alter table dept_copy rename column dept_name to dept_title;

alter table dept_copy rename constraint DEPT_COPY_DEPT_NAME_UQ to dept_title_nn;

-- ���̺� ������ ���� �����ϰ� ��ȸ
desc dept_copy;

select * from dept_copy;

alter table dept_copy rename to dept_test;

alter table dept_test rename to ���̺�;

rename ���̺� to dept_copy;








