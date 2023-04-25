/*
    ========== ========== [null 처리 함수] ========== ==========
    1) nvl(컬럼, 컬럼값이 null이면 반환할 값)
    - null로 되어있는 컬럼의 값을 인자로 지정한 값으로 변경하여 반환
*/
-- null이 연산되지 않아서 0으로 변경 후 연산
select name_kor, nvl(commission_pct, 0)
from emp;

select emp_name 사원명, commission_pct 커미션
, salary + (salary*nvl(commission_pct, 0))*12 연봉
--, salary + (salary*commission_pct)*12 연봉 -- null은 연산불가
from emp;

-- 숫자타입의 컬럼인 경우 매개값으로 숫자를 넣어줘야함
-- 타입이 맞지 않는 경우 "수치가 부적합합니다." 오류 발생
-- 문자를 입력하고싶은 경우 to_char()함수 이용해서
-- 숫자를 문자로 : char타입으로 변환 후 nvl()함수 이용
select emp_name, DEPARTMENT_ID, nvl(to_char(DEPARTMENT_ID), '부서 없음')
from emp;

select to_timestamp(sysdate) from dual;

/*
    2)nvl2(컬럼, 변경할 값1, 변경할 값2)
    - 컬럼이 null이 아니면 변경할 값1
                null이면 변경할 값2
*/

-- emp 테이블에서 커미션을 출력하는데 동결되어서 0.1로 표시한다면 ?

select name_kor, COMMISSION_PCT 기존
    , nvl2(commission_pct, 0.1, 0) 동결
    , salary + salary*nvl2(commission_pct, 0.1, 0) "동결 급여"
    , (salary + (salary*nvl2(commission_pct, 0.1, 0)))*12 "동결 연봉"
from emp
order by "동결 급여" desc;

-- 연습문제1)
select emp_name 이름, salary 급여,  nvl(commission_pct, 0) 커미션
, (salary+(salary*nvl(commission_pct,0)))*12 연봉
from emp
where (salary+(salary*nvl(commission_pct,0)))*12 >= 200000
order by 연봉 desc;

-- 연습문제2)
/*
    select '1111294045862' from dual;
    select '9511294045862' from dual;
    
    1900년대생 주민등록번호 뒷자리의 첫번째 숫자가 1,2
    2000년대생 주민등록번호 뒷자리의 첫번째 숫자가 3,4
    
    나이를 구하기 위해서는 출생년도를 알아야함 -> 주민번호에는 년도가 2자리로 표현됨
*/

select to_char(sysdate ,'yyyy') - ('20'||substr('1111294045862',1,2))+1 나이 from dual;

    select to_char(sysdate, 'yyyy') - '20'||substr('1111294045862',1,2) from dual;
    -- 결과값 200311이 나옴 : 연산은 순차적으로 진행되기 때문에 2023 - 20이 먼저 계산됨
    
    select '나이는 ' || (to_char(sysdate, 'yyyy') - ('19'||substr('9511294045862',1,2))+1) || '살 입니다.' 나이 from dual;

/*
    3) nullif(비교대상1, 비교대상2)
    - 두 개의 값이 동일하면 null을 반환
    - 두 개의 값이 동일하지 않으면 비교대상1을 반환
*/
    select nullif('라붐', '라붐') from dual;    -- null 반환
    select nullif('라붐', '리얼리티') from dual;  -- 라붐 반환






























