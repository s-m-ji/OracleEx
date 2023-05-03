SET SERVEROUTPUT ON;
-- [����2]   1 ~ 10 ������ ������ ¦���� ���� ���ϴ� �͸��� ���ν����� �ۼ� �Ͻÿ�

DECLARE
  even_sum NUMBER := 0;
BEGIN
  FOR i IN 1..10 LOOP
    IF MOD(i, 2) = 0 THEN
      even_sum := even_sum + i;
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('1���� 10���� ¦���� ��: ' || even_sum);
END;
/

DECLARE
    NUM_SUM NUMBER := 0;
BEGIN
    FOR i IN 1..10
    LOOP
        IF MOD (i,2)=0 THEN        
--            dbms_output.put_line(i);
            NUM_SUM := NUM_SUM + i;
        END IF;
   END LOOP;  
   DBMS_OUTPUT.PUT_LINE(NUM_SUM);
END;
/

DECLARE 
    NUM NUMBER := 1;
    SUM NUMBER := 0;
BEGIN
    WHILE NUM <= 10
        LOOP
            IF MOD (NUM,2)=0 THEN 
            DBMS_OUTPUT.PUT_LINE(NUM);        
            END IF;
        NUM := NUM + 1;
        SUM := NUM + SUM;
        DBMS_OUTPUT.PUT_LINE(SUM);  
    END LOOP;
END;
/

DECLARE
    NUM NUMBER := 1;
    SUM NUMBER := 0;
BEGIN
    LOOP
        IF MOD (NUM,2)=0 THEN 
            DBMS_OUTPUT.PUT_LINE(NUM);  
            
            SUM := NUM + SUM;
            DBMS_OUTPUT.PUT_LINE(SUM); 
        END IF;
        NUM := NUM + 1;
        EXIT WHEN NUM > 10;        
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE PROC_DELETE_EMP
    (P_EMP_ID   EMP.EMP_ID%TYPE)
IS
BEGIN
    DELETE EMP WHERE EMP_ID = P_EMP_ID;
END;
/
EXEC PROC_DELETE_EMP(301);
SELECT * FROM EMP ORDER BY 1 DESC;

CREATE OR REPLACE FUNCTION FN_GET_AGE
    (P_EMP_NO   EMP.EMP_NO%TYPE)
RETURN NUMBER
IS
BEGIN   
RETURN EXTRACT(YEAR FROM SYSDATE) - ('19'||SUBSTR(P_EMP_NO,1,2));   
END;
/
SELECT FN_GET_AGE('821235-1985634') FROM DUAL;
SELECT * FROM EMP;
SELECT EMP_ID ���, EMP_NAME �����, FN_GET_AGE(EMP_NO) ���� FROM EMP;

/*
[����7]  Ʈ���Ÿ� �ۼ� �Ͻÿ�
Ʈ���Ÿ�    : TRG_DEPT_DEL
ó������    :
1.    �μ����̺��� �μ��ڵ��� ���� �۾��� �߻��� ���� ����
2.    ������̺��� �μ��ڵ忡 ������ �μ��ڵ尡 �Էµ� ��� �μ��ڵ带 D1���� ������Ʈ
*/
CREATE OR REPLACE TRIGGER TRG_DEPT_DEL
AFTER DELETE ON DEPT
FOR EACH ROW
BEGIN
--        UPDATE EMP SET DEPT_CODE = 'D1' WHERE DEPT_CODE IS NULL;
        UPDATE EMP SET DEPT_CODE = 'D1' WHERE DEPT_CODE  = :OLD.DEPT_ID;
END;
/
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! �߰� �ۼ� �ʿ�

SELECT * FROM DEPT;

SELECT * FROM EMP WHERE EMP_NAME = '������';

SELECT EMP_NAME, DEPT_CODE FROM EMP;

UPDATE EMP SET DEPT_CODE = 'D1' WHERE DEPT_CODE IS NULL;

UPDATE EMP SET DEPT_CODE = 'D0' WHERE EMP_NAME = '������';

INSERT INTO DEPT VALUES ('D0' , 'TEST', 'L0');

DELETE DEPT WHERE LOCATION_ID = 'L0';

UPDATE EMP 
SET DEPT_CODE = 'D1' 
WHERE DEPT_CODE !=
           (SELECT DEPT_ID 
           FROM DEPT 
           LEFT JOIN EMP ON (DEPT_CODE = DEPT_ID)
           );




