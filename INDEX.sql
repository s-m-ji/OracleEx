/*
    < INDEX >
    SQL 명령문의 처리 속도를 향상 시키기 위해서 컬럼에 대해 생성하는 오라클 객체
    컬럼을 복사하여 정렬해 놓고 정렬된 상태의 데이터를 조회
    
    - 검색 속도가 빨라지고 시스템에 걸리는 부하를 줄여 시스템 전체 성능 향상
    - 인덱스를 위한 추가 저장 공간이 필요하고 인덱스를 생성하는데 시간이 걸림
    - 데이터의 변경 작업이 자주 일어나는 경우 오히려 성능이 저하 될수 있음
    
    [사용법]
    CREATE [UNIQUE] INDEX 인덱스명 ON 테이블명(컬럼명, 컬럼명 | 함수명, 함수 계산식);
*/
-- 인덱스 조회 
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_INDEXES WHERE TABLE_NAME='TB_STUDENT';
SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'TB_STUDENT';

-- 테이블 복사 생성
CREATE TABLE COPY_STUDENT AS SELECT * FROM TB_STUDENT WHERE 1=3;
-- 시퀀스 생성 (기본: 1부터 시작하여 1씩 증가)
CREATE SEQUENCE SEQ_TB_STUDENT_NO;

-- 데이터 삽입
-- 학생 테이블의 데이터를 복사하여 입력
-- STUDENT_NO : 시퀀스의 증가값 이용 A로 시작하는 8자리 숫자값 (e,g A00000001)
-- STUDENT_SSN : 시퀀스의 현재값 이용

--INSERT INTO 

SELECT LPAD('A'||(SEQ_TB_STUDENT_NO.NEXTVAL),0,8) FROM DUAL;
SELECT 'A'||LPAD(SEQ_TB_STUDENT_NO.NEXTVAL,8,0), SEQ_TB_STUDENT_NO.CURRVAL FROM DUAL;

DESC COPY_STUDENT;

-- 588건
SELECT COUNT(*) FROM TB_STUDENT;
-- 
SELECT COUNT(*) FROM COPY_STUDENT;
SELECT * FROM COPY_STUDENT ORDER BY 1 DESC;
SELECT * FROM COPY_STUDENT ORDER BY 1;

INSERT INTO COPY_STUDENT
    ( SELECT 'A'||LPAD(SEQ_TB_STUDENT_NO.NEXTVAL,8,0)
        ,DEPARTMENT_NO
        ,STUDENT_NAME
        ,SEQ_TB_STUDENT_NO.CURRVAL
        ,STUDENT_ADDRESS
        ,ENTRANCE_DATE
        ,ABSENCE_YN
        ,COACH_PROFESSOR_NO
--    FROM TB_STUDENT
        FROM COPY_STUDENT   -- 자기자신을 복사
    ) 
;
-- (INDEX 생성 전) 질의 결과 : 0.093초
SELECT * FROM COPY_STUDENT WHERE STUDENT_NO = 'A00123456';
-- 인덱스 생성
-- 컬럼에 중복이 없는 경우 UNIQUE 인덱스로 생성
CREATE UNIQUE INDEX IDX_COPY_STUDENT_NO 
    ON COPY_STUDENT(STUDENT_NO);
    
CREATE UNIQUE INDEX IDX_COPY_STUDENT_NO 
    ON COPY_STUDENT(STUDENT_NAME);
    
-- (INDEX 생성 후) 질의 결과 : 0.029초
SELECT * FROM COPY_STUDENT WHERE STUDENT_NO = 'A00123456';
-- 인덱스 제거
DROP INDEX IDX_COPY_STUDENT_NO;
-- (INDEX 제거 후) 질의 결과 : 인출된 모든 행 1(0.051초)
SELECT * FROM COP  Y_STUDENT WHERE STUDENT_NO = 'A00123456';

-- 옵티마이저(Optimizer)는 사용자가 질의한 SQL문에 대해 최적의 실행 방법을 결정하는 역할을 수행한다. 
-- 이러한 최적의 실행 방법을 실행계획(Execution Plan)이라고 한다. 
-- UNIQUE SCAN : 컬럼이 유일한 값이고 동등조건(=)인 경우 사용

/*
    NONUNIQUE INDEX
    중복값이 있는 컬럼에 생성 가능한 인덱스
*/
-- (INDEX 생성 전) 질의 결과 : 0.0005초 / 8192건
SELECT COUNT(*) FROM COPY_STUDENT WHERE STUDENT_NAME = '윤상민';
-- 인덱스 생성
CREATE INDEX IDX_STUDENT_NAME ON COPY_STUDENT(STUDENT_NAME);
-- (INDEX 생성 후) 질의 결과 : 0.0003초
SELECT * FROM COPY_STUDENT WHERE STUDENT_NAME = '윤상민';

-- 입학 날짜 컬럼에 인덱스를 생성해봅니다.
CREATE INDEX IDX_ENTRANCE_DATE ON COPY_STUDENT(ENTRANCE_DATE);
SELECT COUNT(*) FROM COPY_STUDENT WHERE ENTRANCE_DATE <= '20070105';

DROP INDEX IDX_ENTRANCE_DATE;

/*
    인덱스가 타지 않는 경우
        - 내부적으로 데이터 형변환이 일어나는 경우
*/
-- 주민번호에 인덱스를 생성해봅니다.
CREATE INDEX IDX_STUDENT_SSN ON COPY_STUDENT(STUDENT_SSN);
SELECT COUNT(*) FROM COPY_STUDENT WHERE SUBSTR(STUDENT_SSN,1,2) <= 9;
-- 0.059 -> 0.015
SELECT * FROM COPY_STUDENT WHERE STUDENT_SSN = '11111';
-- 0.153 -> 0.154 (별로 영향을 받지 않음)
SELECT * FROM COPY_STUDENT WHERE STUDENT_SSN = 11111;

/*
    <인덱스 재생성>
    DML 작업을 수행한 경우, 인덱스 엔트리가 논리적으로만 제거됩니다.
    필요없는 공간을 차지하고 있지 않도록 인덱스를 재생성 해줍니다.
*/
ALTER INDEX IDX_STUDENT_SSN REBUILD;

/*
    <결합 인덱스>
        두 개 이상의 컬럼을 사용
*/
CREATE INDEX IDX_COPY_A_P
                ON COPY_STUDENT(ABSENCE_YN, COACH_PROFESSOR_NO);
SELECT INDEX_NAME, COLUMN_NAME FROM USER_IND_COLUMNS
        WHERE TABLE_NAME = 'COPY_STUDENT' ORDER BY INDEX_NAME;
SELECT COUNT(*) FROM COPY_STUDENT WHERE ABSENCE_YN = 'Y' AND COACH_PROFESSOR_NO='P099';
DROP INDEX IDX_COPY_STUDENT_A_P;

/*
    < 함수기반 인덱스 >
        자주 사용하는 연산식을 인덱스로 등록할수 있다
*/
CREATE INDEX IDX_COPY_STUDENT_ ON COPY_STUDENT(SUBSTR(STUDENT_SSN,3,1));
-- 0.233초 -> 0.225초 : WHERE 조건에 따라 실행 속도에 영향을 받을 수 있기 때문에 설정하기나름..?
SELECT COUNT(SUBSTR(STUDENT_SSN,3,1)) FROM COPY_STUDENT WHERE SUBSTR(STUDENT_SSN,3,1) IS NOT NULL; 
DROP INDEX IDX_COPY_STUDENT_;

















