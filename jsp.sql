-- member 테이블 생성
create table member (
    id varchar2(10) not null primary key
    , pass varchar2(10) not null
    , name varchar2(30) not null
    , regidate date default sysdate not null
);
-- board 테이블 생성
create table board (
    num number primary key
    , title varchar2(200) not null
    , content varchar2(2000) not null
    , id varchar2(10) not null
    , postdate date default sysdate not null
    , visitcount number(6)
);
-- board 외래키 설정
alter table board
    add constraint board_mem_fk foreign key (id)
    references member (id)
;
-- seq_board_num 시퀀스 생성
create sequence seq_board_num
    increment by  1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle 
    nocache
;
-- 더미데이터 입력
insert into member (id, pass, name) values ('test','1234', '사용자');
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '나상현씨밴드입니다', '클럽투어 기대해주세요', 'test10',
sysdate, 0);

insert into board (num, title, content, id, postdate, visitcount) values (seq_board_num.nextval, ?, ?, ?, sysdate, 0);

select * from member;
select * from board;

comment on table member is '회원';
comment on column member.id is '아이디';
comment on column member.pass is '패스워드';
comment on column member.name is '이름';
comment on column member.regidate is '가입 날짜';

comment on table board is '게시판';
comment on column board.num is '일련번호. 기본키';
comment on column board.title is '게시물의 제목';
comment on column board.content is '내용';
comment on column board.id is '작성자의 아이디. member 테이블의 id를 참조하는 외래키';
comment on column board.postdate is '작성일';
comment on column board.visitcount is '조회수';

select to_char(sysdate, 'yyyy-mm-dd') today from dual;

select * from member where id='test' and pass='1234';

select id, name, regidate from member;
select id, pass, name from member;

insert into member (id, pass, name) values ('test3','1234', '사용자3');

delete member where id='id';

delete board where num = '36';

select count(*) from board order by num desc;
select * from board where num='5' order by num desc;
select count(*) from board where postdate like '%14%' order by num desc ;

update board set content = '내용55555입니다', title='제목55555입니다' where num = 21;

SELECT * FROM( SELECT Tb.*, rownum rNum FROM( SELECT * FROM board ORDER BY num DESC ) Tb ) WHERE rNum BETWEEN 1 and 5;

-- 오늘 날짜와 같으면 시간을 보여주고, 아니면 날짜를 보여줌
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

update board set title = '제목2', content ='내용2' where num = '8'; 

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

update board set title = '푸들입니다'
, content = '제로퍼제로입니다 멍멍'
, editdate = '2023-06-15 20:10:03'
 where num = '55';

insert into board select seq_board_num.nextval, '제목', '내용', 'test',
sysdate, sysdate, 0 from board;

insert into board
select
  seq_board_num.nextval,
  '제목' || level || '입니다',
  '내용' || level || '입니다',
  'test',
  sysdate,
  0,
  sysdate
from
  dual
connect by level <= 100;


select count(*) from board;


select * from ( select b.*, rownum rn from ( select * from board order by num desc) b ) where rn between 1 and 1