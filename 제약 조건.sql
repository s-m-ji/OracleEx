/*
    <제약 조건>
    데이터의 무결성을 지키기 위해 입력값을 제한
    
    not null : null 입력 제한
    unique : 중복되지 않는 값
    default : 디폴트 값을 부여
    check : 체크 로직에 만족하는 값
    
    primary key : 기본키(not null + unique) 
    foreign key : 외래키(두 테이블의 연관관계에 따라 데이터 입력 또는 삭제 시 제한 받음)
    
    
    <primary key (기본키) 제약조건>
    테이블에서 한 행(튜플 TUPLE)의 정보를 식별하기 위해 사용할 컬럼에 부여하는 제약 조건
    각 행들을 구분할 수 있는 식별자 역할(사번, 부서코드, 직급코드 ...)
    기본키 제약조건을 설정하게 되면 자동으로 해당 컬럼에 not null + unique 제약 조건이 설정된다.
    PK를 설정하면 자동으로 INDEX 값도 생성된다.
    
    한 테이블에 한 개만 설정할 수 있다
    (한 개 이상의 컬럼을 묶어서 primary key로 제약조건을 설정하는 것도 가능)
    컬럼 레벨, 테이블 레벨 방식 모두 설정 가능하다.  --> 2가지 방식으로 설정 가능
*/

/*
create table book(
    book_no char(5) primary key,    
    title varchar2(100) not null,
    author varchar2(100) not null, 
    rentyn char(1) DEFAULT 'N' 
                    -- 도메인 : 속성의 값, 타입, 제약사항 등에 대한 값의 범위 
                    조건으로 주어진 Y 아니면 N 이외에는 체크 로직을 통과할 수 없음 
                    CHECK (RENTYN IN ('Y','N')),
    REG_DATE DATE DEFAULT SYSDATE,
    UPDATE_DATE DATE
);

-- 제약조건에 이름을 부여하여 테이블 생성 
-- 컬럼 레벨 지정 방식
create table book(
    book_no char(5) CONSTRAINT BOOK_NO_PK primary key,    
    -- 이렇게 컬럼 생성 시에 바로 지정
    --      컬럼명 타입(크기) CONSTRAINT 제약조건명 PRIMARY KEY
    title varchar2(100) not null,
    author varchar2(100) not null, 
    rentyn char(1) DEFAULT 'N' CHECK (RENTYN IN ('Y','N')),
    REG_DATE DATE DEFAULT SYSDATE,
    UPDATE_DATE DATE
);
*/
DROP TABLE BOOK;

-- 테이블 레벨 지정 방식
create table book(
    book_no char(5),    
    title varchar2(100) not null,
    author varchar2(100) not null, 
    rentyn char(1) DEFAULT 'N' CHECK (RENTYN IN ('Y','N')),
    REG_DATE DATE DEFAULT SYSDATE,
    UPDATE_DATE DATE,
    CONSTRAINT BOOK_NO_PK PRIMARY KEY (BOOK_NO)     
    -- 이렇게 테이블 마지막에 지정할 수도 있음. 
    --      CONSTRAINT 제약조건명 PRIMARY KEY (컬럼명)
);

INSERT INTO BOOK VALUES('B_001', 'H마트', '미셀', 'Y', SYSDATE, '');
INSERT INTO BOOK VALUES('B_002', 'H마트2', '미셀2', DEFAULT, SYSDATE, '');
INSERT INTO BOOK VALUES('B_003', 'H마트3', '미셀3', 'Y', SYSDATE, '20230401');
INSERT INTO BOOK VALUES(NULL, 'H마트2', '미셀2', DEFAULT, SYSDATE, '');

SELECT * FROM BOOK;

CREATE TABLE MEMBER_GRADE(
    GRADE_CODE CHAR(1) PRIMARY KEY
    , GRADE_NAME VARCHAR(30) NOT NULL
);

CREATE TABLE MEMBER_GRADE(
    GRADE_CODE CHAR(1)
    , GRADE_NAME VARCHAR(30) NOT NULL
    , CONSTRAINT MEMBER_GRADE_CODE_PK PRIMARY KEY (GRADE_CODE)
);

DROP TABLE MEMBER_GRADE;

INSERT INTO MEMBER_GRADE VALUES('C', '일반회원');
INSERT INTO MEMBER_GRADE VALUES('B', '우수회원');
INSERT INTO MEMBER_GRADE VALUES('A', '특별회원');

SELECT * FROM MEMBER_GRADE;

DELETE FROM MEMBER_GRADE
WHERE GRADE_CODE = 'C';

/*
    <FOREGIN KEY(외래키 = 참조키) 제약조건>
    다른 테이블에 존재하는 값만을 가져야하는 컬럼에 부여하는 제약조건이다. (NULL값도 가질 수 있음)
    FOREGIN KEY 제약조건에 의해 테이블 간의 관계가 형성된다.
    
    - 입력 제한
    자식테이블이 부모테이블을 참조하여 부모테이블에 입력된 값만 입력할 수 있음
    즉, 참조된 다른 테이블이 제공하는 값만 기록할 수 있다.    
    
    - 삭제 제한 : 옵션에 따라 3가지로 나눠짐
    부모테이블의 데이터를 삭제 시 자식테이블에서 사용 중이면
    1. ON DELETE RESTRICT 삭제 불가(기본)
    2. ON DELETE SET NULL 자식테이블의 컬럼을 NULL로 업데이트
    3. ON DELETE CASCADE 자식테이블의 행을 삭제
    
    1) 컬럼 레벨
    컬럼명 자료형(크기) [CONSTRAINT 제약조건명] REFERENCES 참조할 테이블명 (컬럼명) [삭제룰]
        
    2) 테이블 레벨
        [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 (컬럼명) [삭제룰]
*/

