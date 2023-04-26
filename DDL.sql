/*
    < DDL(DATA DEFINITION LANGUAGE) >
    - 데이터 정의어
    - 오라클에서 제공하는 객체를 생성/변경/삭제하는 데이터 구조 자체를 정의한다.
    - 주로 DB 관리자, 설계자가 사용한다 (*문서를 작성해주면 개발자가 쿼리를 작성하고 실행)
       
   [alter]
    - 오라클에서 제공하는 객체를 수정하는 구문
    
    테이블 수정
    alter table 테이블명 수정할 내용;
    
    * 수정할 내용
        1) 컬럼 추가/수정/삭제
        2) 제약조건 추가/삭제   
            *제약조건은 수정 불가능(삭제 후 재추가) *다만 not null은 수정이 가능함.  *이름을 주지 않으면 알아서 지어짐.. 
        3) 테이블명/컬럼명/제약조건명 변경
*/

-- 테이블 복사하여 생성하기 
create table dept_copy
as select * from dept;
--as select DEPARTMENT_ID from dept;                -- 특정 컬럼만 복사 가능
--as select * from dept where DEPARTMENT_ID=70;     -- where 조건에 맞는 데이터만 복사 가능 
--as select DEPARTMENT_ID dept_id from dept;        -- 특정 컬럼을 내가 만든 별칭으로 복사 가능 
--as select * from dept where 0>1;                  -- where 조건에 맞지 않는 즉, true가 아닐 때는 데이터 복사 불가

-- 테이블 삭제하기 
drop table dept_copy;

-- 테이블 조회하기
select * from dept_copy;

/*
    1) 컬럼 추가/수정/삭제
        추가: alter table 테이블명 add 컬럼명 데이터타입 [default 기본값]; 
        --> 추가 시 테이블 '열'탭에 가장 마지막에 추가 된다. 
        - 기본값 입력하지 않으면 null로 채워짐 / 입력 시 모든 행을 임의 값으로 초기화.
*/
    alter table dept_copy add cname varchar2(20); 
    alter table dept_copy add dname varchar2(20) default '춘식이';

/*
    2) 컬럼 수정(modify)
        - 데이터 타입 변경
            alter table 테이블명 modify 컬럼명 변경할 데이터 타입;
        - 기본값 변경
            alter table 테이블명 modify 컬럼명 default 변경할 값;        
*/

    alter table dept_copy modify DEPARTMENT_NAME varchar2(100);
    alter table dept_copy modify dname varchar2(1);
    -- 변경하려는 자료형의 크기보다 큰 값이 존재할 경우 오류 발생 : 일부 값이 너무 커서 열 길이를 줄일 수 없음

    alter table dept_copy modify cname number;
    -- 등록된 값이 하나도 없는 경우라면 데이터 타입 변경 가능

    -- 다중 수정도 가능함
    alter table dept_copy modify DEPARTMENT_NAME varchar2(50)
                        modify dname default '스누피';

select * from dept_copy;

/*
    3) 컬럼 삭제(drop column)
        alter table 테이블명 drop column 컬럼명;
        - 데이터 값이 기록되어있어도 삭제
        - 삭제된 컬럼은 복구 불가능 (*DDL 구문은 롤백으로 복구 불가)
        - 테이블에는 최소 1개 이상 컬럼이 존재해야하며
        - 참조하고 있는 컬럼이 있다면 삭제 불가능
*/

    alter table dept_copy drop column DEPARTMENT_NAME; 
    alter table dept_copy drop column PARENT_ID;
    alter table dept_copy drop column MANAGER_ID;
    alter table dept_copy drop column CREATE_DATE;
    alter table dept_copy drop column UPDATE_DATE ;
    alter table dept_copy drop column CNAME ;
    alter table dept_copy drop column DNAME ;

    insert into dept_copy values (default);

    alter table dept rename column DEPARTMENT_ID to dept_id; 
    alter table dept rename column DEPARTMENT_NAME to dept_name;
    alter table emp rename column EMPLOYEE_ID to emp_id;
    alter table emp rename column DEPARTMENT_ID to dept_id;
    alter table JOB_HISTORY rename column EMPLOYEE_ID to emp_id;
    alter table job_history rename column DEPARTMENT_ID to dept_id;
    
    alter table sales rename column employee_id to emp_id;
    
    /*
    2) 제약조건 추가/삭제
        2-1) 제약조건 추가
            primary key : (unique + notnull) 식별키
                alter 테이블명 add [constraint 제약조건명] primary key(컬럼명);
            unique :
                alter 테이블명 add [constraint 제약조건명] unique(컬럼명);
            check :
                alter 테이블명 add [constraint 제약조건명] check(컬럼에 대한 조건);
            not null :
                alter 테이블명 modify 컬럼명 [constraint 제약조건명] not null;
    */

