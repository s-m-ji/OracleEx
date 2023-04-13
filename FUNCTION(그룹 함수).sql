/* [그룹 함수]
    대량의 데이터로 집계, 통계 등의 작업을 처리해야하는 경우 사용
    모든 그룹 함수는 null 값을 자동으로 제외함 => nvl() 함수와 함께 사용하는걸 권장 
    
    1) sum(number)
    - 해당 컬럼의 총 합계를 반환
    
    2) avg(number)
    - 해당 컬럼의 평균을 반환
    
    3) min(모든 타입) / max(모든 타입)
    - min : 해당 컬럼의 값 중 가장 작은 값을 반환
    - max : 해당 컬럼의 값 중 가장 큰 값을 반환
    
    4) count(*|컬럼)
    - 결과행의 갯수를 세서 반환
    - count(*) : 조회결과에 해당하는 모든 행 갯수 반환  -> null도 같이 셈
    - count(컬럼) : 제시한 컬럼값이 null이 아닌 행 갯수 반환
    - count(distinct 컬럼) : 해당 컬럼의 중복을 제거한 후 행 갯수 반환
*/

select  to_char(sum(salary), 'L999,999') "총 급여"
        ,to_char(avg(salary), 'L999,999') "평균 급여"
from emp;

select  sum(salary) "총 급여"
        ,avg(salary) "평균 급여"
        ,floor(avg(salary)) "평균 급여 floor"
        ,trunc(avg(salary)) "평균 급여 trunc"
        ,min(EMPLOYEE_ID) "첫번째 사번"
        ,max(EMPLOYEE_ID) "마지막 사번"  -- max(EMPLOYEE_ID)+1 추후 시퀀스로 순번?을 만들 때 기본키로 이런 형식을 쓴다고용
        ,min(salary) "최소 급여"
        ,max(salary) "최대 급여"
from emp;

select DEPARTMENT_ID 
from emp
where DEPARTMENT_ID is null; 

select count(DEPARTMENT_ID)
from emp;   -- 106건 *null 제외하고 셈

select count(EMPLOYEE_ID)
from emp;   -- 107건

-- 중복을 제거한 건수   *null 제외하고 셈 => 모두 컬럼을 명시했을 경우임 !
select count(distinct DEPARTMENT_ID) 
from emp;   -- 11건

select distinct DEPARTMENT_ID
from emp;   -- 12건

-- nvl 함수를 이용해서 null 값을 치환 후 조회
select count(distinct nvl(DEPARTMENT_ID,0))
from emp;   -- 만약 테이블에 이미 있는 값으로 치환하면 중복에 걸려서 정확한 값 도출이 어려움

-- 사원 급여 합계, 중복 제거한 급여 합계, 
-- 평균 급여, 중복 제거한 평균 급여
-- 최소 급여, 중복 제거한 최소 급여  *최소/최대값은 고정적이기에 중복에 영향 받지 않음
select sum(salary), sum(distinct(salary))
,avg(salary), avg(distinct(salary))
,min(salary), min(distinct(salary))
from emp;

-- 분산과 표준 편차
select variance(salary), stddev(salary)
from emp;

/*
    ========== ========== <group by> ========== ==========
    그룹에 대한 기준을 제시할 수 있는 구문
    여러개의 값을 하나의 그룹으로 묶어서 처리할 목적으로 사용
    select
    from
    [where]
    [group by]
    [order by]
    쿼리는 순서대로 작성되어야함 *[] 생략가능한 절
    - select 절에는 집계 함수와 group by 절에 명시된 컬럼만 쓸 수 있음
*/
-- 전체사원을 하나의 그룹으로 묶어서 총합을 구한 결과
select sum(salary) from emp;
-- 부서별 사원의 급여 합계
select DEPARTMENT_ID 부서, sum(salary) 총급여, count(*) 사원수 -- count(*) count(EMP_NAME) 요런게 집계함수
from emp
group by DEPARTMENT_ID
order by 1;

-- 각 부서별 사원수
select DEPARTMENT_ID 부서, count(*) 사원수
from emp
group by DEPARTMENT_ID
order by 2 desc;

-- 부서별 커미션이 있는 사원수
select DEPARTMENT_ID 부서, COMMISSION_PCT 보너스, count(*) 사원수
from emp
group by DEPARTMENT_ID, COMMISSION_PCT
order by 2;

-- 값에 null이 있어서 count(COMMISSION_PCT)은 0으로 나오기도 한다
--select DEPARTMENT_ID 부서, count(COMMISSION_PCT) "보너스 사원수"
select DEPARTMENT_ID 부서, count(*) "보너스 사원수", COMMISSION_PCT 커미션
from emp
group by DEPARTMENT_ID, COMMISSION_PCT
order by 2;

select JOB_ID 부서, to_char(trunc(avg(salary)), 'L999,999') "평균 급여", count(DEPARTMENT_ID) 사원수,  count(*) 사원수
from emp
group by JOB_ID;

