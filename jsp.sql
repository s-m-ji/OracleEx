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
INSERT INTO MEMBER (ID, pass, NAME) VALUES ('test','1234', '사용자');
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
;
create ;
create table myfile (
    idx number primary key          -- 시퀀스
    , name varchar2(50) not null    -- form 전달
    , title varchar2(200) not null  -- form 전달
    , cate varchar2(30)             -- form 전달
    , ofile varchar2(100) not null 
    , sfile varchar2(100) not null 
    , postdate date default sysdate not null
);

select * from myfile;
select * from myfile order by idx desc;
select count(*) from myfile order by idx desc;
COMMENT ON TABLE myfile IS '파일 업로드' ;
COMMENT ON COLUMN myfile.postdate IS '등록한 날짜';

insert into myfile values (
seq_myfile_num.nextval, '작성자1', '제목1' ,'카테고리1' ,'원본파일명', '수정파일명', sysdate);

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
  '작성자' || level,
  '제목' || level,
  '내용' || level,
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

comment on table mvcboard is 'MVC게시판';
comment on column mvcboard.idx is '일련번호. 기본키';
comment on column mvcboard.name is '작성자 이름';
comment on column mvcboard.title is '제목';
comment on column mvcboard.content is '내용';
comment on column mvcboard.postdate is '작성일';
comment on column mvcboard.ofile is '원본 파일명';
comment on column mvcboard.sfile is '저장된 파일명';
comment on column mvcboard.downcount is '다운로드 횟수';
comment on column mvcboard.pass is '비밀번호';
comment on column mvcboard.visitcount is '조회수';

insert into mvcboard values (seq_mvcboard_num.nextval,
'작성자 이름3', '제목3' ,'내용3', sysdate ,'원본 파일명3', '저장된 파일명3', 0, '1234', 0);

SELECT COUNT(*) FROM mvcboard ORDER BY idx DESC;
SELECT * FROM mvcboard ORDER BY idx DESC;

SELECT * FROM mvcboard WHERE idx = 3;

SELECT COUNT(*) FROM mvcboard WHERE title LIKE '%제목%';

update mvcboard set name = '작성자3', title = '제목3', content = '내용3', ofile = 'test', sfile = 'new_test' where idx = '111';

update mvcboard set sfile = '파일명_20230626_10499736.png' where idx = 114;

-- libBoard 테이블 생성
create table libBoard (
    idx 	number 			primary key
    , title	varchar2(200)		not null	
    , writer	varchar2(100)		not null	
    , publisher	varchar2(100)		not null	
    , post_date	date	default sysdate	not null	
    , rent_yn	char	default 'N'	not null	
    , rent_date	date	default sysdate		
    , return_exp_date	date	default sysdate + 14		
    , return_date	date	default sysdate		
    , ebook_file	varchar2(100)			
    , rent_count	number 	default 0	not null	
    , review	varchar2(500)			
);

insert into libBoard
select
  seq_libBoard_idx.nextval, '책 ' || level, '작가 ' || level, '출판사 ' || level,
  sysdate, 'N', sysdate, sysdate+14, '', 0, '', '', '', '' from dual
connect by level <= 100; 
commit;

drop sequence seq_libBoard_idx;

INSERT INTO libBoard (idx, title, writer, publisher, rent_yn, rent_date, return_date, return_exp_date, rent_count)
    VALUES (seq_libBoard_idx.nextval, '책', '작가', '출판사', default, sysdate, '', sysdate+7, default);

to_char(postdate, 'yyyy-mm-dd')

SELECT idx, title, writer, publisher, rent_yn, to_char(rent_date, 'yyyy-mm-dd') as "RENT_DATE"
                , return_date, to_char(return_exp_date, 'yyyy-mm-dd') as "RETURN_EXP_DATE", rent_count FROM libBoard ORDER BY idx DESC;

update libBoard set rent_yn = 'Y' where idx = 2;
create sequence seq_libBoard_idx
    increment by  1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle 
    nocache
;
INSERT INTO mvcboard (idx, name, title, content, ofile, sfile, pass) VALUES (seq_mvcboard_num.nextval, '1', '2', '3', '4', '5', '6');

UPDATE mvcboard set visitcount = visitcount + 1 WHERE idx = 114;

ALTER TABLE member ADD grade CHAR DEFAULT 'B' NOT NULL;

ALTER TABLE member RENAME COLUMN admin TO adminyn;

select * from member;