-- dept_copy 테이블 다시 만들기
-- dept_id pk
-- dept_name unique
-- update_date not null

drop table dept_copy;

create table dept_copy(
    dept_id varchar2(10)
    , create_date number , dept_name number

    );

alter table dept_copy
    add CONSTRAINT dept_copy_dept_id_pk PRIMARY KEY (dept_id)       --> dept_copy_dept_id_pk 이건 그냥 제약조건명 : 말그대로 밍쯔 !
    add CONSTRAINT dept_copy_dept_name_uq unique (dept_name)
    modify create_date CONSTRAINT dept_copy_create_date_nn not null;

-- 작성한 제약 조건 확인
select uc.constraint_name, uc.constraint_type, uc.table_name, ucc.column_name
from user_constraints uc
    join user_cons_columns ucc      --> join : 테이블을 합칠 때 씀 / 컬럼명이 겹칠 경우에는 별칭을 앞에 둬서 구분하도록한다.
        on uc.constraint_name = ucc.constraint_name
        -- 검색하려는 테이블명
        where ucc.table_name = 'DEPT_COPY';                         
        
-- constraint_type (c:check, p:primary key, u:unique)

-- pk: null 입력이 불가능하고(not null) 중복된 값이 저장될 수 없다.(unique)
insert into dept_copy (dept_id, dept_name, create_name)
    values(10,'테스트',sysdate);   -- 테이블에 이미 10이 있어서 유니크 제약 조건에 걸림 
    
alter table dept_copy drop constraint dept_copy_dept_id_pk;

alter table dept_copy modify create_date null;

/*
    3) 테이블명/컬럼명/제약조건명 변경
    3-1) 컬럼명 변경
        alter table 테이블명 rename column 기존 컬럼명 to 변경할 컬럼명;
        
    3-2) 제약조건의 이름 변경
        alter table 테이블명 rename constraint 기존 제약조건명 to 변경할 제약조건명;
        
    3-3) 테이블명 변경
        1) alter table 테이블명 rename to 변경할 테이블명;
        2) rename 기존 테이블명 to 변경할 테이블명;
*/

-- 기본키 제약 조건 설정 시 데이터가 이미 중복인 경우 : 검증할 수 없습니다. - 잘못된 기본키입니다. 오류발생

alter table dept_copy add CONSTRAINT dept_copy_dept_id PRIMARY KEY (dept_id);

alter table dept_copy rename column dept_name to dept_title;

alter table dept_copy rename constraint DEPT_COPY_DEPT_NAME_UQ to dept_title_nn;

-- 테이블 정보를 비교적 간결하게 조회
desc dept_copy;

select * from dept_copy;

alter table dept_copy rename to dept_test;

alter table dept_test rename to 테이블;

rename 테이블 to dept_copy;
---------------------------------------------------------------------------------------------------
/*
    SQL_DDL
*/

-- 》》》》》 Ex1) 계열 정보를 저장할 카테고리 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR(10)
    ,USE_YN CHAR(1) DEFAULT 'Y' CHECK (USE_YN IN('Y','N'))
);

-- 》》》》》 Ex2) 과목 구분을 저장할 테이블을 만들려고 한다. 다음과 같은 테이블을 작성하시오.
CREATE TABLE TB_CLASS_TYPE (
    NO VARCHAR2(5) PRIMARY KEY
    ,NAME VARCHAR2(10)
);

-- 》》》》》 Ex3) TB_CATEGORY 테이블의 NAME 컬럼에 PRIMARY KEY를 생성하시오.
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY (컬럼명)
ALTER TABLE TB_CATEGORY ADD CONSTRAINT TB_CATEGORY_NAME_PK PRIMARY KEY (NAME);

-- 》》》》》 Ex4) TB_CLASS_TYPE 테이블의 NAME 컬럼에 NULL 값이 들어가지 않도록 속성을 변경하시오.
-- ALTER TABLE 테이블명 MODIFY 컬럼명 조건 CONSTRAINT 제약조건명 NOT NULL
ALTER TABLE TB_CLASS_TYPE MODIFY NAME CONSTRAINT TB_CALSS_TYPE_NAME_NN NOT NULL;

SELECT * FROM TB_CATEGORY;
SELECT * FROM TB_CLASS_TYPE;