-- 부서별
select DEPARTMENT_ID 부서, lpad(count(*)||'명',8) as 사원수
        , lpad(decode(count(COMMISSION_PCT), 0,' ', count(COMMISSION_PCT)||'명'),8) as 커미션
        , to_char(sum(salary), '999,999') as 급여합계, floor(avg(salary)) as 평균
        , min(salary) as 최저급여 , max(salary) as 최고급여
from emp
group by DEPARTMENT_ID
order by 1;

SELECT CUST_GENDER, count(*)
from CUSTOMERS
group by CUST_GENDER
order by 1 desc;

-- 소계를 구하는 함수: rollup   => 소그룹 합계를 반환
--SELECT nvl(decode(CUST_GENDER, 'F','여','M','남'), 'F와M') 성별, count(*) 고객수
SELECT decode(CUST_GENDER, 'F','여','M','남', '남여') 성별, count(*) 고객수
from CUSTOMERS
group by rollup(CUST_GENDER);

SELECT count(*) from CUSTOMERS;

-- 여러 컬럼을 제시해서 그룹의 기준을 설정
-- 부서별 직급별 사원수와 급여의 총합
select DEPARTMENT_ID as "부서", JOB_ID as "직급"
        , count(*) as "부서내 직급별 사원수", sum(salary) as " 부서내 직급별 급여 총합"
        
from emp
group by DEPARTMENT_ID, JOB_ID
order by 1,2
;

/*
    ========== ========== <having> ========== ==========
    - 그룹에 대한 조건을 제시할 때 사용하는 구문
    - 그룹 함수의 결과를 가지고 비교를 수행
    
    * 실행 순서
        5.select    조회할 컬럼명|계산식|함수식|[as]별칭
        1.from      조회할 테이블명
        2.where     조건식
        3.group by  그룹 기준에 해당하는 컬럼명|계산식|함수식
        4.having    그룹에 대한 조건식
        6.order by  정렬 기준에 해당하는 컬럼명|[as]별칭|컬럼 순번
*/

select JOB_ID, sum(salary) 
from emp
-- where sum(salary) >= 10000   --- => 그룹함수는 where절에 올 수 없음! 허가 오류 발생함
group by JOB_ID
having sum(salary) >= 10000
order by sum(salary) desc;

select nvl(to_char(DEPARTMENT_ID), '부서없음') 부서
    , trim(to_char(floor(avg(salary)), 'L999,999'),20) 평균급여
    , lpad(count(*)||'명', 7) 사원수
from emp
group by DEPARTMENT_ID
having avg(salary) >= 7000
order by avg(salary);

-- 부서별 보너스를 받는 사원이 없는 부서들만 조회
select DEPARTMENT_ID, count(commission_pct)
from emp
--where commission_pct is null
group by DEPARTMENT_ID
having count(commission_pct) = 0;

/*
    ========== ========== <집계 함수> ========== ==========
    그룹별 산출한 결과 값의 중간 집계를 계산해주는 함수
*/

select nvl(to_char(JOB_ID),'전체 급여 합계') as "직급 목록" , sum(salary) as "직급별 급여 합계"
from emp
group by rollup(JOB_ID)
order by 1 desc;

-- cube
select JOB_ID, sum(salary)
from emp
group by cube(JOB_ID)
;

-- 부서 코드도 같고 직급 코드도 같은 사원들을 그룹 지어서 급여의 합계를 조회
select DEPARTMENT_ID, JOB_ID,  sum(salary)
from emp
group by rollup(DEPARTMENT_ID, JOB_ID)
order by 1,2;

select DEPARTMENT_ID, JOB_ID,  sum(salary)
from emp
group by cube(DEPARTMENT_ID, JOB_ID)
order by 1,2;

/*
    ========== ========== <grouping> ========== ==========
    rollup, cube에 의해 산출된 값이 
    해당 컬럼의 집합 산출물이면 0을 반환 아니면 0을 반환
*/

select DEPARTMENT_ID, JOB_ID,  sum(salary)
        , grouping (DEPARTMENT_ID)
        , grouping (JOB_ID)
from emp
group by rollup(DEPARTMENT_ID, JOB_ID)
order by 1,2;

/*
    ========== ========== <집합 연산자> ========== ==========
    - 여러개의 쿼리문을 가지고 하나의 쿼리문을 만듦
    - 합집합 
        union       : 두 쿼리문을 수행한 결과를 더한 후 중복 행은 제거
        union all   :               "              중복 행도 허용 
    - 교집합
        intersect   : 두 쿼리문을 수행한 결과에 중복된 결과값만 추출
    - 차집합
        minus       : 선행 결과집합에서 후행 결과집합을 뺀 나머지 결과값만 추출
*/
 -- 2건 인출
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20   
;
-- 3건 인출
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000      
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
        or      ------ or 로 묶음
    SALARY between 5000 and 6000      
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    union       ------ 중복 제거 합집합 *or와 같은 결과
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    union all      ------ 중복 허용 합집합
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
        and      ------ and 로 묶음
    SALARY between 5000 and 6000      
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    intersect       ---- 교집합 *and와 같은 결과
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    minus       ---- 차집합 
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select * from KOR_LOAN_STATUS;

