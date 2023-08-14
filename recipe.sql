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
                    FLOOR((SYSDATE - ct.regdate) * 24 * 60) || '�� ��'
                ELSE
                    CASE
                        WHEN (SYSDATE - ct.regdate) * 24 < 24 THEN
                            FLOOR((SYSDATE - ct.regdate) * 24) || '�ð� ��'
                        ELSE
                            TRUNC(SYSDATE - ct.regdate) || '�� ��'
                    END
            END
        WHEN ct.regdate >= TRUNC(SYSDATE) - 7 THEN
            TRUNC(ROUND(SYSDATE - ct.regdate)) || '�� ��'
        ELSE
            TO_CHAR(ct.regdate, 'YYYY/MM/DD')
    END AS regdate
				          	FROM com_board ct
				          	 -- WHERE com_content LIKE '%' || #{sWord} || '%'
                             
                              ) t
				)
				WHERE rn BETWEEN 1 AND 20;

-- �׽�Ʈ�� ���̺� ���� ( �������� �� ) 
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

-- notice ������ (NNO) 
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
  'ī�װ� ' || level
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
  '������ ' || level, 
  'ȸ�� ' || level,
  sysdate,
  sysdate,
  level,
  '�丮 �Ұ� ' || level || '�Դϴ�.',
  '�丮 �� ' || level || '�Դϴ�.',
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

-- C_NO �÷��� ���� ������ NULL�� ����
ALTER TABLE rec_category MODIFY C_NO NULL;
ALTER TABLE rec_board MODIFY C_NO NULL;

-- ���ο� ������ �Ҵ�
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
  '��� ' || level
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
                    THEN TRUNC(ROUND((SYSDATE - rt.regdate) * 24, 2)) || '�ð� ��'  
                    WHEN rt.regdate >= TRUNC(SYSDATE) - 7 AND rt.regdate < TRUNC(SYSDATE) THEN
            TRUNC(ROUND(SYSDATE - rt.regdate)) || '�� ��'
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
                    TO_CHAR(rt.regdate, 'YYYY�� MM�� DD��')
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

SELECT ROUND((TO_DATE(TO_CHAR(sysdate, 'YYYY-MM-DD HH24')) - TO_DATE(TO_CHAR(rt.regdate, 'YYYY-MM-DD HH24'))) * 24, 2) || '�ð� ��' as reg
  FROM rec_board rt;

SELECT  ROUND((TO_DATE(TO_CHAR(sysdate, 'YYYY-MM-DD HH24')) - TO_DATE(TO_CHAR(rt.regdate, 'YYYY-MM-DD HH24'))) * 24, 2) || '�ð� ��' as regtime FROM rec_board rt;

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
          FLOOR((SYSDATE - rt.regdate) * 24 * 60) || '�� ��'
        WHEN rt.regdate >= TRUNC(SYSDATE) - 7 THEN
          TRUNC(ROUND(SYSDATE - rt.regdate)) || '�� ��'
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
-- view.jsp ������Ʈ
alter table rec_board 
add videoLink varchar2(3000);

-- rec_board
Insert into RECIPE.REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,C_NO1,C_NO2,MNO,REPLYCNT,VIDEOLINK) values (2,'�õ����ο丮 ���ι������� ����¹� �������� ����� �������� ������','�׷���������',to_date('23/08/07 14:39:08','RR/MM/DD hh24:MI:SS'),to_date('23/08/07 14:39:08','RR/MM/DD hh24:MI:SS'),0,'����� �ִ� ��Ḧ �����ϴٰ� �������� ����� ������ ���ι��������� ����� �Ծ�߰ڴ� �ʹ�����','�߰ſ ���� ������ �����ǲ���� ���δ� ���� ������ �־��ּ���',0,0,1,2,1,0,'https://youtu.be/_TGhAtAqrLk')
;
ALTER TABLE rec_ingredients MODIFY i_power VARCHAR2(300); -- ������ Ÿ���� ���� �������ּ���
ALTER TABLE rec_ingredients modify i_cook varchar2(300); -- 