DESC TB_CATEGORY;
DESC TB_CLASS_TYPE;

-- 》》》》》 Ex5) 두 테이블에서 컬럼 명이 NO인 것은 기존 타입을 유지하면서 크기는 10으로
-- , 컬럼명이 NAME인 것은 마찬가지로 기존 타입을 유지하면서 크기 20으로 
-- 변경하시오.
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10) MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);

ROLLBACK;

-- 》》》》》 Ex6) 두 테이블의 NO 컬럼과 NAME 컬럼의 이름을 각 테이블 이름이 앞에 붙은 형태로 변경한다.
-- EX. CATEGORY_NAME
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;

ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NAME TO CLASS_TYPE_NAME;

-- 》》》》》 Ex7) INSERT 문을 수행한다.
SELECT CATEGORY
FROM TB_DEPARTMENT
GROUP BY CATEGORY;
-- 한번에 하나의 값만 INSERT
INSERT INTO TB_CATEGORY VALUES('인문사회', 'Y');
-- 한번에 여러개 값 INSERT => TB_DEPARTMENT에서 CATEGORY 값을 서브쿼리로 가져오기
INSERT INTO TB_CATEGORY (SELECT CATEGORY, 'Y'
                        FROM TB_DEPARTMENT
                        GROUP BY CATEGORY)
;
COMMIT;
SELECT * FROM TB_CATEGORY;

-- 》》》》》 Ex8) TB_DEPARTMENT의 CATEGORY 컬럼이 
-- TB_CATEGORY 테이블의 CATEGORY_NAME 컬럼을 부모값으로 참조하도록 FOREIGN KEY를 지정하시오.
-- 이 때 KEY 이름은 FK_테이블이름_컬럼이름으로 지정한다
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY (컬럼명) REFERENCES 참조할 테이블명 (컬럼명)
ALTER TABLE TB_DEPARTMENT 
    ADD CONSTRAINT FK_TB_DEPARTMENT_CATEGORY 
        FOREIGN KEY (CATEGORY)
            REFERENCES TB_CATEGORY (CATEGORY_NAME); 
            
-- 》》》》》 Ex9) 학생들의 정보만이 포함되어 있는 학생일반정보 VIEW를 만들고자 한다.
-- 다음 내용을 참고하여 적절한 SQL문을 작성하시오. (학번, 학생이름, 주소)
-- CREATE [OR REPLACE] VIEW 뷰名 AS 서브쿼리;
-- alter table 테이블명 modify 컬럼명 변경할 데이터 타입;
CREATE OR REPLACE VIEW VW_학생일반정보 (학번, 학생이름, 주소)
AS ( SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT 
);
SELECT * FROM VW_학생일반정보;
-- ALTER VIEW VW_학생일반정보 ADD COLUMN STUDENT_AGE NUMBER;   -- TODO 컬럼 추가해서 나이/성별 입력하기

-- 》》》》》 Ex10) 1년에 두 번씩 학과별로 지도교수가 지도 면담을 진행한다.
-- 이를 위해 사용할 학생이름, 학과이름, 담당교수이름으로 구성되어 있는 VIEW를 만드시오.
-- 이때 지도 교사가 없는 학생이 있을 수 있음을 고려하시오.
-- (학과별로 정렬되어 화면에 보여지게 만드시오.)
CREATE VIEW VW_지도면담(학생이름, 학과이름, 지도교수이름)
AS
    SELECT STUDENT_NAME, DEPARTMENT_NAME, NVL(PROFESSOR_NAME,'지도교수없음')
    FROM TB_STUDENT S, TB_DEPARTMENT D, TB_PROFESSOR P
    WHERE  S.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND P.PROFESSOR_NO = S.COACH_PROFESSOR_NO(+)
    ORDER BY DEPARTMENT_NAME
;

SELECT * FROM VW_지도면담;

-- 》》》》》 Ex11) 모든 학과의 학과별 학생 수를 확인할 수 있도록 적절한 VIEW를 작성해보자.
CREATE VIEW VW_학과별학생수(학과이름, 학생수)
AS 
    SELECT DEPARTMENT_NAME, COUNT(*) CNT
    FROM TB_STUDENT S, TB_DEPARTMENT D
    WHERE  S.DEPARTMENT_NO(+) = D.DEPARTMENT_NO
    GROUP BY D.DEPARTMENT_NO, DEPARTMENT_NAME
    ORDER BY CNT DESC
;

-- 》》》》》 Ex12) 위에서 생성한 학생일반정보 VIEW를 통해서 학번이 A213046인 학생의 이름을 본인 이름으로 변경 해봅시다 
UPDATE VW_학생일반정보
SET 학생이름 = '미미'
WHERE 학번 = 'A213046';