CREATE TABLE MEMBER (
    MEMBER_NO CHAR(5) PRIMARY KEY
    , ID VARCHAR2(20) NOT NULL
    , PW VARCHAR2(20) NOT NULL
    , NAME VARCHAR2(20) NOT NULL
    , GENDER CHAR(3) DEFAULT 'F' CHECK (GENDER IN ('F','M'))
    , AGE NUMBER CHECK (AGE>0)
    , REG_DATE DATE DEFAULT SYSDATE
    -- 참조하려는 부모테이블이 가지고 있는 컬럼과 일치하는 타입을 지정한다.
    , GRADE_CODE CHAR(1) REFERENCES  MEMBER_GRADE (GRADE_CODE)
    -- GRADE_CODE CHAR(1)
    -- CONSTRAINT MEMBER_GRADE_CODE_FK REFERENCES MEMBER_GRADE -- [(GRADE_CODE)]

);

SELECT * FROM MEMBER;
DROP TABLE MEMBER;

INSERT INTO MEMBER VALUES 
    ('M_001', 'ID1', '1234', 'GD', 'F', 30, DEFAULT, 'A');
INSERT INTO MEMBER VALUES 
    ('M_002', 'ID2', '1234', 'GD2', 'F', 30, DEFAULT, 'B');
INSERT INTO MEMBER VALUES 
    ('M_003', 'ID3', '1234', 'GD3', DEFAULT, 30, '20020202', 'C');

UPDATE MEMBER SET GENDER = 'M' WHERE NAME = 'GD2';
UPDATE MEMBER SET GRADE_CODE = 'A' WHERE GENDER = 'M';

-- 외래키 제약조건 삭제 확인
DELETE MEMBER_GRADE WHERE GRADE_CODE = 'A';
-- 자식테이블에서 사용하지 않는 코드는 삭제 가능
DELETE MEMBER_GRADE WHERE GRADE_CODE = 'B';

SELECT * FROM MEMBER_GRADE;

CREATE TABLE RENT(
  RENT_NO CHAR(5) CONSTRAINT RENT_NO_PK PRIMARY KEY
  , BOOK_NO CHAR(5) CONSTRAINT RENT_BOOK_NO_FK REFERENCES BOOK (BOOK_NO) ON DELETE SET NULL
    , MEMBER_NO CHAR(5) 
    , START_DATE DATE DEFAULT SYSDATE
    , END_DATE DATE
    , OVERDUE_NUM NUMBER
    , CONSTRAINT RENT_MEMBER_NO_FK FOREIGN KEY (MEMBER_NO) REFERENCES MEMBER ON DELETE CASCADE
    -- PK(기본키)가 아닐 경우에는 REFERENCES 테이블명 뒤에 컬럼명을 명시해줘야합네당 
);

DROP TABLE RENT;

INSERT INTO RENT VALUES ('R_001', 'B_001', 'M_001', '20230101', '20230115', 10);
INSERT INTO RENT VALUES ('R_002', 'B_002', 'M_002', DEFAULT, SYSDATE+14, 1);
INSERT INTO RENT VALUES ('R_003', 'B_003', 'M_003', DEFAULT, DEFAULT, '');

ALTER TABLE RENT MODIFY END_DATE DEFAULT SYSDATE+14;

UPDATE BOOK SET RENTYN = 'Y';

SELECT * FROM BOOK;

/*
    '도서 대여 처리' 작업 구현 시 선행되어야 하는 작업
    
    1. 도서 대여 가능한 상태인지 확인
    - 도서 대출 가능 여부
    - 사용자의 대출 제한 여부
    - 사용자의 대출 가능 도서 수 확인
    
    2. 가능한 상태라면 대여 처리 진행
    - 도서테이블의 대여 상태를 업데이트
    - 대여테이블에 데이터를 등록
        두개의 작업은 항상 같이 이루어져야하므로 하나의 트랜잭션으로 묶어
        두개 중 하나라도 실패할 경우 롤백 처리를 진행해야한다
*/

DELETE FROM BOOK WHERE BOOK_NO = 'B_001';
DELETE FROM MEMBER WHERE MEMBER_NO = 'M_002';

SELECT * FROM RENT;
SELECT * FROM BOOK;
SELECT * FROM MEMBER;

-- 제약조건은 수정할 수 없기에 삭제 후 다시 맹글기 ~~~
SELECT * FROM user_constraints WHERE TABLE_NAME = 'RENT';

ALTER TABLE RENT DROP CONSTRAINT RENT_MEMBER_NO_FK;

ALTER TABLE RENT ADD CONSTRAINT RENT_MEMBER_NO_FK
                        FOREIGN KEY (MEMBER_NO) REFERENCES MEMBER;

DESC RENT;

DELETE FROM MEMBER WHERE MEMBER_NO = 'M_003';

-- 부모 테이블 삭제하기
-- 1) 옵션을 만들어서 삭제
--  DPOP TABLE 테이블명 [CASCADE CONSTRAINT]
DROP TABLE BOOK CASCADE CONSTRAINTS;

ROLLBACK;

DROP TABLE MEMBER;

-- 2) 참조 제약 조건을 삭제 후 테이블을 삭제
ALTER TABLE RENT DROP CONSTRAINT RENT_MEMBER_NO_FK;

-- 테이블의 제약 조건을 조회하는 쿼리문
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'RENT';

-- 3) 자식테이블을 삭제 후 삭제
SELECT * FROM RENT;
DROP TABLE RENT;
SELECT * FROM BOOK;




















