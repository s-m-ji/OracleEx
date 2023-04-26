/*
<SEQUENCE>
    정수값을 순차적으로 생성하는 역할을 하는 객체
    [표현법]
    CREATE SEQUENCE 시퀀스명
        [START WITH 숫자] : 처음 발생시킬 시작 값, 기본값 1
        [INCREAMENT BY 숫자] : 다음 값에 대한 증가치, 기본값 1
        [MAXVALUE 숫자] : 발생시킬 최대값 10의 27승 -1
        [MINVALUE 숫자] : 발생시킬 최소값 -10의 26승
        [CYCLE | NOCYCLE] : 시퀀스가 최대값에 도달할 경우 START WITH으로 돌아감
        [CACHE 바이트크기 | NOCACHE]; : 메모리 상에서 시퀀스 값 관리(기본값 20 바이트)
*/
CREATE SEQUENCE SEQ_EMP_COPY_ID 
START WITH 100;
-- 현재 계정이 가지고 있는 스퀀스들에 대한 정보를 조회
SELECT * FROM USER_SEQUENCES;

-- NEXTVAL를 한 번이라도 수행하지 않는 이상 CURRVAL을 가져올 수 없다. (조회할 때마다 +1이 된다)
-- CURRVAL는 마지막으로 수행된 NEXTVAL값을 저장해서 보여주는 값이다. (+1이 되지 않은 값 그대로를 보여줌)

SELECT SEQ_EMP_COPY_ID.CURRVAL FROM DUAL;
SELECT SEQ_EMP_COPY_ID.NEXTVAL FROM DUAL;

-- 시퀀스명 : SEQ_TEST
-- 300 시작
-- 5씩 증가
-- 310
-- NOCYCLE
-- NOCACHE
-- 시퀀스 생성
CREATE SEQUENCE SEQ_TEST
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;
-- 시퀀스 값 확인
SELECT SEQ_TEST.NEXTVAL FROM DUAL;
SELECT SEQ_TEST.CURRVAL FROM DUAL;
SELECT SEQ_TEST.NEXTVAL FROM DUAL;
-- MAX값 초과로 오류 발생
SELECT SEQ_TEST.NEXTVAL FROM DUAL; 

-- MAX값을 400 으로 변경
-- 시작값은 변경 불가능 합니다. 
-- ===>> 시작값을 변경하고 싶다면 삭제후 다시 작성
-- START WITH 구문오류 발생 
ALTER SEQUENCE SEQ_TEST
--START WITH 200
INCREMENT BY 1
MAXVALUE 400;

-- SELECT 결과 집합을 테이블로 생성
CREATE TABLE EMP_COYP
AS SELECT * FROM EMP;

-- SEQ_EMP_COPY : 207번부터 시작해서 1씩 증가하는 시퀀스를 생성
CREATE SEQUENCE SEQ_EMP_COPY
START WITH 207
INCREMENT BY 1;

DESC EMP_COYP;

SELECT * FROM EMP_COYP;

INSERT INTO EMP_COYP (EMP_ID, EMP_NAME, HIRE_DATE) 
            VALUES (SEQ_EMP_COPY.NEXTVAL , '홍길동', '2005-02-01');
            
 SELECT * FROM EMP_COYP ORDER BY EMP_ID DESC;           
            
SELECT  MAX(EMP_ID)
FROM    EMP_COYP;

/*
    의사컬럼
    - 테이블의 컬럼처럼 동작 하지만 실제로 테이블에 저장되지 않는 컬럼
    
    SEQUENCE 에서 사용되는 의사컬럼
        NEXTVAL, CURRVAL
    ROWNUM : 쿼리에서 반환되는 각 로우의 순서값 
    ROWID : 테이블에 저장된 각 로우가 저장된 주소값
*/ 
-- 페이징 처리 할 때 사용
SELECT * 
FROM (
    SELECT ROWNUM RN, EMP_COYP.* 
    FROM EMP_COYP
)
WHERE RN BETWEEN 10 AND 19;














