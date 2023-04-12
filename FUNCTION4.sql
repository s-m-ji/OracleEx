/*
    ========== ========== [형변환 함수] ========== ==========
    
    1) to_char(날짜|숫자[, 포맷])
    - 날짜,숫자 타입의 데이터를 문자 타입으로 변환 후 char로 반환
    ---> 날짜 또는 숫자를 포맷으로 지정해줄 수 있다.
*/
    -- 숫자 -> 문자
    select to_char(1234) from dual;
    -- 6칸의 공간을 확보, 오른쪽 정렬, 9: 빈칸은 공백 
    select to_char(1234, '999999') from dual;
    -- 0 : 빈 공간을 0으로 채워준다. ↑9, →0 이렇게 약속된겨 ^_^
    select to_char(1234, '000000') from dual;
    -- 현재 설정된 나라(LOCAL)의 화폐 단위를 출력
    select to_char(1234, 'L999,999') from dual;
    
select emp_name 이름, to_char(SALARY, 'L999,999,999') 급여
from emp;

    -- 날짜 -> 문자
    -- YYYY : 4자리 년도    YY : 2자리 년도
    -- MM : 월을 숫자로     MON : 월을 문자로
    -- DAY : 요일 표현      DY : 요일의 약어 
    select sysdate from dual;
    select to_char(sysdate, 'yyyy/mm/dd') from dual;
    select to_char(sysdate, 'yy/mon/day') from dual;
    -- 설정 언어에 따라 다르게 나타남 23/apr/wednesday   23/4월 /수요일
    
    -- 일에 대한 포맷
    select to_char(sysdate,'ddd') -- 한 해를 기준으로 며칠째인지
            ,to_char(sysdate, 'dd') -- 한 달을 기준으로 며칠째인지
            ,to_char(sysdate, 'd') -- 한 주를 기준으로 며칠째인지
    from dual;
    
--select emp_name 사원명, to_char(HIRE_DATE, 'yyyy-mm-dd(dy)') 입사일
select emp_name 사원명, to_char(HIRE_DATE, 'yyyy"년"mm"월"dd"일"(dy)') 입사일 
-- 포맷 안에 문자를 넣고 싶다면 " " 처리하면 된다 ~~~
from emp;
    
/*
    to_date(숫자|문자[, 포맷])
    - 숫자 또는 문자형 데이터를 입력 받아서 날짜 타입으로 변환 후 date로 반환
*/
    -- 숫자를 날짜로
    select to_date(20230412) from dual;
    select to_date(20230412114150) from dual; -- 시:분:초 까지 
    
    -- 문자를 날짜로    
    select to_date('20230412') from dual;    
    select to_date('20230412 114150') from dual;    
    select to_date('23/04/12', 'yy-mm-dd') from dual;    -- 앞에가 '/'여도 '-'형식으로 표현
    
/*
    날짜data + 숫자 : 숫자만큼 이후의 날짜
    날짜data - 숫자 : 숫자만큼 이전의 날짜
    날짜data - 날짜data : 두 날짜data 간 일수 차
    날짜data + 날짜data : 지원하지않음!!!
*/    
    -- 100일 후
    select sysdate+100 "100일 후" from dual;
    
    -- d-day(20230721)
    select floor(months_between(to_date('20230721'), sysdate)*30) "d-day" from dual;
    -- 30, 31 일수 차이가 있기 때문에 부정확할 수 있음
    select trunc(to_date('20230721') - sysdate) "d-day" from dual;
    select to_date('20230721') - trunc(sysdate) "d-day" from dual;
    select to_date('20230721') from dual; -- 시간까지 계산하기때문에 99.12334 어쩌고웅앵값이 나옴
    --->>> trunc를 어디에 처리하느냐에 따라 d-day 일수가 달라지기 때문에 정확히 계산할 수 있도록 유의!

    -- 어제 오늘 내일
    select trunc(sysdate-1) "어제", trunc(sysdate) "오늘", trunc(sysdate+1) "내일" from dual;

    -- 지난달 이번달 다음달
    select add_months(sysdate, -1)"지난달", sysdate "이번달"
    ,add_months(sysdate, +1)"다음달"  from dual;
    
    -- 작년 올해 내년
     select add_months(sysdate, -12)"작년", sysdate "올해"
    ,add_months(sysdate, +12)"내년"  from dual;
    

select NAME_KOR "이름", to_char(HIRE_DATE,'yyyy/mm/dd') "입사일"
from emp
--where EXTRACT(year from HIRE_DATE) >= 2007;
--where HIRE_DATE >= '2007/01/01';
where HIRE_DATE >= '2007-01-01'; -- 문자를 날짜로 자동형변환하여 비교연산해줌

select 123+'1234' from dual; 
-- 숫자, 문자 연산 시 문자를 숫자로 자동형변환
select 123+'1234A' from dual; 
-- 문자에 숫자 외의 문자가 섞여있어서 자동형변환 되지 않고 오류 발생 !
    
/*
    3) to_number(컬럼|문자열[, 포맷])
    - 문자 타입의 데이터를 숫자 타입으로 변환 후 number로 반환
*/    
    select '12345', 12345 from dual; -- 문자는 왼쪽 정렬, 숫자는 오른쪽 정렬이 기본
    select '12345', to_number('12345') from dual;
    
    select '10,000,000' + '10,000,000' from dual; -- 문자 + 문자라서 오류 발생
    
    select to_number('10,000,000', '99,999,999')
            ,to_number('10,000,000', '99,999,999')
    from dual;



-- 값을 도출하는 방식은 아주 다양함 ! 그 중에 가장 효율적인 방식으로 사용하면 되겠음다
select CUST_NAME 이름, CUST_YEAR_OF_BIRTH 출생년도
    , months_between(trunc(sysdate,'month')
        , to_date(CUST_YEAR_OF_BIRTH,'yyyy'))/12+1 나이trunc
        
    , to_char(sysdate, 'yyyy') - CUST_YEAR_OF_BIRTH +1 나이tochar
    
    , floor(months_between(sysdate, to_date(CUST_YEAR_OF_BIRTH, 'yyyy'))/12)+1 나이months
    
    , extract(year from sysdate) - CUST_YEAR_OF_BIRTH 나이extract
    
    , trunc(to_char(sysdate, 'yyyy') - CUST_YEAR_OF_BIRTH +1, -1) 연령대
    
    -- 나이/10 -> 소수점 제거(floor) -> *10
from customers
--where extract(year from sysdate) - CUST_YEAR_OF_BIRTH between 30 and 40
where trunc(to_char(sysdate, 'yyyy') - CUST_YEAR_OF_BIRTH +1, -1) = 30
order by 나이extract;

-- 쿼리의 실행 순서 : from > where > select > order 이렇게 코드가 돌아오기 때문에
-- select에서 만들어둔 함수는 where에서 먼저 쓸 수 없음 ! 가공된 결과를 참조할 수 없음 !







