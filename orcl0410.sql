drop table book;
drop table member;

create table book(
    bookNo number unique not null,
    bookTitle varchar2(200) not null,
    bookAuthor varchar2(20) not null,
    bookRentYN char(1) default('n') check(bookRentYN in ('Y','N'))
);

select * from book order by bookNO;

-- max : 컬럼의 최대값을 반환함
select max(bookNo)+1 from book;

select max(bookNo)+1 from book;

-- 아래와 같은 형식으로 써야한다고 하셨는데요.. 보통 시퀀스를 사용할거기때문에 일단 패스하기로 !
insert into book values((select max(bookNo)+1 from book), 'H마트에서 울다', '미셸', 'Y');
insert into book values(2, '천년의사랑', '양귀자', 'N');
insert into book values(3, '한.다.된', '양귀자', 'N');

commit;


create table member(
    memberId varchar2(50) unique not null,
    memberPw varchar2(50) not null,
    memberName varchar2(20) not null,
    memberAdminYN char(1) default('n') check(memberAdminYN in ('y','n'))
);

insert into member values ('mem1', '1234', '예지', 'y');
insert into member values ('mem2', '12345', '다울', DEFAULT);
insert into member values ('mem3', '123456', '인규', DEFAULT);

update member
set memberId = 'admin'
where memberId = 'mem1';

select * from member;

select * from member where memberId = 'admin' and memberPw = '1234';

commit;

select * from book where bookNo = 1 and bookRentYN = 'Y';

update book set bookRentYN = 'Y' where bookNo = 1;

select * from book where bookNo = 1;

drop table user_notnull;


-- 테이블 스페이스 경로 조회
SELECT * FROM DBA_DATA_FILES;
-- D:\APP\USER\ORADATA\ORCL\MYTS.dbf

-- 테이블 스페이스 생성 (물리적인 경로 생성)
CREATE TABLESPACE MYTS DATAFILE
'D:\APP\USER\ORADATA\ORCL\MYTS.dbf' SIZE 100M AUTOEXTEND ON NEXT 5M;



