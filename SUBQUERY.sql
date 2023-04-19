/*
    <SUBQUERY>
    하나의 SQL문 안에 포함된 또 다른 SQL문을 뜻한다.
    메인 쿼리(기존 쿼리)를 보조하는 역할을 하는 쿼리문
*/

/*
    [쿼리 실행 순서]
    5. SELECT       조회할 컬럼
    1. FROM         테이블
    2. WHERE        조건식
    3. GROUP BY     그룹 기준
    4. HAVING       그룹 조건식
    6. ORDER BY     정렬 기준
*/

-- 노옹철 사원과 같은 부서원들을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE EMP_NAME = '노옹철'
;

-- 서브쿼리는 () 괄호로 묶기
-- 비교값과 결과 타입이 일치해야한다

-- 서브쿼리를 수행한 결과 값의 행과 열 갯수에 따라 서브쿼리를 분류함

-- <단일행 서브쿼리> =====================================================
--   서브쿼리 조회 결과 값의 행과 열 갯수가 1개
--      비교연산자 사용 가능 (=, !=, <>, ^=, <, >, <=, >=)
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMP
                    WHERE EMP_NAME = '노옹철'
    );

-- 단일행 1) 전 직원의 평균 급여보다 급여를 적게 받는 직원명, 직급코드, 급여를 조회
--      서브쿼리: 전 직원의 평균 급여
SELECT ROUND(AVG(SALARY))
FROM EMP
;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMP
WHERE SALARY < (
                SELECT ROUND(AVG(SALARY))
                FROM EMP
        );

-- 단일행 2) 최저 급여를 받는 직원의 사번, 이름, 직급 코드, 급여, 입사일 조회
--      서브쿼리: 최저 급여 조회
SELECT MIN(SALARY)
FROM EMP;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMP
WHERE SALARY = (
        SELECT MIN(SALARY)
        FROM EMP
    );

-- 단일행 3) 노옹철 사원의 급여보다 더 많은 급여를 받는 사원의 사번, 사원명, 부서명, 직급 코드, 급여를 조회
--      서브쿼리: 노옹철 사원의 급여를 조회
SELECT SALARY
FROM EMP
WHERE EMP_NAME = '노옹철'
;
--      오라클 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, JOB_CODE 직급코드, SALARY 급여
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
WHERE SALARY > (
    SELECT SALARY
    FROM EMP
    WHERE EMP_NAME = '노옹철'
);
--      ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, EMP.JOB_CODE 직급코드, TO_CHAR(SALARY, 'L99,999,999') 급여
FROM EMP, DEPT, JOB
WHERE DEPT_CODE = DEPT_ID
AND EMP.JOB_CODE = JOB.JOB_CODE
AND SALARY > (
    SELECT SALARY
    FROM EMP
    WHERE EMP_NAME = '노옹철'
);

-- 단일행4) 부서별 급여의 합이 가장 큰 부서의 부서코드, 급여합 조회
--      서브쿼리1) : 부서별 급여의 합 조회
SELECT DEPT_CODE 부서코드, SUM(SALARY) 급여합      -- SUM(SALARY)는 집계 함수라서 같이 쓸 수 있음. 
FROM EMP
GROUP BY DEPT_CODE;

--      서브쿼리2) 부서별 급여의 합계 중 최대값을 구함      -- SELECT절에서 DEPT_CODE, MAX(SUM(SALARY)를 같이 쓸 수 없어서 서브쿼리로 분기함
SELECT MAX(SUM(SALARY)) 급여합최대      
FROM EMP
GROUP BY DEPT_CODE
;

SELECT DEPT_CODE 부서코드, SUM(SALARY)급여합
FROM EMP
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY)) 급여합최대      
    FROM EMP
    GROUP BY DEPT_CODE
);

-- 부서별 평균급여가 가장 작은 부서의 부서 코드와 평균 급여를 조회
SELECT MIN(AVG(SALARY))    
FROM EMP
GROUP BY DEPT_CODE
;    
SELECT DEPT_CODE 부서코드, ROUND(AVG(SALARY)) 평균급여
FROM EMP
GROUP BY DEPT_CODE
HAVING AVG(SALARY) = (
    SELECT MIN(AVG(SALARY))    
    FROM EMP
    GROUP BY DEPT_CODE
);

