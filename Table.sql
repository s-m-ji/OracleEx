-- <CREATE>
-- 데이터베이스의 객체를 생성하는 구문이다.
-- <테이블 생성>
-- 표현법
-- [옵션] : 미/기입 상관없음
-- 대/소문자 상관없음

/* 
CREAT TABLE 테이블 (
    컬럼명 자료형(크기) [DEFUALT 기본값] [제약조건],
    컬럼명 자료형(크기) [DEFUALT 기본값] [제약조건],
        ...
);
*/

CREATE TABLE MEMBER (
    member_id   VARCHAR2(20),
    member_pwd  VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20)
);

COMMENT ON COLUMN MEMBER.member_id IS
    '사용자 ID';

CREATE TABLE user_notnull (
    user_no   NUMBER NOT NULL,
    user_id   VARCHAR2(20) NOT NULL,
    user_pwd  VARCHAR2(20) NOT NULL,
    user_name VARCHAR2(30)
);

-- INSERT INTO 테이블명 VALUES (컬럼 순서대로 값을 입력)
-- NULL 제약조건: 빈 문자열도 윤허하지 않노라 ! 

INSERT INTO user_notnull VALUES (
    1,
    'user01',
    1234,
    '스누피'
);

INSERT INTO user_notnull VALUES (
    2,
    '',
    1234,
    '찰리'
);

CREATE TABLE user_unique (
    user_no   NUMBER,
    user_id   VARCHAR2(20) UNIQUE,
    user_pwd  VARCHAR2(30) NOT NULL,
    user_name VARCHAR2(30)
);

-- 테이블 삭제
-- DROP table 테이블명;
DROP TABLE user_unique;

-- 테이블의 구조를 확인할 수 있음
-- DESC 테이블명;
DESC MEMBER;

DESCRIBE user_notnull;

-- Book 테이블 생성
-- NO, TITLE, AUTHOR, ISRENT
-- NUMBER, VARCHAR2(100), VARCHAR2(20), CHAR(1)
-- 한글은 3byte씩 차지하니까, 
-- UNIQUE, NOT NULL, NOT NULL, 'N'
-- 컬럼이름 타입(길이) 제약조건
 
-- 제약 조건을 만든 테이블 생성
CREATE TABLE book(
    NO NUMBER UNIQUE not null, /* -> 기본키의 특징 2가지를 갖고있지요 */
    title VARCHAR2(100) NOT NULL,
    author  VARCHAR2(20) NOT NULL,
    /*사용자가 값을 입력하지 않았을 경우 자동으로 입력되는 값*/
    isrent CHAR(1) DEFAULT  'n'  CHECK(isrent IN ('y','n')),
    regdate DATE default sysdate /*등록일*/,
    editdate date /*수정일*/
);

-- 데이터 삽입
--insert into 테이블명 values (모든 컬럼값1,컬럼값2..);
--insert into 테이블명 (컬럼명) values (컬럼값);
-- 컬럼이 명시되지 않은 경우 디폴트값은 null로 쓸 수도 있다.
-- 데이터 타입이 다르면 순서를 지키지 않고 써도 된다? 컬럼이 적으면 상관없겠지만
-- 대부분 테이블을 생성했을 때 설정한 컬럼 순서대로 알아서 값을 넣어주기 때문에 웬만하면 맞춰서 기입하는게 좋겠다.
insert into book values (1, 'H마트에서울다2', '미셀', 'y', sysdate, null);

insert into book (book.title,book.author) values ('천문학자는 별을 보지 않는다','심채경');

-- sysdate 현재 날짜와 시간을 알려줌
-- 형식 변경도 가능함 RR/MM/DD HH24:MI:SS  -> 소문자도 상관없나봄
insert into book (no, title, author, regdate) values (2, '모순','양귀자', sysdate);

drop table book;

SELECT (book.title) from book; 
SELECT title from book; 
SELECT title,author from book; 
select * from book;

-- 위에서 테이블에 추가한 데이터를 실제 데이터베이스에 반영한다.
-- (메모리 버퍼에 임시 저장된 데이터를 실제 테이블에 반영)

commit;

-- 자동 커밋 설정
-- 1. 현재 상태를 확인
-- 하지만 자동 커밋을 권장하진 않는다고 하십니다요우..
SHOW AUTOCOMMIT;

-- 2. 자동커밋 설정
SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;


-- 제약조건에 이름을 붙여서 만든 테이블 생성
CREATE TABLE book(
    NO NUMBER UNIQUE,
    title VARCHAR2(100) NOT NULL,
    author  VARCHAR2 ( 20 ) NOT NULL,
    isrent CHAR(1),
    CONSTRAINT chenkisrent CHECK(isrent IN ('y','n'))
    );
    
DROP TABLE book;

/*
데이터 딕셔너리(메타 데이터)
    자원을 효율적으로 관리하기 위한 다양한 객체들의 정보를 저장하는 시스템 테이블이다.
    사용자가 객체를 생성하거나 객체를 변경하는 등의 작업을 할 때
    데이터베이스에 의해서 자동으로 갱신되는 테이블이다.
    데이터에 관한 데이터가 저장되어 있다고 해서 메타 데이터라고도 한다.
    
    USER_TABLES
    : 사용자가 가지고있는 테이블들의 전반적인 구조를 확인하는 뷰 테이블이다.
    USER_TAB_COLUMNS
    : 테이블, 뷰의 컬럼과 관련된 정보를 조회하는 뷰 테이블이다.
*/

/*
    select 구문 : 테이블에서 데이터를 조회한다
    select 컬럼명1, 컬럼명2... from 테이블명;
    * : 테이블 내 모든 컬럼을 조회
*/


-- 제약 조건 확인
DESC user_constraints;

-- 사용자가 작성한 제약조건을 확인하는 뷰
SELECT * FROM user_constraints;

DESC user_cons_columns;
-- 사용자가 작성한 제약조건이 걸려있는 컬럼을 확인하는 뷰
SELECT * FROM user_cons_columns;















