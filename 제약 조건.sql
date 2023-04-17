/*
    <���� ����>
    �������� ���Ἲ�� ��Ű�� ���� �Է°��� ����
    
    not null : null �Է� ����
    unique : �ߺ����� �ʴ� ��
    default : ����Ʈ ���� �ο�
    check : üũ ������ �����ϴ� ��
    
    primary key : �⺻Ű(not null + unique) 
    foreign key : �ܷ�Ű(�� ���̺��� �������迡 ���� ������ �Է� �Ǵ� ���� �� ���� ����)
    
    
    <primary key (�⺻Ű) ��������>
    ���̺��� �� ��(Ʃ�� TUPLE)�� ������ �ĺ��ϱ� ���� ����� �÷��� �ο��ϴ� ���� ����
    �� ����� ������ �� �ִ� �ĺ��� ����(���, �μ��ڵ�, �����ڵ� ...)
    �⺻Ű ���������� �����ϰ� �Ǹ� �ڵ����� �ش� �÷��� not null + unique ���� ������ �����ȴ�.
    PK�� �����ϸ� �ڵ����� INDEX ���� �����ȴ�.
    
    �� ���̺� �� ���� ������ �� �ִ�
    (�� �� �̻��� �÷��� ��� primary key�� ���������� �����ϴ� �͵� ����)
    �÷� ����, ���̺� ���� ��� ��� ���� �����ϴ�.  --> 2���� ������� ���� ����
*/

/*
create table book(
    book_no char(5) primary key,    
    title varchar2(100) not null,
    author varchar2(100) not null, 
    rentyn char(1) DEFAULT 'N' 
                    -- ������ : �Ӽ��� ��, Ÿ��, ������� � ���� ���� ���� 
                    �������� �־��� Y �ƴϸ� N �̿ܿ��� üũ ������ ����� �� ���� 
                    CHECK (RENTYN IN ('Y','N')),
    REG_DATE DATE DEFAULT SYSDATE,
    UPDATE_DATE DATE
);

-- �������ǿ� �̸��� �ο��Ͽ� ���̺� ���� 
-- �÷� ���� ���� ���
create table book(
    book_no char(5) CONSTRAINT BOOK_NO_PK primary key,    
    -- �̷��� �÷� ���� �ÿ� �ٷ� ����
    --      �÷��� Ÿ��(ũ��) CONSTRAINT �������Ǹ� PRIMARY KEY
    title varchar2(100) not null,
    author varchar2(100) not null, 
    rentyn char(1) DEFAULT 'N' CHECK (RENTYN IN ('Y','N')),
    REG_DATE DATE DEFAULT SYSDATE,
    UPDATE_DATE DATE
);
*/
DROP TABLE BOOK;

-- ���̺� ���� ���� ���
create table book(
    book_no char(5),    
    title varchar2(100) not null,
    author varchar2(100) not null, 
    rentyn char(1) DEFAULT 'N' CHECK (RENTYN IN ('Y','N')),
    REG_DATE DATE DEFAULT SYSDATE,
    UPDATE_DATE DATE,
    CONSTRAINT BOOK_NO_PK PRIMARY KEY (BOOK_NO)     
    -- �̷��� ���̺� �������� ������ ���� ����. 
    --      CONSTRAINT �������Ǹ� PRIMARY KEY (�÷���)
);

INSERT INTO BOOK VALUES('B_001', 'H��Ʈ', '�̼�', 'Y', SYSDATE, '');
INSERT INTO BOOK VALUES('B_002', 'H��Ʈ2', '�̼�2', DEFAULT, SYSDATE, '');
INSERT INTO BOOK VALUES('B_003', 'H��Ʈ3', '�̼�3', 'Y', SYSDATE, '20230401');
INSERT INTO BOOK VALUES(NULL, 'H��Ʈ2', '�̼�2', DEFAULT, SYSDATE, '');

SELECT * FROM BOOK;