-- 서브쿼리는 WHERE절뿐만 아니라 SELECT/FROM/HAVING절에서도 사용이 가능하다.
SELECT DEPT_CODE 부서코드   
        , ( SELECT DEPT_TITLE                           -- DEPT_TITLE을 조회하기 위해 서브쿼리를 사용함
            FROM DEPT
            WHERE DEPT_ID = DEPT_CODE ) 부서명             -- 메인쿼리에 사용된 테이블(EMP)이 가진 컬럼값을 조건으로 사용
        , ROUND(AVG(SALARY)) 평균급여
FROM EMP
GROUP BY DEPT_CODE
HAVING AVG(SALARY) = (
    SELECT MIN(AVG(SALARY))    
    FROM EMP
    GROUP BY DEPT_CODE
);

-- 단일행5) 전지연 사원이 속한 부서의 부서원의 사번, 사원명, 전화번호, 직급명, 부서명, 입사일 조회 (단, 전지연 본인은 제외)
--      서브쿼리: 전지연 사원이 속해있는 부서 조회
SELECT DEPT_TITLE
FROM DEPT
JOIN EMP ON (DEPT_ID = DEPT_CODE)
WHERE EMP_NAME = '전지연'
;
--      또는 (* EMP 테이블에 DEPT_CODE라는 키가 있다.)
SELECT DEPT_CODE
FROM EMP
WHERE EMP_NAME = '전지연'
;
        -- 오라클 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, PHONE 전화번호
    , JOB_NAME 직급명, DEPT_TITLE 부서명, HIRE_DATE 입사일
FROM EMP, DEPT, JOB
WHERE DEPT_ID = DEPT_CODE
AND EMP.JOB_CODE = JOB.JOB_CODE
AND DEPT_TITLE = 
        (SELECT DEPT_TITLE
            FROM DEPT
            JOIN EMP ON (DEPT_ID = DEPT_CODE)
            WHERE EMP_NAME = '전지연'
        )
AND EMP_NAME ^= '전지연'
;
        -- ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 사원명, PHONE 전화번호
    , JOB_NAME 직급명, DEPT_TITLE 부서명, HIRE_DATE 입사일
FROM EMP
JOIN DEPT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
WHERE DEPT_CODE = 
        (SELECT DEPT_CODE
            FROM EMP
            WHERE EMP_NAME = '전지연'
        )
AND EMP_NAME ^= '전지연'
;

/*
    <다중행 서브쿼리> =====================================================
    서브쿼리의 조회 결과 값이 여러행일 때
    
    IN / NOT IN (서브쿼리)
    여러개의 결과값중 하나라도 일치하면 TRUE를 리턴
    -> WHERE절에서 조건을 만족할 경우 TRUE (결과집합에 포함)
    
    ANY 
    여러개의 값들 중 한 개라도 만족하면 TRUE
        ANY (값, 값, 값 ..) -> 값들은 OR로 엮인다.
    
    * IN과 다른점 : 비교연산자를 함께 사용할 수 있다.
        E.G) SALARY = ANY(...) IN과 같은 결과
             SALARY != ANY(...) NOT IN과 같은 결과
             SALARY > ANY (10000000, 2000000, 3000000) 최소값 보다 크면 TRUE
             SALARY < ANY (10000000, 2000000, 3000000) 최대값 보다 작으면 TRUE
             
    ALL 
    여러개의 값들 모두와 비교하여 만족해야 TRUE
        ALL (값, 값, 값 ..) -> 값들은 AND로 엮인다.
        
        E.G) SALARY > ANY (10000000, 2000000, 3000000) 최소값 보다 크면 TRUE
             SALARY < ANY (10000000, 2000000, 3000000) 최대값 보다 작으면 TRUE
*/

-- 다중행1) 각 부서별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회
--      서브쿼리: 우선 각 부서별 최고 급여 조회
SELECT DEPT_CODE, MAX(SALARY)
FROM EMP
GROUP BY DEPT_CODE
;

--      위에 조회된 급여를 받는 사람을 조회
SELECT EMP_NAME 이름, JOB_CODE 직급코드, NVL(DEPT_CODE,' ') 부서코드, SALARY 급여
        ,( SELECT JOB_NAME
            FROM JOB
            WHERE EMP.JOB_CODE = JOB.JOB_CODE
        ) 직급명
        ,NVL((SELECT DEPT_TITLE
            FROM DEPT
            WHERE DEPT_CODE = DEPT_ID
        ), '*부서 없음*') 부서명
