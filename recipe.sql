-- 테스트용 테이블 생성 ( 제약조건 無 ) 
CREATE TABLE rec_board_test (
    B_NO NUMBER,
    title VARCHAR2(200) ,
    nickName VARCHAR2(50) ,
    regdate DATE default sysdate,
    updatedate DATE default sysdate,
    boomup NUMBER ,
    intro VARCHAR2(3000) ,
    cookTip VARCHAR2(3000) ,
    viewCnt NUMBER ,
    star NUMBER ,
    C_NO number ,
    mno NUMBER ,
    CONSTRAINT PK_REC_B_TEST PRIMARY KEY (B_NO)
);

create sequence seq_rec_board_num;
create sequence seq_rec_cate_num;
create sequence seq_rec_mate_num;
create sequence seq_rec_ing_num;

drop sequence seq_rec_board_num;
drop sequence seq_rec_cate_num;
drop sequence seq_rec_mate_num;
drop sequence seq_rec_ing_num;

INSERT INTO rec_category (C_NO, cateName)
SELECT
  seq_rec_cate_num.nextval,
  '카테고리 ' || level
FROM
  dual
CONNECT BY level <= 30;
commit;

select * from rec_category;
delete rec_category;
drop table rec_category;

INSERT INTO rec_board (B_NO, nickName, title, C_NO)
SELECT
  seq_rec_board_num.nextval,
  '오늘뭐먹조 ' || level, 
  '레시피 ' || level,
  1
FROM
  dual
CONNECT BY level <= 100;
commit;

select * from rec_board;
update rec_category set c_no = '';
UPDATE rec_board SET C_NO = NULL;

-- C_NO 컬럼의 제약 조건을 NULL로 변경
ALTER TABLE rec_category MODIFY C_NO NULL;
ALTER TABLE rec_board MODIFY C_NO NULL;

-- 새로운 데이터 할당
UPDATE rec_category SET C_NO = ROWNUM;
UPDATE rec_board SET C_NO = ROWNUM;

UPDATE rec_board rb
SET rb.C_NO = (
  SELECT rc.C_NO
  FROM rec_category rc
  WHERE rc.rowid = (
    SELECT MIN(rc2.rowid)
    FROM rec_category rc2
    WHERE rc2.C_NO = ROWNUM
  )
);

UPDATE rec_board rb
SET rb.C_NO = (
  SELECT rc.C_NO
  FROM (
    SELECT rc.C_NO, ROW_NUMBER() OVER (ORDER BY rc.C_NO) AS rn
    FROM rec_category rc
  ) rc
  WHERE rc.rn = MOD(rb.B_NO, 30) + 1
);

INSERT INTO rec_material (M_NO)
SELECT
    seq_rec_mate_num.nextval
FROM
  dual
CONNECT BY level <= 30;
commit;

INSERT INTO rec_ingredients (I_NO, I_NAME)
SELECT
    seq_rec_ing_num.nextval,
  '재료 ' || level
FROM
  dual
CONNECT BY level <= 30;
commit;

SELECT *
    FROM (
      SELECT t.*, ROWNUM rn
      FROM (
        SELECT rc.catename, rc.C_NO,
                rt.title, rt.regdate, rt.nickname,
                 rm.B_NO,
                  ri.I_NO, ri.I_NAME
        FROM rec_board rt, rec_category rc, rec_material rm, rec_ingredients ri
            WHERE rc.C_NO = rt.C_NO
            AND rt.B_NO = rm.B_NO
            AND rm.I_NO = ri.I_NO
            AND I_NAME like '%12%'
        ORDER BY B_NO DESC
      ) t
    )
    WHERE rn BETWEEN 1 AND 100;

drop table rec_board;
drop table rec_category;

--------------------------------------------------------------------------------

-- 현재 로그인 된 계정이 가진 테이블을 전부 조회 
SELECT 'DROP TABLE ' || TABLE_NAME || ';'  
FROM USER_ALL_TABLES ;

-- 조회 결과 값으로 얻은 아래 쿼리문 복붙 실행 
DROP TABLE REC_BOARD;
DROP TABLE REC_STEP;
DROP TABLE REC_INGREDIENTS;
DROP TABLE REC_CATEGORY;
DROP TABLE REC_NOTICE;
DROP TABLE REC_MEMBER;
DROP TABLE COM_BOARD;
DROP TABLE COM_FILE;
DROP TABLE REC_MATERIAL;
DROP TABLE REC_GRADE;
DROP TABLE REC_REPLY;
DROP TABLE REC_FILE;

--------------------------------------------------------------------------------
CREATE TABLE rec_board (
	B_NO number,
	title varchar2(200),
	nickName varchar2(50),
	regdate Date default sysdate,
	updatedate Date default sysdate,
	boomup number,
	intro varchar2(3000),
	cookTip varchar2(3000),
	viewCnt number,
	star number,
	mno number,
	C_NO number
);

CREATE TABLE rec_reply (
	R_NO number,
	replydate date DEFAULT sysdate,
	reply varchar2(2000),
	bno number,
	star number
);

CREATE TABLE rec_file (
	uuid varchar2(100),
	uploadpath varchar2(200),
	filetype char(1),
	filename varchar2(100),
	R_NO number,
	I_NO number,
	B_NO number,
	S_NO number
);

CREATE TABLE rec_step (
	S_NO number,
	step_content varchar2(2000),
	B_NO number
);

CREATE TABLE rec_ingredients (
	I_NO number,
	I_NAME varchar2(50),
	I_COOK varchar2(30),
	I_POWER varchar2(20),
	I_FriendFood varchar2(50),
	I_repair varchar2(200)
);