delete REC_INGREDIENTS;
delete rec_material;

Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (2,'����','���ߺ���/���߷�/�Ұ����߸���','����/�Ƿ�ȸ��/�Ǻι̿�','�κ�','���߸� ������ �߶� �帣�� ���� �Ĵ´�.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (3,'���̹���','�ҺҰ���ä����/���̹�������/����ä�Ҹ���','�������/�׾�ȿ��/�ݷ����׷�����','����','�ص��� �߶󳻰� �帣�� ���� �Ĵ´�.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (4,'����','�ߺ�����/��ä/��������','������ȯ/�Ҹ���/�Ƿ�ȸ��','����','�Ѹ� �κ��� �߶󳻰� �븦 �ڸ� �κп������� ������ ���� ������ ���� �� �뵵�� ���� �� ���');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (5,'û�����','�����/�κ�����/�ߺ�����/�ᳪ����','���̾�Ʈ/�Ǻι̿�/��Ʈ�����ؼ�','����','�������� ���� ���� �к��Ͽ� ���庸��, �����ϰų� ���� ���� �õ������Ѵ�.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (6,'����','�Ұ�⹫��/��������/���κ��/�����','���׼�ȯ/�Ƿ�ȸ��/�鿪��','�̿�','�Ѹ� �κ��� �߶󳻰�, ���� �ٱ� �κ��� �и��Ѵ�.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (7,'��','�������','���� ����/���� ����/�Ƿ�ȸ��','�������','������ ��� �����ϰ� ���籤���� ���� ������ �����ϰ�, �����Ŀ��� ���� �����Ѵ�.');
Insert into RECIPE.REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (8,'������','����/�����α�/��������','�˵��˵�','������','�߶� �����ϰų� ������ �õ������Ѵ�.');

Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values ('2','2','6��','2','����');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (3,3,'1��',2,'���̹���');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (4,4,'1/2��',2,'����');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (5,5,'1��',2,'û�����');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (6,6,'1/3��',2,'����');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (7,7,'4~5��',2,'��');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (8,8,'1/2��',2,'������');
Insert into RECIPE.REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (9,9,'1��',2,'�õ�����');

-- rec_step( �������� ���̺� )

Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (2,'���ι������� �� ������ �������ּ��� �˹����ߴ� ��������� ����Ͽ���ϴ�',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (3,'������ ��ä�� ���񳿺� �̻ڰ� ����ֽø� �ǿ� �˹�����, �����̹���, �����ڹ��� �׸��� ���ĸ� �־��־��� �������� ���� �̸� ������ ��� �͹��� �� �� ����Ͽ����',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (4,'�õ��ǿ� �������̴� �õ���⸸�� 5���� ��ġ���� 2���� �־��־���ϴ�',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (5,'������� ������������ ����� ���� �̻۵� �Ͽ� �� ������ �̸� ������ ���̿���',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (6,'��ᰡ ��������� ���� �ξ��ֽø� �Ǵµ� �̶� ���� �̸� �������� �� �ִ°� ��õ����� �ʹ� �����ð� ���̰� �Ǹ� ���ΰ� ���� ������ �ְŵ�� ~',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (7,'������ ġŲ������ �־� ���� �� �� �� ���ۺ��� �����ݴϴ�',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (8,'���¹��� �־� ���������� �ݹ� ��������ϴµ��� ��������ϰ� 4~ 5������ �ٱ۹ٱ� �����ּ��� �̶� �ö���� �⸧�� �Ҽ����� �ִ��� �������ݴϴ�',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (9,'�������� ���� �� �� ������� �߰����� ���־���� ~',2);
Insert into RECIPE.REC_STEP (S_NO,STEP_CONTENT,B_NO) values (10,'����� ��Ÿ���� ���ι������� �ϼ��̿��� !',2);

-- rec_file ( ���� ���̺� ) 

Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('cae8b0ce-a936-415a-a173-cbb63c0ba17a','2023\08\07\','R','����5.jpg',4,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('fb902b7f-7b1b-466b-8a16-e11b491b39ee','2023\08\07\','R','����3.jpg',5,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('13d2f80b-45c4-4782-b2a6-60473548b531','2023\08\07\','R','����4.jpg',6,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('2f72e10f-9ca0-4105-bb9b-183a3021178e','2023\08\07\','R','��ä����.jpg',7,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('87153209-d0d0-4b7e-83cb-67c1ab11700f','2023\08\07\','B','��Į��������.jpg',null,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('e3845ed4f68ea245e1543240e4c20789','2023\08\07\','M','����.jpg',null,2,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('PPPP','2023\08\07\','M','���̹���.jpg',null,3,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('5c57d3e425b8a17ef4a9e715160b7f32','2023\08\07\','M','����.jpg',null,4,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('DWDWDWDDDD','2023\08\07\','M','û�����.jpg',null,5,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('cf95f7a9a402160e883887b882107745','2023\08\07\','M','����.jpg',null,6,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('6fbc62b02932672f4b15fb5be626c7c6','2023\08\07\','M','����.jpg',null,7,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('ErE','2023\08\07\','M','������.jpg',null,8,null,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step1','2023\08\07\','S','��������丮����1.JPG',null,null,2,2);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step2','2023\08\07\','S','��������丮����2.JPG',null,null,2,3);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step3','2023\08\07\','S','��������丮����3.JPG',null,null,2,4);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step4','2023\08\07\','S','��������丮����4.JPG',null,null,2,5);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step9','2023\08\07\','S','��������丮����9.JPG',null,null,2,6);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step6','2023\08\07\','S','��������丮����6.JPG',null,null,2,7);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step7','2023\08\07\','S','��������丮����7.JPG',null,null,2,8);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step8','2023\08\07\','S','��������丮����8.JPG',null,null,2,9);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('step5','2023\08\07\','S','��������丮����5.JPG',null,null,2,10);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('cdd94a1d-50a3-40d5-b02f-1d344e9578ea','2023\08\07\','R','�丮��.jpg',2,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('8ff2c8f4-ce66-4be6-8716-0f70272dbb5a','2023\08\07\','R','2323.jpg',8,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('64cdc6dc-d046-4a4d-b262-fc0de464b088','2023\08\07\','R','2323.jpg',1,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('add1c469-6f43-4314-9c1e-ce5e694c85b8','2023\08\07\','R','����2.jpg',3,null,2,null);
Insert into RECIPE.REC_FILE (UUID,UPLOADPATH,FILETYPE,FILENAME,R_NO,I_NO,B_NO,S_NO) values ('f16b36d1-5d4e-4ac8-92cd-8b9ae078e898','2023\08\07\','R','�丮��.jpg',11,null,2,null);
--------------------------------------------------------------------------------

Insert into REC_CATEGORY values (1,'������',11,'��/��/�');
Insert into REC_CATEGORY values (1,'������',12,'��/����/�Ľ�Ÿ');
Insert into REC_CATEGORY values (1,'������',13,'��/��');
Insert into REC_CATEGORY values (1,'������',14,'��/��');
Insert into REC_CATEGORY values (1,'������',15,'����');
Insert into REC_CATEGORY values (1,'������',16,'������');
Insert into REC_CATEGORY values (1,'������',17,'�ҽ�');
Insert into REC_CATEGORY values (1,'������',18,'��/����/��');

Insert into REC_CATEGORY values (2,'��Ằ',21,'����');
Insert into REC_CATEGORY values (2,'��Ằ',22,'�ع���');
Insert into REC_CATEGORY values (2,'��Ằ',23,'���Ϸ�');
Insert into REC_CATEGORY values (2,'��Ằ',24,'�ް�/����ǰ');
Insert into REC_CATEGORY values (2,'��Ằ',25,'ä�ҷ�');
Insert into REC_CATEGORY values (2,'��Ằ',26,'�߰���');
Insert into REC_CATEGORY values (2,'��Ằ',27,'��/�а���');

Insert into REC_CATEGORY values (3,'��Ȳ��',31,'����');
Insert into REC_CATEGORY values (3,'��Ȳ��',32,'����');
Insert into REC_CATEGORY values (3,'��Ȳ��',33,'��Ƽ');
Insert into REC_CATEGORY values (3,'��Ȳ��',34,'���ö�');
Insert into REC_CATEGORY values (3,'��Ȳ��',35,'����');
Insert into REC_CATEGORY values (3,'��Ȳ��',36,'������');
Insert into REC_CATEGORY values (3,'��Ȳ��',37,'�ʽ��ǵ�');

Insert into REC_CATEGORY values (4,'�����',41,'����');
Insert into REC_CATEGORY values (4,'�����',42,'����');
Insert into REC_CATEGORY values (4,'�����',43,'���');
Insert into REC_CATEGORY values (4,'�����',44,'����');
Insert into REC_CATEGORY values (4,'�����',45,'Ƣ��');
Insert into REC_CATEGORY values (4,'�����',46,'���');
Insert into REC_CATEGORY values (4,'�����',47,'����');
Insert into REC_CATEGORY values (4,'�����',48,'���̱�');


--------------------------------------------------------------------------------

-- ���� �α��� �� ������ ���� ���̺��� ���� ��ȸ 
SELECT 'DROP TABLE ' || TABLE_NAME || ' CASCADE CONSTRAINTS;'  
FROM USER_ALL_TABLES ;

-- ��ȸ ��� ������ ���� �Ʒ� ������ ���� ���� 
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


-- ���̺� ����� 08/02 (NOT NULL ����)------------------------------------------------------------------------------
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
--  �ʿ� ��� ���̺� �߰� 
CREATE TABLE "REC_MATERIAL" 
   (	"M_NO" NUMBER, 
	"I_NO" NUMBER, 
	"MATERIALCNT" NUMBER, 
	"B_NO" NUMBER, 
	"I_NAME" VARCHAR2(40 BYTE)
   );

-- ���ƿ� ���̺� �ű� �߰� 
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

-- �Ϲ� ��� ���̺��߰�
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
    gubun varchar2(50) default '�Ϲ�',
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

-- member ������ (MNO)
create sequence SEQ_MEMBER
START WITH 0
INCREMENT BY 1
minvalue 0
MAXVALUE 1000
NOCYCLE
NOCACHE;

-- notice ������ (NNO) 
CREATE SEQUENCE SEQ_NOTICE
START WITH 0
INCREMENT BY 1
minvalue 0
MAXVALUE 1000
NOCYCLE
NOCACHE;

rollback;

-- ������ �߰�
delete REC_BOARD_test;
INSERT INTO REC_BOARD_test
SELECT 
  seq_rec_board_num.nextval,
  '������ ' || LEVEL,
  'ȸ�� ' || LEVEL,
  sysdate,
  sysdate,
  LEVEL,
  '�丮 �Ұ� ' || LEVEL || '�Դϴ�.',
  '�丮 �� ' || LEVEL || '�Դϴ�.',
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
  '������ ' || (LEVEL),
  'ȸ�� ' || (LEVEL),
  sysdate,
  sysdate,
  LEVEL + 10,
  '�丮 �Ұ� ' || (LEVEL + 10) || '�Դϴ�.',
  '�丮 �� ' || (LEVEL + 10) || '�Դϴ�.',
  LEVEL + 10,
  1,
  1,
  10 + TRUNC((LEVEL - 1) / 3) * 10,
  LEVEL + 10,
  NULL
FROM DUAL
CONNECT BY LEVEL <= 8;


--------------------------------------------------------------------------------
Insert into REC_BOARD  values (1,'������ 1','ȸ�� 1',sysdate,sysdate,1,'�丮 �Ұ� 1�Դϴ�.','�丮 �� 1�Դϴ�.',1,1,1,11,1,null);
Insert into REC_BOARD  values (2,'������ 2','ȸ�� 2',sysdate,sysdate,2,'�丮 �Ұ� 2�Դϴ�.','�丮 �� 2�Դϴ�.',2,1,1,12,2,null);
Insert into REC_BOARD  values (3,'������ 3','ȸ�� 3',sysdate,sysdate,3,'�丮 �Ұ� 3�Դϴ�.','�丮 �� 3�Դϴ�.',3,1,1,13,3,null);
Insert into REC_BOARD  values (4,'������ 4','ȸ�� 4',sysdate,sysdate,4,'�丮 �Ұ� 4�Դϴ�.','�丮 �� 4�Դϴ�.',4,1,1,14,4,null);
Insert into REC_BOARD  values (5,'������ 5','ȸ�� 5',sysdate,sysdate,5,'�丮 �Ұ� 5�Դϴ�.','�丮 �� 5�Դϴ�.',5,1,1,15,5,null);
Insert into REC_BOARD  values (6,'������ 6','ȸ�� 6',sysdate,sysdate,6,'�丮 �Ұ� 6�Դϴ�.','�丮 �� 6�Դϴ�.',6,1,1,16,6,null);
Insert into REC_BOARD  values (7,'������ 7','ȸ�� 7',sysdate,sysdate,7,'�丮 �Ұ� 7�Դϴ�.','�丮 �� 7�Դϴ�.',7,1,1,17,7,null);
Insert into REC_BOARD  values (8,'������ 8','ȸ�� 8',sysdate,sysdate,8,'�丮 �Ұ� 8�Դϴ�.','�丮 �� 8�Դϴ�.',8,1,1,18,8,null);
Insert into REC_BOARD  values (9,'������ 9','ȸ�� 9',sysdate,sysdate,9,'�丮 �Ұ� 9�Դϴ�.','�丮 �� 9�Դϴ�.',9,1,2,21,9,null);
Insert into REC_BOARD  values (10,'������ 10','ȸ�� 10',sysdate,sysdate,10,'�丮 �Ұ� 10�Դϴ�.','�丮 �� 10�Դϴ�.',10,1,2,22,10,null);
Insert into REC_BOARD  values (11,'������ 11','ȸ�� 11',sysdate,sysdate,11,'�丮 �Ұ� 11�Դϴ�.','�丮 �� 11�Դϴ�.',11,1,2,23,11,null);
Insert into REC_BOARD  values (12,'������ 12','ȸ�� 12',sysdate,sysdate,12,'�丮 �Ұ� 12�Դϴ�.','�丮 �� 12�Դϴ�.',12,1,2,24,12,null);
Insert into REC_BOARD  values (13,'������ 13','ȸ�� 13',sysdate,sysdate,13,'�丮 �Ұ� 13�Դϴ�.','�丮 �� 13�Դϴ�.',13,1,2,25,13,null);
Insert into REC_BOARD  values (14,'������ 14','ȸ�� 14',sysdate,sysdate,14,'�丮 �Ұ� 14�Դϴ�.','�丮 �� 14�Դϴ�.',14,1,2,26,14,null);
Insert into REC_BOARD  values (15,'������ 15','ȸ�� 15',sysdate,sysdate,15,'�丮 �Ұ� 15�Դϴ�.','�丮 �� 15�Դϴ�.',15,1,2,27,15,null);
Insert into REC_BOARD  values (16,'������ 16','ȸ�� 16',sysdate,sysdate,16,'�丮 �Ұ� 16�Դϴ�.','�丮 �� 16�Դϴ�.',16,1,3,31,16,null);
Insert into REC_BOARD  values (17,'������ 17','ȸ�� 17',sysdate,sysdate,17,'�丮 �Ұ� 17�Դϴ�.','�丮 �� 17�Դϴ�.',17,1,3,32,17,null);
Insert into REC_BOARD  values (18,'������ 18','ȸ�� 18',sysdate,sysdate,18,'�丮 �Ұ� 18�Դϴ�.','�丮 �� 18�Դϴ�.',18,1,3,33,18,null);
Insert into REC_BOARD  values (19,'������ 19','ȸ�� 19',sysdate,sysdate,19,'�丮 �Ұ� 19�Դϴ�.','�丮 �� 19�Դϴ�.',19,1,3,34,19,null);
Insert into REC_BOARD  values (20,'������ 20','ȸ�� 20',sysdate,sysdate,20,'�丮 �Ұ� 20�Դϴ�.','�丮 �� 20�Դϴ�.',20,1,3,35,20,null);
Insert into REC_BOARD  values (21,'������ 21','ȸ�� 21',sysdate,sysdate,21,'�丮 �Ұ� 21�Դϴ�.','�丮 �� 21�Դϴ�.',21,1,3,36,21,null);
Insert into REC_BOARD  values (22,'������ 22','ȸ�� 22',sysdate,sysdate,22,'�丮 �Ұ� 22�Դϴ�.','�丮 �� 22�Դϴ�.',22,1,3,37,22,null);
Insert into REC_BOARD  values (23,'������ 23','ȸ�� 23',sysdate,sysdate,23,'�丮 �Ұ� 23�Դϴ�.','�丮 �� 23�Դϴ�.',23,1,4,41,23,null);
Insert into REC_BOARD  values (24,'������ 24','ȸ�� 24',sysdate,sysdate,24,'�丮 �Ұ� 24�Դϴ�.','�丮 �� 24�Դϴ�.',24,1,4,42,24,null);
Insert into REC_BOARD  values (25,'������ 25','ȸ�� 25',sysdate,sysdate,25,'�丮 �Ұ� 25�Դϴ�.','�丮 �� 25�Դϴ�.',25,1,4,43,25,null);
Insert into REC_BOARD  values (26,'������ 26','ȸ�� 26',sysdate,sysdate,26,'�丮 �Ұ� 26�Դϴ�.','�丮 �� 26�Դϴ�.',26,1,4,44,26,null);
Insert into REC_BOARD  values (27,'������ 27','ȸ�� 27',sysdate,sysdate,27,'�丮 �Ұ� 27�Դϴ�.','�丮 �� 27�Դϴ�.',27,1,4,45,27,null);
Insert into REC_BOARD  values (28,'������ 28','ȸ�� 28',sysdate,sysdate,28,'�丮 �Ұ� 28�Դϴ�.','�丮 �� 28�Դϴ�.',28,1,4,46,28,null);
Insert into REC_BOARD  values (29,'������ 29','ȸ�� 29',sysdate,sysdate,29,'�丮 �Ұ� 29�Դϴ�.','�丮 �� 29�Դϴ�.',29,1,4,47,29,null);
Insert into REC_BOARD  values (30,'������ 30','ȸ�� 30',sysdate,sysdate,30,'�丮 �Ұ� 30�Դϴ�.','�丮 �� 30�Դϴ�.',30,1,4,48,30,null);
Insert into REC_BOARD  values (31,'������ 31','ȸ�� 31',sysdate,sysdate,31,'�丮 �Ұ� 31�Դϴ�.','�丮 �� 31�Դϴ�.',31,1,1,11,31,null);
Insert into REC_BOARD  values (32,'������ 32','ȸ�� 32',sysdate,sysdate,32,'�丮 �Ұ� 32�Դϴ�.','�丮 �� 32�Դϴ�.',32,1,1,12,32,null);
Insert into REC_BOARD  values (33,'������ 33','ȸ�� 33',sysdate,sysdate,33,'�丮 �Ұ� 33�Դϴ�.','�丮 �� 33�Դϴ�.',33,1,1,13,33,null);
Insert into REC_BOARD  values (34,'������ 34','ȸ�� 34',sysdate,sysdate,34,'�丮 �Ұ� 34�Դϴ�.','�丮 �� 34�Դϴ�.',34,1,1,14,34,null);
Insert into REC_BOARD  values (35,'������ 35','ȸ�� 35',sysdate,sysdate,35,'�丮 �Ұ� 35�Դϴ�.','�丮 �� 35�Դϴ�.',35,1,1,15,35,null);
Insert into REC_BOARD  values (36,'������ 36','ȸ�� 36',sysdate,sysdate,36,'�丮 �Ұ� 36�Դϴ�.','�丮 �� 36�Դϴ�.',36,1,1,16,36,null);
Insert into REC_BOARD  values (37,'������ 37','ȸ�� 37',sysdate,sysdate,37,'�丮 �Ұ� 37�Դϴ�.','�丮 �� 37�Դϴ�.',37,1,1,17,37,null);
Insert into REC_BOARD  values (38,'������ 38','ȸ�� 38',sysdate,sysdate,38,'�丮 �Ұ� 38�Դϴ�.','�丮 �� 38�Դϴ�.',38,1,1,18,38,null);
Insert into REC_BOARD  values (39,'������ 39','ȸ�� 39',sysdate,sysdate,39,'�丮 �Ұ� 39�Դϴ�.','�丮 �� 39�Դϴ�.',39,1,2,21,39,null);
Insert into REC_BOARD  values (40,'������ 40','ȸ�� 40',sysdate,sysdate,40,'�丮 �Ұ� 40�Դϴ�.','�丮 �� 40�Դϴ�.',40,1,2,22,40,null);
Insert into REC_BOARD  values (41,'������ 41','ȸ�� 41',sysdate,sysdate,41,'�丮 �Ұ� 41�Դϴ�.','�丮 �� 41�Դϴ�.',41,1,2,23,41,null);
Insert into REC_BOARD  values (42,'������ 42','ȸ�� 42',sysdate,sysdate,42,'�丮 �Ұ� 42�Դϴ�.','�丮 �� 42�Դϴ�.',42,1,2,24,42,null);
Insert into REC_BOARD  values (43,'������ 43','ȸ�� 43',sysdate,sysdate,43,'�丮 �Ұ� 43�Դϴ�.','�丮 �� 43�Դϴ�.',43,1,2,25,43,null);
Insert into REC_BOARD  values (44,'������ 44','ȸ�� 44',sysdate,sysdate,44,'�丮 �Ұ� 44�Դϴ�.','�丮 �� 44�Դϴ�.',44,1,2,26,44,null);
Insert into REC_BOARD  values (45,'������ 45','ȸ�� 45',sysdate,sysdate,45,'�丮 �Ұ� 45�Դϴ�.','�丮 �� 45�Դϴ�.',45,1,2,27,45,null);
Insert into REC_BOARD  values (46,'������ 46','ȸ�� 46',sysdate,sysdate,46,'�丮 �Ұ� 46�Դϴ�.','�丮 �� 46�Դϴ�.',46,1,3,31,46,null);
Insert into REC_BOARD  values (47,'������ 47','ȸ�� 47',sysdate,sysdate,47,'�丮 �Ұ� 47�Դϴ�.','�丮 �� 47�Դϴ�.',47,1,3,32,47,null);
Insert into REC_BOARD  values (48,'������ 48','ȸ�� 48',sysdate,sysdate,48,'�丮 �Ұ� 48�Դϴ�.','�丮 �� 48�Դϴ�.',48,1,3,33,48,null);
Insert into REC_BOARD  values (49,'������ 49','ȸ�� 49',sysdate,sysdate,49,'�丮 �Ұ� 49�Դϴ�.','�丮 �� 49�Դϴ�.',49,1,3,34,49,null);
Insert into REC_BOARD  values (50,'������ 50','ȸ�� 50',sysdate,sysdate,50,'�丮 �Ұ� 50�Դϴ�.','�丮 �� 50�Դϴ�.',50,1,3,35,50,null);
Insert into REC_BOARD  values (51,'������ 51','ȸ�� 51',sysdate,sysdate,51,'�丮 �Ұ� 51�Դϴ�.','�丮 �� 51�Դϴ�.',51,1,3,36,51,null);
Insert into REC_BOARD  values (52,'������ 52','ȸ�� 52',sysdate,sysdate,52,'�丮 �Ұ� 52�Դϴ�.','�丮 �� 52�Դϴ�.',52,1,3,37,52,null);
Insert into REC_BOARD  values (53,'������ 53','ȸ�� 53',sysdate,sysdate,53,'�丮 �Ұ� 53�Դϴ�.','�丮 �� 53�Դϴ�.',53,1,4,41,53,null);
Insert into REC_BOARD  values (54,'������ 54','ȸ�� 54',sysdate,sysdate,54,'�丮 �Ұ� 54�Դϴ�.','�丮 �� 54�Դϴ�.',54,1,4,42,54,null);
Insert into REC_BOARD  values (55,'������ 55','ȸ�� 55',sysdate,sysdate,55,'�丮 �Ұ� 55�Դϴ�.','�丮 �� 55�Դϴ�.',55,1,4,43,55,null);
Insert into REC_BOARD  values (56,'������ 56','ȸ�� 56',sysdate,sysdate,56,'�丮 �Ұ� 56�Դϴ�.','�丮 �� 56�Դϴ�.',56,1,4,44,56,null);
Insert into REC_BOARD  values (57,'������ 57','ȸ�� 57',sysdate,sysdate,57,'�丮 �Ұ� 57�Դϴ�.','�丮 �� 57�Դϴ�.',57,1,4,45,57,null);
Insert into REC_BOARD  values (58,'������ 58','ȸ�� 58',sysdate,sysdate,58,'�丮 �Ұ� 58�Դϴ�.','�丮 �� 58�Դϴ�.',58,1,4,46,58,null);
Insert into REC_BOARD  values (59,'������ 59','ȸ�� 59',sysdate,sysdate,59,'�丮 �Ұ� 59�Դϴ�.','�丮 �� 59�Դϴ�.',59,1,4,47,59,null);
Insert into REC_BOARD  values (60,'������ 60','ȸ�� 60',sysdate,sysdate,60,'�丮 �Ұ� 60�Դϴ�.','�丮 �� 60�Դϴ�.',60,1,4,48,60,null);
Insert into REC_BOARD  values (61,'������ 61','ȸ�� 61',sysdate,sysdate,61,'�丮 �Ұ� 61�Դϴ�.','�丮 �� 61�Դϴ�.',61,1,1,11,61,null);
Insert into REC_BOARD  values (62,'������ 62','ȸ�� 62',sysdate,sysdate,62,'�丮 �Ұ� 62�Դϴ�.','�丮 �� 62�Դϴ�.',62,1,1,12,62,null);
Insert into REC_BOARD  values (63,'������ 63','ȸ�� 63',sysdate,sysdate,63,'�丮 �Ұ� 63�Դϴ�.','�丮 �� 63�Դϴ�.',63,1,1,13,63,null);
Insert into REC_BOARD  values (64,'������ 64','ȸ�� 64',sysdate,sysdate,64,'�丮 �Ұ� 64�Դϴ�.','�丮 �� 64�Դϴ�.',64,1,1,14,64,null);
Insert into REC_BOARD  values (65,'������ 65','ȸ�� 65',sysdate,sysdate,65,'�丮 �Ұ� 65�Դϴ�.','�丮 �� 65�Դϴ�.',65,1,1,15,65,null);
Insert into REC_BOARD  values (66,'������ 66','ȸ�� 66',sysdate,sysdate,66,'�丮 �Ұ� 66�Դϴ�.','�丮 �� 66�Դϴ�.',66,1,1,16,66,null);
Insert into REC_BOARD  values (67,'������ 67','ȸ�� 67',sysdate,sysdate,67,'�丮 �Ұ� 67�Դϴ�.','�丮 �� 67�Դϴ�.',67,1,1,17,67,null);
Insert into REC_BOARD  values (68,'������ 68','ȸ�� 68',sysdate,sysdate,68,'�丮 �Ұ� 68�Դϴ�.','�丮 �� 68�Դϴ�.',68,1,1,18,68,null);
Insert into REC_BOARD  values (69,'������ 69','ȸ�� 69',sysdate,sysdate,69,'�丮 �Ұ� 69�Դϴ�.','�丮 �� 69�Դϴ�.',69,1,2,21,69,null);
Insert into REC_BOARD  values (70,'������ 70','ȸ�� 70',sysdate,sysdate,70,'�丮 �Ұ� 70�Դϴ�.','�丮 �� 70�Դϴ�.',70,1,2,22,70,null);
Insert into REC_BOARD  values (71,'������ 71','ȸ�� 71',sysdate,sysdate,71,'�丮 �Ұ� 71�Դϴ�.','�丮 �� 71�Դϴ�.',71,1,2,23,71,null);
Insert into REC_BOARD  values (72,'������ 72','ȸ�� 72',sysdate,sysdate,72,'�丮 �Ұ� 72�Դϴ�.','�丮 �� 72�Դϴ�.',72,1,2,24,72,null);
Insert into REC_BOARD  values (73,'������ 73','ȸ�� 73',sysdate,sysdate,73,'�丮 �Ұ� 73�Դϴ�.','�丮 �� 73�Դϴ�.',73,1,2,25,73,null);
Insert into REC_BOARD  values (74,'������ 74','ȸ�� 74',sysdate,sysdate,74,'�丮 �Ұ� 74�Դϴ�.','�丮 �� 74�Դϴ�.',74,1,2,26,74,null);
Insert into REC_BOARD  values (75,'������ 75','ȸ�� 75',sysdate,sysdate,75,'�丮 �Ұ� 75�Դϴ�.','�丮 �� 75�Դϴ�.',75,1,2,27,75,null);
Insert into REC_BOARD  values (76,'������ 76','ȸ�� 76',sysdate,sysdate,76,'�丮 �Ұ� 76�Դϴ�.','�丮 �� 76�Դϴ�.',76,1,3,31,76,null);
Insert into REC_BOARD  values (77,'������ 77','ȸ�� 77',sysdate,sysdate,77,'�丮 �Ұ� 77�Դϴ�.','�丮 �� 77�Դϴ�.',77,1,3,32,77,null);
Insert into REC_BOARD  values (78,'������ 78','ȸ�� 78',sysdate,sysdate,78,'�丮 �Ұ� 78�Դϴ�.','�丮 �� 78�Դϴ�.',78,1,3,33,78,null);
Insert into REC_BOARD  values (79,'������ 79','ȸ�� 79',sysdate,sysdate,79,'�丮 �Ұ� 79�Դϴ�.','�丮 �� 79�Դϴ�.',79,1,3,34,79,null);
Insert into REC_BOARD  values (80,'������ 80','ȸ�� 80',sysdate,sysdate,80,'�丮 �Ұ� 80�Դϴ�.','�丮 �� 80�Դϴ�.',80,1,3,35,80,null);
Insert into REC_BOARD  values (81,'������ 81','ȸ�� 81',sysdate,sysdate,81,'�丮 �Ұ� 81�Դϴ�.','�丮 �� 81�Դϴ�.',81,1,3,36,81,null);
Insert into REC_BOARD  values (82,'������ 82','ȸ�� 82',sysdate,sysdate,82,'�丮 �Ұ� 82�Դϴ�.','�丮 �� 82�Դϴ�.',82,1,3,37,82,null);
Insert into REC_BOARD  values (83,'������ 83','ȸ�� 83',sysdate,sysdate,83,'�丮 �Ұ� 83�Դϴ�.','�丮 �� 83�Դϴ�.',83,1,4,41,83,null);
Insert into REC_BOARD  values (84,'������ 84','ȸ�� 84',sysdate,sysdate,84,'�丮 �Ұ� 84�Դϴ�.','�丮 �� 84�Դϴ�.',84,1,4,42,84,null);
Insert into REC_BOARD  values (85,'������ 85','ȸ�� 85',sysdate,sysdate,85,'�丮 �Ұ� 85�Դϴ�.','�丮 �� 85�Դϴ�.',85,1,4,43,85,null);
Insert into REC_BOARD  values (86,'������ 86','ȸ�� 86',sysdate,sysdate,86,'�丮 �Ұ� 86�Դϴ�.','�丮 �� 86�Դϴ�.',86,1,4,44,86,null);
Insert into REC_BOARD  values (87,'������ 87','ȸ�� 87',sysdate,sysdate,87,'�丮 �Ұ� 87�Դϴ�.','�丮 �� 87�Դϴ�.',87,1,4,45,87,null);
Insert into REC_BOARD  values (88,'������ 88','ȸ�� 88',sysdate,sysdate,88,'�丮 �Ұ� 88�Դϴ�.','�丮 �� 88�Դϴ�.',88,1,4,46,88,null);
Insert into REC_BOARD  values (89,'������ 89','ȸ�� 89',sysdate,sysdate,89,'�丮 �Ұ� 89�Դϴ�.','�丮 �� 89�Դϴ�.',89,1,4,47,89,null);
Insert into REC_BOARD  values (90,'������ 90','ȸ�� 90',sysdate,sysdate,90,'�丮 �Ұ� 90�Դϴ�.','�丮 �� 90�Դϴ�.',90,1,4,48,90,null);
Insert into REC_BOARD  values (91,'������ 91','ȸ�� 91',sysdate,sysdate,91,'�丮 �Ұ� 91�Դϴ�.','�丮 �� 91�Դϴ�.',91,1,1,11,91,null);
Insert into REC_BOARD  values (92,'������ 92','ȸ�� 92',sysdate,sysdate,92,'�丮 �Ұ� 92�Դϴ�.','�丮 �� 92�Դϴ�.',92,1,1,11,92,null);
Insert into REC_BOARD  values (93,'������ 93','ȸ�� 93',sysdate,sysdate,93,'�丮 �Ұ� 93�Դϴ�.','�丮 �� 93�Դϴ�.',93,1,1,11,93,null);
Insert into REC_BOARD  values (94,'������ 94','ȸ�� 94',sysdate,sysdate,94,'�丮 �Ұ� 94�Դϴ�.','�丮 �� 94�Դϴ�.',94,1,1,11,94,null);
Insert into REC_BOARD  values (95,'������ 95','ȸ�� 95',sysdate,sysdate,95,'�丮 �Ұ� 95�Դϴ�.','�丮 �� 95�Դϴ�.',95,1,1,11,95,null);
Insert into REC_BOARD  values (96,'������ 96','ȸ�� 96',sysdate,sysdate,96,'�丮 �Ұ� 96�Դϴ�.','�丮 �� 96�Դϴ�.',96,1,1,11,96,null);
Insert into REC_BOARD  values (97,'������ 97','ȸ�� 97',sysdate,sysdate,97,'�丮 �Ұ� 97�Դϴ�.','�丮 �� 97�Դϴ�.',97,1,1,11,97,null);
Insert into REC_BOARD  values (98,'������ 98','ȸ�� 98',sysdate,sysdate,98,'�丮 �Ұ� 98�Դϴ�.','�丮 �� 98�Դϴ�.',98,1,1,11,98,null);
Insert into REC_BOARD  values (99,'������ 99','ȸ�� 99',sysdate,sysdate,99,'�丮 �Ұ� 99�Դϴ�.','�丮 �� 99�Դϴ�.',99,1,1,11,99,null);
Insert into REC_BOARD  values (100,'������ 100','ȸ�� 100',sysdate,sysdate,100,'�丮 �Ұ� 100�Դϴ�.','�丮 �� 100�Դϴ�.',100,1,1,11,100,null);

--------------------------------------------------------------------------------

-- rec_member ���̺� ���� ������ �߰� // ����
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (1,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (2,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (3,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (4,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (5,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:08:37','RR/MM/DD/HH24:MI:SS'),1,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (6,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (7,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (8,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (9,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (10,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:08:49','RR/MM/DD/HH24:MI:SS'),1,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (11,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (12,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (13,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (14,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (15,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:08:53','RR/MM/DD/HH24:MI:SS'),2,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (16,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (17,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (18,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (19,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (20,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:08:54','RR/MM/DD/HH24:MI:SS'),2,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (21,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (22,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (23,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (24,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (25,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:08:57','RR/MM/DD/HH24:MI:SS'),3,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (26,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (27,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (28,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (29,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (30,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:08:59','RR/MM/DD/HH24:MI:SS'),3,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (31,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (32,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (33,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (34,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (35,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:09:02','RR/MM/DD/HH24:MI:SS'),4,'N');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (36,'recipe1@naver.com','1231','�̸�1','�г���1','01012345671',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (37,'recipe2@naver.com','1232','�̸�2','�г���2','01012345672',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (38,'recipe3@naver.com','1233','�̸�3','�г���3','01012345673',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (39,'recipe4@naver.com','1234','�̸�4','�г���4','01012345674',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');
Insert into RECIPE.REC_MEMBER (MNO,EMAIL,PW,NAME,NICKNAME,PNUM,REG_DATE,GNO,DELYN) values (40,'recipe5@naver.com','1235','�̸�5','�г���5','01012345675',to_date('23/08/01/20:09:03','RR/MM/DD/HH24:MI:SS'),4,'Y');


-- rec_grade ���̺� ������ �߰� // ����
insert into rec_grade values(1, 'cook Helper', '1,000p');
insert into rec_grade values(2, 'cook Manager', '3,000p');
insert into rec_grade values(3, 'sous Chef', '5,000p');
insert into rec_grade values(4, 'head Chef', '10,000p');

-- rec_notice ���̺� ������  �߰� // ����

Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (1,'����1','�ȳ��ϼ���. �ݰ����ϴ�.1','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (2,'����2','�ȳ��ϼ���. �ݰ����ϴ�.2','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (3,'����3','�ȳ��ϼ���. �ݰ����ϴ�.3','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (4,'����4','�ȳ��ϼ���. �ݰ����ϴ�.4','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (5,'����5','�ȳ��ϼ���. �ݰ����ϴ�.5','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (6,'����6','�ȳ��ϼ���. �ݰ����ϴ�.6','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (7,'����7','�ȳ��ϼ���. �ݰ����ϴ�.7','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (8,'����8','�ȳ��ϼ���. �ݰ����ϴ�.8','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (9,'����9','�ȳ��ϼ���. �ݰ����ϴ�.9','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (10,'����10','�ȳ��ϼ���. �ݰ����ϴ�.10','admin',to_date('23/08/01/20:09:31','RR/MM/DD/HH24:MI:SS'),0,'�Ϲ�');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (11,'����ȸ�� �̺�Ʈ1','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.1','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (12,'����ȸ�� �̺�Ʈ2','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.2','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (13,'����ȸ�� �̺�Ʈ3','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.3','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (14,'����ȸ�� �̺�Ʈ4','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.4','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (15,'����ȸ�� �̺�Ʈ5','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.5','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (16,'����ȸ�� �̺�Ʈ6','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.6','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (17,'����ȸ�� �̺�Ʈ7','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.7','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (18,'����ȸ�� �̺�Ʈ8','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.8','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (19,'����ȸ�� �̺�Ʈ9','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.9','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (20,'����ȸ�� �̺�Ʈ10','���ο��� ȸ���е��� ���� �̺�Ʈ�� �غ�Ǿ��ֽ��ϴ�.10','admin',to_date('23/08/01/20:09:41','RR/MM/DD/HH24:MI:SS'),0,'�̺�Ʈ');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (21,'������1','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.1','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (22,'������2','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.2','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (23,'������3','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.3','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (24,'������4','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.4','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (25,'������5','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.5','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (26,'������6','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.6','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (27,'������7','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.7','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (28,'������8','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.8','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (29,'������9','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.9','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');
Insert into RECIPE.REC_NOTICE (NNO,NTITLE,NCONTENT,NWRITER,NREGDATE,NCOUNT,GUBUN) values (30,'������10','�Խù� 5�� �̻��� cook manager�� �˴ϴ�.10','admin',to_date('23/08/01/20:09:43','RR/MM/DD/HH24:MI:SS'),0,'���� ���� ����');

-- [ REC_BOARD ( �Խñ� ���̺�) ������ �Է� ]

Insert into REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(6,'������ �ٷ� �ظ��� �� �ִ� ������ ��ġ�','������',to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),0,'��ġ�� ������������ ����� ���� �� �ִ� �ս��� ��ġ� ������ �Դϴ�.','��ġ�� �߽�.. ������ �鼳������ �غ����ּ��� ! !',0,5,1,null);
Insert into REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(3,'����','�Ϲ�ȸ��',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'�Ұ���1','�丮��1',0,5,2,null);
Insert into .REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(4,'����2','������',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'�Ұ���2','�丮��2',0,5,1,null);
Insert into REC_BOARD (B_NO,TITLE,NICKNAME,REGDATE,UPDATEDATE,BOOMUP,INTRO,COOKTIP,VIEWCNT,STAR,MNO,REPLYCNT) values 
(5,'������ �ٷ� �ظ��� �� �ִ� ������ ������� ������','������',to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),0,'����� ������������ ����� ���� �� �ִ� �ս��� ������� ������ �Դϴ�.','����� ��Ǯ�.. ������ �鼳������ �غ����ּ��� ! !',0,5,1,10);

Insert into REC_BOARD values 
(4,'����2','������',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'�Ұ���2','�丮��2',0,5,1,3,31,null);


delete rec_board;

Insert into REC_BOARD values 
(6,'������ �ٷ� �ظ��� �� �ִ� ������ ��ġ�','������',to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),to_date('23/07/27 11:31:45','RR/MM/DD hh24:MI:SS'),0,'��ġ�� ������������ ����� ���� �� �ִ� �ս��� ��ġ� ������ �Դϴ�.','��ġ�� �߽�.. ������ �鼳������ �غ����ּ��� ! !',0,5,1,11,1,null);

Insert into REC_BOARD values 
(3,'����','�Ϲ�ȸ��',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'�Ұ���1','�丮��1',0,5,2,21,2,null);

Insert into REC_BOARD values 
(4,'����2','������',to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 14:24:56','RR/MM/DD hh24:MI:SS'),0,'�Ұ���2','�丮��2',0,5,3,31,1,null);

Insert into REC_BOARD values 
(5,'������ �ٷ� �ظ��� �� �ִ� ������ ������� ������','������',to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),to_date('23/07/26 15:58:29','RR/MM/DD hh24:MI:SS'),0,'����� ������������ ����� ���� �� �ִ� �ս��� ������� ������ �Դϴ�.','����� ��Ǯ�.. ������ �鼳������ �غ����ּ��� ! !',0,5,4,41,1,10);


-- [ REC_REPLY ( �丮�ı� ���̺�) ������ �Է� ]

Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (68,to_date('23/08/01 12:02:27','RR/MM/DD hh24:MI:SS'),'�ľ��������',5,'�ľ�����',5);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (65,to_date('23/08/01 09:45:32','RR/MM/DD hh24:MI:SS'),'����5���ı�',5,'�����ۼ���',5);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (66,to_date('23/08/01 10:20:13','RR/MM/DD hh24:MI:SS'),'����',5,'����',4);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (70,to_date('23/08/01 12:08:52','RR/MM/DD hh24:MI:SS'),'��ġ��� �Ǿ����',5,'�����ۼ���',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (72,to_date('23/08/02 09:24:57','RR/MM/DD hh24:MI:SS'),'�����ħ���Դϴ�',5,'���°����ħ��',4);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (61,to_date('23/08/01 09:03:08','RR/MM/DD hh24:MI:SS'),'���̻���',5,'���̻���',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (60,to_date('23/08/01 09:02:48','RR/MM/DD hh24:MI:SS'),'������������',5,'������������',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (62,to_date('23/08/01 09:03:29','RR/MM/DD hh24:MI:SS'),'�������´��',5,'�������´��',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (69,to_date('23/08/01 12:08:10','RR/MM/DD hh24:MI:SS'),'������� �Ǿ����.',5,'�����ۼ���',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (63,to_date('23/08/01 09:26:32','RR/MM/DD hh24:MI:SS'),'�����',5,'����ۼ�',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (64,to_date('23/08/01 09:26:54','RR/MM/DD hh24:MI:SS'),'���°�������ı�',5,'���°������',0);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (67,to_date('23/08/01 11:54:43','RR/MM/DD hh24:MI:SS'),'�̹������ε� ',5,'�����ۼ���',5);
Insert into REC_REPLY (R_NO,REPLYDATE,REPLY,B_NO,WRITER,STAR) values (71,to_date('23/08/01 13:39:04','RR/MM/DD hh24:MI:SS'),'ħ��λ�',5,'���ΰ�ħ',5);

-------------------------------------------------------------------------------------------------------------------------
-- [ REC_MATERIAL ( ������ �ʿ� ��� ���̺� ) ������ �Է� ] ?

--- ���⼭ M_NO ��  �ʿ���� �⺻Ű�� MEMBER ���̺��� MNO �ʹ� �ٸ� ������ �Դϴ�. 
 
   Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (4,3,4,5,'����');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (5,4,5,5,'���');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (6,5,2,5,'����');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (3,1,3,6,'���');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (1,1,5,5,'���');
    Insert into REC_MATERIAL (M_NO,I_NO,MATERIALCNT,B_NO,I_NAME) values (2,2,4,5,'��');

-------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------

-- REC_STEP ( �丮���� ���̺� ) ������ �Է� ] ?


Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (2,'����� �ĸ� �غ��մϴ�.',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (3,'����� �� Ǯ� �ĸ� �ۼ� ����ݴϴ�.',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (4,'���� 4���� ���� �װ� ���Ҿ�� �׸��� ��������Ҷ��� ������ ���!! �ƽ���?',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (5,'���⼭ ���� �׳� ����� ���µ�..���ֺδ� �����Ǵ� ù���� ��ũ�����ϱ�!!',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (6,'�������� �о�ΰ� �� ����� �ױ� �������� �����ֽø� �˴ϴ�.',5);
Insert into REC_STEP (S_NO,STEP_CONTENT,B_NO) values (7,'÷�� ��ũ������ �Ǿ��ִٺ��� �� �ȸ����ٽͱ��ߴµ�... ��� ����� �װ� ���ٺ��� ���ڰ� �߸������󱸿� ����',5);

-------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------

-- REC_INGREDIENTS ( ���� ������� ���̺� ) ������ �Է� ] ?

Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (1,'���','�����/����Ķ���/�����ް�','���̼���','����','�帣�� ���� �� �Ĵ´�.');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (2,'��','������/��ġ�/������','�ſ���','�������','�帣�� ���� �� �Ĵ´�.');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (3,'����','��/','�޾���','�ұ�','������ ���� ����');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (4,'���','�������/','����������','����','�帣�� ���� �� �Ĵ´�.');
Insert into REC_INGREDIENTS (I_NO,I_NAME,I_COOK,I_POWER,I_FRIENDFOOD,I_REPAIR) values (5,'����','���������Ѵ�/','�������ϰ���','����','�帣�� ���� �� �Ĵ´�.');


-------------------------------------------------------------------------------------------------------------------------

-- REC_INGREDIENTS ( �Ϲ� ��� ���̺� ) ������ �Է� ] ?

Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(4,'��� �ۼ� �׽�Ʈ','testWriter',to_date('23/08/01 12:31:28','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 12:31:28','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(6,'����ۼ��׽�Ʈ���','����ۼ��׽�Ʈ',to_date('23/08/01 13:35:53','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 13:35:53','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(2,'�Ϲݴ�۳���','�Ϲݴ���ۼ���',to_date('23/08/01 10:45:53','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 10:45:53','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(3,'�Ϲݴ�۳���2','�Ϲݴ���ۼ���2',to_date('23/08/01 11:33:49','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 11:33:49','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(8,'����ۼ��׽�Ʈ���2','�ۼ����Է�2',to_date('23/08/02 09:25:22','RR/MM/DD hh24:MI:SS'),to_date('23/08/02 09:25:22','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values 
(5,'����ۼ��׽�Ʈ���','����ۼ��׽�Ʈ',to_date('23/08/01 13:34:53','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 13:34:53','RR/MM/DD hh24:MI:SS'),5);
Insert into REC_GENERALREPLY (GR_NO,CONTENT,REPLYER,REGDATE,UPDATEDATA,B_NO) values
(7,'����ۼ��׽�Ʈ���','����ۼ��׽�Ʈ',to_date('23/08/01 15:04:59','RR/MM/DD hh24:MI:SS'),to_date('23/08/01 15:04:59','RR/MM/DD hh24:MI:SS'),5);
-------------------------------------------------------------------------------------------------------------------------

-- LIKE_RECIPE ( ���ƿ� ���̺�  ) ������ �Է� ] ?

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
- - ������ ���� seq_board
CREATE SEQUENCE seq_board
    MINVALUE 1
    MAXVALUE 9999999999999999999999999999
    INCREMENT BY 1
    START WITH 1;

-- com_board insert��

INSERT INTO com_board (com_bno, nickName, com_title, com_content, replycnt, mno)
VALUES (seq_board.nextval , '�ڴ���', '����߸�������', '���忡�� ��Դ� ��߸� �������� ����������', 0, 1);
INSERT INTO com_board (com_bno, nickName, com_title, com_content, replycnt, mno)
VALUES (seq_board.nextval , '������', '�н��������̹ٷα׸�', '������� �б��տ��� ��Դ¸� !!', 0, 1);
INSERT INTO com_board (com_bno, nickName, com_title, com_content, replycnt, mno)
VALUES (seq_board.nextval , '�丮��', '�ƻ���̼ҹ���', '���� �ƻ��� ���̼ҹ��̶��ϴ�~', 0, 1);

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
				          			THEN TRUNC(ROUND((SYSDATE - ct.regdate) * 24, 2)) || '�ð� ��'  
				          			 WHEN ct.regdate >= TRUNC(SYSDATE) - 7 AND ct.regdate < TRUNC(SYSDATE) 
				          			THEN TRUNC(ROUND(SYSDATE - ct.regdate)) || '�� ��'
				          			ELSE TO_CHAR(ct.regdate, 'YYYY/MM/DD') END AS regdate
				          	FROM com_board ct
				          	 -- WHERE com_content LIKE '%' || #{sWord} || '%'
                              ) t
				)
				WHERE rn BETWEEN 1 AND 20;

Insert into com_board
    select
        seq_board.nextval,
        'ȸ�� ' || level,
        '��� Ÿ�� ���� �� ����? ' || level,
        '���� �� ���İ�Ƽ�� ��Ÿ�� ���ݾƿ� ' || level,
        sysdate,
        sysdate,
        level,
        level
        from dual
        connect by level <= 100;
        

-- 2. com_file ���������

CREATE TABLE com_file (
    uuid VARCHAR2(100) NOT NULL,
    uploadpath VARCHAR2(200) NOT NULL,
    filetype CHAR(1) NOT NULL,
    filename VARCHAR2(100) NOT NULL,
    com_bno NUMBER NOT NULL,
    CONSTRAINT PK_COM_F PRIMARY KEY (uuid)
);

? com_file insert��
INSERT INTO com_file (uuid, filetype, uploadpath,  filename, com_bno)
VALUES ('f59asdfdf4-5145-4e47-9cb5-8b7af8c6423e', 'I', '/uploads/', 'file1.jpg', 2);
INSERT INTO com_file (uuid, filetype, uploadpath,  filename, com_bno)
VALUES ('f59asdfdf4-5145-4e47-9cb5-86241423e', 'I', '/uploads/', 'file1.jpg', 3);

-- 3. com_reply ���
CREATE TABLE com_reply (
    R_NO NUMBER NOT NULL,
    replydate DATE DEFAULT sysdate,
    updatedate Date DEFAULT sysdate,
    reply VARCHAR2(2000) NOT NULL,
    com_bno NUMBER NOT NULL,
    mno number not null,
    CONSTRAINT PK_COM_R PRIMARY KEY (R_NO)
);

? ������ ���� seq_comreply
CREATE SEQUENCE seq_comreply
    MINVALUE 1
    MAXVALUE 9999999999999999999999999999
    INCREMENT BY 1
    START WITH 1;

? com_reply insert��
insert into com_reply values(seq_comreply.nextval,sysdate,sysdate,'��ս��ϴ�',11,1);
insert into com_reply values(seq_comreply.nextval,sysdate,sysdate,'��������������',53,1);
insert into com_reply values(seq_comreply.nextval,sysdate,sysdate,'���� ���� ',43,1);


