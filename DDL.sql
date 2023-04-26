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
        1) �÷� �߰�/����/����
        2) �������� �߰�/����   
            *���������� ���� �Ұ���(���� �� ���߰�) *�ٸ� not null�� ������ ������.  *�̸��� ���� ������ �˾Ƽ� ������.. 
        3) ���̺��/�÷���/�������Ǹ� ����
*/

-- ���̺� �����Ͽ� �����ϱ� 
create table dept_copy
as select * from dept;
--as select DEPARTMENT_ID from dept;                -- Ư�� �÷��� ���� ����
--as select * from dept where DEPARTMENT_ID=70;     -- where ���ǿ� �´� �����͸� ���� ���� 
--as select DEPARTMENT_ID dept_id from dept;        -- Ư�� �÷��� ���� ���� ��Ī���� ���� ���� 
--as select * from dept where 0>1;                  -- where ���ǿ� ���� �ʴ� ��, true�� �ƴ� ���� ������ ���� �Ұ�

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
            alter table ���̺�� modify �÷��� default ������ ��;        
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
                alter ���̺�� add [constraint �������Ǹ�] primary key(�÷���);
            unique :
                alter ���̺�� add [constraint �������Ǹ�] unique(�÷���);
            check :
                alter ���̺�� add [constraint �������Ǹ�] check(�÷��� ���� ����);
            not null :
                alter ���̺�� modify �÷��� [constraint �������Ǹ�] not null;
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

alter table dept_copy
    add CONSTRAINT dept_copy_dept_id_pk PRIMARY KEY (dept_id)       --> dept_copy_dept_id_pk �̰� �׳� �������Ǹ� : ���״�� ���� !
    add CONSTRAINT dept_copy_dept_name_uq unique (dept_name)
    modify create_date CONSTRAINT dept_copy_create_date_nn not null;

-- �ۼ��� ���� ���� Ȯ��
select uc.constraint_name, uc.constraint_type, uc.table_name, ucc.column_name
from user_constraints uc
    join user_cons_columns ucc      --> join : ���̺��� ��ĥ �� �� / �÷����� ��ĥ ��쿡�� ��Ī�� �տ� �ּ� �����ϵ����Ѵ�.
        on uc.constraint_name = ucc.constraint_name
        -- �˻��Ϸ��� ���̺��
        where ucc.table_name = 'DEPT_COPY';                         
        
-- constraint_type (c:check, p:primary key, u:unique)

-- pk: null �Է��� �Ұ����ϰ�(not null) �ߺ��� ���� ����� �� ����.(unique)
insert into dept_copy (dept_id, dept_name, create_name)
    values(10,'�׽�Ʈ',sysdate);   -- ���̺� �̹� 10�� �־ ����ũ ���� ���ǿ� �ɸ� 
    
alter table dept_copy drop constraint dept_copy_dept_id_pk;

alter table dept_copy modify create_date null;

/*
    3) ���̺��/�÷���/�������Ǹ� ����
    3-1) �÷��� ����
        alter table ���̺�� rename column ���� �÷��� to ������ �÷���;
        
    3-2) ���������� �̸� ����
        alter table ���̺�� rename constraint ���� �������Ǹ� to ������ �������Ǹ�;
        
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
---------------------------------------------------------------------------------------------------
/*
    SQL_DDL
*/

-- ���������� Ex1) �迭 ������ ������ ī�װ� ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR(10)
    ,USE_YN CHAR(1) DEFAULT 'Y' CHECK (USE_YN IN('Y','N'))
);

-- ���������� Ex2) ���� ������ ������ ���̺��� ������� �Ѵ�. ������ ���� ���̺��� �ۼ��Ͻÿ�.
CREATE TABLE TB_CLASS_TYPE (
    NO VARCHAR2(5) PRIMARY KEY
    ,NAME VARCHAR2(10)
);

-- ���������� Ex3) TB_CATEGORY ���̺��� NAME �÷��� PRIMARY KEY�� �����Ͻÿ�.
-- ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� PRIMARY KEY (�÷���)
ALTER TABLE TB_CATEGORY ADD CONSTRAINT TB_CATEGORY_NAME_PK PRIMARY KEY (NAME);

-- ���������� Ex4) TB_CLASS_TYPE ���̺��� NAME �÷��� NULL ���� ���� �ʵ��� �Ӽ��� �����Ͻÿ�.
-- ALTER TABLE ���̺�� MODIFY �÷��� ���� CONSTRAINT �������Ǹ� NOT NULL
ALTER TABLE TB_CLASS_TYPE MODIFY NAME CONSTRAINT TB_CALSS_TYPE_NAME_NN NOT NULL;

SELECT * FROM TB_CATEGORY;
SELECT * FROM TB_CLASS_TYPE;

