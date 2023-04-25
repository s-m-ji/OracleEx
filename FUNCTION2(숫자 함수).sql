-- 어제자 복습
select * from emp;
select phone_number
, replace('(02)' || substr (phone_number, 5), '.' , '-') "번호 수정1"
--, lpad(substr(phone_number, 5), 12, '(02)') "번호 수정2"
-- lpad 사용 시 길이가 지정되어서 원래 값에 영향을 받을 수 있기에
-- 이렇게 다양한 자릿수의 번호를 바꾸는 방법은 replace가 더 낫다 
-->> 입력된 컬럼 또는 문자열의 길이가 지정 길이보다 길면 지정된 길이 만큼만 보여준다
-->> 지정된 길이보다 짦으면 남은 공간을 공백 또는 지정한 문자열을 반복해서 입력
from emp;

/*
    함수 : 컬럼의 값을 읽어서 결과를 반환
    함수를 기술할 수 있는 위치 : select, where, order by, group by, having
    
    ========== ========== [숫자 함수] ========== ==========
    1) asb(number)
    절대값을 반환
*/
    select abs(10.9), abs(-10.9), abs(5), abs(-5)
    from dual;

/*
    2) mod(number, number)
    - 두 수를 나눈 나머지를 반환 (Java % 연산과 동일)
*/
    select mod(5,2), mod(-6,2), mod(4,0) from dual;
/*
    3) round(number, 위치)
    - 위치를 지정하여 반올림 
    *위치 양수: 소수점 기준 오른쪽에서 지정한 위치를 반올림 
         음수: 소수점 기준 왼쪽에서 지정한 위치를 반올림
         지정하지 않을 시 정수로 반환(소수점 아래 자리 모두 버림)
*/
    select round(123.456, 2), round(123.456, -2), round(123.456) 
    , round(1230.456, -3) -- 천 단위 절삭
    from dual;

/*
    4) ceil(number)
    - 소수점을 기준으로 올림 (정수로 만들어줌)
*/
    select ceil(12.345) from dual;
    -- 인자값이 음수인 경우 인수로 지정한 수치보다 크고 가까운 정수를 반환
    select ceil(-10.911) from dual;
       
/*
    5)floor(number)
    - 소수점을 기준으로 버림
*/
    select floor(12.789) from dual;
    -- 인자 값이 음수인 경우 소수점을 내림할 경우 음수값이 커지게 된다.
        select floor(-10.123) from dual;

/*
    6)trunc(number, [위치])
    - [위치를 지정하여] 소수점을 기준으로 버림
    * 위치 양수: 소수점 기준으로 오른쪽
          음수: 소수점 기준으로 왼쪽
*/
    select trunc(123.456), trunc(123.456, 2), trunc(123.456, -2) from dual;
    
/*
    7)power(number1, number2)
    - number1을 number2번 제곱한 결과를 반환
    - 첫번째 인자값이 음수일 경우에는 실수를 제곱할 수 없습니다. 
    - EX : POWER(-5, 3.01) 같은 연산은 할 수 없습니다.
*/
    select power(3,2), power(-10,2), power(-2,3) from dual;
    -- select POWER(-5, 3.01) from dual;
    SELECT POWER(5, 2), POWER(5, -3), POWER(-5, 3), POWER(5, 3.1) FROM DUAL;