select PERIOD, GUBUN, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS
--where substr(PERIOD,1,4) = '2013'
where PERIOD like '2013%'
group by PERIOD, GUBUN
;

select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS 
group by PERIOD, REGION
having sum(LOAN_JAN_AMT) >= 100000
    intersect
select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS 
where PERIOD like '2012%'
--where REGION = '서울'
group by PERIOD, REGION
;

select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS 
--where PERIOD like '2012%' and REGION = '서울'
-- 컬럼별로 따로 소계를 줄 수도 있음 : 이 경우 총 합계는 사라짐 !
--group by rollup(PERIOD), REGION       ----> 기간에 대한 소계: 지역마다 하나씩 결과가 나옴
--group by PERIOD, rollup(REGION)       ----> 지역에 개한 소계: 기간마다 하나식 결과가 나옴
group by rollup(PERIOD, REGION)         ----> 기간과 지역에 대한 소계: 모든 값을 다 더한 값이 전체 결과로 하나 더 나옴 
--having sum(LOAN_JAN_AMT) >= 100000

-- *** having절을 사용해도 rollup의 결과(소계)는 변하지 않는다
-- 소계에는 그룹의 조건이 적용되지 않아서 ???                 ----> 하지만 having 조건은 적용 되는게 맞음 !
--having sum(LOAN_JAN_AMT) between 100000 and 500000      ----> 실제 소계가 100만이 넘는데 having 조건으로 50만을 넘지 않는 필터링이 있기 때문에 집계에는 소계가 보이지 않음
                                                        ----> 소계에 having 조건이 해당되지 않을 경우 집계에 반영되지 않는다

-- having 조건을 추가할 경우 소계가 일치하지 않을 수 있다.      ----> having 조건으로 필터링 된 값은 집계에 보이지 않는 것  
-- having 조건이 없는 상태에서 집계할 경우 소계 금액이 일치하는 것을 확인할 수 있다.


/*
===== 결론 : having절은 결과집합에 대한 필터링이라고 볼 수 있음. 휴 !




*/

order by 1
;
-- 1023154.6
select DEPARTMENT_ID, JOB_ID,  sum(salary)
        , grouping (DEPARTMENT_ID)
        , grouping (JOB_ID)
from emp
group by rollup(DEPARTMENT_ID, JOB_ID)
order by 1,2;

-- ================= 04/13 교재 self-check 문제 관련 ===================
create table e(
    id number(6), name varchar2(80), salary number(8,2), id2 number(6)
);

merge into 테이블명1 별칭1
    using(select 컬럼1, 컬럼2, 컬럼3
        from 테이블명2
        where 컬럼3 = 값2) 별칭2
        on (별칭1.컬럼1 = 별칭2.컬럼1)
    when matched then
    update set 별칭1.컬럼4 = 별칭1.컬럼4 + 별칭1.컬럼5*값2
    when not matched then
    insert(별칭1.컬럼1, 별칭1.컬럼4) values(별칭2.컬럼1, 별칭1.컬럼5*값3);
     


select substr('ABCDEFG',-2,4) from dual;

-- 근속년수 구하기 : round((sysdate - hire_date)/365)
-- 연령대(n령대) 구하기 : trunc((to_char(sysdate, 'yyyy')-birtrh_date)/10)

select round((sysdate - hire_date)/365)
from emp;

select TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH
from CUSTOMERS;

select sum(CUST_NAME) FROM CUSTOMERS;  

SELECT CUST_NAME, 
       CUST_YEAR_OF_BIRTH, 
       CASE WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 1 THEN '10대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 2 THEN '20대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 3 THEN '30대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 4 THEN '40대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 5 THEN '50대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 6 THEN '60대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 7 THEN '70대'
          ELSE '기타' END AS new_generation
FROM CUSTOMERS;  

SELECT period, 
       CASE WHEN gubun = '기타대출'     THEN SUM(loan_jan_amt) ELSE 0 END 기타대출액, 
       CASE WHEN gubun = '주택담보대출' THEN SUM(loan_jan_amt) ELSE 0 END 주택담보대출액
       
  FROM kor_loan_status
 WHERE period = '201311' 
 GROUP BY period, gubun;

SELECT period, SUM(loan_jan_amt) 주택담보대출액, 0 기타대출액
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '주택담보대출'
 GROUP BY period, gubun
 UNION all
SELECT period, 0 주택담보대출액, SUM(loan_jan_amt) 기타대출액
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '기타대출'
 GROUP BY period, gubun ;
 
SELECT period, 0 주택담보대출액, SUM(loan_jan_amt) 기타대출액
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '기타대출'
 GROUP BY period, gubun
   UNION all
 SELECT period, SUM(loan_jan_amt) 주택담보대출액, 0 기타대출액
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '주택담보대출'
 GROUP BY period, gubun;