-- 조회할 컬럼이 다양하기 때문에 메인쿼리는 GROUP으로 묶지않는다.
FROM EMP
WHERE SALARY IN (
    SELECT MAX(SALARY)      -- 메인쿼리 WHERE에서 SALARY를 찾기 때문에 서브쿼리 SELECT에서도 SALARY를 써야함
    FROM EMP
    GROUP BY DEPT_CODE
);

-- 다중행2-1) 전 직원의 사번, 이름, 부서코드, 구분(매니저/사원)을 조회 
--      서브쿼리: *매니저인 사원의 사번을 조회 (*중복 제거) 
--          일단 매니저 컬럼의 값을 중복되지 않게 모두 조회
SELECT DISTINCT MANAGER_ID
FROM EMP
;
--          매니저 컬럼 값 중 관리 사원이 있는 값만 추리기 
SELECT DISTINCT MANAGER_ID
FROM EMP
WHERE MANAGER_ID IS NOT NULL
ORDER BY MANAGER_ID
;

--      1. 매니저에 해당하는 사원의 사번, 사원명, 부서코드, 구분(매니저) 조회
--          UNION
--      2. 사원에 해당하는 사원의 사번, 사원명, 부서코드, 구분(사원) 조회
SELECT EMP_ID 사번, EMP_NAME 사원명, NVL(DEPT_CODE, '**부서없음**') 부서코드, '매니저' 구분
FROM EMP
WHERE EMP_ID IN (
        SELECT DISTINCT MANAGER_ID
        FROM EMP
        WHERE MANAGER_ID IS NOT NULL
    )
    UNION
SELECT EMP_ID 사번, EMP_NAME 사원명, NVL(DEPT_CODE, '**부서없음**') 부서코드, '사원' 구분
FROM EMP
WHERE EMP_ID NOT IN (
        SELECT DISTINCT MANAGER_ID
        FROM EMP
        WHERE MANAGER_ID IS NOT NULL
    )
ORDER BY 구분
;

-- 다중행2-2) SELECT 절에 서브 쿼리를 이용하는 방법
--      매니저 사번이 200번인 사번을 모두 조회 -> 200번 매니저에게 관리되는 사원의 결과집합
SELECT EMP_ID
FROM EMP
WHERE MANAGER_ID = 200;
--      매니저 행이 맞으면 관리하는 사원 수를 산정하여 표시함, 아니면 0
SELECT (SELECT COUNT(*) FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID) FROM EMP;
--      매니저 행이 맞으면 해당 사번을 중복 제거하고 표시함
SELECT (SELECT DISTINCT MANAGER_ID FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID) FROM EMP;

SELECT EMP_ID 사번
        -- MANAGER_ID에 등록된 EMP_ID 갯수 조회
        , ( SELECT COUNT(*) FROM EMP 서브 WHERE 서브.MANAGER_ID = 메인.EMP_ID ) 조회
        -- 서브쿼리에서 사용된 컬럼명은 앞에 테이블을 명시하지 않으면 기본적으로 서브쿼리 FROM절 테이블에서 조회해온다.
        -- 메인쿼리 테이블을 참조하려면 메인쿼리 FROM절 테이블로 명시해야한다.
        -- 만약 참조해오는 메인/서브쿼리 테이블을 서로 바꿔쓰면 예상한 값이 나오지 않는다. -> 오류
FROM EMP 메인;

SELECT EMP_ID 사번, EMP_NAME 사원명
--      CASE 구문 활용하여 관리 사원 수가 0보다 크면 매니저, 아니면 사원으로 출력
        , CASE WHEN (SELECT COUNT(*) FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID) > 0 
            THEN '매니저' ELSE '사원' END 구분1
--      DECODE 함수 활용하여 중복을 제거한 매니저 사번이 NULL이면 사원, 아니면 매니저로 출력            
        , DECODE((SELECT DISTINCT MANAGER_ID FROM EMP E WHERE E.MANAGER_ID = EMP.EMP_ID )
            ,'', '사원', '매니저') 구분2
        , NVL(DEPT_CODE, '**부서없음**') 부서코드
FROM EMP
--ORDER BY 구분              -- 쿼리문에 없는 별칭을 조회 순서 기준으로 삼고자 할 경우 당연히 오류가 난다.. 
;

