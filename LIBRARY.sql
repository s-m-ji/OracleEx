CREATE TABLE BOOK (
    NO NUMBER PRIMARY KEY
    , TITLE VARCHAR2(100)
    , RENTYN CHAR(1) DEFAULT 'N' CHECK (RENTYN IN ('Y','N'))
    , AUTHOR VARCHAR2(20)
);

CREATE TABLE MEMBER (
    ID VARCHAR2(20) PRIMARY KEY
    , PW VARCHAR2(20)
    , NAME VARCHAR2(20)
    , ADMINYN CHAR(1) DEFAULT 'N' CHECK (ADMINYN IN ('Y','N'))
    , STATUS CHAR(1) DEFAULT 'N' CHECK (STATUS IN ('Y','N'))
    , GRADE	CHAR(1) DEFAULT 'B'  
);

SELECT * FROM BOOK;
SELECT * FROM MEMBER;

INSERT ALL 
INTO BOOK VALUES (1, '����Ŀ�� ���ǿ���1', 'Y', '�ڻ�1')
INTO BOOK VALUES (2, '����Ŀ�� ���ǿ���2', DEFAULT, '�ڻ�2')
INTO BOOK VALUES (3, '����Ŀ�� ���ǿ���3', DEFAULT, '�ڻ�3')
INTO BOOK VALUES (4, '����Ŀ�� ���ǿ���4', 'Y', '�ڻ�4')
INTO BOOK VALUES (5, '����Ŀ�� ���ǿ���5', DEFAULT, '�ڻ�5')
SELECT * FROM DUAL
;

INSERT INTO MEMBER VALUES ('ADMIN', '1234', '������', 'Y', 'Y', DEFAULT);

INSERT INTO BOOK VALUES (SEQ_BOOK_NO.NEXTVAL, '����Ŀ�� ���ǿ���6', 'Y', '�ڻ�6');
INSERT INTO BOOK VALUES (SEQ_BOOK_NO.NEXTVAL, 'test3', 'Y', 'test3');
INSERT INTO BOOK VALUES (7, 'test', 'Y', 'test');

DELETE BOOK WHERE SEQ_BOOK_NO.NEXTVAL in ('7', '8');
delete book where no in ('7', '8');

ROLLBACK;
COMMIT;

CREATE SEQUENCE SEQ_BOOK_NO;

select * from book order by no;

select id, name, adminyn, status, grade from member where id = 'ADMIN' and pw = '1234';

select * from member where id = '';

insert into member values ('id', 'pw', 'name', 'adminyn', 'status', 'grade');

select id from member;

rollback;


select rentyn from book;

-- BOOK ���̺��� RENTYN�÷� ��� �뿩 ���̺��� �뿩���� �÷��� �̿�
-- NO, TITLE, RENTYN, AUTHOR
-- NO, TITLE, �뿩����, AUTHOR

DROP TABLE �뿩;
CREATE TABLE �뿩 (
    �뿩��ȣ VARCHAR2(10) PRIMARY KEY
    , ���̵� VARCHAR2(20)
    , ������ȣ NUMBER
    , �뿩���� CHAR(1) DEFAULT 'Y' CHECK (�뿩���� IN ('Y','N'))
    , �뿩�� DATE DEFAULT SYSDATE
    , �ݳ��� DATE
    , �ݳ������� DATE -- DEFAULT �뿩��+7
    , ��ü�� NUMBER
);

CREATE SEQUENCE SEQ_�뿩;

SELECT * FROM SEQ_�뿩;

SELECT * FROM �뿩;

INSERT INTO �뿩 VALUES (SEQ_�뿩.NEXTVAL, 'USER01', 1, 'N', DEFAULT, SYSDATE, SYSDATE+7, '');

DELETE �뿩;

SELECT NO, TITLE, NVL(�뿩����, 'N'), AUTHOR FROM BOOK, �뿩 WHERE NO = ������ȣ(+) AND �뿩����(+) = 'Y';


                
SELECT NO, TITLE
        , NVL((SELECT �뿩���� 
        FROM �뿩 
        WHERE ������ȣ = BOOK.NO 
        AND �뿩���� IN ('Y')),'N') 
        , AUTHOR
FROM BOOK;

UPDATE �뿩 SET �ݳ��� = SYSDATE, �뿩����='N' WHERE ������ȣ=3; 






































