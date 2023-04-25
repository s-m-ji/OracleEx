-- 교재 p174 연습문제
-- 1) 사원테이블에서 입사년도별 사원수를 구하는 쿼리를 작성
select to_char(HIRE_DATE, 'yyyy') 입사년도
--select lpad(extract(year from HIRE_DATE)||'년',8) 입사년도
        , lpad(count(*)||'명',7) 사원수
from emp
group by to_char(HIRE_DATE, 'yyyy')
--group by HIRE_DATE
order by 1 ;

-- 2) 2012년도 월별, 지역별, 대출잔액의 합계
select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS
where PERIOD like '2012%'               -->  where절로 필터링하거나
group by PERIOD, REGION
--having substr(period,1,4) = '2012'    --> having절로 필터링하거나
;
select * from KOR_LOAN_STATUS;

-- 3) 2013년도 기간별 대출종류별 대출잔액의 합계
--select PERIOD 기간
select nvl(to_char(substr(PERIOD,1,4)||'년 ')||(substr(PERIOD,4,2)||'월'),'합계') 기간
        , lpad(nvl(to_char(GUBUN),'*소계*'),15) 구분
        , to_char(sum(LOAN_JAN_AMT), 'L9,999,999') 대출잔액합계
from KOR_LOAN_STATUS
where period like '2013%'
group by PERIOD, rollup(GUBUN)
;

-- 4) 위 쿼리를 집합연산자로 바꿔 써보기

-- 4-1) 2013년도 기간 내 대출종류별 대출잔액의 합계
select PERIOD 기간, GUBUN 구분
        , to_char(sum(LOAN_JAN_AMT), 'L9,999,999') 대출잔액합계
from KOR_LOAN_STATUS
where period like '2013%'
group by PERIOD, GUBUN
    union                                 --> 두 쿼리의 컬럼수가 다를 경우 : 오류 발생 "질의 블록은 부정확한 수의 결과 열을 갖고있음둥"  
                                        --> 두 쿼리의 데이터 타입이 다를 경우 : 오류 발생 "대응하는 식과 같은 데이터 유형이어야함둥"     
-- 4-2) 2013년도 기간별 대출잔액의 합계
select PERIOD 기간, ''    -- '' : (null)로 만들기 위함, '소계' 로 문자를 대입하면 컬럼 내 값들 순서가 바뀐다. 
        , to_char(sum(LOAN_JAN_AMT), 'L9,999,999') 대출잔액합계
from KOR_LOAN_STATUS
where period like '2013%'
group by PERIOD
;

-- 5) 기간별 주.담.대, 기.대 구하기

-- 5-1) select절에서 decode 또는 case문 사용하여, 구분 컬럼의 값이 주.담.대인 경우의 합 구하기

-- * 피벗 테이블 : 행의 데이터를 열의 머릿글로 사용 

-- 5-2) select문의 결과 집합을 테이블처럼 사용   
--> 결과 집합이 가진 컬럼(기간, 주택담보대출, 기타대출)만 select 조회 가능  
--> 기간&구분을 sum으로 합쳐야 한 줄로 표현할 수 있음 

select decode(grouping(기간),1, '기간별 소계', 기간) as 기간       --> 그룹에 대한 null 값이므로 nvl보다 grouping이 더 정확할 것 같다고 하심. 
--select nvl(기간, '기간별 소계') as 기간
            , sum(주택담보대출) as 주택담보대출 
            , sum(기타대출) as 기타대출
            , sum(주택담보대출 + 기타대출) as "기간별 합계"
from (
        select PERIOD as 기간
                , decode(GUBUN, '주택담보대출', sum(LOAN_JAN_AMT), 0) as 주택담보대출
                , decode(GUBUN, '기타대출', sum(LOAN_JAN_AMT), 0) as 기타대출
        from KOR_LOAN_STATUS
        where PERIOD like '2013%'
        group by PERIOD, GUBUN
        order by 1
)
group by rollup(기간)
;

-- 6) 위 쿼리를 집합연산자로 표현하기
-- 6-1) 2013년 11월 주담대 합계
-- 6-2) 2013년 11월 기타 합계
select 기간, sum(주담대) as 주택담보대출, sum(기타) as 기타대출
from (
    select PERIOD as 기간, sum(LOAN_JAN_AMT)as 주담대 , 0 as 기타
    from KOR_LOAN_STATUS
    where PERIOD = '201311' and GUBUN = '주택담보대출'
    group by PERIOD, GUBUN
        union
    select PERIOD, 0 , sum(LOAN_JAN_AMT)            --> from table 내 한 쪽에서 별칭을 만들었다면 다른 쪽은 달지 않아도 된단다 
    from KOR_LOAN_STATUS
    where PERIOD = '201311' and GUBUN = '기타대출'
    group by PERIOD, GUBUN
)
group by 기간
;

-- 7) 지역과 각 월별 대출총잔액을 구하기

select region as "지역"
        ,sum("201111") as "2011년 11월", sum("201112") as "2011년 12월"
        ,sum("201210") as "2012년 10월", sum("201211") as "2012년 11월", sum("201212") as "2012년 12월"
        ,sum("201310") as "2013년 10월", sum("201311") as "2013년 11월"
from (
    select REGION, PERIOD, LOAN_JAN_AMT 
            ,decode(period, 201110, loan_jan_amt, 0) as "201110"
            ,decode(period, 201111, loan_jan_amt, 0) as "201111"
            ,decode(period, 201112, loan_jan_amt, 0) as "201112"
            ,decode(period, 201210, loan_jan_amt, 0) as "201210"
            ,decode(period, 201211, loan_jan_amt, 0) as "201211"
            ,decode(period, 201212, loan_jan_amt, 0) as "201212"
            ,decode(period, 201310, loan_jan_amt, 0) as "201310"
            ,decode(period, 201311, loan_jan_amt, 0) as "201311"
            ,decode(period, 201312, loan_jan_amt, 0) as "201312"
    from KOR_LOAN_STATUS
--    where region = '강원' 
)
group by region
order by 1
;

/*
    - pivot 함수
    행을 열로 변환해주는 함수 : 2차원의 표로 출력
    통계 작업에 사용
    11버전 이후 pivot 함수 제공
    
    select *
    from    ( 피벗 대상 쿼리문 )
    pivot   ( 그룹함수(집계컬럼) for 피벗컬럼 in (피벗컬럼값) )
*/

select *
from (
    select region, period, loan_jan_amt
    from kor_loan_status
)
pivot ( sum(loan_jan_amt) for period in (201111 as "2011년 11월", 201112 as "2011년 12월",  
                                        201210, 201211, 201212, 
                                        201310, 201311)
)
order by 1
;

-- 부서별 년도별 입사자수
select *
from (
    select DEPT_ID 부서
            , to_char(HIRE_DATE, 'yyyy') 입사년도
    from emp
)
pivot ( count(*) for 입사년도 in (2000,2001,2002,2003,2004,2005)
);


-- 부서별 월별 입사자수
select *
from (
    select DEPT_ID 부서
            , to_char(HIRE_DATE, 'fmmm') 입사월
    from emp
)
pivot ( count(*) for 입사월 in (1,2,3,4,5,6,7,8,9,10,11,12)
);





