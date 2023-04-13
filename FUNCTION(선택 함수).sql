/*
    ========== ========== <선택 함수> ========== ==========
    - 여러가지 경우에 선택을 할 수 있는 기능을 제공하는 함수
    
    1) decode(컬럼, 조건1, 결과1[, 조건2, 결과2, ...], 결과값)
                -- 조건1이 true면 결과1 조건2이 true면 결과2 모두 아니면(false면) 결과값
       decode(컬럼, 조건1, 결과1, 결과2)
                -- 조건이 true면 결과1 false면 결과2
*/

select decode(substr('1111294056520',7,1), 1,'男' ,3,'男' ,2,'女' ,4,'女', '^_^') from dual;
select decode(5, 1,'男' ,3,'男' ,2,'女' ,4,'女', '^_^') ㅅㅓㅇㅂㅕㄹ from dual; 
                            -- 모두 아니면 마지막 값을 출력, 별도로 설정해두지않으면 null이 나온다 !

-- 1111294265952
-- 9511294265952

select to_char(sysdate, 'yyyy') - decode(substr('1111294056520',7,1)
        , 4, '20'||substr('1111294056520',1,2))+1 "2000년대생 나이"
from dual;

select to_char(sysdate, 'yyyy') - decode(substr('9511292265952',7,1)
        , 2, '19'||substr('9511294265952',1,2))+1 "1900년대생 나이"
from dual;


create table user01 (
    name varchar2(30)
    , jumin char(13)
    , telno varchar2(20)
); 

insert into user01 values (
'스누피', '1111294056520', '010-0000-0000');

insert into user01 values (
'찰리', '9511294265952', '010-1111-1111');

update user01
set jumin = '9511291265952'
where name = '찰리';

select * from user01;

select jumin, substr(jumin,7,1) "주민번호 성별"
                , decode(substr(jumin,7,1)
                , '1','19' , '2','19'
                , '3','20' , '4','20'
                , '') || substr(jumin,0,2) 출생년도
                , to_char(sysdate, 'yyyy') 올해1
                , extract(year from sysdate) 올해2
                
                , extract(year from sysdate) - (decode(substr(jumin,7,1)
                , '1','19' , '2','19'
                , '3','20' , '4','20'
                , '') || substr(jumin,0,2)) 나이
from user01;

/*
    직급 코드가 AD_VP 이면 10% 인상 (salary*1.1)
              SA_REP 이면 15% 인상   (salary*1.15)
              IT_PROG 이면 20% 인상   (salary*1.2)
                그 외 직원은 5% 인상   (salary*1.05)
*/

select TITLE_KOR 직업명 ,MIN_SALARY "기존 급여"
    , decode(JOB_ID, 'AD_VP', MIN_SALARY*1.1
                    , 'SA_REP', MIN_SALARY*1.15
                    , 'IT_PROG', MIN_SALARY*1.2
                    ,MIN_SALARY*1.05 ) "인상된 급여"
from JOBS;

select NAME_KOR 사원명 ,SALARY "기존 급여"
    , decode(JOB_ID, 'AD_VP', SALARY*1.1
                    , 'SA_REP', SALARY*1.15
                    , 'IT_PROG', SALARY*1.2
                    ,SALARY*1.05 ) "인상된 급여"
from EMP;

/*
    2)case
        case when 조건식1 then 결과값1
            when 조건식2 then 결과값2
            ...
            else 결과값        -- 모든 조건이 아닐 때 결과값으로 도출 ~
        end
*/

select name 이름, case when substr(jumin,7,1) = '1' then '男' 
            when substr(jumin,7,1) = '3' then '男'
            when substr(jumin,7,1) = '2' then '女'
            when substr(jumin,7,1) = '4' then '女'
            else '^_^' end 성별
from user01;

select CUST_NAME 이름, CUST_YEAR_OF_BIRTH 출생년도, extract(year from sysdate) - CUST_YEAR_OF_BIRTH 나이
                     ,case  when (extract(year from sysdate) - CUST_YEAR_OF_BIRTH) >= 50 and extract(year from sysdate) - CUST_YEAR_OF_BIRTH <60 then '50대'
                            when (extract(year from sysdate) - CUST_YEAR_OF_BIRTH) >= 40 and extract(year from sysdate) - CUST_YEAR_OF_BIRTH <50 then '40대'
                            when (extract(year from sysdate) - CUST_YEAR_OF_BIRTH) >= 30 and extract(year from sysdate) - CUST_YEAR_OF_BIRTH <40 then '30대'
                      else '기타' end 연령대          
from CUSTOMERS
order by CUST_YEAR_OF_BIRTH desc;

select CUST_NAME 이름
    , case  when trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10) = 3 then '30대'
            when trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10) = 4 then '40대'
            when trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10) = 5 then '50대'
    else '기타' end 연령대  
from CUSTOMERS;

select CUST_NAME 이름, decode(trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10)
                        , '3','30대' , '4','40대', '5','50대', '6','60대', '기타') 연령대 
from CUSTOMERS;
-- 코드가 간결해지기 위해서는 검사할 값을 미리 정제해두는게 좋겠다 !

/*
    ========== ========== <선택 함수> ========== ==========
    *값 : 컬럼, 문자열(리터럴)
    
    greatset(값1,값2...)
    - 매개변수로 들어오는 값 중 장 큰 값을 반환
    
    least(값1,값2...)
    - 매개변수로 들어오는 값 중 가장 작은 값을 반환
*/

select greatest(1,10) from dual;
select greatest('A','a') from dual;

select least(1,10,3,-30) from dual;
select least(1,10,3,-30) from dual;


select name 
from user01 order by name;







