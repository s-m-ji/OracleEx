-- 04/11(화)
select abs(-3) from dual; -- n의 절대값 반환
select ceil(10.22) from dual; -- n과 같거나 가장 큰 정수 반환
select floor(10.22) from dual; -- n보다 작거나 가능 큰 정수 반환
select round(10.222,1) from dual; -- n을 소수점 기준(i+1)번째에서 반올림한 결과 반환
select trunc(2.111111,3) from dual; -- n1을 소수점 기준 n2자리에서 잘라낸 결과 반환
select power(2,3) from dual; -- n2를 n1제곱한 결과를 반환 (n2가 음수면 n1은 반드시 정수)
select sqrt(2) from dual; -- n의 제곱근 반환
select mod(3,2) from dual; -- n2를 n1으로 나눈 나머지 값을 반환
select remainder(3,1) from dual; -- n2를 n1으로 나눈 나머지 값을 반환
select exp(2) from dual;
select ln(2) from dual;
select log(10,100) from dual;
select initcap('hELLO wORLD') from dual;
select lower('hELLO wORLD') from dual;
select upper('hELLO wORLD') from dual;
select concat('얘', '미뇽앙') from dual;
select substr('어떨것같니',3,1) from dual;
select substrb('어떨것같니',3,1) from dual;
select ltrim('이런 뮝췽날들잉', '이런') from dual;
select rtrim('네 하루강 됭다묭말양', '말양') from dual;
select rpad('너였다면', 15, '*') from dual;
select lpad('어떨것같아', 15, '*') from dual;
select replace('이런미친날들이','미친','뮝췽') from dual;
select translate('이런 미친 미날 미들 미이','미친','뮝췽') from dual;
select instr('네 하루가 되면 말야','야', -1, 1) from dual;
select length('너였다면') from dual; -- 4 출력
select lengthb('너였다면') from dual; -- 8 출력
select sysdate from dual;
select systimestamp from dual;
select add_months(sysdate, 3) from dual;
select months_between(add_months(sysdate,3), sysdate) from dual;
select last_day(sysdate) from dual;
select round(sysdate, 'month') from dual;
select trunc(sysdate, 'month') from dual;
select next_day(sysdate, '금요일') from dual;
select to_char(sysdate, 'yyyy-mm-dd') from dual;
select to_number('123456') from dual;
select to_date('20230411','yyyy-mm-dd') from dual;
select to_timestamp('20230411' ,'yyyy-mm-dd') from dual;



