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
INTO BOOK VALUES (1, '스니커즈 사피엔스1', 'Y', '박상영1')
INTO BOOK VALUES (2, '스니커즈 사피엔스2', DEFAULT, '박상영2')
INTO BOOK VALUES (3, '스니커즈 사피엔스3', DEFAULT, '박상영3')
INTO BOOK VALUES (4, '스니커즈 사피엔스4', 'Y', '박상영4')
INTO BOOK VALUES (5, '스니커즈 사피엔스5', DEFAULT, '박상영5')
SELECT * FROM DUAL
;

INSERT INTO MEMBER VALUES ('ADMIN', '1234', '관리자', 'Y', 'Y', DEFAULT);

INSERT INTO BOOK VALUES (SEQ_BOOK_NO.NEXTVAL, '스니커즈 사피엔스6', 'Y', '박상영6');
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

-- BOOK 테이블의 RENTYN컬럼 대신 대여 테이블의 대여여부 컬럼을 이용
-- NO, TITLE, RENTYN, AUTHOR
-- NO, TITLE, 대여여부, AUTHOR

DROP TABLE 대여;
CREATE TABLE 대여 (
    대여번호 VARCHAR2(10) PRIMARY KEY
    , 아이디 VARCHAR2(20)
    , 도서번호 NUMBER
    , 대여여부 CHAR(1) DEFAULT 'Y' CHECK (대여여부 IN ('Y','N'))
    , 대여일 DATE DEFAULT SYSDATE
    , 반납일 DATE
    , 반납가능일 DATE -- DEFAULT 대여일+7
    , 연체일 NUMBER
);

CREATE SEQUENCE SEQ_대여;

SELECT * FROM SEQ_대여;

SELECT * FROM 대여;

INSERT INTO 대여 VALUES (SEQ_대여.NEXTVAL, 'USER01', 1, 'N', DEFAULT, SYSDATE, SYSDATE+7, '');

DELETE 대여;

SELECT NO, TITLE, NVL(대여여부, 'N'), AUTHOR FROM BOOK, 대여 WHERE NO = 도서번호(+) AND 대여여부(+) = 'Y';


                
SELECT NO, TITLE
        , NVL((SELECT 대여여부 
        FROM 대여 
        WHERE 도서번호 = BOOK.NO 
        AND 대여여부 IN ('Y')),'N') 
        , AUTHOR
FROM BOOK;

UPDATE 대여 SET 반납일 = SYSDATE, 대여여부='N' WHERE 도서번호=3; 






