DESC TB_CATEGORY;
DESC TB_CLASS_TYPE;

-- ���������� Ex5) �� ���̺��� �÷� ���� NO�� ���� ���� Ÿ���� �����ϸ鼭 ũ��� 10����
-- , �÷����� NAME�� ���� ���������� ���� Ÿ���� �����ϸ鼭 ũ�� 20���� 
-- �����Ͻÿ�.
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10) MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);

ROLLBACK;

-- ���������� Ex6) �� ���̺��� NO �÷��� NAME �÷��� �̸��� �� ���̺� �̸��� �տ� ���� ���·� �����Ѵ�.
-- EX. CATEGORY_NAME
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

-- ���������� Ex7) INSERT ���� �����Ѵ�.
SELECT CATEGORY
FROM TB_DEPARTMENT
GROUP BY CATEGORY;
-- �ѹ��� �ϳ��� ���� INSERT
INSERT INTO TB_CATEGORY VALUES('�ι���ȸ', 'Y');
-- �ѹ��� ������ �� INSERT => TB_DEPARTMENT���� CATEGORY ���� ���������� ��������
INSERT INTO TB_CATEGORY (SELECT CATEGORY, 'Y'
                        FROM TB_DEPARTMENT
                        GROUP BY CATEGORY)
;
COMMIT;
SELECT * FROM TB_CATEGORY;

-- ���������� Ex8) TB_DEPARTMENT�� CATEGORY �÷��� 
-- TB_CATEGORY ���̺��� CATEGORY_NAME �÷��� �θ����� �����ϵ��� FOREIGN KEY�� �����Ͻÿ�.
-- �� �� KEY �̸��� FK_���̺��̸�_�÷��̸����� �����Ѵ�
-- ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� PRIMARY KEY (�÷���) REFERENCES ������ ���̺�� (�÷���)
ALTER TABLE TB_DEPARTMENT 
    ADD CONSTRAINT FK_TB_DEPARTMENT_CATEGORY 
        FOREIGN KEY (CATEGORY)
            REFERENCES TB_CATEGORY (CATEGORY_NAME); 
            
-- ���������� Ex9) �л����� �������� ���ԵǾ� �ִ� �л��Ϲ����� VIEW�� ������� �Ѵ�.
-- ���� ������ �����Ͽ� ������ SQL���� �ۼ��Ͻÿ�. (�й�, �л��̸�, �ּ�)
-- CREATE [OR REPLACE] VIEW ��٣ AS ��������;
-- alter table ���̺�� modify �÷��� ������ ������ Ÿ��;
CREATE OR REPLACE VIEW VW_�л��Ϲ����� (�й�, �л��̸�, �ּ�)
AS ( SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT 
);
SELECT * FROM VW_�л��Ϲ�����;
-- ALTER VIEW VW_�л��Ϲ����� ADD COLUMN STUDENT_AGE NUMBER;   -- TODO �÷� �߰��ؼ� ����/���� �Է��ϱ�

-- ���������� Ex10) 1�⿡ �� ���� �а����� ���������� ���� ����� �����Ѵ�.
-- �̸� ���� ����� �л��̸�, �а��̸�, ��米���̸����� �����Ǿ� �ִ� VIEW�� ����ÿ�.
-- �̶� ���� ���簡 ���� �л��� ���� �� ������ ����Ͻÿ�.
-- (�а����� ���ĵǾ� ȭ�鿡 �������� ����ÿ�.)
CREATE VIEW VW_�������(�л��̸�, �а��̸�, ���������̸�)
AS
    SELECT STUDENT_NAME, DEPARTMENT_NAME, NVL(PROFESSOR_NAME,'������������')
    FROM TB_STUDENT S, TB_DEPARTMENT D, TB_PROFESSOR P
    WHERE  S.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND P.PROFESSOR_NO = S.COACH_PROFESSOR_NO(+)
    ORDER BY DEPARTMENT_NAME
;

SELECT * FROM VW_�������;

-- ���������� Ex11) ��� �а��� �а��� �л� ���� Ȯ���� �� �ֵ��� ������ VIEW�� �ۼ��غ���.
CREATE VIEW VW_�а����л���(�а��̸�, �л���)
AS 
    SELECT DEPARTMENT_NAME, COUNT(*) CNT
    FROM TB_STUDENT S, TB_DEPARTMENT D
    WHERE  S.DEPARTMENT_NO(+) = D.DEPARTMENT_NO
    GROUP BY D.DEPARTMENT_NO, DEPARTMENT_NAME
    ORDER BY CNT DESC
;

