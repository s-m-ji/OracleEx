SELECT *
				FROM (
				  SELECT t.*, ROWNUM rn
				  FROM (
SELECT  ct.com_bno, ct.nickname, ct.com_title, ct.com_content, ct.replycnt,
				          		CASE WHEN ct.regdate >= TRUNC(SYSDATE) - 3 THEN 'new' ELSE '' END AS newpost,
				          		CASE
        WHEN ct.regdate >= TRUNC(SYSDATE) - 1 THEN
            CASE
                WHEN (SYSDATE - ct.regdate) * 24 * 60 < 60 THEN 
                    FLOOR((SYSDATE - ct.regdate) * 24 * 60) || '분 전'
                ELSE
                    CASE
                        WHEN (SYSDATE - ct.regdate) * 24 < 24 THEN
                            FLOOR((SYSDATE - ct.regdate) * 24) || '시간 전'
                        ELSE
                            TRUNC(SYSDATE - ct.regdate) || '일 전'
                    END
            END
        WHEN ct.regdate >= TRUNC(SYSDATE) - 7 THEN
            TRUNC(ROUND(SYSDATE - ct.regdate)) || '일 전'
        ELSE
            TO_CHAR(ct.regdate, 'YYYY/MM/DD')
    END AS regdate
				          	FROM com_board ct
				          	 -- WHERE com_content LIKE '%' || #{sWord} || '%'
                             
                              ) t
				)
				WHERE rn BETWEEN 1 AND 20;

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

delete rec_board;

-- notice 시퀀스 (NNO) 
CREATE SEQUENCE seq_rec_board_num
START WITH 0
INCREMENT BY 1
minvalue 0
MAXVALUE 1000
NOCYCLE
NOCACHE;

CREATE SEQUENCE SEQ_REPLY
START WITH 0
INCREMENT BY 1
minvalue 0
MAXVALUE 1000
NOCYCLE
NOCACHE;

CREATE SEQUENCE seq_gr_no
START WITH 0
INCREMENT BY 1
minvalue 0
MAXVALUE 1000
NOCYCLE
NOCACHE;



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

INSERT INTO rec_board 
SELECT
  seq_rec_board_num.nextval,
  '레시피 ' || level, 
  '회원 ' || level,
  sysdate,
  sysdate,
  level,
  '요리 소개 ' || level || '입니다.',
  '요리 팁 ' || level || '입니다.',
  level,
  1,
  1,
  11,
  level,
  null
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
            ---AND I_NAME like '%12%'
        ORDER BY B_NO DESC
      ) t
    )
    WHERE rn BETWEEN 1 AND 100;

drop table rec_board;
drop table rec_category;

SELECT *
    FROM (
      SELECT t.*, ROWNUM rn
      FROM (
              SELECT rt.title, rt.regdate, rt.nickname, rt.intro, rt.boomup,
              CASE WHEN rt.regdate >= TRUNC(SYSDATE) - 3 THEN 'new' ELSE '' END AS newpost,
              TO_CHAR(ROUND((TO_DATE(TO_CHAR(sysdate, 'YYYY-MM-DD HH24')) - TO_DATE(TO_CHAR(rt.regdate, 'YYYY-MM-DD HH24'))) * 24, 2)) as regtime1,
              ROUND((SYSDATE - rt.regdate) * 24, 2) AS regtime2,
              CASE WHEN TO_CHAR(rt.regdate, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD') 
                    THEN TRUNC(ROUND((SYSDATE - rt.regdate) * 24, 2)) || '시간 전'  
                    WHEN rt.regdate >= TRUNC(SYSDATE) - 7 AND rt.regdate < TRUNC(SYSDATE) THEN
            TRUNC(ROUND(SYSDATE - rt.regdate)) || '일 전'
                        ELSE TO_CHAR(rt.regdate, 'YYYY-MM-DD') 
                    END AS regtime,
                        rc.C_NO1, rc.C_NO2
                FROM rec_board rt, rec_category rc
                 WHERE rc.C_NO1 = rt.C_NO1
                  AND rc.C_NO2 = rt.C_NO2
                    --AND rc.C_NO1 = 1 AND intro LIKE '%%'
            -- ORDER BY rt.regdate DESC
            ORDER BY rt.boomup DESC
      ) t
    )
    WHERE rn BETWEEN 1 AND 100;
    
    SELECT *
FROM (
    SELECT t.*, ROWNUM rn
    FROM (
        SELECT
            rt.title,
            rt.nickname,
            rt.intro,
            rt.boomup,
            CASE
                WHEN rt.regdate >= TRUNC(SYSDATE) - 3 THEN 'new'
                ELSE ''
            END AS newpost,
            CASE
                WHEN rt.regdate = TRUNC(SYSDATE) THEN
                    ROUND((TO_DATE(TO_CHAR(sysdate, 'YYYY-MM-DD HH24')) - TO_DATE(TO_CHAR(rt.regdate, 'YYYY-MM-DD HH24'))) * 24, 2) 
                ELSE
                    TO_CHAR(rt.regdate, 'YYYY년 MM월 DD일')
            END AS regdate,
            rc.C_NO1,
            rc.C_NO2
        FROM
            rec_board rt
            JOIN rec_category rc ON rc.C_NO1 = rt.C_NO1 AND rc.C_NO2 = rt.C_NO2
        -- WHERE rc.C_NO1 = 1 AND rt.intro LIKE '%%'
        -- ORDER BY rt.regdate DESC
        ORDER BY rt.boomup DESC
    ) t
)
WHERE rn BETWEEN 1 AND 100;

select extract( day from diff ) days,
           extract( hour from diff ) hours,
           extract( minute from diff ) minutes,
           extract( second from diff ) seconds
from (select systimestamp - to_timestamp( '2012-07-23', 'yyyy-mm-dd' ) diff
           from dual);
           
SELECT
    EXTRACT(DAY FROM diff) AS days,
    EXTRACT(HOUR FROM diff) AS hours,
    EXTRACT(MINUTE FROM diff) AS minutes,
    EXTRACT(SECOND FROM diff) AS seconds
FROM (
    SELECT SYSTIMESTAMP - TO_DATE(rt.regdate, 'YYYY-MM-DD') AS diff
    FROM rec_board rt
);

SELECT ROUND((TO_DATE(TO_CHAR(sysdate, 'YYYY-MM-DD HH24')) - TO_DATE(TO_CHAR(rt.regdate, 'YYYY-MM-DD HH24'))) * 24, 2) || '시간 전' as reg
  FROM rec_board rt;

SELECT  ROUND((TO_DATE(TO_CHAR(sysdate, 'YYYY-MM-DD HH24')) - TO_DATE(TO_CHAR(rt.regdate, 'YYYY-MM-DD HH24'))) * 24, 2) || '시간 전' as regtime FROM rec_board rt;

SELECT rt.title, rt.regdate, rt.nickname, rt.intro, rc.C_NO1, rc.C_NO2
FROM rec_board rt, rec_category rc
WHERE rc.C_NO1(+) = rt.C_NO1
AND rc.C_NO2(+) = rt.C_NO2
ORDER BY rt.B_NO DESC;

delete rec_category;

SELECT *
    FROM (
      SELECT t.*, ROWNUM rn
      FROM (
             SELECT rt.title, rt.nickname, rt.intro, rt.b_no, rt.boomup, rt.viewcnt,
                    CASE WHEN rt.regdate >= TRUNC(SYSDATE) - 3 THEN 'new' ELSE '' END AS newpost,
                   CASE
        WHEN rt.regdate >= TRUNC(SYSDATE) - 1 THEN
          FLOOR((SYSDATE - rt.regdate) * 24 * 60) || '분 전'
        WHEN rt.regdate >= TRUNC(SYSDATE) - 7 THEN
          TRUNC(ROUND(SYSDATE - rt.regdate)) || '일 전'
        ELSE
          TO_CHAR(rt.regdate, 'YYYY/MM/DD')
      END AS regdate,
                            rc.C_NO1, rc.C_NO2, rc.catename1, rc.catename2 
                FROM rec_board rt, rec_category rc
                 WHERE rc.C_NO1 = rt.C_NO1
                  AND rc.C_NO2 = rt.C_NO2
                  ORDER BY rt.regdate DESC
                  ) t
    )
    WHERE rn BETWEEN 1 AND 50;

select * from rec_board order by b_no;

select * from com_board;

SELECT T.* 
    , uploadpath||uuid||'_'||filename savepath
     , DECODE(filetype , 'I', uploadpath||'thum_'||uuid||'_'||filename, 'file') t_savepath
 			FROM rec_file T WHERE FILETYPE = 'B' AND b_no = 2;
--------------------------------------------------------------------------------
-- view.jsp 업데이트
alter table rec_board 
add videoLink varchar2(3000);

-- rec_board
Insert into RECIPE.REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,C_NO1,C_NO2,MNO,REPLYCNT,VIDEOLINK) values (2,'냉동만두요리 만두버섯전골 만드는법 만두전골 만들기 버섯전골 레시피','그럴만두하지',to_date('23/08/07 14:39:08','RR/MM/DD hh24:MI:SS'),to_date('23/08/07 14:39:08','RR/MM/DD hh24:MI:SS'),0,'냉장고에 있는 재료를 생각하다가 오랫만에 깔끔한 국물의 만두버섯전골을 만들어 먹어야겠다 싶더군요','뜨거운물 말고 찬물을 넣으실꺼라면 만두는 물이 끓고나면 넣어주세요',0,0,1,2,1,0,'https://youtu.be/_TGhAtAqrLk')
;
ALTER TABLE rec_ingredients MODIFY i_power VARCHAR2(300); -- 데이터 타입을 먼저 변경해주세요
ALTER TABLE rec_ingredients modify i_cook varchar2(300); -- 

