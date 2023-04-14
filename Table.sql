-- <CREATE>
-- �����ͺ��̽��� ��ü�� �����ϴ� �����̴�.
-- <���̺� ����>
-- ǥ����
-- [�ɼ�] : ��/���� �������
-- ��/�ҹ��� �������

/* 
CREAT TABLE ���̺� (
    �÷��� �ڷ���(ũ��) [DEFUALT �⺻��] [��������],
    �÷��� �ڷ���(ũ��) [DEFUALT �⺻��] [��������],
        ...
);
*/

CREATE TABLE MEMBER (
    member_id   VARCHAR2(20),
    member_pwd  VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20)
);

COMMENT ON COLUMN MEMBER.member_id IS
    '����� ID';

CREATE TABLE user_notnull (
    user_no   NUMBER NOT NULL,
    user_id   VARCHAR2(20) NOT NULL,
    user_pwd  VARCHAR2(20) NOT NULL,
    user_name VARCHAR2(30)
);

-- INSERT INTO ���̺�� VALUES (�÷� ������� ���� �Է�)
-- NULL ��������: �� ���ڿ��� �������� �ʳ�� ! 

INSERT INTO user_notnull VALUES (
    1,
    'user01',
    1234,
    '������'
);

INSERT INTO user_notnull VALUES (
    2,
    '',
    1234,
    '����'
);

CREATE TABLE user_unique (
    user_no   NUMBER,
    user_id   VARCHAR2(20) UNIQUE,
    user_pwd  VARCHAR2(30) NOT NULL,
    user_name VARCHAR2(30)
);

-- ���̺� ����
-- DROP table ���̺��;
DROP TABLE user_unique;

-- ���̺��� ������ Ȯ���� �� ����
-- DESC ���̺��;
DESC MEMBER;

DESCRIBE user_notnull;

-- Book ���̺� ����
-- NO, TITLE, AUTHOR, ISRENT
-- NUMBER, VARCHAR2(100), VARCHAR2(20), CHAR(1)
-- �ѱ��� 3byte�� �����ϴϱ�, 
-- UNIQUE, NOT NULL, NOT NULL, 'N'
-- �÷��̸� Ÿ��(����) ��������
 
-- ���� ������ ���� ���̺� ����
CREATE TABLE book(
    NO NUMBER UNIQUE not null, /* -> �⺻Ű�� Ư¡ 2������ ���������� */
    title VARCHAR2(100) NOT NULL,
    author  VARCHAR2(20) NOT NULL,
    /*����ڰ� ���� �Է����� �ʾ��� ��� �ڵ����� �ԷµǴ� ��*/
    isrent CHAR(1) DEFAULT  'n'  CHECK(isrent IN ('y','n')),
    regdate DATE default sysdate /*�����*/,
    editdate date /*������*/
);

-- ������ ����
--insert into ���̺�� values (��� �÷���1,�÷���2..);
--insert into ���̺�� (�÷���) values (�÷���);
-- �÷��� ��õ��� ���� ��� ����Ʈ���� null�� �� ���� �ִ�.
-- ������ Ÿ���� �ٸ��� ������ ��Ű�� �ʰ� �ᵵ �ȴ�? �÷��� ������ �����������
-- ��κ� ���̺��� �������� �� ������ �÷� ������� �˾Ƽ� ���� �־��ֱ� ������ �����ϸ� ���缭 �����ϴ°� ���ڴ�.
insert into book values (1, 'H��Ʈ�������2', '�̼�', 'y', sysdate, null);

insert into book (book.title,book.author) values ('õ�����ڴ� ���� ���� �ʴ´�','��ä��');

-- sysdate ���� ��¥�� �ð��� �˷���
-- ���� ���浵 ������ RR/MM/DD HH24:MI:SS  -> �ҹ��ڵ� ���������
insert into book (no, title, author, regdate) values (2, '���','�����', sysdate);

drop table book;

SELECT (book.title) from book; 
SELECT title from book; 
SELECT title,author from book; 
select * from book;

-- ������ ���̺� �߰��� �����͸� ���� �����ͺ��̽��� �ݿ��Ѵ�.
-- (�޸� ���ۿ� �ӽ� ����� �����͸� ���� ���̺� �ݿ�)

commit;

-- �ڵ� Ŀ�� ����
-- 1. ���� ���¸� Ȯ��
-- ������ �ڵ� Ŀ���� �������� �ʴ´ٰ� �Ͻʴϴٿ��..
SHOW AUTOCOMMIT;

-- 2. �ڵ�Ŀ�� ����
SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;


-- �������ǿ� �̸��� �ٿ��� ���� ���̺� ����
CREATE TABLE book(
    NO NUMBER UNIQUE,
    title VARCHAR2(100) NOT NULL,
    author  VARCHAR2 ( 20 ) NOT NULL,
    isrent CHAR(1),
    CONSTRAINT chenkisrent CHECK(isrent IN ('y','n'))
    );
    
DROP TABLE book;

/*
������ ��ųʸ�(��Ÿ ������)
    �ڿ��� ȿ�������� �����ϱ� ���� �پ��� ��ü���� ������ �����ϴ� �ý��� ���̺��̴�.
    ����ڰ� ��ü�� �����ϰų� ��ü�� �����ϴ� ���� �۾��� �� ��
    �����ͺ��̽��� ���ؼ� �ڵ����� ���ŵǴ� ���̺��̴�.
    �����Ϳ� ���� �����Ͱ� ����Ǿ� �ִٰ� �ؼ� ��Ÿ �����Ͷ�� �Ѵ�.
    
    USER_TABLES
    : ����ڰ� �������ִ� ���̺���� �������� ������ Ȯ���ϴ� �� ���̺��̴�.
    USER_TAB_COLUMNS
    : ���̺�, ���� �÷��� ���õ� ������ ��ȸ�ϴ� �� ���̺��̴�.
*/

/*
    select ���� : ���̺��� �����͸� ��ȸ�Ѵ�
    select �÷���1, �÷���2... from ���̺��;
    * : ���̺� �� ��� �÷��� ��ȸ
*/


-- ���� ���� Ȯ��
DESC user_constraints;

-- ����ڰ� �ۼ��� ���������� Ȯ���ϴ� ��
SELECT * FROM user_constraints;

DESC user_cons_columns;
-- ����ڰ� �ۼ��� ���������� �ɷ��ִ� �÷��� Ȯ���ϴ� ��
SELECT * FROM user_cons_columns;















