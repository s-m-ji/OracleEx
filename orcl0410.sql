drop table book;
drop table member;

create table book(
    bookNo number unique not null,
    bookTitle varchar2(200) not null,
    bookAuthor varchar2(20) not null,
    bookRentYN char(1) default('n') check(bookRentYN in ('Y','N'))
);

select * from book order by bookNO;

-- max : �÷��� �ִ밪�� ��ȯ��
select max(bookNo)+1 from book;

select max(bookNo)+1 from book;

-- �Ʒ��� ���� �������� ����Ѵٰ� �ϼ̴µ���.. ���� �������� ����Ұű⶧���� �ϴ� �н��ϱ�� !
insert into book values((select max(bookNo)+1 from book), 'H��Ʈ���� ���', '�̼�', 'Y');
insert into book values(2, 'õ���ǻ��', '�����', 'N');
insert into book values(3, '��.��.��', '�����', 'N');

commit;


create table member(
    memberId varchar2(50) unique not null,
    memberPw varchar2(50) not null,
    memberName varchar2(20) not null,
    memberAdminYN char(1) default('n') check(memberAdminYN in ('y','n'))
);

insert into member values ('mem1', '1234', '����', 'y');
insert into member values ('mem2', '12345', '�ٿ�', DEFAULT);
insert into member values ('mem3', '123456', '�α�', DEFAULT);

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


-- ���̺� �����̽� ��� ��ȸ
SELECT * FROM DBA_DATA_FILES;
-- D:\APP\USER\ORADATA\ORCL\MYTS.dbf

-- ���̺� �����̽� ���� (�������� ��� ����)
CREATE TABLESPACE MYTS DATAFILE
'D:\APP\USER\ORADATA\ORCL\MYTS.dbf' SIZE 100M AUTOEXTEND ON NEXT 5M;