update member set adminyn = 'Y' where id = 'test6';
update member set id = 'admin01' where name = '관리자1';
delete member where name = '관리자1';
SELECT * FROM libBoard order by idx desc;

SELECT rent_yn FROM libBoard WHERE idx = 3;

delete from libboard where idx in ('102');
delete from libboard where idx in ('102');
delete from libboard where idx in (102);

conn jsp/1234
create table 대여 as select * from library.대여;

GRANT SELECT, INSERT ON library.대여 TO jsp;

create table 대여 (
    대여번호 VARCHAR2(10 BYTE) not null,
    아이디 VARCHAR2(20 BYTE),
    ehtjqjsgh 
);

alter table libboard modify rent_count null;
ALTER TABLE member ADD reserve_no VARCHAR2(20);
ALTER TABLE libboard DROP COLUMN eBook_file;


select * from libboard;

insert into libboard (idx, title) values (SEQ_libboard_idx.NEXTVAL, '아무튼, 피아노');

insert into libboard (idx, title, writer, publisher, ofile, sfile values (SEQ_libboard_idx.NEXTVAL, '아무튼 외국어', '-', '-', '아무튼_외국어.png', '아무튼_외국어_20230628_102351723.png');

create sequence seq_대여
    increment by  1
    start with 1
    minvalue 1
    nomaxvalue 
    nocycle 
    nocache
;
drop sequence seq_대여;
-- rentBook 메소드 쿼리 1. 
select 'R'||lpad(seq_대여.nextval,5,0) from dual; 
-- rentBook 메소드 쿼리 2.
update libboard set rent_no = 'R0001' where idx = 3 and (rent_no is null or rent_no = '');
-- rentBook 메소드 쿼리 3.
select * from 대여;
insert into 대여 values ( 'R0001', '아이디', '3', 'Y', sysdate, null, sysdate+14, null);

select * from libboard;

delete libboard;

SELECT b.idx, b.title, d.대여여부, b.writer, d.아이디, to_char(대여일, 'yy/mm/dd/') 대여일, to_char(반납가능일, 'yy/mm/dd/') 반납가능일, 반납일, sfile, ofile, d.대여번호 FROM libBoard b, 대여 d WHERE b.rent_no = d.대여번호(+) and b.idx = 126;

select d.대여번호 from libBoard b, 대여 d
WHERE b.idx = d.도서번호(+) and b.idx = 126;

select d.대여번호 from libBoard b, 대여 d WHERE b.idx(+) = d.도서번호 and b.idx = 118;
update libboard set rent_yn = 'N', rent_no = '' where rent_no = 'R00006' and rent_no is not null;

SELECT * FROM ( 
    SELECT ROWNUM rn, lib.* FROM ( 
        SELECT b.idx, b.title, b.writer, b.publisher, b.rent_yn 
        FROM libboard b, 대여 d 
        WHERE b.idx = d.도서번호
        AND title LIKE '%책%' 
        AND 'test' = d.아이디 
        AND b.rent_yn = 'Y'
        ORDER BY idx DESC 
    ) lib 
) WHERE rn BETWEEN 1 AND 10;

SELECT * FROM ( SELECT ROWNUM rn, lib.* FROM ( SELECT b.idx, title, writer, publisher, rent_no, d.대여번호, d.대여여부, TO_DATE(to_char(반납가능일, 'yy/mm/dd'), 'YY/MM/DD') - TRUNC(SYSDATE) AS 잔여일, to_char(대여일, 'yy/mm/dd') 대여일, to_char(반납가능일, 'yy/mm/dd') 반납가능일, to_char(반납일, 'yy/mm/dd') 반납일 from libboard b, 대여 d WHERE b.idx = d.도서번호 ORDER BY idx DESC ) lib ) WHERE rn BETWEEN 1 AND 10;

SELECT * FROM ( SELECT ROWNUM rn, lib.* FROM ( SELECT idx, title, writer, publisher, d.대여번호, d.대여여부,  TO_DATE(to_char(반납가능일, 'yy/mm/dd'), 'YY/MM/DD') - TRUNC(SYSDATE) AS 잔여일 to_char(대여일, 'yy-mm-dd') 대여일, to_char(반납가능일, 'yy-mm-dd') 반납가능일, to_char(반납일, 'yy-mm-dd') 반납일 FROM libboard b, 대여 d WHERE b.idx = d.도서번호 ORDER BY idx DESC ) lib ) WHERE rn BETWEEN 1 AND 10;
