-- create table test(col varchar2(10));
-- 테이블명 변경
RENAME EMPLOYEE TO EMP;
RENAME DEPARTMENT TO DEPT;

/*
    <JOIN>
    두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용하는 구문이다.
    
    1. 등가 조인(EQUAL JOIN) / 내부 조인(INNER JOIN)
    연결시키는 컬럼의 값이 일치하는 행들만 조인되어서 조회한다. 
    (일치하는 값이 없는 행은 조회X)
    
        1) 오라클 전용 구문
            SELECT 컬럼, 컬럼 ...
            FROM 테이블1, 테이블2
            WHERE 테이블1.컬럼명 = 테이블2.컬럼명;
            
            - FROM절에 조회하고자하는 컬럼들을 ,(콤마)로 구분하여 나열
            - WHERE절에 매칭 시킬 컬럼에 대한 조건을 제시

        2) ANSI 표준 구문
                 * ANSI 미국 국립 표준 협회(American National Standards Institute)
            SELECT 컬럼, 컬럼...
            FROM 테이블1
            [INNER] JOIN 테이블2 ON (테이블1.컬렴명 = 테이블2.컬럼명);
            [INNER] JOIN 테이블2 USING (컬럼명);
            
            -- FROM절에는 기준이 되는 테이블을 기술
            -- JOIN절에 같이 조회하고자 하는 테이블을 기술 후 조건을 명시
            -- 연결에 사용하려는 컬럼명이 같다면 ON절 대신 USING절 사용 가능
*/

-- 각 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT COUNT(*) FROM EMP; -- 총 23건
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMP;    -- DEPT_CODE

SELECT COUNT(*) FROM DEPT; -- 총 9건
SELECT DEPT_ID, DEPT_TITLE FROM DEPT;            -- DEPT_ID

-- 1) ========== 오라클 전용 구문 ==========================================

    -- 1. 연결할 컬럼명이 다른 경우
SELECT * FROM EMP, DEPT                         -- 콤마(,)로 테이블 여러개 나열
WHERE DEPT_CODE = DEPT_ID                       -- 총 21건 * -2건인 상태이므로 누락된 결과를 찾아가야함
;    
-- [INNER] JOIN : 조인 조건에 만족하는 값만 조회 (LIKE 교집합)
-- 앞에 아무것도 쓰지 않으면 기본이 INNER JOIN이다.

-- EMP(사원 테이블)에서 누락된 데이터 찾기
--  1) 차집합 이용 
--  전체 사원의 결과집합 - JOIN문의 결과집합 = 일치하지 않는 값 조회
SELECT * FROM EMP
    MINUS
SELECT EMP.*                                     -- EMP(사원 테이블)이 가진 모든 컬럼을 조회
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID;                      --  DEPT_CODE가 NULL인 사람이 2명 있었음

-- DEPT(부서 테이블)에서 사용되지 않은 부서코드 찾기
-- JOIN 결과 중복 제거
SELECT DISTINCT(DEPT_ID)                                  
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID;

SELECT * 
FROM DEPT 
WHERE DEPT_ID NOT IN (
    SELECT DISTINCT(DEPT_ID)                                  
    FROM EMP, DEPT
    WHERE DEPT_CODE = DEPT_ID
);                                              -- 사원이 배정되지 않은 부서 (D3,D4,D7)

SELECT * FROM EMP, DEPT                        
WHERE DEPT_CODE = DEPT_ID(+)                    -- LEFT OUTER JOIN : 왼쪽(DEPT_CODE)에 해당하는 값을 모두 찾고 싶다면 오른쪽에(+) 붙이기               
;

SELECT * FROM EMP, DEPT                        
WHERE DEPT_CODE(+) = DEPT_ID                   -- RIGHT OUTER JOIN : 오른쪽(DEPT_ID)에 해당하는 값을 모두 찾고 싶다면 왼쪽에(+) 붙이기               
;

-- * 오라클 문법에서는 FULL OUTER JOIN : 컬럼명(+) = 컬럼명(+) 은 지원해주지않음

    -- 2. 연결할 컬럼명이 같은 경우
    --  SELECT절에 쓰인 컬럼명이 어떤 테이블의 것인지 명시

-- 연습 문제
-- 각 사원들의 사번, 사원명, 직급 코드, 직급명을 조회
SELECT EMP_ID, EMP_NAME, EMP.JOB_CODE, JOB_NAME
FROM EMP
JOIN JOB ON (EMP.JOB_CODE = JOB.JOB_CODE);

-- 테이블에 별칭 줘서 조회하기
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME       
FROM EMP E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;
-- 테이블에 별칭을 사용한 경우 SELECT절 WHERE절에서는 별칭을 이용해서 접근해야한다. E.JOB_CODE (O), EMP.JOB_CODE (X)

SELECT * FROM EMP, JOB
WHERE EMP.JOB_CODE(+) = JOB.JOB_CODE;

-- ========== ANSI 표준 구문 ==========================================
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
JOIN DEPT ON (DEPT_ID = DEPT_CODE);

SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME         -- USING을 사용할 경우 테이블 이름 명시하면 안된다. E.JOB_CODE (X), EMP.JOB_CODE (X)
FROM EMP E
JOIN JOB USING (JOB_CODE);
-- USING절의 열 부분은 식별자를 가질 수 없음 / USING절에 사용된 컬럼은 테이블 이름을 앞에 붙일 수 없음

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMP E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE); 

-- EMP테이블과 JOB테이블을 조인하여 직급이 대리인 사원의
-- 사번, 사원명, 직급명, 급여를 조회

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY  
FROM EMP E, JOB J
--WHERE JOB_NAME = '대리';
WHERE E.JOB_CODE = 'J6';
-- 이것도 JOIN 조건이 없기 때문에 엉뚱한 값이 나오는겨 !

SELECT * FROM EMP, DEPT;        
-- 이렇게 JOIN 조건을 주지 않으면 사원 1명당 모든 부서와 연결지어서 결과집합을 보여주기때문에
--    23*9 = 207개의 값이 나온다. (카테시안 조인)

-- 오라클 구문으로 쓴 답 *******************
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
--AND JOB_NAME = '대리'; 이렇게 NAME으로 거르거나, 아래와 같이 CODE로 필터링하거나
AND EMP.JOB_CODE = 'J6';

-- ANSI 구문으로 쓴 답 *******************
SELECT EMP_ID, EMP_NAME, J.JOB_NAME, SALARY
FROM EMP E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
--WHERE J.JOB_NAME = '대리';
WHERE E.JOB_CODE = 'J6';

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMP
JOIN JOB USING (JOB_CODE)
--WHERE JOB_NAME = '대리';
WHERE JOB_CODE = 'J6';

/*
    2. 다중 JOIN
    여러개의 테이블을 조인하는 경우에 사용
    - ANSI 구문을 쓰는 경우에는 다중 조인 순서가 중요하다.
    - 오라클 구문에서는 FROM절에서 테이블이 명시되어있기 때문에 순서를 바꿔도 결과값에 영향을 받지 않는다.
*/
-- 사번, 사원명, 부서명, 지역명 조회
SELECT * FROM EMP;          -- DEPT_CODE
SELECT * FROM DEPT;         -- DEPT_ID  LOCATION_ID
SELECT * FROM LOCATION;     -- LOCAL_CODE

SELECT * FROM EMP, DEPT, LOCATION
WHERE DEPT_CODE = DEPT_ID           -- 컬럼명이 다르다면 앞에 테이블명을 명시하지않아도 괜츈
AND LOCATION_ID = LOCAL_CODE
;

-- 오라클 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMP, DEPT, LOCATION
--WHERE DEPT_CODE = DEPT_ID
--AND LOCATION_ID = LOCAL_CODE;
WHERE LOCATION_ID = LOCAL_CODE 
AND DEPT_CODE = DEPT_ID;

-- ANSI 구문
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);
--JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)       -- 이렇게 순서를 바꿀 경우 결과를 찾을 수 없어짐.
--JOIN DEPT ON (DEPT_CODE = DEPT_ID);


/*
    3. 외부 조인(OUTER JOIN)
    테이블 간 JOIN 시 조건에 일치하지않는 행도 모두 포함시켜서 조회
    기준이 되는 테이블을 지정해야한다.(LEFT/RIGHT/(+))
*/
-- 누락된 사원 2명을 모두 출력하고싶다면 ? EMP 테이블 값을 모두 출력하도록 함 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP, DEPT
WHERE EMP.DEPT_CODE = DEPT.DEPT_ID(+);

-- 1) LEFT [OUTER] JOIN 
--  : 두 테이블 중 왼쪽에 기술된 테이블 컬럼을 기준으로 JOIN을 진행
--      JOIN 조건을 일치하지않아도 모두 출력하겠다는 것
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
LEFT OUTER JOIN DEPT ON (DEPT_CODE = DEPT_ID);      
-- EMP를 모두 출력하고싶음
-- JOIN을 기준으로 LEFT/RIGHT 
-- JOIN 앞의 OUTER는 생략 가능함 (간결한 코드를 위해 생략해도 괜찮음)

-- 2) RIGHT [OUTER] JOIN 
--  : 두 테이블 중 오른쪽에 기술된 테이블 컬럼을 기준으로 JOIN을 진행
--      JOIN 조건을 일치하지않아도 모두 출력하겠다는 것
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
RIGHT JOIN DEPT ON (DEPT_CODE = DEPT_ID); 
-- DEPT를 모두 출력하고싶음

-- 사원명, 부서명, 급여 출력하되 부서테이블의 모든 데이터가 출력되도록... 
-- 오라클 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP, DEPT
WHERE EMP.DEPT_CODE(+) = DEPT.DEPT_ID;
-- ANSI 구문
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP
RIGHT JOIN DEPT ON (DEPT_CODE = DEPT_ID);

-- 3) FULL [OUTER] JOIN 
--  : 두 테이블에 기술된 테이블 컬럼을 기준으로 모두 출력되도록 JOIN을 진행
--      JOIN 조건을 일치하지않아도 모두 출력하겠다는 것
-- 조회 조건 만족한 21건 + EMP가 NULL인 2건 + 사원이 배정되지 않은 부서코드 3건 = 결과 총 26건 조회
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP
FULL JOIN DEPT ON (DEPT_CODE = DEPT_ID);






