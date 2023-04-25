-- 사용자 계정 생성
create user jungang identified by 1234;

-- 사용자 계정 삭제
-- 사용자 계정에 오브젝트가 생성되어 있으면 오브젝트도 함께 제거할 수 있도록
DROP USER JUNGANG CASCADE;

--  create session 권한 불충분하여 접근 불가 
-- (계정을 생성한다고 해서 권한이 바로 주어지는 것은 아님)
conn jungang/1234;

-- 사용자가 가진 권한 확인
select * from dba_sys_privs where grantee = 'JUNGANG'; -- 대문자로 작성해야함

-- 사용자 계정에 권한 부여
grant create session to jungang;
-- 계정에 접속은 되지만 테이블 생성 등등 다른 작업은 할 수 없음

-- 롤(ROLE) : 하나 이상의 권한으로 이루어진 집합체
--      오라클에서 미리 정의해둔 것도 있지만 사용자가 직접 정의할 수도 있음
--      connect : 접속 권한, resource : 오브젝트 생성 권한 
grant connect, resource, create view to jungang;
-- 권한 부여 후 접속해제 - 재접속해야 해당 계정에서 테이블을 생성할 수 있다.

-- 오라클에서 미리 정의해둔 ROLE
select * from dba_roles;

-- ROLE 등록된 권한을 확인
select grantee, privilege 
from dba_sys_privs 
where grantee = 'CONNECT' or grantee = 'RESOURCE';  -- 대문자로 작성해야함 (소문자로 작성하면 컬럼 값이 나오지 않는다)

-- 사용자가 가진 권한 확인
select * from dba_sys_privs where grantee = 'JUNGANG';

-- 사용자가 가진 롤 확인
select * from dba_role_privs where grantee = 'JUNGANG';    

-- DBA 모든 시스템 권한이 부여된 롤
grant dba to JUNGANG;

/*
    <데이터 딕셔너리>
    자원을 효율적으로 관리하기 위한 다양한 객체들의 정보를 저장하는 시스템 테이블
    사용자가 객체를 생성하거나 객체를 변경하는 등의 작업을 할 때
    데이터베이스에 의해서 자동으로 갱신되는 테이블
    데이터에 관한 데이터가 저장되어 있다고 해서 메타 데이터라고도 함
    
    DBA_XXX : 관리자만 접근 가능한 객체에 관한 정보 조회          
    USER_XXX : 계정이 소유한 객체에 관한 정보 조회                 
    ALL_XXX : 계정 소유 또는 권한을 부여받은 객체에 관한 정보 조회    
    
    - dba_sys_privs : 현재 사용자가 롤에 부여된 시스템 권한(privilege) 나열
    - dba_role_privs : 사용자 및 롤에 할당된 롤 확인
    - user_constraints : 제약조건을 확인
*/

-- 권한 회수
revoke connect, resource from JUNGANG;
revoke dba from JUNGANG;

grant connect, resource to JUNGANG;
grant dba to JUNGANG;
---------------------------------------------------------------------------------------------------
SELECT * FROM book; 

-- 자동 커밋 설정
-- 1. 현재 상태를 확인
-- 하지만 자동 커밋을 권장하진 않는다고 하십니다요우..
SHOW AUTOCOMMIT;

-- 2. 자동커밋 설정
SET AUTOCOMMIT ON;
SET AUTOCOMMIT OFF;






