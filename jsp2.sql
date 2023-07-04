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

SELECT * FROM tbl_board WHERE bno > 0
