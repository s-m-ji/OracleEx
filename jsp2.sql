create sequence seq_board;
CREATE SEQUENCE seq_board MINVALUE 0 START WITH 0;

create table tbl_board (
  bno number(10,0),
  title varchar2(200) not null,
  content varchar2(2000) not null,
  writer varchar2(50) not null,
  regdate date default sysdate, 
  updatedate date default sysdate
);
 
alter table tbl_board add constraint pk_board 
primary key (bno);

drop sequence seq_board;
drop table tbl_board;

select * from tbl_board;

SELECT * FROM tbl_board;

INSERT INTO tbl_board
SELECT
  seq_board.NEXTVAL,
  'title ' || LEVEL ,
  'content ' || LEVEL ,
  'writer ' || LEVEL ,
  sysdate,
  sysdate
FROM
  dual
CONNECT BY level <= 100;

SELECT * FROM tbl_board WHERE bno > 0;

drop table tbl_reply;
drop sequence seq_reply;

CREATE TABLE tbl_reply (
  rno NUMBER(10,0), 
  bno NUMBER(10,0) NOT NULL,
  reply VARCHAR2(1000) NOT NULL,
  replyer VARCHAR2(50) NOT NULL, 
  replydate DATE DEFAULT sysdate, 
  updatedate DATE DEFAULT sysdate
);

CREATE SEQUENCE seq_reply MINVALUE 0 START WITH 0;
 
ALTER TABLE tbl_reply ADD CONSTRAINT pk_reply PRIMARY KEY (rno);
 
ALTER TABLE tbl_reply  ADD CONSTRAINT fk_reply_board  
FOREIGN KEY (bno)  REFERENCES  tbl_board (bno);

insert into tbl_reply (rno, bno, reply, replyer) 
    seq_reply.nextval, 1, '댓글test1', '댓글작성자1'
);



INSERT INTO TBL_REPLY VALUES (SEQ_REPLY.NEXTVAL, 1, '댓글test11', '댓글작성자11', SYSDATE, SYSDATE);
INSERT INTO TBL_REPLY VALUES (SEQ_REPLY.NEXTVAL, 2, '댓글', '작성자', SYSDATE, SYSDATE);
commit;
select * from tbl_reply;

INSERT INTO tbl_reply (rno, bno, reply, replyer)  
SELECT
  seq_reply.NEXTVAL,
  1,
  '댓글test' || LEVEL ,
  '댓글작성자' || LEVEL
FROM
  dual 
CONNECT BY level <= 100 ;

SELECT bno, rno, reply, replyer, TO_CHAR(replyDate, 'yyyy/MM/dd'), updateDate
	 FROM tbl_reply WHERE bno = 1 ORDER BY rno DESC;

DELETE tbl_reply;

UPDATE tbl_reply SET reply = '냥냥', updateDate = sysdate WHERE rno = 38;

select TO_CHAR(replyDate, 'yyyy/MM/dd HH24:MI:SS') from tbl_reply;

select  * from tbl_board where bno = 87;

SELECT DECODE(COUNT(*),1, 1, 0) FROM member WHERE id = 'test';



-- 로그 테이블 생성 ~
create table tbl_log (
classname varchar2(100)
, methodname varchar2(100) 
, params varchar2(1000)
, errmsg varchar2(2000)
, regdate date
);

select * from tbl_log;

create table MemberRole (
    id varchar2(20)
    , role_id varchar2(20)
);
drop table MemberRole;
select * from MemberRole;

alter table tbl_board add (replycnt number default 0);

update tbl_board set replycnt = (
    select count(rno) from tbl_reply where tbl_reply.bno = tbl_board.bno);
select * from tbl_board;
UPDATE tbl_board SET replycnt = replycnt + 1 WHERE bno = 2;

create table tbl_attach ( 
  uuid varchar2(100) not null,
  uploadPath varchar2(200) not null,
  fileName varchar2(100) not null, 
  filetype char(1) default 'I', -- I는 Image를 의미함
  bno number(10,0)
);
 alter table tbl_attach add constraint pk_attach primary key (uuid); 
 alter table tbl_attach add constraint fk_board_attach foreign key (bno) references tbl_board(bno);

 select * from tbl_attach;
 select * from tbl_board;
 
 SELECT T.* 
    , uploadpath||uuid||'_'||filename savepath
    , DECODE(filetype , 'I', uploadpath||'thum_'||uuid||'_'||filename, 'file') t_savepath
 FROM tbl_attach T WHERE bno = 3;
 -- filetype이 i이면 t_savepath를 만들고 아니면 빈 문자열 출력하도록 코드 수정 (i, I 대소문자 구별 주의 !)

DELETE tbl_attach WHERE bno = 6;

DELETE tbl_board WHERE bno = 187 CASCADE;

