-- 다중행3) 대리 직급임에도 과장 직급의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급명, 급여를 조회
--      서브쿼리: 과장 직급의 급여 정보
SELECT MIN(SALARY)
FROM EMP
WHERE JOB_CODE = 'J5'
;
--      ANSI 구문
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, SALARY 급여
FROM EMP
JOIN JOB USING (JOB_CODE)
WHERE JOB_CODE = 'J6' 
AND SALARY > ANY( SELECT MIN(SALARY)
                    FROM EMP
                    WHERE JOB_CODE = 'J5')
;
--      오라클 구문
SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, SALARY 급여
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND EMP.JOB_CODE = 'J6'   
AND SALARY > ANY (SELECT MIN(SALARY)
                    FROM EMP
                    WHERE JOB_CODE = 'J5')
;

-- 다중행4) 과장 직급임에도 차장 직급의 최대급여보다 더 많이 받는 직원의 사번, 이름, 직급명, 급여를 조회
--      서브쿼리: 차장 직급들의 최대급여를 조회
SELECT MAX(SALARY)
FROM EMP
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '차장'
;

SELECT EMP_ID 사번, EMP_NAME 이름, JOB_NAME 직급명, SALARY 급여
FROM EMP E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND J.JOB_NAME = '과장'
AND SALARY > ANY (
            SELECT MAX(SALARY)
            FROM EMP
            JOIN JOB USING (JOB_CODE)
            WHERE JOB_NAME = '차장')
;


/*
    <다중열 서브 쿼리> =====================================================
    조회 결과 값은 한 행이지만 나열된 컬럼 수가 여러 개일 때
*/
-- 다중열1) 하이유 사원과 같은 부서 코드, 같은 직급 코드에 해당하는 사원들 조회
--      서브쿼리: 하이유 사원의 부서 코드, 직급 코드 조회
SELECT DEPT_CODE 부서코드, JOB_CODE 직급코드
FROM EMP
WHERE EMP_NAME = '하이유'
;

SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE DEPT_CODE = (
            SELECT DEPT_CODE 부서코드
            FROM EMP
            WHERE EMP_NAME = '하이유')
AND JOB_CODE = (
            SELECT JOB_CODE 직급코드
            FROM EMP
            WHERE EMP_NAME = '하이유'
            )
;
-- 다중열 서브쿼리 (컬럼1, 컬럼2, ...)를 사용해서 하나의 쿼리로 작성하기
-- 컬럼의 갯수만큼 값을 나열함  => 메인쿼리 내 WHERE절에 쓰인 컬럼과 갯수와 타입을 동일하게 맞춤

--      컬럼값을 바로 대입했을 경우
SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE (DEPT_CODE, JOB_CODE) = (('D5', 'J5'))        
;
--          조회되는 결과집합 행이 단일일 때 등호(=) 사용 (* 그렇담 이건 다중열/단일행이라고 생각해도될지...?)

--      서브쿼리1로 대입했을 경우
SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE (DEPT_CODE, JOB_CODE) IN (                    -- 조회되는 결과집합 행 갯수가 여러개일때는 IN 사용
                            SELECT DEPT_CODE, JOB_CODE      
                            FROM EMP
                            WHERE DEPT_CODE = 'D5' AND JOB_CODE = 'J5')
;
--      서브쿼리2로 대입했을 경우
SELECT EMP_NAME, DEPT_CODE, JOB_CODE  
FROM EMP
WHERE (DEPT_CODE, JOB_CODE) IN (            
                            SELECT DEPT_CODE, JOB_CODE  
                            FROM EMP
                            WHERE EMP_NAME = '하이유')
;

-- 다중열2) 박나라 사원과 직급 코드가 일치하면서 같은 사수를 가지고 있는 사원의 사번, 이름, 직급코드, 사수사번, 조회
--      서브쿼리: 박사원의 직급코드와 사수사번을 조회
SELECT JOB_CODE 직급코드, MANAGER_ID 사수사번
FROM EMP
WHERE EMP_NAME = '박나라'
;


SELECT EMP_ID 사번, EMP_NAME 이름, JOB_CODE 직급코드, MANAGER_ID 사수사번
FROM EMP
WHERE (JOB_CODE, MANAGER_ID) IN (
                            SELECT JOB_CODE, MANAGER_ID
                            FROM EMP
                            WHERE EMP_NAME = '박나라') 
    AND EMP_NAME != '박나라'               -- 문제에서 박나라 본인은 제외할 수 있도록 쿼리문을 추가했다.