delete REC_INGREDIENTS;
delete rec_material;

Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (2,'배추','배추볶음/배추롤/소고기배추말이','변비/피로회복/피부미용','두부','배추를 반으로 잘라 흐르는 물에 씻는다.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (3,'팽이버섯','소불고기야채정식/팽이버섯말이/육우채소말이','성장발육/항암효과/콜레스테롤저하','육류','밑동을 잘라내고 흐르는 물에 씻는다.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (4,'양파','닭볶음탕/잡채/제육볶음','혈관질환/불면증/피로회복','육류','뿌리 부분은 잘라내고 대를 자른 부분에서부터 갈색의 마른 껍질을 벗긴 후 용도에 따라 썰어서 사용');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (5,'청양고추','된장찌개/두부조림/닭볶음탕/콩나물국','다이어트/피부미용/스트레스해소','우유','손질하지 않은 것은 밀봉하여 냉장보관, 손질하거나 다진 것은 냉동보관한다.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (6,'대파','소고기무국/제육볶음/순두부찌개/어묵볶음','혈액순환/피로회복/면역력','미역','뿌리 부분은 잘라내고, 흰대와 줄기 부분을 분리한다.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (7,'물','모든음식','장기능 개선/노폐물 제거/피로회복','모든음식','생수의 경우 서늘하고 직사광선이 없는 곳에서 보관하고, 개봉후에는 냉장 보관한다.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (8,'떡국떡','떡국/떡만두국/만두전골','쫀득쫀득','국종류','잘라서 보관하거나 통으로 냉동보관한다.');

Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values ('2','2','6장','2','배추');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (3,3,'1개',2,'팽이버섯');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (4,4,'1/2개',2,'양파');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (5,5,'1개',2,'청양고추');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (6,6,'1/3대',2,'대파');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (7,7,'4~5컵',2,'물');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (8,8,'1/2컵',2,'떡국떡');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (9,9,'1팩',2,'냉동만두');

-- rec_step( 조리순서 테이블 )

Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (2,'만두버섯전골에 들어갈 재료부터 손질해주세요 알배기배추는 작은사이즈를 사용하였답니다',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (3,'손질한 야채는 전골냄비에 이쁘게 담아주시면 되요 알배기배추, 새송이버섯, 만가닥버섯 그리고 대파를 넣어주었고 샤브샤브용 고기는 미리 찬물에 담궈 핏물을 뺀 후 사용하였어요',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (4,'냉동실에 보관중이던 냉동고기만두 5개와 김치만두 2개를 넣어주었답니다',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (5,'전골류는 끓여내기전의 모습이 더욱 이쁜듯 하여 늘 사진을 미리 찍어놓는 편이예요',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (6,'재료가 잠길정도의 물을 부어주시면 되는데 이때 물은 미리 끓여놓은 후 넣는걸 추천드려요 너무 오랜시간 끓이게 되면 만두가 터질 위험이 있거든요 ~',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (7,'쯔유와 치킨스톡을 넣어 간을 해 준 후 보글보글 끓여줍니다',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (8,'끓는물을 넣어 끓여낸지라 금방 끓기시작하는데요 끓기시작하고 4~ 5분정도 바글바글 끓여주세요 이때 올라오는 기름과 불순물은 최대한 제거해줍니다',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (9,'마지막에 간을 본 후 어간장으로 추가간을 해주었어요 ~',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (10,'깔끔한 스타일의 만두버섯전골 완성이예요 !',2);

-- rec_file ( 파일 테이블 ) 

Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('cae8b0ce-a936-415a-a173-cbb63c0ba17a','2023\08\07\','R','만두5.jpg',4,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('fb902b7f-7b1b-466b-8a16-e11b491b39ee','2023\08\07\','R','만전3.jpg',5,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('13d2f80b-45c4-4782-b2a6-60473548b531','2023\08\07\','R','만전4.jpg',6,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('2f72e10f-9ca0-4105-bb9b-183a3021178e','2023\08\07\','R','야채쿵야.jpg',7,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('87153209-d0d0-4b7e-83cb-67c1ab11700f','2023\08\07\','B','육칼만두전골.jpg',null,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('e3845ed4f68ea245e1543240e4c20789','2023\08\07\','M','배추.jpg',null,2,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('PPPP','2023\08\07\','M','팽이버섯.jpg',null,3,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('5c57d3e425b8a17ef4a9e715160b7f32','2023\08\07\','M','양파.jpg',null,4,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('DWDWDWDDDD','2023\08\07\','M','청양고추.jpg',null,5,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('cf95f7a9a402160e883887b882107745','2023\08\07\','M','대파.jpg',null,6,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('6fbc62b02932672f4b15fb5be626c7c6','2023\08\07\','M','물컵.jpg',null,7,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('ErE','2023\08\07\','M','떡국떡.jpg',null,8,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step1','2023\08\07\','S','만두전골요리순서1.JPG',null,null,2,2);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step2','2023\08\07\','S','만두전골요리순서2.JPG',null,null,2,3);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step3','2023\08\07\','S','만두전골요리순서3.JPG',null,null,2,4);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step4','2023\08\07\','S','만두전골요리순서4.JPG',null,null,2,5);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step9','2023\08\07\','S','만두전골요리순서9.JPG',null,null,2,6);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step6','2023\08\07\','S','만두전골요리순서6.JPG',null,null,2,7);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step7','2023\08\07\','S','만두전골요리순서7.JPG',null,null,2,8);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step8','2023\08\07\','S','만두전골요리순서8.JPG',null,null,2,9);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step5','2023\08\07\','S','만두전골요리순서5.JPG',null,null,2,10);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('cdd94a1d-50a3-40d5-b02f-1d344e9578ea','2023\08\07\','R','요리사.jpg',2,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('8ff2c8f4-ce66-4be6-8716-0f70272dbb5a','2023\08\07\','R','2323.jpg',8,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('64cdc6dc-d046-4a4d-b262-fc0de464b088','2023\08\07\','R','2323.jpg',1,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('add1c469-6f43-4314-9c1e-ce5e694c85b8','2023\08\07\','R','만전2.jpg',3,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('f16b36d1-5d4e-4ac8-92cd-8b9ae078e898','2023\08\07\','R','요리사.jpg',11,null,2,null);
--------------------------------------------------------------------------------

Insert into REC_CATEGORY values (1,'종류별',11,'국/탕/찌개');
Insert into REC_CATEGORY values (1,'종류별',12,'면/국수/파스타');
Insert into REC_CATEGORY values (1,'종류별',13,'밥/죽');
Insert into REC_CATEGORY values (1,'종류별',14,'빵/떡');
Insert into REC_CATEGORY values (1,'종류별',15,'반찬');
Insert into REC_CATEGORY values (1,'종류별',16,'샐러드');
Insert into REC_CATEGORY values (1,'종류별',17,'소스');
Insert into REC_CATEGORY values (1,'종류별',18,'차/음료/술');

Insert into REC_CATEGORY values (2,'재료별',21,'육류');
Insert into REC_CATEGORY values (2,'재료별',22,'해물류');
Insert into REC_CATEGORY values (2,'재료별',23,'과일류');
Insert into REC_CATEGORY values (2,'재료별',24,'달걀/유제품');
Insert into REC_CATEGORY values (2,'재료별',25,'채소류');
Insert into REC_CATEGORY values (2,'재료별',26,'견과류');
Insert into REC_CATEGORY values (2,'재료별',27,'쌀/밀가루');

Insert into REC_CATEGORY values (3,'상황별',31,'간식');
Insert into REC_CATEGORY values (3,'상황별',32,'안주');
Insert into REC_CATEGORY values (3,'상황별',33,'파티');
Insert into REC_CATEGORY values (3,'상황별',34,'도시락');
Insert into REC_CATEGORY values (3,'상황별',35,'간식');
Insert into REC_CATEGORY values (3,'상황별',36,'이유식');
Insert into REC_CATEGORY values (3,'상황별',37,'초스피드');

Insert into REC_CATEGORY values (4,'방법별',41,'볶음');
Insert into REC_CATEGORY values (4,'방법별',42,'조림');
Insert into REC_CATEGORY values (4,'방법별',43,'비빔');
Insert into REC_CATEGORY values (4,'방법별',44,'절임');
Insert into REC_CATEGORY values (4,'방법별',45,'튀김');
Insert into REC_CATEGORY values (4,'방법별',46,'삶기');
Insert into REC_CATEGORY values (4,'방법별',47,'굽기');
Insert into REC_CATEGORY values (4,'방법별',48,'끓이기');


--------------------------------------------------------------------------------

-- 현재 로그인 된 계정이 가진 테이블을 전부 조회 
SELECT 'DROP TABLE ' || TABLE_NAME || ' CASCADE CONSTRAINTS;'  
FROM USER_ALL_TABLES ;

-- 조회 결과 값으로 얻은 아래 쿼리문 복붙 실행 
DROP TABLE REC_STEP;
DROP TABLE REC_INGREDIENTS;
DROP TABLE REC_NOTICE;
DROP TABLE REC_MEMBER;
DROP TABLE COM_BOARD;
DROP TABLE COM_FILE;
DROP TABLE REC_MATERIAL;
DROP TABLE REC_MATERIAL2;
DROP TABLE REC_GRADE;
DROP TABLE REC_REPLY;

DROP TABLE REC_CATEGORY;
DROP TABLE REC_BOARD CASCADE CONSTRAINTS;
DROP TABLE REC_FILE;

DROP TABLE REC_STEP CASCADE CONSTRAINTS;
DROP TABLE REC_INGREDIENTS CASCADE CONSTRAINTS;
DROP TABLE REC_MEMBER CASCADE CONSTRAINTS;
DROP TABLE REC_GRADE CASCADE CONSTRAINTS;

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

rollback;


-- 테이블 재생성 08/02 (NOT NULL 생략)------------------------------------------------------------------------------
CREATE TABLE rec_board_test2 (
    B_NO NUMBER NOT NULL,
    title VARCHAR2(200) NOT NULL,
    nickName VARCHAR2(50) NOT NULL,
    regdate DATE NOT NULL,
    updatedate DATE NULL,
    boomup NUMBER NOT NULL,
    intro VARCHAR2(3000) NOT NULL,
    cookTip VARCHAR2(3000) NOT NULL,
    viewCnt NUMBER NULL,
    star NUMBER NULL,
    C_NO1 number,
    C_NO2 number,
    mno NUMBER NOT NULL,
    REPLYCNT NUMBER,	
    CONSTRAINT PK_REC_B3 PRIMARY KEY (B_NO)
);

CREATE TABLE rec_reply (
    R_NO NUMBER NOT NULL,
    replydate DATE DEFAULT sysdate NOT NULL,
    reply VARCHAR2(2000) NOT NULL,
    star number,
    b_no NUMBER NOT NULL,
    writer varchar2(200),
    CONSTRAINT PK_REC_R PRIMARY KEY (R_NO)
);
--  필요 재료 테이블 추가 
CREATE TABLE "REC_MATERIAL" 
   (	"M_NO" NUMBER, 
	"I_NO" NUMBER, 
	"MATERIALCNT" NUMBER, 
	"B_NO" NUMBER, 
	"I_NAME" VARCHAR2(40 BYTE)
   );

-- 좋아요 테이블 신규 추가 
CREATE TABLE "LIKE_RECIPE" 
   (	"L_NO" NUMBER, 
	"M_NO" NUMBER, 
	"B_NO" NUMBER
   );

CREATE TABLE rec_step (
    S_NO NUMBER NOT NULL,
    step_content VARCHAR2(2000) NOT NULL,
    B_NO NUMBER NOT NULL,
    CONSTRAINT PK_REC_S PRIMARY KEY (S_NO)
);

CREATE TABLE rec_ingredients (
    I_NO NUMBER NOT NULL,
    I_NAME VARCHAR2(50) NOT NULL,
    I_COOK VARCHAR2(30) NOT NULL,
    I_POWER VARCHAR2(20) NOT NULL,
    I_FriendFood VARCHAR2(50),
    I_repair VARCHAR2(200),
    CONSTRAINT PK_REC_I PRIMARY KEY (I_NO)
);

-- 일반 댓글 테이블추가
CREATE TABLE REC_GENERALREPLY (
   	GR_NO NUMBER, 
	"CONTENT" VARCHAR2(2000 BYTE), 
	"REPLYER" VARCHAR2(20 BYTE), 
	"REGDATE" DATE DEFAULT sysdate, 
	"UPDATEDATA" DATE DEFAULT sysdate, 
	"B_NO" NUMBER
   );

CREATE TABLE rec_member (
    mno NUMBER primary key,
    email varchar(50) not null,
    pw varchar2(200) not null,
    name varchar2(50) not null,
    nickName varchar2(50) not null,
    pnum varchar2 (50) not null,
    reg_date DATE DEFAULT sysdate,
    gno number DEFAULT 1,
    delYN char(1) default 'N',
    FOREIGN KEY (gno) REFERENCES rec_grade(gno)
);

CREATE TABLE rec_notice (
    nno NUMBER NOT NULL,
    ntitle VARCHAR2(50) NOT NULL,
    ncontent VARCHAR2(2000) NOT NULL,
    nwriter VARCHAR2(20) NOT NULL,
    nregDate DATE DEFAULT sysdate,
    ncount NUMBER DEFAULT 0,
    gubun varchar2(50) default '일반',
    CONSTRAINT PK_REC_N PRIMARY KEY (nno)
);

CREATE TABLE rec_grade (
    gno NUMBER default 1 primary key,
    grade VARCHAR2(50) default 'cook helper',
    benefit VARCHAR2(50) default '1,000p'
);

CREATE TABLE com_board (
    com_bno NUMBER NOT NULL,
    nickName VARCHAR2(20) NOT NULL,
    com_title VARCHAR2(100) NOT NULL,
    com_content VARCHAR2(500) NOT NULL,
    regdate DATE NOT NULL,
    update_date DATE NOT NULL,
    replycnt NUMBER NOT NULL,
    mno NUMBER NOT NULL,
    CONSTRAINT PK_COM_B PRIMARY KEY (com_bno)
);

CREATE TABLE com_file (
    uuid VARCHAR2(100) NOT NULL,
    uploadpath VARCHAR2(200) NOT NULL,
    filetype CHAR(1) NOT NULL,
    filename VARCHAR2(100) NOT NULL,
    com_bno NUMBER NOT NULL,
    CONSTRAINT PK_COM_F PRIMARY KEY (uuid)
);

CREATE TABLE com_reply (
    R_NO NUMBER NOT NULL,
    replydate DATE NOT NULL,
    reply VARCHAR2(2000) NOT NULL,
    com_bno NUMBER NOT NULL,
    CONSTRAINT PK_COM_R PRIMARY KEY (R_NO)
);

-- member 시퀀스 (MNO)
create sequence SEQ_MEMBER
START WITH 0
INCREMENT BY 1
minvalue 0
MAXVALUE 1000
NOCYCLE
NOCACHE;

-- notice 시퀀스 (NNO) 
CREATE SEQUENCE SEQ_NOTICE
START WITH 0
INCREMENT BY 1
minvalue 0
MAXVALUE 1000
NOCYCLE
NOCACHE;

rollback;

-- 시퀀스 추가
delete REC_BOARD_test;
INSERT INTO REC_BOARD_test
SELECT 
  seq_rec_board_num.nextval,
  '레시피 ' || LEVEL,
  '회원 ' || LEVEL,
  sysdate,
  sysdate,
  LEVEL,
  '요리 소개 ' || LEVEL || '입니다.',
  '요리 팁 ' || LEVEL || '입니다.',
  LEVEL,
  1,
  1,
  11,
  LEVEL,
  NULL
FROM DUAL
CONNECT BY LEVEL <= 100;

INSERT INTO REC_BOARD_test
SELECT 
  seq_rec_board_num.nextval,
  '레시피 ' || (LEVEL),
  '회원 ' || (LEVEL),
  sysdate,
  sysdate,
  LEVEL + 10,
  '요리 소개 ' || (LEVEL + 10) || '입니다.',
  '요리 팁 ' || (LEVEL + 10) || '입니다.',
  LEVEL + 10,
  1,
  1,
  10 + TRUNC((LEVEL - 1) / 3) * 10,
  LEVEL + 10,
  NULL
FROM DUAL
CONNECT BY LEVEL <= 8;


--------------------------------------------------------------------------------
Insert into REC_BOARD  values (1,'레시피 1','회원 1',sysdate,sysdate,1,'요리 소개 1입니다.','요리 팁 1입니다.',1,1,1,11,1,null);
Insert into REC_BOARD  values (2,'레시피 2','회원 2',sysdate,sysdate,2,'요리 소개 2입니다.','요리 팁 2입니다.',2,1,1,12,2,null);
Insert into REC_BOARD  values (3,'레시피 3','회원 3',sysdate,sysdate,3,'요리 소개 3입니다.','요리 팁 3입니다.',3,1,1,13,3,null);
Insert into REC_BOARD  values (4,'레시피 4','회원 4',sysdate,sysdate,4,'요리 소개 4입니다.','요리 팁 4입니다.',4,1,1,14,4,null);
Insert into REC_BOARD  values (5,'레시피 5','회원 5',sysdate,sysdate,5,'요리 소개 5입니다.','요리 팁 5입니다.',5,1,1,15,5,null);
Insert into REC_BOARD  values (6,'레시피 6','회원 6',sysdate,sysdate,6,'요리 소개 6입니다.','요리 팁 6입니다.',6,1,1,16,6,null);
Insert into REC_BOARD  values (7,'레시피 7','회원 7',sysdate,sysdate,7,'요리 소개 7입니다.','요리 팁 7입니다.',7,1,1,17,7,null);
Insert into REC_BOARD  values (8,'레시피 8','회원 8',sysdate,sysdate,8,'요리 소개 8입니다.','요리 팁 8입니다.',8,1,1,18,8,null);
Insert into REC_BOARD  values (9,'레시피 9','회원 9',sysdate,sysdate,9,'요리 소개 9입니다.','요리 팁 9입니다.',9,1,2,21,9,null);
Insert into REC_BOARD  values (10,'레시피 10','회원 10',sysdate,sysdate,10,'요리 소개 10입니다.','요리 팁 10입니다.',10,1,2,22,10,null);
Insert into REC_BOARD  values (11,'레시피 11','회원 11',sysdate,sysdate,11,'요리 소개 11입니다.','요리 팁 11입니다.',11,1,2,23,11,null);
Insert into REC_BOARD  values (12,'레시피 12','회원 12',sysdate,sysdate,12,'요리 소개 12입니다.','요리 팁 12입니다.',12,1,2,24,12,null);
Insert into REC_BOARD  values (13,'레시피 13','회원 13',sysdate,sysdate,13,'요리 소개 13입니다.','요리 팁 13입니다.',13,1,2,25,13,null);
Insert into REC_BOARD  values (14,'레시피 14','회원 14',sysdate,sysdate,14,'요리 소개 14입니다.','요리 팁 14입니다.',14,1,2,26,14,null);
Insert into REC_BOARD  values (15,'레시피 15','회원 15',sysdate,sysdate,15,'요리 소개 15입니다.','요리 팁 15입니다.',15,1,2,27,15,null);
Insert into REC_BOARD  values (16,'레시피 16','회원 16',sysdate,sysdate,16,'요리 소개 16입니다.','요리 팁 16입니다.',16,1,3,31,16,null);
Insert into REC_BOARD  values (17,'레시피 17','회원 17',sysdate,sysdate,17,'요리 소개 17입니다.','요리 팁 17입니다.',17,1,3,32,17,null);
Insert into REC_BOARD  values (18,'레시피 18','회원 18',sysdate,sysdate,18,'요리 소개 18입니다.','요리 팁 18입니다.',18,1,3,33,18,null);
Insert into REC_BOARD  values (19,'레시피 19','회원 19',sysdate,sysdate,19,'요리 소개 19입니다.','요리 팁 19입니다.',19,1,3,34,19,null);
Insert into REC_BOARD  values (20,'레시피 20','회원 20',sysdate,sysdate,20,'요리 소개 20입니다.','요리 팁 20입니다.',20,1,3,35,20,null);
Insert into REC_BOARD  values (21,'레시피 21','회원 21',sysdate,sysdate,21,'요리 소개 21입니다.','요리 팁 21입니다.',21,1,3,36,21,null);
Insert into REC_BOARD  values (22,'레시피 22','회원 22',sysdate,sysdate,22,'요리 소개 22입니다.','요리 팁 22입니다.',22,1,3,37,22,null);
Insert into REC_BOARD  values (23,'레시피 23','회원 23',sysdate,sysdate,23,'요리 소개 23입니다.','요리 팁 23입니다.',23,1,4,41,23,null);
Insert into REC_BOARD  values (24,'레시피 24','회원 24',sysdate,sysdate,24,'요리 소개 24입니다.','요리 팁 24입니다.',24,1,4,42,24,null);
Insert into REC_BOARD  values (25,'레시피 25','회원 25',sysdate,sysdate,25,'요리 소개 25입니다.','요리 팁 25입니다.',25,1,4,43,25,null);
Insert into REC_BOARD  values (26,'레시피 26','회원 26',sysdate,sysdate,26,'요리 소개 26입니다.','요리 팁 26입니다.',26,1,4,44,26,null);
Insert into REC_BOARD  values (27,'레시피 27','회원 27',sysdate,sysdate,27,'요리 소개 27입니다.','요리 팁 27입니다.',27,1,4,45,27,null);
Insert into REC_BOARD  values (28,'레시피 28','회원 28',sysdate,sysdate,28,'요리 소개 28입니다.','요리 팁 28입니다.',28,1,4,46,28,null);
Insert into REC_BOARD  values (29,'레시피 29','회원 29',sysdate,sysdate,29,'요리 소개 29입니다.','요리 팁 29입니다.',29,1,4,47,29,null);
Insert into REC_BOARD  values (30,'레시피 30','회원 30',sysdate,sysdate,30,'요리 소개 30입니다.','요리 팁 30입니다.',30,1,4,48,30,null);
Insert into REC_BOARD  values (31,'레시피 31','회원 31',sysdate,sysdate,31,'요리 소개 31입니다.','요리 팁 31입니다.',31,1,1,11,31,null);
Insert into REC_BOARD  values (32,'레시피 32','회원 32',sysdate,sysdate,32,'요리 소개 32입니다.','요리 팁 32입니다.',32,1,1,12,32,null);
Insert into REC_BOARD  values (33,'레시피 33','회원 33',sysdate,sysdate,33,'요리 소개 33입니다.','요리 팁 33입니다.',33,1,1,13,33,null);
Insert into REC_BOARD  values (34,'레시피 34','회원 34',sysdate,sysdate,34,'요리 소개 34입니다.','요리 팁 34입니다.',34,1,1,14,34,null);
Insert into REC_BOARD  values (35,'레시피 35','회원 35',sysdate,sysdate,35,'요리 소개 35입니다.','요리 팁 35입니다.',35,1,1,15,35,null);
Insert into REC_BOARD  values (36,'레시피 36','회원 36',sysdate,sysdate,36,'요리 소개 36입니다.','요리 팁 36입니다.',36,1,1,16,36,null);
Insert into REC_BOARD  values (37,'레시피 37','회원 37',sysdate,sysdate,37,'요리 소개 37입니다.','요리 팁 37입니다.',37,1,1,17,37,null);
Insert into REC_BOARD  values (38,'레시피 38','회원 38',sysdate,sysdate,38,'요리 소개 38입니다.','요리 팁 38입니다.',38,1,1,18,38,null);
Insert into REC_BOARD  values (39,'레시피 39','회원 39',sysdate,sysdate,39,'요리 소개 39입니다.','요리 팁 39입니다.',39,1,2,21,39,null);
Insert into REC_BOARD  values (40,'레시피 40','회원 40',sysdate,sysdate,40,'요리 소개 40입니다.','요리 팁 40입니다.',40,1,2,22,40,null);
Insert into REC_BOARD  values (41,'레시피 41','회원 41',sysdate,sysdate,41,'요리 소개 41입니다.','요리 팁 41입니다.',41,1,2,23,41,null);
Insert into REC_BOARD  values (42,'레시피 42','회원 42',sysdate,sysdate,42,'요리 소개 42입니다.','요리 팁 42입니다.',42,1,2,24,42,null);
Insert into REC_BOARD  values (43,'레시피 43','회원 43',sysdate,sysdate,43,'요리 소개 43입니다.','요리 팁 43입니다.',43,1,2,25,43,null);
Insert into REC_BOARD  values (44,'레시피 44','회원 44',sysdate,sysdate,44,'요리 소개 44입니다.','요리 팁 44입니다.',44,1,2,26,44,null);
Insert into REC_BOARD  values (45,'레시피 45','회원 45',sysdate,sysdate,45,'요리 소개 45입니다.','요리 팁 45입니다.',45,1,2,27,45,null);
Insert into REC_BOARD  values (46,'레시피 46','회원 46',sysdate,sysdate,46,'요리 소개 46입니다.','요리 팁 46입니다.',46,1,3,31,46,null);
Insert into REC_BOARD  values (47,'레시피 47','회원 47',sysdate,sysdate,47,'요리 소개 47입니다.','요리 팁 47입니다.',47,1,3,32,47,null);
Insert into REC_BOARD  values (48,'레시피 48','회원 48',sysdate,sysdate,48,'요리 소개 48입니다.','요리 팁 48입니다.',48,1,3,33,48,null);
Insert into REC_BOARD  values (49,'레시피 49','회원 49',sysdate,sysdate,49,'요리 소개 49입니다.','요리 팁 49입니다.',49,1,3,34,49,null);
Insert into REC_BOARD  values (50,'레시피 50','회원 50',sysdate,sysdate,50,'요리 소개 50입니다.','요리 팁 50입니다.',50,1,3,35,50,null);
Insert into REC_BOARD  values (51,'레시피 51','회원 51',sysdate,sysdate,51,'요리 소개 51입니다.','요리 팁 51입니다.',51,1,3,36,51,null);
Insert into REC_BOARD  values (52,'레시피 52','회원 52',sysdate,sysdate,52,'요리 소개 52입니다.','요리 팁 52입니다.',52,1,3,37,52,null);
Insert into REC_BOARD  values (53,'레시피 53','회원 53',sysdate,sysdate,53,'요리 소개 53입니다.','요리 팁 53입니다.',53,1,4,41,53,null);
Insert into REC_BOARD  values (54,'레시피 54','회원 54',sysdate,sysdate,54,'요리 소개 54입니다.','요리 팁 54입니다.',54,1,4,42,54,null);
Insert into REC_BOARD  values (55,'레시피 55','회원 55',sysdate,sysdate,55,'요리 소개 55입니다.','요리 팁 55입니다.',55,1,4,43,55,null);
Insert into REC_BOARD  values (56,'레시피 56','회원 56',sysdate,sysdate,56,'요리 소개 56입니다.','요리 팁 56입니다.',56,1,4,44,56,null);
Insert into REC_BOARD  values (57,'레시피 57','회원 57',sysdate,sysdate,57,'요리 소개 57입니다.','요리 팁 57입니다.',57,1,4,45,57,null);
Insert into REC_BOARD  values (58,'레시피 58','회원 58',sysdate,sysdate,58,'요리 소개 58입니다.','요리 팁 58입니다.',58,1,4,46,58,null);
Insert into REC_BOARD  values (59,'레시피 59','회원 59',sysdate,sysdate,59,'요리 소개 59입니다.','요리 팁 59입니다.',59,1,4,47,59,null);
Insert into REC_BOARD  values (60,'레시피 60','회원 60',sysdate,sysdate,60,'요리 소개 60입니다.','요리 팁 60입니다.',60,1,4,48,60,null);
Insert into REC_BOARD  values (61,'레시피 61','회원 61',sysdate,sysdate,61,'요리 소개 61입니다.','요리 팁 61입니다.',61,1,1,11,61,null);
Insert into REC_BOARD  values (62,'레시피 62','회원 62',sysdate,sysdate,62,'요리 소개 62입니다.','요리 팁 62입니다.',62,1,1,12,62,null);
Insert into REC_BOARD  values (63,'레시피 63','회원 63',sysdate,sysdate,63,'요리 소개 63입니다.','요리 팁 63입니다.',63,1,1,13,63,null);
Insert into REC_BOARD  values (64,'레시피 64','회원 64',sysdate,sysdate,64,'요리 소개 64입니다.','요리 팁 64입니다.',64,1,1,14,64,null);
Insert into REC_BOARD  values (65,'레시피 65','회원 65',sysdate,sysdate,65,'요리 소개 65입니다.','요리 팁 65입니다.',65,1,1,15,65,null);
Insert into REC_BOARD  values (66,'레시피 66','회원 66',sysdate,sysdate,66,'요리 소개 66입니다.','요리 팁 66입니다.',66,1,1,16,66,null);
Insert into REC_BOARD  values (67,'레시피 67','회원 67',sysdate,sysdate,67,'요리 소개 67입니다.','요리 팁 67입니다.',67,1,1,17,67,null);
Insert into REC_BOARD  values (68,'레시피 68','회원 68',sysdate,sysdate,68,'요리 소개 68입니다.','요리 팁 68입니다.',68,1,1,18,68,null);
Insert into REC_BOARD  values (69,'레시피 69','회원 69',sysdate,sysdate,69,'요리 소개 69입니다.','요리 팁 69입니다.',69,1,2,21,69,null);
Insert into REC_BOARD  values (70,'레시피 70','회원 70',sysdate,sysdate,70,'요리 소개 70입니다.','요리 팁 70입니다.',70,1,2,22,70,null);
Insert into REC_BOARD  values (71,'레시피 71','회원 71',sysdate,sysdate,71,'요리 소개 71입니다.','요리 팁 71입니다.',71,1,2,23,71,null);
Insert into REC_BOARD  values (72,'레시피 72','회원 72',sysdate,sysdate,72,'요리 소개 72입니다.','요리 팁 72입니다.',72,1,2,24,72,null);
Insert into REC_BOARD  values (73,'레시피 73','회원 73',sysdate,sysdate,73,'요리 소개 73입니다.','요리 팁 73입니다.',73,1,2,25,73,null);
Insert into REC_BOARD  values (74,'레시피 74','회원 74',sysdate,sysdate,74,'요리 소개 74입니다.','요리 팁 74입니다.',74,1,2,26,74,null);
Insert into REC_BOARD  values (75,'레시피 75','회원 75',sysdate,sysdate,75,'요리 소개 75입니다.','요리 팁 75입니다.',75,1,2,27,75,null);
Insert into REC_BOARD  values (76,'레시피 76','회원 76',sysdate,sysdate,76,'요리 소개 76입니다.','요리 팁 76입니다.',76,1,3,31,76,null);
Insert into REC_BOARD  values (77,'레시피 77','회원 77',sysdate,sysdate,77,'요리 소개 77입니다.','요리 팁 77입니다.',77,1,3,32,77,null);
Insert into REC_BOARD  values (78,'레시피 78','회원 78',sysdate,sysdate,78,'요리 소개 78입니다.','요리 팁 78입니다.',78,1,3,33,78,null);
Insert into REC_BOARD  values (79,'레시피 79','회원 79',sysdate,sysdate,79,'요리 소개 79입니다.','요리 팁 79입니다.',79,1,3,34,79,null);
Insert into REC_BOARD  values (80,'레시피 80','회원 80',sysdate,sysdate,80,'요리 소개 80입니다.','요리 팁 80입니다.',80,1,3,35,80,null);
Insert into REC_BOARD  values (81,'레시피 81','회원 81',sysdate,sysdate,81,'요리 소개 81입니다.','요리 팁 81입니다.',81,1,3,36,81,null);
Insert into REC_BOARD  values (82,'레시피 82','회원 82',sysdate,sysdate,82,'요리 소개 82입니다.','요리 팁 82입니다.',82,1,3,37,82,null);
Insert into REC_BOARD  values (83,'레시피 83','회원 83',sysdate,sysdate,83,'요리 소개 83입니다.','요리 팁 83입니다.',83,1,4,41,83,null);
Insert into REC_BOARD  values (84,'레시피 84','회원 84',sysdate,sysdate,84,'요리 소개 84입니다.','요리 팁 84입니다.',84,1,4,42,84,null);
Insert into REC_BOARD  values (85,'레시피 85','회원 85',sysdate,sysdate,85,'요리 소개 85입니다.','요리 팁 85입니다.',85,1,4,43,85,null);
Insert into REC_BOARD  values (86,'레시피 86','회원 86',sysdate,sysdate,86,'요리 소개 86입니다.','요리 팁 86입니다.',86,1,4,44,86,null);
Insert into REC_BOARD  values (87,'레시피 87','회원 87',sysdate,sysdate,87,'요리 소개 87입니다.','요리 팁 87입니다.',87,1,4,45,87,null);
Insert into REC_BOARD  values (88,'레시피 88','회원 88',sysdate,sysdate,88,'요리 소개 88입니다.','요리 팁 88입니다.',88,1,4,46,88,null);
Insert into REC_BOARD  values (89,'레시피 89','회원 89',sysdate,sysdate,89,'요리 소개 89입니다.','요리 팁 89입니다.',89,1,4,47,89,null);
Insert into REC_BOARD  values (90,'레시피 90','회원 90',sysdate,sysdate,90,'요리 소개 90입니다.','요리 팁 90입니다.',90,1,4,48,90,null);
Insert into REC_BOARD  values (91,'레시피 91','회원 91',sysdate,sysdate,91,'요리 소개 91입니다.','요리 팁 91입니다.',91,1,1,11,91,null);
Insert into REC_BOARD  values (92,'레시피 92','회원 92',sysdate,sysdate,92,'요리 소개 92입니다.','요리 팁 92입니다.',92,1,1,11,92,null);
Insert into REC_BOARD  values (93,'레시피 93','회원 93',sysdate,sysdate,93,'요리 소개 93입니다.','요리 팁 93입니다.',93,1,1,11,93,null);
Insert into REC_BOARD  values (94,'레시피 94','회원 94',sysdate,sysdate,94,'요리 소개 94입니다.','요리 팁 94입니다.',94,1,1,11,94,null);
Insert into REC_BOARD  values (95,'레시피 95','회원 95',sysdate,sysdate,95,'요리 소개 95입니다.','요리 팁 95입니다.',95,1,1,11,95,null);
Insert into REC_BOARD  values (96,'레시피 96','회원 96',sysdate,sysdate,96,'요리 소개 96입니다.','요리 팁 96입니다.',96,1,1,11,96,null);
Insert into REC_BOARD  values (97,'레시피 97','회원 97',sysdate,sysdate,97,'요리 소개 97입니다.','요리 팁 97입니다.',97,1,1,11,97,null);
Insert into REC_BOARD  values (98,'레시피 98','회원 98',sysdate,sysdate,98,'요리 소개 98입니다.','요리 팁 98입니다.',98,1,1,11,98,null);
Insert into REC_BOARD  values (99,'레시피 99','회원 99',sysdate,sysdate,99,'요리 소개 99입니다.','요리 팁 99입니다.',99,1,1,11,99,null);
Insert into REC_BOARD  values (100,'레시피 100','회원 100',sysdate,sysdate,100,'요리 소개 100입니다.','요리 팁 100입니다.',100,1,1,11,100,null);

--------------------------------------------------------------------------------

-- rec_member 테이블 더미 데이터 추가 // 시작
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (1,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (2,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (3,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (4,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (5,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (6,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (7,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (8,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (9,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (10,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (11,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (12,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (13,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (14,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (15,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (16,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (17,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (18,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (19,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (20,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (21,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (22,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (23,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (24,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (25,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (26,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (27,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (28,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (29,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (30,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (31,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (32,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (33,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (34,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (35,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (36,'recipe1@naver.com','1231','이름1','닉네임1','01012345671',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (37,'recipe2@naver.com','1232','이름2','닉네임2','01012345672',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (38,'recipe3@naver.com','1233','이름3','닉네임3','01012345673',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (39,'recipe4@naver.com','1234','이름4','닉네임4','01012345674',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (40,'recipe5@naver.com','1235','이름5','닉네임5','01012345675',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');


-- rec_grade 테이블 데이터 추가 // 시작
insert into rec_grade values(1, 'cook Helper', '1,000p');
insert into rec_grade values(2, 'cook Manager', '3,000p');
insert into rec_grade values(3, 'sous Chef', '5,000p');
insert into rec_grade values(4, 'head Chef', '10,000p');

-- rec_notice 테이블 데이터  추가 // 시작

Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (1,'공지1','안녕하세요. 반갑습니다.1','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (2,'공지2','안녕하세요. 반갑습니다.2','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (3,'공지3','안녕하세요. 반갑습니다.3','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (4,'공지4','안녕하세요. 반갑습니다.4','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (5,'공지5','안녕하세요. 반갑습니다.5','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (6,'공지6','안녕하세요. 반갑습니다.6','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (7,'공지7','안녕하세요. 반갑습니다.7','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (8,'공지8','안녕하세요. 반갑습니다.8','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (9,'공지9','안녕하세요. 반갑습니다.9','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (10,'공지10','안녕하세요. 반갑습니다.10','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'일반');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (11,'신입회원 이벤트1','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.1','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (12,'신입회원 이벤트2','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.2','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (13,'신입회원 이벤트3','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.3','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (14,'신입회원 이벤트4','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.4','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (15,'신입회원 이벤트5','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.5','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (16,'신입회원 이벤트6','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.6','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (17,'신입회원 이벤트7','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.7','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (18,'신입회원 이벤트8','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.8','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (19,'신입회원 이벤트9','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.9','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (20,'신입회원 이벤트10','새로오신 회원분들을 위한 이벤트가 준비되어있습니다.10','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'이벤트');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (21,'리워드1','게시물 5개 이상은 cook manager가 됩니다.1','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (22,'리워드2','게시물 5개 이상은 cook manager가 됩니다.2','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (23,'리워드3','게시물 5개 이상은 cook manager가 됩니다.3','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (24,'리워드4','게시물 5개 이상은 cook manager가 됩니다.4','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (25,'리워드5','게시물 5개 이상은 cook manager가 됩니다.5','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (26,'리워드6','게시물 5개 이상은 cook manager가 됩니다.6','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (27,'리워드7','게시물 5개 이상은 cook manager가 됩니다.7','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (28,'리워드8','게시물 5개 이상은 cook manager가 됩니다.8','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (29,'리워드9','게시물 5개 이상은 cook manager가 됩니다.9','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (30,'리워드10','게시물 5개 이상은 cook manager가 됩니다.10','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'자주 묻는 질문');

-- [ REC_BOARD ( 게시글 테이블) 데이터 입력 ]

Insert into REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(6,'집에서 바로 해먹을 수 있는 백종원 김치찌개','관리자',to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),0,'김치과 설탕만있으면 충분히 먹을 수 있는 손쉬운 김치찌개 레시피 입니다.','김치는 잘썰어서.. 설탕은 백설탕으로 준비해주세요 ! !',0,5,1,null);
Insert into REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(3,'제목','일반회원',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'소개글1','요리팁1',0,5,2,null);
Insert into .REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(4,'제목2','관리자',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'소개글2','요리팁2',0,5,1,null);
Insert into REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(5,'집에서 바로 해먹을 수 있는 백종원 계란말이 레시피','관리자',to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),0,'계란과 설탕만있으면 충분히 먹을 수 있는 손쉬운 계란말이 레시피 입니다.','계란은 잘풀어서.. 설탕은 백설탕으로 준비해주세요 ! !',0,5,1,10);

Insert into REC_BOARD values 
(4,'제목2','관리자',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'소개글2','요리팁2',0,5,1,3,31,null);


delete rec_board;

Insert into REC_BOARD values 
(6,'집에서 바로 해먹을 수 있는 백종원 김치찌개','관리자',to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),0,'김치과 설탕만있으면 충분히 먹을 수 있는 손쉬운 김치찌개 레시피 입니다.','김치는 잘썰어서.. 설탕은 백설탕으로 준비해주세요 ! !',0,5,1,11,1,null);

Insert into REC_BOARD values 
(3,'제목','일반회원',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'소개글1','요리팁1',0,5,2,21,2,null);

Insert into REC_BOARD values 
(4,'제목2','관리자',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'소개글2','요리팁2',0,5,3,31,1,null);

Insert into REC_BOARD values 
(5,'집에서 바로 해먹을 수 있는 백종원 계란말이 레시피','관리자',to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),0,'계란과 설탕만있으면 충분히 먹을 수 있는 손쉬운 계란말이 레시피 입니다.','계란은 잘풀어서.. 설탕은 백설탕으로 준비해주세요 ! !',0,5,4,41,1,10);


-- [ REC_REPLY ( 요리후기 테이블) 데이터 입력 ]

Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (68,to_date('23/08/01 12:02:27','RR/MM/DD hh24:MI:SS'),'파아저씨댓글',5,'파아저씨',5);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (65,to_date('23/08/01 09:45:32','RR/MM/DD hh24:MI:SS'),'별점5점후기',5,'별점작성자',5);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (66,to_date('23/08/01 10:20:13','RR/MM/DD hh24:MI:SS'),'ㅇㅇ',5,'ㅇㅇ',4);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (70,to_date('23/08/01 12:08:52','RR/MM/DD hh24:MI:SS'),'김치찌개가 되었어요',5,'나는작성자',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (72,to_date('23/08/02 09:24:57','RR/MM/DD hh24:MI:SS'),'계란부침개입니다',5,'나는계란부침개',4);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (61,to_date('23/08/01 09:03:08','RR/MM/DD hh24:MI:SS'),'뚱이사진',5,'뚱이사진',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (60,to_date('23/08/01 09:02:48','RR/MM/DD hh24:MI:SS'),'독수리독수리',5,'독수리오형제',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (62,to_date('23/08/01 09:03:29','RR/MM/DD hh24:MI:SS'),'사진없는댓글',5,'사진없는댓글',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (69,to_date('23/08/01 12:08:10','RR/MM/DD hh24:MI:SS'),'계란찜이 되었어요.',5,'나는작성자',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (63,to_date('23/08/01 09:26:32','RR/MM/DD hh24:MI:SS'),'랄라루',5,'댓글작성',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (64,to_date('23/08/01 09:26:54','RR/MM/DD hh24:MI:SS'),'나는계란사진후기',5,'나는계란사진',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (67,to_date('23/08/01 11:54:43','RR/MM/DD hh24:MI:SS'),'이미지업로드 ',5,'나는작성자',5);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (71,to_date('23/08/01 13:39:04','RR/MM/DD hh24:MI:SS'),'침고로새',5,'새로고침',5);

-------------------------------------------------------------------------------------------------------------------------
-- [ REC_MATERIAL ( 레시피 필요 재료 테이블 ) 데이터 입력 ] ?

--- 여기서 M_NO 는  필요재료 기본키로 MEMBER 테이블의 MNO 와는 다른 데이터 입니다. 
 
   Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (4,3,4,5,'설탕');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (5,4,5,5,'당근');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (6,5,2,5,'가지');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (3,1,3,6,'계란');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (1,1,5,5,'계란');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (2,2,4,5,'파');

-------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------

-- REC_STEP ( 요리순서 테이블 ) 데이터 입력 ] ?


Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (2,'계란과 파를 준비합니다.',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (3,'계란은 잘 풀어서 파를 송송 썰어줍니다.',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (4,'저는 4번에 나눠 붓고 말았어요 그리고 계란말이할때는 무조건 약불!! 아시죠?',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (5,'여기서 보통 그냥 계란을 마는데..백주부님 레시피는 첫판은 스크램블하기!!',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (6,'한쪽으로 밀어두고 또 계란물 붓기 이제부터 말아주시면 됩니다.',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (7,'첨엔 스크램블이 되어있다보니 좀 안말린다싶긴했는데... 계속 계란물 붓고 말다보면 예쁘게 잘말리더라구요 ㅋㅋ',5);

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-- REC_INGREDIENTS ( 순수 재료정보 테이블 ) 데이터 입력 ] ?

Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (1,'계란','계란찜/계란후라이/삶은달걀','힘이세짐','감자','흐르는 물에 잘 씻는다.');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (2,'파','파절이/김치찌개/도레미','매워짐','모든음식','흐르는 물에 잘 씻는다.');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (3,'설탕','빵/','달아짐','소금','서늘한 곳에 보관');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (4,'당근','당근조림/','눈이좋아짐','가지','흐르는 물에 잘 씻는다.');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (5,'가지','가지가지한다/','가지못하게함','오이','흐르는 물에 잘 씻는다.');


-------------------------------------------------------------------------------------------------------------------------

-- REC_INGREDIENTS ( 일반 댓글 테이블 ) 데이터 입력 ] ?

Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(4,'댓글 작성 테스트','testWriter',to_date('23/08/01 12:31:28','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 12:31:28','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(6,'댓글작성테스트댓글','댓글작성테스트',to_date('23/08/01 13:35:53','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 13:35:53','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(2,'일반댓글내용','일반댓글작성자',to_date('23/08/01 10:45:53','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 10:45:53','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(3,'일반댓글내용2','일반댓글작성자2',to_date('23/08/01 11:33:49','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 11:33:49','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(8,'댓글작성테스트댓글2','작성자입력2',to_date('23/08/02 09:25:22','RR/MM/DD hh24:MI:SS'),to_date('23/08/02 09:25:22','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(5,'댓글작성테스트댓글','댓글작성테스트',to_date('23/08/01 13:34:53','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 13:34:53','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values
(7,'댓글작성테스트댓글','댓글작성테스트',to_date('23/08/01 15:04:59','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 15:04:59','RR/MM/DD hh24:MI:SS'),5);
-------------------------------------------------------------------------------------------------------------------------

-- LIKE_RECIPE ( 좋아요 테이블  ) 데이터 입력 ] ?

Insert into LIKE_RECIPE (L_NO,M_NO,B_NO) values (30,1,5);
    Insert into LIKE_RECIPE (L_NO,M_NO,B_NO) values (34,1,6);
    Insert into LIKE_RECIPE (L_NO,M_NO,B_NO) values (39,2,5);
    
commit;

CREATE TABLE com_board (
    com_bno NUMBER NOT NULL,
    nickName VARCHAR2(20) NOT NULL,
    com_title VARCHAR2(100) NOT NULL,
    com_content VARCHAR2(500) NOT NULL,
    regdate DATE DEFAULT sysdate,
    update_date DATE DEFAULT sysdate,
    replycnt NUMBER NOT NULL,
    mno NUMBER NOT NULL,
    CONSTRAINT PK_COM_B PRIMARY KEY (com_bno)
);
- - 시퀀스 생성 seq_board
CREATE SEQUENCE seq_board
    MINVALUE 1
    MAXVALUE 9999999999999999999999999999
    INCREMENT BY 1
    START WITH 1;

-- com_board insert문

INSERT INTO com_board (com_bno, nickName, com_title, com_content, replycnt, mno)
VALUES (seq_board.nextval , '박덕배', '집통닭만들어보세요', '시장에서 사먹는 통닭맛 집에서도 느껴보세요', 0, 1);
INSERT INTO com_board (com_bno, nickName, com_title, com_content, replycnt, mno)
VALUES (seq_board.nextval , '김춘자', '분식집떡볶이바로그맛', '어렸을적 학교앞에서 사먹는맛 !!', 0, 1);
INSERT INTO com_board (com_bno, nickName, com_title, com_content, replycnt, mno)
VALUES (seq_board.nextval , '요리퀸', '아삭오이소박이', '정말 아삭한 오이소박이랍니다~', 0, 1);

SELECT T.* 
    , uploadpath||uuid||'_'||filename savepath
     , DECODE(filetype , 'I', uploadpath||'thum_'||uuid||'_'||filename, 'file') t_savepath
 			FROM com_file T ;

SELECT *
				FROM (
				  SELECT t.*, ROWNUM rn
				  FROM (
				         SELECT  ct.com_bno, ct.nickname, ct.com_title, ct.com_content, ct.replycnt,
				          		CASE WHEN ct.regdate >= TRUNC(SYSDATE) - 3 THEN 'new' ELSE '' END AS newpost,
				          		CASE WHEN TO_CHAR(ct.regdate, 'YYYY/MM/DD') = TO_CHAR(SYSDATE, 'YYYY/MM/DD') 
				          			THEN TRUNC(ROUND((SYSDATE - ct.regdate) * 24, 2)) || '시간 전'  
				          			 WHEN ct.regdate >= TRUNC(SYSDATE) - 7 AND ct.regdate < TRUNC(SYSDATE) 
				          			THEN TRUNC(ROUND(SYSDATE - ct.regdate)) || '일 전'
				          			ELSE TO_CHAR(ct.regdate, 'YYYY/MM/DD') END AS regdate
				          	FROM com_board ct
				          	 -- WHERE com_content LIKE '%' || #{sWord} || '%'
                              ) t
				)
				WHERE rn BETWEEN 1 AND 20;

Insert into com_board
    select
        seq_board.nextval,
        '회원 ' || level,
        '어디서 타는 냄새 안 나요? ' || level,
        '지금 내 스파게티가 불타고 있잖아요 ' || level,
        sysdate,
        sysdate,
        level,
        level
        from dual
        connect by level <= 100;
        

-- 2. com_file 파일저장소

CREATE TABLE com_file (
    uuid VARCHAR2(100) NOT NULL,
    uploadpath VARCHAR2(200) NOT NULL,
    filetype CHAR(1) NOT NULL,
    filename VARCHAR2(100) NOT NULL,
    com_bno NUMBER NOT NULL,
    CONSTRAINT PK_COM_F PRIMARY KEY (uuid)
);

? com_file insert문
INSERT INTO com_file (uuid, filetype, uploadpath,  filename, com_bno)
VALUES ('f59asdfdf4-5145-4e47-9cb5-8b7af8c6423e', 'I', '/uploads/', 'file1.jpg', 2);
INSERT INTO com_file (uuid, filetype, uploadpath,  filename, com_bno)
VALUES ('f59asdfdf4-5145-4e47-9cb5-86241423e', 'I', '/uploads/', 'file1.jpg', 3);

-- 3. com_reply 댓글
CREATE TABLE com_reply (
    R_NO NUMBER NOT NULL,
    replydate DATE DEFAULT sysdate,
    updatedate Date DEFAULT sysdate,
    reply VARCHAR2(2000) NOT NULL,
    com_bno NUMBER NOT NULL,
    mno number not null,
    CONSTRAINT PK_COM_R PRIMARY KEY (R_NO)
);

? 시퀀스 생성 seq_comreply
CREATE SEQUENCE seq_comreply
    MINVALUE 1
    MAXVALUE 9999999999999999999999999999
    INCREMENT BY 1
    START WITH 1;

? com_reply insert문
insert into com_reply values(seq_comreply.nextval,sysdate,sysdate,'재밌습니다',11,1);
insert into com_reply values(seq_comreply.nextval,sysdate,sysdate,'ㅋㅋㅋㅋㅋㅋㅋ',53,1);
insert into com_reply values(seq_comreply.nextval,sysdate,sysdate,'ㄹㅇ 인정 ',43,1);