-- ���������� Ex12) ������ ������ �л��Ϲ����� VIEW�� ���ؼ� �й��� A213046�� �л��� �̸��� ���� �̸����� ���� �غ��ô� 
UPDATE VW_�л��Ϲ�����
SET �л��̸� = '�̹�'
WHERE �й� = 'A213046';

SELECT * FROM VW_�л��Ϲ����� WHERE �й� = 'A213046';
SELECT * FROM TB_STUDENT WHERE STUDENT_NO = 'A213046';

-- ���������� Ex13) 12�������� ���� VIEW�� ���ؼ� �����Ͱ� ����� �� �ִ� ��Ȳ�� �������� VIEW�� ��� �����ؾ� �ϴ��� �ۼ��Ͻÿ�
-- WITH READ ONLY ���� �� SELECT�� ����
CREATE OR REPLACE VIEW VW_�л��Ϲ����� (�й�, �л��̸�, �ּ�)
AS ( SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT )
WITH READ ONLY
;
/*  ========== SYSTEM (������) �������� ���� ==========
-- HR������ JOBS���̺��� ��ȸ ������ JUNGANG�� �ο�
GRANT SELECT ON HR.JOBS TO JUNGANG;
-- HR������ ���̺� ������ ��ȸ
SELECT * FROM DBA_TAB_PRIVS WHERE OWNER = 'HR';
-- �ó��(���Ǿ�/��Ī)�� ������ �� �ִ� ������ �ο�
GRANT CREATE SYNONYM TO JUNGANG;
-- ������ ������ ��ȸ
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'JUNGANG';
-- ���� ȸ��
REVOKE SELECT ON HR.JOBS FROM JUNGANG;
REVOKE CREATE SYNONYM FROM JUNGANG;
*/
/*  ========== JUNGANG (�����) �������� �ۼ��ߴ� ���� ==========
SELECT * FROM HR.JOBS;
*/
-- HR������ JOBS���̺��� ��ȸ ������ JUNGANG�� �ο�

-- ���������� Ex14) SYNONYM
-- �����ڷκ��� HR ������ JOBS ���̺� ��ȸ ������ �޾ƾ� ��ȸ�� �����ϴ�.
SELECT * FROM HR.JOBS;

-- �ó�� �����ϱ� (HR.JOBS�� ��Ī���� JOB ����)
-- �����ڷκ��� �ó��(���Ǿ�/��Ī)�� ������ �� �ִ� ������ �޾ƾ� ������ �����ϴ�.
CREATE OR REPLACE SYNONYM JOBS FOR HR.JOBS;

-- �ó������ ��ȸ
SELECT * FROM JOBS;

-- �ó�� ����
DROP SYNONYM JOBS;      

-- ���������� Ex15) SEQUENCE
-- 10�� �����ϴ� �������� ����
CREATE SEQUENCE SEQ_TB_CLASS_TYPE_NO
START WITH 10
INCREMENT BY 10
--MINVALUE 10
--MAXVALUE 40
;
DROP SEQUENCE SEQ_TB_CLASS_TYPE_NO;

-- NEXTVAL ���� CURRVAL ��� ���� 
-- ���� ������Ų �� ��ȯ
SELECT SEQ_TB_CLASS_TYPE_NO.NEXTVAL FROM DUAL;
SELECT SEQ_TB_CLASS_TYPE_NO.CURRVAL FROM DUAL;

SELECT * FROM TB_CLASS_TYPE; 
SELECT SEQ_TB_CLASS_TYPE_NO.NEXTVAL, CLASS_TYPE_NAME  FROM TB_CLASS_TYPE; 
SELECT CLASS_TYPE FROM TB_CLASS GROUP BY CLASS_TYPE;

SELECT SEQ_TB_CLASS_TYPE_NO.NEXTVAL, CLASS_TYPE         
FROM (SELECT CLASS_TYPE FROM TB_CLASS GROUP BY CLASS_TYPE);

-- �������� �̿��ؼ� �ϰ������� ����.      
/*
    INSERT INTO ���̺�
        ��������
        
    ���������� ��ȸ��������� ���̺� ����
*/
INSERT INTO TB_CLASS_TYPE 
    SELECT CLASS_TYPE, SEQ_TB_CLASS_TYPE_NO.NEXTVAL 
    FROM (SELECT CLASS_TYPE FROM TB_CLASS GROUP BY CLASS_TYPE);
    
SELECT * FROM TB_CLASS_TYPE;

-- ***** ���̺��� �÷� ����
ALTER TABLE TB_CLASS_TYPE DROP COLUMN CLASS_TYPE_NO;

-- ***** ���̺��� �ʵ� ���� ����
-- ALTER TABLE ���̺�� CHANGE COLUMN ������ �ʵ�� ������ �ʵ�� varchar(255) NULL AFTER ���� �ʵ��; 