;

/*
    <다중행 다중열 서브 쿼리> =====================================================
    서브쿼리의 조회 결과값이 여러행, 여러열일 경우
*/
-- 다중행 다중열1) 각 직급별로 최소 급여를 받는 사원들의 사번, 이름, 직급코드, 급여 조회
--      서브쿼리: 각 직급별 최소 급여 조회
SELECT JOB_CODE 직급코드, MIN(SALARY) 최소급여
FROM EMP
GROUP BY JOB_CODE
ORDER BY JOB_CODE
;
SELECT EMP_ID 사번, EMP_NAME 이름
--          DECODE 함수를 활용해서 직급코드에 따라 직급명을 표시
        , DECODE(JOB_CODE, 'J1', '대표', 'J2', '부사장', 'J3', '부장'
                        , 'J3', '차장', 'J5', '과장', 'J6', '대표', '사원') 직급코드
        , JOB_CODE 직급코드, SALARY 급여         
FROM EMP
WHERE (JOB_CODE, SALARY) IN ( SELECT JOB_CODE , MIN(SALARY) 
                                FROM EMP
                                GROUP BY JOB_CODE )
ORDER BY JOB_CODE
;

-- 다중행 다중열2) 각 부서별 최소급여를 받는 사원들의 사번, 이름, 부서명, 급여 조회 (* 부서가 없는 사원은 부서없음으로 조회)
--          서브쿼리: 각 부서별 최소 급여 조회
--              참고로 여기서는 총 7건이 조회되지만
SELECT NVL(DEPT_CODE, '**부서없음**'), MIN(SALARY)     
FROM EMP
GROUP BY DEPT_CODE
;
--              여기서는 6건이 조회됨 : 값이 NULL이면 결과집합에서 제외되어 나옴
--                  테이블을 JOIN해서 다른 테이블의 데이터를 출력함. 
SELECT EMP_ID 사번, EMP_NAME 이름, SALARY 급여, NVL(DEPT_TITLE, '**부서없음**') 부서명
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID(+)
--      NVL함수로 NULL을 치환해줄 경우 메인/서브 쿼리 컬럼의 형식을 동일하게 맞춰줘야함
AND (NVL(DEPT_CODE, '**부서없음**'), SALARY) IN ( SELECT NVL(DEPT_CODE, '**부서없음**'), MIN(SALARY)
                                                FROM EMP
                                                GROUP BY DEPT_CODE )
;
--                  테이블을 JOIN하지 않고 서브쿼리를 이용해서 다른 테이블의 데이터를 출력함. 
SELECT EMP_ID 사번, EMP_NAME 이름,  SALARY 급여 , NVL((SELECT DEPT_TITLE FROM DEPT WHERE DEPT_CODE = DEPT_ID),'**부서없음**') 부서명
FROM EMP
WHERE (NVL(DEPT_CODE, '**부서없음**'), SALARY) IN ( SELECT NVL(DEPT_CODE, '**부서없음**'), MIN(SALARY)      
                                                    FROM EMP
                                                    GROUP BY DEPT_CODE )
;

/*
    <인라인 뷰>
    FROM 절에 서브쿼리를 제시하고, 서브쿼리를 수행한 결과를 테이블 대신 사용한다.
    1) 인라인 뷰를 활용한 TOP-N 분석
*/

-- 전 직원 중 급여가 가장 높은 사람 5명 순위, 이름, 급여 조회
-- FROM -> SELECET(순번이 정해진다) -> ORDER BY (순서대로 쿼리가 실행)
SELECT ROWNUM, E.*
FROM (
        SELECT ROWNUM RN, EMP_NAME, SALARY  -- 그래서 ROWNUM에 RN이라고 별칭을 붙여주었음
        FROM EMP
        ORDER BY SALARY DESC
    ) E
--WHERE ROWNUM > 5 AND ROWNUM < 10         -- ROWNUM은 첫번째가 무조건 1인데 조건이 5보다 크다고하면 ROWNUM이 아예 나올 수 없음 
WHERE ROWNUM <= 5
;

