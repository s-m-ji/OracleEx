/*
    <TRIGGER>
        Å×ÀÌºíÀÌ INSERT, UPDATE, DELETE µî DML ±¸¹®¿¡ ÀÇÇØ¼­ º¯°æµÉ °æ¿ì
        ÀÚµ¿À¸·Î ½ÇÇàµÉ ³»¿ëÀ» Á¤ÀÇÇØ³õ´Â °´Ã¼ÀÌ´Ù.
        
        * Æ®¸®°ÅÀÇ Á¾·ù
          1) SQL ¹®ÀÇ ½ÇÇà ½Ã±â¿¡ µû¸¥ ºÐ·ù
            - BEFORE TRIGGER : ÇØ´ç SQL ¹®Àå ½ÇÇà Àü¿¡ Æ®¸®°Å¸¦ ½ÇÇàÇÑ´Ù.
            - AFTER TRIGGER : ÇØ´ç SQL ¹®Àå ½ÇÇà ÈÄ¿¡ Æ®¸®°Å¸¦ ½ÇÇàÇÑ´Ù.
          
          2) SQL ¹®¿¡ ÀÇÇØ ¿µÇâÀ» ¹Þ´Â Çà¿¡ µû¸¥ ºÐ·ù
            - ¹®Àå Æ®¸®°Å : ÇØ´ç SQL ¹®¿¡ ÇÑ ¹ø¸¸ Æ®¸®°Å¸¦ ½ÇÇàÇÑ´Ù.
            - Çà Æ®¸®°Å : ÇØ´ç SQL ¹®¿¡ ¿µÇâÀ» ¹Þ´Â Çà¸¶´Ù Æ®¸®°Å¸¦ ½ÇÇàÇÑ´Ù.
            
        [Ç¥Çö¹ý]
            CREATE OR REPLACE TRIGGER Æ®¸®°Å¸í
            BEFORE|AFTER INSERT|UPDATE|DELETE ON Å×ÀÌ¸í
            [FOR EACH ROW]  --> ±âº»ÀÌ ¹®Àå Æ®¸®°Å / EACH ¾²¸é Çà Æ®¸®°Å
            DECLARE
                ¼±¾ðºÎ
            BEGIN
                ½ÇÇàºÎ
            EXCEPTION
                ¿¹¿ÜÃ³¸®ºÎ
            END;
            /
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRG_EMP_IST
AFTER INSERT ON EMP
BEGIN
    DBMS_OUTPUT.PUT_LINE('½ÅÀÔ »ç¿øÀÌ µî·ÏµÇ¾ú½À´Ï´ç È÷ÆR');
END;
/
DESC EMP;
SELECT MAX(EMP_ID)+1 FROM EMP;

INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES((SELECT MAX(EMP_ID)+1 FROM EMP)
                , 'ÀÌÂù¼Ö', '123456-1234567', 'J9' );

UPDATE EMP SET DEPT_CODE = NULL WHERE DEPT_CODE = 'D1';
SELECT * FROM EMP WHERE DEPT_CODE = 'D1';
-- TODO ´Ù½Ã È®ÀÎÇØºÁ¾ßÇÔ
CREATE OR REPLACE TRIGGER TRG_DEPT_DEL
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('»ç¿ø Á¤º¸°¡ ¾÷µ¥ÀÌÆ® µÇ¾ú½¿´ó');
    -- FOR EACH ROW ±¸¹®ÀÌ »ç¿ëµÈ Çà Æ®¸®°Å¿¡¼­¸¸ ¾µ ¼ö ÀÖ´Â °Íµé
    -- :0LD     Å×ÀÌºíÀÌ º¯°æµÇ±â Àü µ¥ÀÌÅÍ
    -- :NEW     Å×ÀÌºíÀÌ º¯°æµÈ ÈÄ µ¥ÀÌÅÍ
    DBMS_OUTPUT.PUT_LINE('º¯°æ Àü' ||:0LD.DEPT_CODE||'º¯°æ ÈÄ' ||:NEW.DEPT_CODE);
END;
/

DROP TRIGGER TRG_DEPT_DEL;

-- Å×ÀÌºíÀÇ ±¸Á¶¸¸ º¹»çÇÏ¿© HISTORY Å×ÀÌºíÀ» »ý¼º
CREATE TABLE EMP_HISTORY
AS
    SELECT EMP.*, SYSDATE AS "REGDATE" FROM EMP WHERE 1<0;
SELECT * FROM EMP_HISTORY;

-- EMP Å×ÀÌºí¿¡ ¾÷µ¥ÀÌÆ® ÀÛ¾÷ÀÌ ÀÏ¾î³­ ÈÄ
-- ¼öÁ¤»çÇ×ÀÌ ¹ß»ýÇÑ ÇàÀÇ ÀÌÀü Á¤º¸¸¦ EMP_HISTORY Å×ÀÌºí¿¡ ÀÔ·Â
CREATE OR REPLACE TRIGGER TRG_EMP_UDT
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    INSERT INTO EMP_HISTORY (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES(:OLD.EMP_ID, :OLD.EMP_NAME, :OLD.EMP_NO, :OLD.JOB_CODE);
END;
/

UPDATE EMP SET EMP_NAME = '¹Ì¹ÌÂ»' WHERE EMP_ID = '105';
SELECT * FROM EMP WHERE EMP_ID = '105';
SELECT * FROM EMP_HISTORY;






