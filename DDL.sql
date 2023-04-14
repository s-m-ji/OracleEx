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
        1) 컬럼추가/수정/삭제
        2) 제약조건 추가/삭제   
        *제약조건은 수정 불가능(삭제 후 재추가) *다만 not null은 수정이 가능함.  *이름을 주지 않으면 알아서 지어짐.. 
        3) 테이블명/컬럼명/제약조건명 변경
*/

-- 테이블 복사하여 생성하기 
create table dept_copy
as select * from dept;
--as select DEPARTMENT_ID from dept;                -- 내가 원하는 컬럼만 복사 가능
--as select * from dept where DEPARTMENT_ID=70;     -- 내가 원하는 세부 조건으로만 복사 가능 
--as select DEPARTMENT_ID dept_id from dept;        -- 내가 원하는 별칭으로 복사 가능 
--as select * from dept where 0>1;                  -- 조건이 true가 아닐 때는 데이터 복사 불가

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
            alter tlable 테이블명 modify 컬럼명 default 변경할 값;        
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
            alter table명 add [constraint 제약조건명] primary key(컬럼명);
        unique :
            alter table명 add [constraint 제약조건명] unique(컬럼명);
        check :
            alter table명 add [constraint 제약조건명] check(컬럼에 대한 조건);
        not null :
            alter table명 modify 컬럼명 [constraint 제약조건명] not null;
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

-- TODO
alter table dept_copy
    add CONSTRAINT dept_copy_dept_id_pk PRIMARY KEY (dept_id)       --> dept_copy_dept_id_pk 이건 그냥 제약조건명 : 말그대로 밍쯔 !
    add CONSTRAINT dept_copy_dept_name_uq unique (dept_name)
    modify create_date CONSTRAINT dept_copy_create_date_nn not null;

-- 작성한 제약 조건 확인
select uc.constraint_name, uc.constraint_type, uc.table_name, ucc.column_name
from user_constraint uc
    join user_cons_columns ucc      --> join : 테이블을 합칠 때 씀 / 컬럼명이 겹칠 경우에는 별칭을 앞에 둬서 구분하도록한다.
        on uc.constraint_name = ucc.constraint_name
        -- 검색하려는 테이블명
        where ucc.table_name = 'dept_copy';                         ----->>>>> TODO 테이블 또는 뷰가 존재하지않습니다..? 어흑마이깟
        
-- constraint_type (c:check, p:primary key, u:unique)

-- pk: null 입력이 불가능하고 중복된 값이 저장될 수 없다.
insert into dept_copy (dept_id, dept_name, create_name)
    values(10,'테스트',sysdate);   -- 유니크 제약 조건에 걸림 
    
alter table dept_copy drop constraint dept_copy_dept_id_pk;

alter table dept_copy modify create_date null;

/*
    3) 테이블명/컬럼명/제약조건명 변경
    3-1) 컬럼명 변경
        alter table 테이블명 rename column 기존컬럼명 to 변경할 컬럼명;
        
    3-2) 제약조건의 이름 변경
        alter table 테이블명 rename constraint 기존제약조건명 to 변경할 제약조건명;
        
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








