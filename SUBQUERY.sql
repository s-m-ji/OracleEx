/*
    <SUBQUERY>
    하나의 SQL문 안에 포함된 또 다른 SQL문을 뜻한다.
    메인 쿼리(기존 쿼리)를 보조하는 역할을 하는 쿼리문
*/

-- 노옹철 사원과 같은 부서원들을 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE EMP_NAME = '노옹철'
;

-- 서브쿼리는 () 괄호로 묶기
-- 비교값과 결과 타입이 일치해야한다

-- 서브쿼리를 수행한 결과 값의 행과 열 갯수에 따라 서브쿼리를 분류함

-- 1) 단일행 서브쿼리 : 서브쿼리 조회 결과 값의 행과 열 갯수가 1개
--      비교연산자 사용 가능 (=, !=, <>, ^=, <, >, <=, >=)
SELECT EMP_NAME, DEPT_CODE
FROM EMP
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMP
                    WHERE EMP_NAME = '노옹철'
    );

-- 1) 전 직원의 평균 급여보다 급여를 적게 받는 직원명, 직급코드, 급여를 조회
-- 전 직원의 평균 급여
SELECT ROUND(AVG(SALARY))
FROM EMP
;

SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMP
WHERE SALARY < (
                SELECT ROUND(AVG(SALARY))
                FROM EMP
        );

-- 2) 최저 급여를 받는 직원의 사번, 이름, 직급 코드, 급여, 입사일 조회
-- 최저 급여 조회
SELECT MIN(SALARY)
FROM EMP;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, HIRE_DATE
FROM EMP
WHERE SALARY = (
        SELECT MIN(SALARY)
        FROM EMP
    );

/*
    [쿼리 실행 순서]
    5. SELECT       조회할 컬럼
    1. FROM         테이블
    2. WHERE        조건식
    3. GROUP BY     그룹 기준
    4. HAVING       그룹 조건식
    6. ORDER BY     정렬 기준
*/




















