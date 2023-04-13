/*
    [날짜 관련 함수]
    1) sysdate
    - 현재 날짜와 시간을 반환
*/
    select sysdate from dual;
/*
    2) months_between(date1, date2)
    - 입력 받은 두 날짜 사이의 개월수를 반환 (date1 - date2)
    - 결과값은 number 타입으로 반환
*/

    select months_between(sysdate, add_months(sysdate, 4)) from dual;
    select months_between(add_months(sysdate, 4), sysdate)from dual;

/*
    3) add_months(date, number)
    - 특정 날짜에 입력 받은 숫자만큼의 개월수를 더한 날짜를 반환
    - 결과 값은 date 타입
*/
    select add_months(sysdate, 4) from dual;

select emp_name 이름, HIRE_DATE 입사일
, to_char(months_between(sysdate, HIRE_DATE), 999) 근무개월수to_char
, floor(months_between(sysdate, HIRE_DATE)) 근무개월수floor
, ceil(months_between(sysdate, HIRE_DATE)) 근무개월수ceil
from emp
order by months_between(sysdate, HIRE_DATE) desc;

/*
    4)next_day(date, 요일(문자|숫자))
    - 특정 날짜에서 구하려는 요일의 가장 가까운 날짜를 반환
    - 결과값은 date 타입
*/
    select sysdate, next_day(sysdate, 3), next_day(sysdate, '금')
    from dual;
    -- 1: 일, 2: 월, 3: 화, 4: 수, 5: 목, 6: 금, 7: 토
    
    -- 언어 설정에 따라 오류 발생 가능
    select next_day(sysdate, 'sunday') from dual;
  
/*
    NLS : 국가별 언어 지원
    - 언어 지원 관련 설정 정보를 확인 및 변경
*/
    select * from nls_session_parameters;
    
    alter SESSION SET nls_language = american; -- 설정 언어 변경
    alter SESSION SET NLS_CURRENCY = '￦'; -- 화폐 단위 변경
    
    alter SESSION SET nls_language = korean;
    
    alter SESSION SET nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
    alter SESSION SET nls_date_format = 'yyyy/mm/dd';
    select sysdate from dual;
    
/*
    5)last_day(date)
    - 해당 월의 마지막 날짜를 반환
    - 결과값은 date 타입
*/    
    select sysdate, last_day(sysdate) from dual;

/*
    6)extract(year|month|day from date)
    - 특정 날짜에서 년,월,일 정보를 추출하여 반환
    - 결과값은 number 타입
*/
    select EXTRACT(year from sysdate), extract(month from sysdate)
    ,extract(day from sysdate) from dual;

-- 확인 문제

select emp_name 이름, extract(year from HIRE_DATE) 입사년도
, extract(month from HIRE_DATE) 입사월, extract(day from HIRE_DATE) 입사일 
from emp
where extract(year from hire_date) = 1998;

-- 확인 문제
select EMPLOYEE_ID 사원번호, EMP_NAME 사원명, HIRE_DATE 입사일
, floor(months_between(sysdate, hire_date)/12)||'년' 근속년수
from emp
where floor(months_between(sysdate, hire_date)/12) >= 20
order by floor(months_between(sysdate, hire_date)/12) desc;

/*
    7)round(date, year|month|day)
    - 반올림한 날짜를 반환
*/
    select sysdate, round(sysdate, 'year')
    , round(sysdate, 'month'), round(sysdate, 'day')
    , round(to_date(20230620), 'month')round -- 반올림처리
    , trunc(to_date(20230620), 'month')trunc -- 내림처리
    from dual;

/*
    8)trunc(date, year|month|day)
    - 잘라낸（버린） 날짜를 반환
*/
    select sysdate, trunc(sysdate, 'year')
    , trunc(sysdate, 'month'), trunc(sysdate, 'day')
    from dual;