CREATE TABLE MEMBER_GRADE(
    GRADE_CODE CHAR(1) PRIMARY KEY
    , GRADE_NAME VARCHAR(30) NOT NULL
);

CREATE TABLE MEMBER_GRADE(
    GRADE_CODE CHAR(1)
    , GRADE_NAME VARCHAR(30) NOT NULL
    , CONSTRAINT MEMBER_GRADE_CODE_PK PRIMARY KEY (GRADE_CODE)
);

DROP TABLE MEMBER_GRADE;

INSERT INTO MEMBER_GRADE VALUES('C', '�Ϲ�ȸ��');
INSERT INTO MEMBER_GRADE VALUES('B', '���ȸ��');
INSERT INTO MEMBER_GRADE VALUES('A', 'Ư��ȸ��');

SELECT * FROM MEMBER_GRADE;

DELETE FROM MEMBER_GRADE
WHERE GRADE_CODE = 'C';

/*
    <FOREGIN KEY(�ܷ�Ű = ����Ű) ��������>
    �ٸ� ���̺� �����ϴ� ������ �������ϴ� �÷��� �ο��ϴ� ���������̴�. (NULL���� ���� �� ����)
    FOREGIN KEY �������ǿ� ���� ���̺� ���� ���谡 �����ȴ�.
    
    - �Է� ����
    �ڽ����̺��� �θ����̺��� �����Ͽ� �θ����̺� �Էµ� ���� �Է��� �� ����
    ��, ������ �ٸ� ���̺��� �����ϴ� ���� ����� �� �ִ�.    
    
    - ���� ���� : �ɼǿ� ���� 3������ ������
    �θ����̺��� �����͸� ���� �� �ڽ����̺��� ��� ���̸�
    1. ON DELETE RESTRICT ���� �Ұ�(�⺻)
    2. ON DELETE SET NULL �ڽ����̺��� �÷��� NULL�� ������Ʈ
    3. ON DELETE CASCADE �ڽ����̺��� ���� ����
    
    1) �÷� ����
    �÷��� �ڷ���(ũ��) [CONSTRAINT �������Ǹ�] REFERENCES ������ ���̺�� (�÷���) [������]
        
    2) ���̺� ����
        [CONSTRAINT �������Ǹ�] FOREIGN KEY(�÷���) REFERENCES ������ ���̺�� (�÷���) [������]
*/

CREATE TABLE MEMBER (
    MEMBER_NO CHAR(5) PRIMARY KEY
    , ID VARCHAR2(20) NOT NULL
    , PW VARCHAR2(20) NOT NULL
    , NAME VARCHAR2(20) NOT NULL
    , GENDER CHAR(3) DEFAULT 'F' CHECK (GENDER IN ('F','M'))
    , AGE NUMBER CHECK (AGE>0)
    , REG_DATE DATE DEFAULT SYSDATE
    -- �����Ϸ��� �θ����̺��� ������ �ִ� �÷��� ��ġ�ϴ� Ÿ���� �����Ѵ�.
    , GRADE_CODE CHAR(1) REFERENCES  MEMBER_GRADE (GRADE_CODE)
    -- GRADE_CODE CHAR(1)
    -- CONSTRAINT MEMBER_GRADE_CODE_FK REFERENCES MEMBER_GRADE -- [(GRADE_CODE)]

);

SELECT * FROM MEMBER;
DROP TABLE MEMBER;

INSERT INTO MEMBER VALUES 
    ('M_001', 'ID1', '1234', 'GD', 'F', 30, DEFAULT, 'A');
INSERT INTO MEMBER VALUES 
    ('M_002', 'ID2', '1234', 'GD2', 'F', 30, DEFAULT, 'B');
INSERT INTO MEMBER VALUES 
    ('M_003', 'ID3', '1234', 'GD3', DEFAULT, 30, '20020202', 'C');

UPDATE MEMBER SET GENDER = 'M' WHERE NAME = 'GD2';
UPDATE MEMBER SET GRADE_CODE = 'A' WHERE GENDER = 'M';

