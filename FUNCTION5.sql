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









