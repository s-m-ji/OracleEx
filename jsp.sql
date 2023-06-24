-- member ���̺� ����
create table member (
    id varchar2(10) not null primary key
    , pass varchar2(10) not null
    , name varchar2(30) not null
    , regidate date default sysdate not null
);
-- board ���̺� ����
create table board (
    num number primary key
    , title varchar2(200) not null
    , content varchar2(2000) not null
    , id varchar2(10) not null
    , postdate date default sysdate not null
    , visitcount number(6)
);
-- board �ܷ�Ű ����
alter table board
    add constraint board_mem_fk foreign key (id)
    references member (id)
;
-- seq_board_num ������ ����
create sequence seq_board_num
    increment by  1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle 
    nocache
;
-- ���̵����� �Է�
insert into member (id, pass, name) values ('test','1234', '�����');
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '������������Դϴ�', 'Ŭ������ ������ּ���', 'test10',
sysdate, 0);

insert into board (num, title, content, id, postdate, visitcount) values (seq_board_num.nextval, ?, ?, ?, sysdate, 0);

select * from member;
select * from board;

comment on table member is 'ȸ��';
comment on column member.id is '���̵�';
comment on column member.pass is '�н�����';
comment on column member.name is '�̸�';
comment on column member.regidate is '���� ��¥';

comment on table board is '�Խ���';
comment on column board.num is '�Ϸù�ȣ. �⺻Ű';
comment on column board.title is '�Խù��� ����';
comment on column board.content is '����';
comment on column board.id is '�ۼ����� ���̵�. member ���̺��� id�� �����ϴ� �ܷ�Ű';
comment on column board.postdate is '�ۼ���';
comment on column board.visitcount is '��ȸ��';

select to_char(sysdate, 'yyyy-mm-dd') today from dual;

select * from member where id='test' and pass='1234';

select id, name, regidate from member;
select id, pass, name from member;

insert into member (id, pass, name) values ('test3','1234', '�����3');

delete member where id='id';

delete board where num = '36';

select count(*) from board order by num desc;
select * from board where num='5' order by num desc;
select count(*) from board where postdate like '%14%' order by num desc ;

update board set content = '����55555�Դϴ�', title='����55555�Դϴ�' where num = 21;

SELECT * FROM( SELECT Tb.*, rownum rNum FROM( SELECT * FROM board ORDER BY num DESC ) Tb ) WHERE rNum BETWEEN 1 and 5;

-- ���� ��¥�� ������ �ð��� �����ְ�, �ƴϸ� ��¥�� ������
select sysdate, postdate, trunc(sysdate), trunc(postdate) from board;
select num, title, content, id, visitcount, decode( trunc(sysdate), trunc(postdate), to_char(postdate, 'hh24:mi:ss'), to_char(postdate, 'yyyy-mm-dd')) postdate from board;

select * from (
    select rownum rn, t.* from (
        select num, title, content, id, visitcount,
            decode( trunc(sysdate), trunc(postdate), to_char(postdate, 'hh24:mi:ss')
            , to_char(postdate, 'yyyy-mm-dd')) postdate from board order by num desc 
        ) t
    ) 
where rn between 11 and 20;

select * from ( select b.*, rownum rn from ( select * from board order by num ) b ) where rn between 1 and 10;

update board set title = '����2', content ='����2' where num = '8'; 

delete board;
select * from board;
update board set visitcount = visitcount+1 where num=8;

UPDATE board b SET editdate = (SELECT postdate FROM board a WHERE a.num = b.num);