-- �ܷ�Ű �������� ���� Ȯ��
DELETE MEMBER_GRADE WHERE GRADE_CODE = 'A';
-- �ڽ����̺��� ������� �ʴ� �ڵ�� ���� ����
DELETE MEMBER_GRADE WHERE GRADE_CODE = 'B';

SELECT * FROM MEMBER_GRADE;

CREATE TABLE RENT(
  RENT_NO CHAR(5) CONSTRAINT RENT_NO_PK PRIMARY KEY
  , BOOK_NO CHAR(5) CONSTRAINT RENT_BOOK_NO_FK REFERENCES BOOK (BOOK_NO) ON DELETE SET NULL
    , MEMBER_NO CHAR(5) 
    , START_DATE DATE DEFAULT SYSDATE
    , END_DATE DATE
    , OVERDUE_NUM NUMBER
    , CONSTRAINT RENT_MEMBER_NO_FK FOREIGN KEY (MEMBER_NO) REFERENCES MEMBER ON DELETE CASCADE
    -- PK(�⺻Ű)�� �ƴ� ��쿡�� REFERENCES ���̺�� �ڿ� �÷����� ���������ճ״� 
);

DROP TABLE RENT;

INSERT INTO RENT VALUES ('R_001', 'B_001', 'M_001', '20230101', '20230115', 10);
INSERT INTO RENT VALUES ('R_002', 'B_002', 'M_002', DEFAULT, SYSDATE+14, 1);
INSERT INTO RENT VALUES ('R_003', 'B_003', 'M_003', DEFAULT, DEFAULT, '');

ALTER TABLE RENT MODIFY END_DATE DEFAULT SYSDATE+14;

UPDATE BOOK SET RENTYN = 'Y';

SELECT * FROM BOOK;

/*
    '���� �뿩 ó��' �۾� ���� �� ����Ǿ�� �ϴ� �۾�
    
    1. ���� �뿩 ������ �������� Ȯ��
    - ���� ���� ���� ����
    - ������� ���� ���� ����
    - ������� ���� ���� ���� �� Ȯ��
    
    2. ������ ���¶�� �뿩 ó�� ����
    - �������̺��� �뿩 ���¸� ������Ʈ
    - �뿩���̺� �����͸� ���
        �ΰ��� �۾��� �׻� ���� �̷�������ϹǷ� �ϳ��� Ʈ��������� ����
        �ΰ� �� �ϳ��� ������ ��� �ѹ� ó���� �����ؾ��Ѵ�
*/

DELETE FROM BOOK WHERE BOOK_NO = 'B_001';
DELETE FROM MEMBER WHERE MEMBER_NO = 'M_002';

SELECT * FROM RENT;
SELECT * FROM BOOK;
SELECT * FROM MEMBER;

-- ���������� ������ �� ���⿡ ���� �� �ٽ� �ͱ۱� ~~~
SELECT * FROM user_constraints WHERE TABLE_NAME = 'RENT';

ALTER TABLE RENT DROP CONSTRAINT RENT_MEMBER_NO_FK;

ALTER TABLE RENT ADD CONSTRAINT RENT_MEMBER_NO_FK
                        FOREIGN KEY (MEMBER_NO) REFERENCES MEMBER;

DESC RENT;

DELETE FROM MEMBER WHERE MEMBER_NO = 'M_003';

-- �θ� ���̺� �����ϱ�
-- 1) �ɼ��� ���� ����
--  DPOP TABLE ���̺�� [CASCADE CONSTRAINT]
DROP TABLE BOOK CASCADE CONSTRAINTS;

ROLLBACK;

DROP TABLE MEMBER;

-- 2) ���� ���� ������ ���� �� ���̺��� ����
ALTER TABLE RENT DROP CONSTRAINT RENT_MEMBER_NO_FK;

-- ���̺��� ���� ������ ��ȸ�ϴ� ������
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'RENT';

-- 3) �ڽ����̺��� ���� �� ����
SELECT * FROM RENT;
DROP TABLE RENT;
SELECT * FROM BOOK;




