CREATE TABLE rec_category (
	C_NO number,
	cateName varchar2(30)
);

CREATE TABLE rec_notice (
	nno number,
	gubun varchar2(50),
	ntitle varchar2(50),
	ncontent varchar2(20),
	nwriter varchar2(20),
	nregDate date DEFAULT sysdate,
	ncount number DEFAULT 0
);

CREATE TABLE rec_member (
	mno number,
	email varchar2(50),
	pw varchar2(50),
	name varchar2(50),
	nickName varchar2(50),
	pNum varchar2(50),
	reg_date date DEFAULT sysdate,
	delYN char(1) DEFAULT 'N',
	gno number
);

CREATE TABLE com_board (
	com_bno number,
	nickName varchar2(20),
	com_title varchar2(100),
	com_content varchar2(500),
	regdate date,
	update_date date,
	replycnt number,
	mno number
);

CREATE TABLE com_file (
	uuid varchar2(100),
	uploadpath varchar2(200),
	filetype char(1),
	filename varchar2(100),
	com_bno number
);

CREATE TABLE com_reply (
	R_NO number,
	replydate date,
	reply varchar2(2000),
	com_bno number
);

CREATE TABLE rec_material (
	M_NO number,
	I_NO number,
	materialCnt number,
	B_NO number
);

CREATE TABLE rec_grade (
	gno number,
	grade varchar2(50) DEFAULT 'cook helper',
	benefit varchar2(50) DEFAULT '1000p'
);

ALTER TABLE rec_board ADD CONSTRAINT PK_REC_BOARD PRIMARY KEY (B_NO);
ALTER TABLE rec_reply ADD CONSTRAINT PK_REC_REPLY PRIMARY KEY (R_NO);
ALTER TABLE rec_file ADD CONSTRAINT PK_REC_FILE PRIMARY KEY (uuid);
ALTER TABLE rec_step ADD CONSTRAINT PK_REC_STEP PRIMARY KEY (S_NO);
ALTER TABLE rec_ingredients ADD CONSTRAINT PK_REC_INGREDIENTS PRIMARY KEY (I_NO);
ALTER TABLE rec_category ADD CONSTRAINT PK_REC_CATEGORY PRIMARY KEY (C_NO);
ALTER TABLE rec_notice ADD CONSTRAINT PK_REC_NOTICE PRIMARY KEY (nno);
ALTER TABLE rec_member ADD CONSTRAINT PK_REC_MEMBER PRIMARY KEY (mno);
ALTER TABLE com_board ADD CONSTRAINT PK_COM_BOARD PRIMARY KEY (com_bno);
ALTER TABLE com_file ADD CONSTRAINT PK_COM_FILE PRIMARY KEY (uuid);
ALTER TABLE com_reply ADD CONSTRAINT PK_COM_REPLY PRIMARY KEY (R_NO);
ALTER TABLE rec_material ADD CONSTRAINT PK_REC_MATERIAL PRIMARY KEY (M_NO);
ALTER TABLE rec_grade ADD CONSTRAINT PK_REC_GRADE PRIMARY KEY (gno);

ALTER TABLE rec_board ADD CONSTRAINT FK_rec_member_TO_rec_board_1 FOREIGN KEY (mno)
REFERENCES rec_member (mno);
ALTER TABLE rec_board ADD CONSTRAINT FK_rec_category_TO_rec_board_1 FOREIGN KEY (C_NO)
REFERENCES rec_category (C_NO);
ALTER TABLE rec_reply ADD CONSTRAINT FK_rec_board_TO_rec_reply_1 FOREIGN KEY (bno)
REFERENCES rec_board (B_NO);
ALTER TABLE rec_file ADD CONSTRAINT FK_rec_reply_TO_rec_file_1 FOREIGN KEY (R_NO)
REFERENCES rec_reply (R_NO);
ALTER TABLE rec_file ADD CONSTRAINT FK_rec_ing_TO_rec_file_1 FOREIGN KEY (I_NO)
REFERENCES rec_ingredients (I_NO);
ALTER TABLE rec_file ADD CONSTRAINT FK_rec_board_TO_rec_file_1 FOREIGN KEY (B_NO)
REFERENCES rec_board (B_NO);
ALTER TABLE rec_file ADD CONSTRAINT FK_rec_step_TO_rec_file_1 FOREIGN KEY (S_NO)
REFERENCES rec_step (S_NO);
ALTER TABLE rec_step ADD CONSTRAINT FK_rec_board_TO_rec_step_1 FOREIGN KEY (B_NO)
REFERENCES rec_board (B_NO);
ALTER TABLE rec_member ADD CONSTRAINT FK_rec_grade_TO_rec_member_1 FOREIGN KEY (gno)
REFERENCES rec_grade (gno);
ALTER TABLE com_board ADD CONSTRAINT FK_rec_member_TO_com_board_1 FOREIGN KEY (mno)
REFERENCES rec_member (mno);
ALTER TABLE com_file ADD CONSTRAINT FK_com_board_TO_com_file_1 FOREIGN KEY (com_bno)
REFERENCES com_board (com_bno);
ALTER TABLE com_reply ADD CONSTRAINT FK_com_board_TO_com_reply_1 FOREIGN KEY (com_bno)
REFERENCES com_board (com_bno);
ALTER TABLE rec_material ADD CONSTRAINT FK_rec_ing_TO_rec_material_1 FOREIGN KEY (I_NO)
REFERENCES rec_ingredients (I_NO);
ALTER TABLE rec_material ADD CONSTRAINT FK_rec_board_TO_rec_material_1 FOREIGN KEY (B_NO)
REFERENCES rec_board (B_NO);