ALTER TABLE board ADD editdate date default sysdate;
select * from ( 
select rownum rn, t.* from ( 
select num, title, content, id, visitcount, 
decode( trunc(sysdate), trunc(postdate), to_char(postdate, 'hh24:mi:ss'), to_char(postdate, 'yyyy-mm-dd') ) postdate, 
decode( trunc(sysdate), trunc(editdate), to_char(editdate, 'hh24:mi:ss'), to_char(editdate, 'yyyy-mm-dd') ) editdate from board;

update board set title = 'Ǫ���Դϴ�'
, content = '�����������Դϴ� �۸�'
, editdate = '2023-06-15 20:10:03'
 where num = '55';

insert into board select seq_board_num.nextval, '����', '����', 'test',
sysdate, sysdate, 0 from board;

insert into board
select
  seq_board_num.nextval,
  '����' || level || '�Դϴ�',
  '����' || level || '�Դϴ�',
  'test',
  sysdate,
  0,
  sysdate
from
  dual
connect by level <= 100;
select count(*) from board;
select * from ( select b.*, rownum rn from ( select * from board order by num desc) b ) where rn between 1 and 1
;
create ;
create table myfile (
    idx number primary key          -- ������
    , name varchar2(50) not null    -- form ����
    , title varchar2(200) not null  -- form ����
    , cate varchar2(30)             -- form ����
    , ofile varchar2(100) not null 
    , sfile varchar2(100) not null 
    , postdate date default sysdate not null
);

select * from myfile;
select * from myfile order by idx desc;
select count(*) from myfile order by idx desc;
COMMENT ON TABLE myfile IS '���� ���ε�' ;
COMMENT ON COLUMN myfile.postdate IS '����� ��¥';

insert into myfile values (
seq_myfile_num.nextval, '�ۼ���1', '����1' ,'ī�װ�1' ,'�������ϸ�', '�������ϸ�', sysdate);

delete myfile;
drop table myfile;
drop sequence seq_myfile_num;
create sequence seq_myfile_num;

select * from ( select rownum rn, t.* from ( select idx, name, title, cate, ofile, sfile, postdate from myfile order by idx desc ) t ) where rn between 1 and 10;

create sequence seq_mvcboard_num;
;
SELECT * FROM mvcboard ORDER BY idx DESC ;

create table mvcboard (
    idx number primary key,
    name varchar2(50) not null,
    title varchar2(200) not null,
    content varchar2(2000) not null,
    postdate date default sysdate not null,
    ofile varchar2(200),
    sfile varchar2(200),
    downcount number default 0 not null,
    pass varchar2(50) not null,
    visitcount number default 0 not null
);

insert into mvcboard
select
  seq_mvcboard_num.nextval,
  '�ۼ���' || level,
  '����' || level,
  '����' || level,
  sysdate,
  '',
  '',
  0,
  '1234',
  0
from
  dual
connect by level <= 100;
commit;

comment on table mvcboard is 'MVC�Խ���';
comment on column mvcboard.idx is '�Ϸù�ȣ. �⺻Ű';
comment on column mvcboard.name is '�ۼ��� �̸�';
comment on column mvcboard.title is '����';
comment on column mvcboard.content is '����';
comment on column mvcboard.postdate is '�ۼ���';
comment on column mvcboard.ofile is '���� ���ϸ�';
comment on column mvcboard.sfile is '����� ���ϸ�';
comment on column mvcboard.downcount is '�ٿ�ε� Ƚ��';
comment on column mvcboard.pass is '��й�ȣ';
comment on column mvcboard.visitcount is '��ȸ��';

insert into mvcboard values (seq_mvcboard_num.nextval,
'�ۼ��� �̸�3', '����3' ,'����3', sysdate ,'���� ���ϸ�3', '����� ���ϸ�3', 0, '1234', 0);

SELECT COUNT(*) FROM mvcboard ORDER BY idx DESC;
SELECT * FROM mvcboard ORDER BY idx DESC;

SELECT * FROM mvcboard WHERE idx = 3;

SELECT COUNT(*) FROM mvcboard WHERE title LIKE '%����%';

update mvcboard set name = '�ۼ���3', title = '����3', content = '����3', ofile = 'test', sfile = 'new_test' where idx = '111';









