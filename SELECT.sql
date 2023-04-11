/*
    select 컬럼, 컬럼, ...
    from   테이블명
    
    - 데이터를 조회할 때 사용하는 구문
    - SELECT 구문을 통해 조회된 결과물을 RESULT SET(조회된 행들의 집합)이라고 한다.
    - 조회하고자하는 컬럼은 반드시 테이블에 존재하는 컬럼이어야한다.
    
*/

-- 테이블의 전체 컬럼, 전체 레코드를 조회
select * from EMPLOYEES; 

-- EMPLOYEES 테이블에서 전체 사원의 사번, 이름, 월급을 조회
select EMPLOYEE_id, emp_name, salary
from EMPLOYEES;

/*
    <컬럼 값을 통한 산술 연산>
    select 절에 컬럼명 입력 부분에서 산술 연산을 이용한 결과를 조회할 수 있다.
    - 컬럼명에 별칭을 넣지 않으면 연산식 그대로 나옴 e.g)salary*12
*/

-- 직원의 연봉 구하기
select emp_name, salary 월급여, salary*12 연봉 
from EMPLOYEES;

-- 산술 연산 중 null값이 존재할 경우 산술 연산의 결과는 null이 된다.

-- 연봉((급여+(급여*보너스))*12) *보너스가 없을 경우 null이 되는 것!
select emp_name, salary 월급여, salary*12 연봉,
        (salary + (salary* commission_pct))*12 "보너스 포함연봉"
from EMPLOYEES;

-- EMPLOYEES 테이블에서 직원명, 입사일, 근무일수(오늘 날짜 - 입사일)
-- date 형식끼리도 연산이 가능하다
-- sysdate는 현재 날짜를 출력한다

-- dual은 오라클에서 제공하는 더미 테이블
SELECT sysdate from dual;

SELECT emp_name, HIRE_DATE, floor(sysdate-hire_date)
from EMPLOYEES;

/*
    <컬럼에 별칭 지정하기>
    컬럼명 as 별칭 / 컬럼명 별칭 / 컬럼명 "별칭"
    - 산술 연산 시 컬럼명이 길어지기때문에 별칭을 붙여서 깔끔하게 처리한다
    - 주의할 점: 띄어쓰기 또는 특수문자가 포함될 경우 " " 쌍따옴표로 묶어준다
*/

/*
    <DISTINCT>
    중복 제거: 컬럼에 포함된 값을 한번씩만 표시하고자 할 때
    select 절에 한번만 기술할 수 있다
*/

select DISTINCT job_id
from EMPLOYEES;

/*
    <연결 연산자> ||
    여러 컬럼 값을 하나의 컬럼인 것처럼 연결하거나,
    컬럼과 리터럴(값 자체)을 연결할 수 있다.
    
*/

-- "사원 이름의 월급은 월급여 입니다." 라고 출력.
select emp_name || '의 월급여는 ' || salary || '입니다.'
from EMPLOYEES;


/*
    <where절(조건절)>
    select 컬럼, 컬럼, ...
    from 테이블명
    where 조건식;
    - 테이블에서 해당 조건을 만족하는 결과만 조회하고자할 때 사용한다
    - 조건식에 다양한 연산자들을 이용할 수 있다
    - 크기 비교 >, <, <=, >=
    - 동등 비교 =(같다), !=, ^=, <>(같지 않다) 
*/

-- employees 테이블에서 부서 코드가 100와 일치하는 사원들의 모든 컬럼 정보를 조회
select *
from employees
where DEPARTMENT_ID = 100;

-- employees 테이블에서 부서 코드가 90, 80, 50이 아닌 사원들의 모든 컬럼 정보를 조회
select *
from emp
where department_id != 90 and department_id <> 80 and department_id ^= 50; 

-- employees 테이블에서 급여가 7000 이상인 사원들의 사원명, 부서코드, 급여를 조회
select emp_name, name_kor, department_id, salary
from emp
where salary >= 7000;

-- emp 테이블에서 연봉이 80,000 이상인 직원의 이름, 급여, 연봉, 입사일을 조회
select emp_name "영문 이름", name_kor "한글 이름",  salary 급여, salary*12 연봉, HIRE_DATE 입사일 
from emp
where salary*12 >= 80000;

/*
    <논리 연산자>
    여러개의 조건을 엮을 때 사용한다
    and (그리고) 
    or (또는)
*/

-- emp에서 부서코드가 100이고 급여가 8000이상인 사원의 이름, 부서코드, 급여를 조회
-- to_char(연산식, 형식) : 원하는 형식으로 값을 출력할 수 있다
select emp_name "name", 
        name_kor 이름, 
        department_id "부서 코드", 
        salary as 급여, 
        to_char(salary*12,'99,999,999') as 연봉
from emp
where department_id = 100 and salary >= 8000;