-- 부서별 평균급여가 높은 3개 부서의 부서코드, 평균급여 조회
SELECT ROWNUM RN, SUB.*
FROM (
        SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
        FROM EMP
        GROUP BY DEPT_CODE
        ORDER BY 평균급여 DESC
    ) SUB
WHERE RN <= 3                                    -- TODO RN 별칭을 쓰고시푼뎅..?????????????????? -> 쿼리 실행 순서에 따라 셀렉 절의 별칭은 쓸 수 없당
;

SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여
        FROM EMP
        GROUP BY DEPT_CODE
        ORDER BY 평균급여 DESC;

-- 2) WITH을 이용한 방법
    -- 같은 서브쿼리가 여러번 사용될 경우 중복 작성을 피하기 위해 사용함
WITH TOPN_SAL AS (
    SELECT DEPT_CODE 부서코드, TRUNC(AVG(SALARY)) 평균급여
    FROM EMP
    GROUP BY DEPT_CODE
    ORDER BY 2 DESC
)

SELECT ROWNUM, 부서코드, 평균급여
FROM TOPN_SAL
WHERE ROWNUM <= 3
;

/*
    <RANK 함수>
    표현법
        RANK() OVER(정렬 기준) / DENSE_RANK() OVER(정렬 기준) 
        - 동일한 값인 경우 동일한 순번을 부여
        - 동일한 순위 이후 동일한 갯수만큼 건너 뛰고 순위를 부여
        - 정렬 기준을 더 상세히 설정해서 순위를 구분할 수도 있다. 
*/
SELECT RANK() OVER (ORDER BY SALARY DESC) AS RN, EMP_NAME, SALARY   -- RN이 19,19,21로 출력 : 2개만큼 건너뛰기 (19+2=21)
FROM EMP    
;
SELECT DENSE_RANK() OVER (ORDER BY SALARY DESC, EMP_NAME) AS RN, EMP_NAME, SALARY     -- RN이 19,19,20로 출력
FROM EMP                                            -- -> DENSE_RANK() : 동일한 순위 이후의 등수는 무조건 1씩 증가
;

SELECT RANK() OVER (ORDER BY SALARY DESC) AS RN
        , DENSE_RANK() OVER (ORDER BY SALARY DESC) AS DRN
        , EMP_NAME, SALARY
FROM EMP
-- RANK함수는 WHERE에서 쓸 수 없기 때문에 조건 설정이 필요한 경우 서브쿼리에 담는다.
-- WHERE RANK() OVER (ORDER BY SALARY DESC) <= 3;
;

SELECT *
FROM ( SELECT RANK() OVER (ORDER BY SALARY DESC) AS RN
                , DENSE_RANK() OVER (ORDER BY SALARY DESC) AS DRN
                , EMP_NAME, SALARY
        FROM EMP )
WHERE RN <= 3
;

/*
    상관 쿼리
    메인쿼리의 컬럼 중 하나가 안쪽 서브쿼리의 조건에 이용
    IN, NOT IN, EXISTS, NOT EXISTS
    
    세미 조인 : 서브쿼리의 대상만 선택하여 데이터를 추출  IN, EXISTS
    안티 조인 : 메인쿼리의 대상만 선택하여 데이터를 추출  NOT IN, NOT EXISTS
*/

SELECT *
FROM DEPT
WHERE NOT EXISTS (
                SELECT * 
                FROM EMP
                WHERE DEPT.DEPT_ID = EMP.DEPT_CODE      --> 이 조건만 맞으면 출력된다
)            
;   --> 사원을 배정 받지 못한 부서 3개


SELECT *
FROM EMP
WHERE NOT EXISTS (
                SELECT 1       --> 사실 이 서브쿼리의 SELECT절에서는 뭘 조회하든 상관없다
                FROM DEPT
                WHERE DEPT.DEPT_ID = EMP.DEPT_CODE      --> 이 조건만 맞으면 출력된다
)            
;   --> 부서를 배정 받지 못한 사원 2명

SELECT *
FROM EMP
WHERE EMP.DEPT_CODE NOT IN (
                SELECT DEPT.DEPT_ID 
                FROM DEPT
                WHERE DEPT.DEPT_ID = EMP.DEPT_CODE     
)            
;  

SELECT *
FROM EMP
WHERE DEPT_CODE IN (
                SELECT DEPT_ID 
                FROM DEPT
)            
;  












