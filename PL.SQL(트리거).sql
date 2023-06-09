/*
    <TRIGGER>
        테이블이 INSERT, UPDATE, DELETE 등 DML 구문에 의해서 변경될 경우
        자동으로 실행될 내용을 정의해놓는 객체이다.
        
        * 트리거의 종류
          1) SQL 문의 실행 시기에 따른 분류
            - BEFORE TRIGGER : 해당 SQL 문장 실행 전에 트리거를 실행한다.
            - AFTER TRIGGER : 해당 SQL 문장 실행 후에 트리거를 실행한다.
          
          2) SQL 문에 의해 영향을 받는 행에 따른 분류
            - 문장 트리거 : 해당 SQL 문에 한 번만 트리거를 실행한다.
            - 행 트리거 : 해당 SQL 문에 영향을 받는 행마다 트리거를 실행한다.
            
        [표현법]
            CREATE OR REPLACE TRIGGER 트리거명
            BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이명
            [FOR EACH ROW]  --> 기본이 문장 트리거 / EACH 쓰면 행 트리거
            DECLARE
                선언부
            BEGIN
                실행부
            EXCEPTION
                예외처리부
            END;
            /
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRG_EMP_IST
AFTER INSERT ON EMP
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입 사원이 등록되었습니당 히힣');
END;
/
DESC EMP;
SELECT MAX(EMP_ID)+1 FROM EMP;

INSERT INTO EMP (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES((SELECT MAX(EMP_ID)+1 FROM EMP)
                , '이찬솔', '123456-1234567', 'J9' );

UPDATE EMP SET DEPT_CODE = NULL WHERE DEPT_CODE = 'D1';
SELECT * FROM EMP WHERE DEPT_CODE = 'D1';
-- TODO 다시 확인해봐야함
CREATE OR REPLACE TRIGGER TRG_DEPT_DEL
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('사원 정보가 업데이트 되었슴댕');
    -- FOR EACH ROW 구문이 사용된 행 트리거에서만 쓸 수 있는 것들
    -- :0LD     테이블이 변경되기 전 데이터
    -- :NEW     테이블이 변경된 후 데이터
    DBMS_OUTPUT.PUT_LINE('변경 전' ||:0LD.DEPT_CODE||'변경 후' ||:NEW.DEPT_CODE);
END;
/

DROP TRIGGER TRG_DEPT_DEL;

-- 테이블의 구조만 복사하여 HISTORY 테이블을 생성
CREATE TABLE EMP_HISTORY
AS
    SELECT EMP.*, SYSDATE AS "REGDATE" FROM EMP WHERE 1<0;
SELECT * FROM EMP_HISTORY;

-- EMP 테이블에 업데이트 작업이 일어난 후
-- 수정사항이 발생한 행의 이전 정보를 EMP_HISTORY 테이블에 입력
CREATE OR REPLACE TRIGGER TRG_EMP_UDT
AFTER UPDATE ON EMP
FOR EACH ROW
BEGIN
    INSERT INTO EMP_HISTORY (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE)
        VALUES(:OLD.EMP_ID, :OLD.EMP_NAME, :OLD.EMP_NO, :OLD.JOB_CODE);
END;
/

UPDATE EMP SET EMP_NAME = '미미쨩' WHERE EMP_ID = '105';
SELECT * FROM EMP WHERE EMP_ID = '105';
SELECT * FROM EMP_HISTORY;