-- 급여가 8000보다 크고 10000이하인 사원의 사번, 이름, 급여를 조회
select EMPLOYEE_ID 사번, emp_name 이름, to_char(salary, '999,999') 급여
from emp
-- where salary >= 8000 and salary <= 10000;
-- where salary BETWEEN 8000 and 10000;
where not salary BETWEEN 8000 and 10000;

/*
    <between and>
    where 비교대상컬럼 between 하한값 and 상한값
    - where절에서 사용되는 구문으로 범위에 대한 조건을 제시할 때 사용
    - 비교대상컬럼이 하한값 이상, 상한값 이하인 경우에 조회
    
    <not>
    해당 조건은 제외하고 조회
*/

-- 입사일 98/01/01 ~ 99/12/31
-- 모든 컬럼을 조회 후 입사일 순서로 오름차순 정렬
select * 
from emp
where hire_date between '98/01/01' and '99/12/31'
--order by employee_id desc;
order by hire_date;

/*
    <like>
    where 비교 대상 컬럼 like '특정 패턴'
    - 비교하려는 컬럼 값이 지정된 특정 패턴을 만족할 경우
    - 패턴 문자 : %, _
                 
    % : 0글자 이상
    특정 문자열로 시작하거나 특정 문자열로 끝나는 경우
    컬럼명 like    '%on' : on으로 끝나는 문자가 있는 행을 조회
    컬럼명 like    'on%' : on으로 시작하는 문자가 있는 행을 조회
    컬럼명 like    '%on%' : on을 포함하는 문자가 있는 행을 조회
                
     _ : 1글자
    컬럼명 like    '_문자' : 문자 앞에 한 글자가 오는 행을 조회
    컬럼명 like    '__문자' : 문자 앞에 두 글자가 오는 행을 조회
*/


-- 사원명이 D로 시작하는 사원의 급여, 입사일을 조회
select emp_name, salary, hire_date
from emp
where emp_name like 'D%'
order by salary desc;

select emp_name, salary, hire_date
from emp
where emp_name like '%L__';

-- 전화번호 5번째자리 숫자가 4로 시작하는 사원의 사번, 사원명, 전화번호를 조회
select employee_id, emp_name, PHONE_NUMBER
from emp
where PHONE_NUMBER like '____4%'
order by employee_id;

select * from emp;

-- 이메일을 조회하는데 @jungang.com 문자를 추가하여 출력
select EMAIL || '@jungang.com'
from emp;

-- 전화번호 첫 3자리가 515가 아닌 사원
select emp_name, phone_number
from emp
--where not phone_number like '515%'; * not을 앞,뒤 어디에 쓰든 상관없다 ??
where phone_number not like '515%';

select *
from dept
--where DEPARTMENT_NAME like '건설%';
where DEPARTMENT_NAME = '건설팀';


/*
    <is null / is not null>
    where 비교대상컬럼 is [not] null;
    - 컬럼 값에 null이 있는 경우 null값 비교에 사용된다.
    is null : 컬럼이 null인 경우 
    is not null : 컬럼이 null이 아닌 경우
*/

select *
from emp
where commission_pct is not null and department_id is null
order by commission_pct desc;
-- where commission_pct = null; 이건 틀린 구문 ! 
-- 오라클에서 null은 비교 연산자로 쓸 수 없다.

select department_id "사원 번호", emp_name as 사원명
from emp
where MANAGER_ID is null;

select '사장 아들이라고 의심되는 ' || name_kor || '(' || emp_name || ')' as "부서 배치(x), 보너스(o)"
from emp
where DEPARTMENT_ID is null and commission_pct is not null;

/*
    <in>
    where 비교대상컬럼 in ('값','값', ...);
    값 목록 중 일치하는 값이 있을 경우 조회
    or로 연결해서 쓸 수도 있음
*/

select count(*)
from emp
--where DEPARTMENT_ID in ('30','40','50');
where DEPARTMENT_ID in (30,40,50);
--where DEPARTMENT_ID = 30 
--    or DEPARTMENT_ID = 40
--    or DEPARTMENT_ID = 50;

/*
    <order by [asc|desc] [nulls first|nulls last]>
    ! 쿼리 기입 시 구문 순서 지키지 않으면 오류 발생 !
    
    select 컬럼, 컬럼
    from 테이블명
    [where 조건]  조건이 없으면 생략 가능
    order by 정렬시킬 컬럼명 / 별칭 / 컬럼순번 
        asc     오름차순 : 기본값
        desc    내림차순
        nulls first     null값을 맨 처음으로 정렬
        nulls last      null값을 맨 끝으로 정렬 : 기본값`
*/

select commission_pct, emp_name 이름, salary 급여
from emp
where commission_pct is not null
--order by commission_pct nulls first;
-- 커미션 오름차순, 커미션이 같으면 급여로 내림차순
order by commission_pct, salary;