SELECT * FROM VW_학생일반정보 WHERE 학번 = 'A213046';
SELECT * FROM TB_STUDENT WHERE STUDENT_NO = 'A213046';

-- 》》》》》 Ex13) 12번에서와 같이 VIEW를 통해서 데이터가 변경될 수 있는 상황을 막으려면 VIEW를 어떻게 생성해야 하는지 작성하시오
-- WITH READ ONLY 기재 시 SELECT만 가능
CREATE OR REPLACE VIEW VW_학생일반정보 (학번, 학생이름, 주소)
AS ( SELECT STUDENT_NO, STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT )
WITH READ ONLY
;
/*  ========== SYSTEM (관리자) 계정에서 실행 ==========
-- HR계정의 JOBS테이블의 조회 권한을 JUNGANG에 부여
GRANT SELECT ON HR.JOBS TO JUNGANG;
-- HR계정의 테이블 권한을 조회
SELECT * FROM DBA_TAB_PRIVS WHERE OWNER = 'HR';
-- 시노님(동의어/별칭)을 생성할 수 있는 권한을 부여
GRANT CREATE SYNONYM TO JUNGANG;
-- 계정의 권한을 조회
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'JUNGANG';
-- 권한 회수
REVOKE SELECT ON HR.JOBS FROM JUNGANG;
REVOKE CREATE SYNONYM FROM JUNGANG;
*/
/*  ========== JUNGANG (사용자) 계정에서 작성했던 내용 ==========
SELECT * FROM HR.JOBS;
*/
-- HR계정의 JOBS테이블의 조회 권한을 JUNGANG에 부여

-- 》》》》》 Ex14) SYNONYM
-- 관리자로부터 HR 계정의 JOBS 테이블 조회 권한을 받아야 조회가 가능하다.
SELECT * FROM HR.JOBS;

-- 시노님 생성하기 (HR.JOBS의 별칭으로 JOB 생성)
-- 관리자로부터 시노님(동의어/별칭)을 생성할 수 있는 권한을 받아야 생성이 가능하다.
CREATE OR REPLACE SYNONYM JOBS FOR HR.JOBS;

-- 시노님으로 조회
SELECT * FROM JOBS;

-- 시노님 삭제
DROP SYNONYM JOBS;      

-- 》》》》》 Ex15) SEQUENCE
-- 10씩 증가하는 시퀀스를 생성
CREATE SEQUENCE SEQ_TB_CLASS_TYPE_NO
START WITH 10
INCREMENT BY 10
--MINVALUE 10
--MAXVALUE 40
;
DROP SEQUENCE SEQ_TB_CLASS_TYPE_NO;

-- NEXTVAL 이후 CURRVAL 사용 가능 
-- 값을 증가시킨 후 반환
SELECT SEQ_TB_CLASS_TYPE_NO.NEXTVAL FROM DUAL;
SELECT SEQ_TB_CLASS_TYPE_NO.CURRVAL FROM DUAL;

SELECT * FROM TB_CLASS_TYPE; 
SELECT SEQ_TB_CLASS_TYPE_NO.NEXTVAL, CLASS_TYPE_NAME  FROM TB_CLASS_TYPE; 
SELECT CLASS_TYPE FROM TB_CLASS GROUP BY CLASS_TYPE;

SELECT SEQ_TB_CLASS_TYPE_NO.NEXTVAL, CLASS_TYPE         
FROM (SELECT CLASS_TYPE FROM TB_CLASS GROUP BY CLASS_TYPE);

-- 시퀀스를 이용해서 일괄적으로 삽입.      
/*
    INSERT INTO 테이블
        서브쿼리
        
    서브쿼리의 조회결과집합을 테이블에 삽입
*/
INSERT INTO TB_CLASS_TYPE 
    SELECT CLASS_TYPE, SEQ_TB_CLASS_TYPE_NO.NEXTVAL 
    FROM (SELECT CLASS_TYPE FROM TB_CLASS GROUP BY CLASS_TYPE);
    
SELECT * FROM TB_CLASS_TYPE;

-- ***** 테이블에서 컬럼 삭제
ALTER TABLE TB_CLASS_TYPE DROP COLUMN CLASS_TYPE_NO;

-- ***** 테이블의 필드 순서 변경
-- ALTER TABLE 테이블명 CHANGE COLUMN 변경전 필드명 변경후 필드명 varchar(255) NULL AFTER 기준 필드명; 