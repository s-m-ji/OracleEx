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
--  : 두 테이블 중 왼쪽에 기술된 테이블 컬럼 수를 기준으로 JOIN을 진행
--      JOIN 조건을 일치하지않아도 모두 출력하겠다는 것
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMP
LEFT OUTER JOIN DEPT ON (DEPT_CODE = DEPT_ID);      
-- EMP를 모두 출력하고싶음
-- JOIN을 기준으로 LEFT/RIGHT 
-- JOIN 앞의 OUTER는 생략 가능함 (간결한 코드를 위해 생략해도 괜찮음)

-- 2) RIGHT [OUTER] JOIN 
--  : 두 테이블 중 오른쪽에 기술된 테이블 컬럼 수를 기준으로 JOIN을 진행
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
--  : 두 테이블의 모든 행을 기준으로 모두 출력되도록 JOIN을 진행
--      JOIN 조건을 일치하지않아도 모두 출력하겠다는 것
-- 조회 조건 만족한 21건 + EMP가 NULL인 2건 + 사원이 배정되지 않은 부서코드 3건 = 결과 총 26건 조회
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM EMP
FULL JOIN DEPT ON (DEPT_CODE = DEPT_ID);

SELECT DEPT_ID 부서코드, DEPT_TITLE 부서명, L.LOCAL_CODE 지역코드, LOCAL_NAME 지역명 
FROM DEPT D
JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE);

SELECT DEPT_ID 부서코드2, DEPT_TITLE 부서명2, L.LOCAL_CODE 지역코드2, LOCAL_NAME 지역명2
FROM DEPT D, LOCATION L
WHERE LOCATION_ID = LOCAL_CODE;
--WHERE LOCATION_ID = LOCAL_CODE(+);

/*
    4. 카테시안 곱(CATESIAN PRODUCT) 교차 조인(CROSS JOIN)
    조인되는 모든 테이블의 각 행들이 서로서로 모두 매핑된 데이터가 검색된다.
    테이블의 행들이 모두 곱해진 행들의 조합이 출력 -> 과부화 위험 有
*/

SELECT COUNT(*) FROM EMP;   -- 사원 23명
SELECT COUNT(*) FROM DEPT;   -- 9개 부서

SELECT EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE 
FROM EMP, DEPT
ORDER BY EMP_ID;       
-- 조회 결과 23 * 9 = 207 건
-- 별다른 조건을 명시하지 않았기 때문에 
-- 한 명의 사원이 각기 다른 부서와 연결되어 9번씩 조회되는 것을 볼 수 있음.

SELECT COUNT(*) 
--SELECT EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE 
FROM EMP
CROSS JOIN DEPT
ORDER BY EMP_ID;

/*
    5. 비등가 조인(NON EQUAL JOIN)
    조인 조건에 등호(=)를 사용하지 않는 조인문을 비등가 조인이라고 한다.
    지정한 컬럼 값이 일치하는 경우가 아닌,
    값의 범위에 포함되는 행들을 연결하는 방식이다.
    (= 이외에 비교 연산자 >, <, >=, <=, BETWEEN AND, IN, NOT IN 등을 사용)
    ANSI 구문으로는 JOIN ON 구문만 사용 가능(USING 사용 불가)
*/
-- 급여 등급 테이블 생성
CREATE TABLE SAL_GRADE (
    SAL_LEVEL CHAR(2 BYTE)
    , MIN_SAL NUMBER
    , MAX_SAL NUMBER
);
COMMENT ON COLUMN SAL_GRADE.SAL_LEVEL IS '급여등급';
COMMENT ON COLUMN SAL_GRADE.MIN_SAL IS '최소급여';
COMMENT ON COLUMN SAL_GRADE.MAX_SAL IS '최대급여';
COMMENT ON TABLE SAL_GRADE IS '급여등급';

INSERT INTO SAL_GRADE VALUES ('S1',6000000,1000000);
INSERT INTO SAL_GRADE VALUES ('S2',5000000,5999999);
INSERT INTO SAL_GRADE VALUES ('S3',4000000,4999999);
INSERT INTO SAL_GRADE VALUES ('S4',3000000,3999999);
INSERT INTO SAL_GRADE VALUES ('S5',2000000,2999999);
INSERT INTO SAL_GRADE VALUES ('S6',1000000,1999999);

SELECT EMP_NAME, TO_CHAR(SALARY,'L999,999,999'), SAL_LEVEL
FROM EMP E, SAL_GRADE S
--WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL
WHERE MIN_SAL < SALARY
AND SALARY < MAX_SAL
ORDER BY EMP_ID
;

UPDATE SAL_GRADE SET MAX_SAL = 3500000 WHERE SAL_LEVEL = 'S5';
UPDATE SAL_GRADE SET MAX_SAL = 2999999 WHERE SAL_LEVEL = 'S5';
-- 범위를 겹치게 줄 경우 당연히 값이 중복되어 나온다. (유재식 3,400,000은 레벨 S4,S5 둘 다 포함됨)
SELECT * FROM SAL_GRADE;

SELECT EMP_NAME, TO_CHAR(SALARY,'L999,999,999'), SAL_LEVEL
FROM EMP
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL)
;

SELECT * FROM SAL_GRADE;

/*
    6. 자체 조인(SELF JOIN)
    같은 테이블을 다시 한번 조인하는 경우에 사용한다.
    -- SELECT절에 쓰인 모든 컬럼명에 테이블을 명시해야한다.
*/
-- MANAGER_ID : 매니저 사번
SELECT E.EMP_ID 사번, E.EMP_NAME 사원명, E.DEPT_CODE 부서코드, E.MANAGER_ID 매니저코드
    , M.EMP_ID 매니저사번 , M.EMP_NAME 매니저명
FROM EMP E, EMP M
WHERE E.MANAGER_ID = M.EMP_ID(+);   -- 매니저사번 모두 조회하기 위함


-- 연습문제를 풀어봅시당
-- 보너스를 받는 사원의 사번, 사원명, 보너스, 부서명 조회
SELECT EMP_ID 사번, EMP_NAME 사원명, BONUS 보너스, DEPT_TITLE 부서명
FROM EMP, DEPT
WHERE BONUS IS NOT NULL
AND DEPT_CODE = DEPT_ID;

SELECT EMP_ID 사번, EMP_NAME 사원명, BONUS 보너스, DEPT_TITLE 부서명
FROM EMP
--JOIN DEPT ON (DEPT_CODE = DEPT_ID AND BONUS > 0);
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
AND BONUS IS NOT NULL;

-- 인사관리부가 아닌 사원의 사원명, 부서명, 급여 조회
SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, SALARY 급여
FROM EMP, DEPT
WHERE NVL(DEPT_TITLE, '부서없음') ^= '인사관리부'         
AND DEPT_CODE = DEPT_ID(+);
-- 부서 코드가 NULL인 사람도 인사관리부가 아니지 않나요..?
--> 기본적으로 NULL은 제외하고 반환/조회되기 때문에
--> 만약 NULL까지 포함하고싶다면 NVL()함수를 이용하거나, OR로 조건으로 추가해주면 된다.

SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, SALARY 급여
FROM EMP
--LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID AND DEPT_TITLE <> '인사관리부');
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE <> '인사관리부'
OR DEPT_TITLE IS NULL;   

SELECT EMP_NAME 사원명, DEPT_TITLE 부서명, SALARY 급여
FROM EMP
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
--WHERE DEPT_TITLE IS NULL OR DEPT_TITLE NOT IN ('인사관리부')
--WHERE NVL(DEPT_TITLE, '부서 없음') != '인사관리부' OR DEPT_TITLE NOT IN ('인사관리부')
WHERE DEPT_TITLE NOT IN ('인사관리부') AND NVL(DEPT_TITLE, '부서 없음') != '인사관리부' 
;

SELECT COUNT(*)
FROM EMP, DEPT
WHERE DEPT_TITLE = '인사관리부'
AND DEPT_CODE = DEPT_ID;

SELECT * FROM EMP;


-- 사번, 사원명, 부서명, 지역명, 국가명 조회
SELECT EMP_ID 사원, EMP_NAME 부서명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMP E, DEPT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE = N.NATIONAL_CODE(+);

SELECT EMP_ID 사원, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
FROM EMP E
LEFT JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
;

-- 사번, 사원명, 부서명, 지역명, 국가명, 급여등급 조회
SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명, SAL_LEVEL 급여등급
FROM EMP E, DEPT D, LOCATION L, NATIONAL N, SAL_GRADE S
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+)
AND L.NATIONAL_CODE = N.NATIONAL_CODE(+)
AND SALARY BETWEEN MIN_SAL AND MAX_SAL;     

SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명, SAL_LEVEL 급여등급
FROM EMP E
LEFT JOIN DEPT D ON (E.DEPT_CODE = D.DEPT_ID)
LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
LEFT JOIN SAL_GRADE S ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

SELECT E.EMP_ID 사번, E.EMP_NAME 사원명, E.DEPT_CODE 부서코드, E.MANAGER_ID 매니저코드, M.EMP_ID 매니저사번 , M.EMP_NAME 매니저명
FROM EMP E
    LEFT JOIN EMP M ON (E.MANAGER_ID = M.EMP_ID); 
--       JOIN EMP M ON (E.MANAGER_ID = M.EMP_ID(+));   -- ANSI에서 (+) 사용이 된다 어떤 경우엔 ^_^ 되나보다...
--  LEFT JOIN EMP M ON (E.MANAGER_ID = M.EMP_ID(+));   -- 게다가 이렇게 LEFT, (+) 동시에 적어도 된다 어떤 경우엔 ^_^ 되나보다...


-- 종합실습문제
-- 1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원의 사번, 사원명, 직급명, 부서명, 근무지역, 급여 조회

SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 근무지역, SALARY 급여
FROM EMP E, DEPT D, JOB J, LOCATION L
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND LOCATION_ID = LOCAL_CODE
AND JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%'
;

SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 근무지역, SALARY 급여
FROM EMP E
LEFT JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB B USING (JOB_CODE)
LEFT JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
WHERE JOB_NAME = '대리' AND LOCAL_NAME LIKE 'ASIA%'
;

-- 70년대생이면서 여자이고 성이 전 씨인 직원의 사원명, 주민번호, 부서명, 직급명 조회
SELECT EMP_NAME 사원명, EMP_NO 주민번호, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMP E
LEFT JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT JOIN JOB B USING (JOB_CODE)
WHERE EMP_NAME LIKE '전%'            -- 성이 전 씨  
AND (SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4')        -- 여자
AND SUBSTR(EMP_NO,1,2) LIKE '7%'    -- 70년대생
;

SELECT EMP_NAME 사원명, EMP_NO 주민번호, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMP E, JOB J, DEPT D
WHERE DEPT_CODE = DEPT_ID(+)            -- 
AND E.JOB_CODE = J.JOB_CODE             -- 모든 사원이 직급을 갖고있기에 (+)할 필요가 없었음
WHERE EMP_NAME LIKE '전%'              -- 성이 전 씨  
AND SUBSTR(EMP_NO,8,1) = '2' OR SUBSTR(EMP_NO,8,1) = '4'          
AND EMP_NO LIKE '7%'    -- 70년대생 방법1)
--AND SUBSTR(EMP_NO,1,1) = '7'    -- 70년대생 방법2)

-- TODO 만약 '-' 바로 뒷자리 숫자를 가져오라고 한다면 ???????????????????????
;

SELECT SUBSTR((TO_CHAR(SYSDATE, 'YYYY') - SUBSTR(EMP_NO,1,2)),3) FROM EMP;


-- 보너스를 받는 직원의 사원명, 보너스, 연봉, 부서명, 근무지역을 조회
-- 부서 코드가 없는 사람도 출력될 수 있게 OUTER JOIN 사용
-- 연봉 : 월급여 * 12 세자리 콤마로 표시
-- NULL은 ' '으로 치환

SELECT EMP_NAME 사원명, NVL(BONUS,0) 보너스, TO_CHAR(SALARY*12, '999,999,999') 연봉, NVL(DEPT_TITLE, ' ') 부서명, NVL(LOCAL_NAME, ' ') 근무지역
FROM EMP E 
LEFT OUTER JOIN DEPT D ON (DEPT_CODE = DEPT_ID)
LEFT OUTER JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE)
WHERE BONUS <> 0
ORDER BY EMP_NAME;

SELECT EMP_NAME 사원명, BONUS 보너스, TO_CHAR(SALARY*12, '999,999,999') 연봉, DEPT_TITLE 부서명, LOCAL_NAME 근무지역
FROM EMP E, DEPT D, LOCATION L
WHERE DEPT_CODE = DEPT_ID(+)            -- 일단 E.DEPT_CODE 에서 사원수를 모두 조회해야하기 때무넹 (+) 기입 
AND LOCATION_ID = LOCAL_CODE(+)         -- LOCATION_ID는 DEPT랑 연관이 되어있기 때문에 아래에도 (+) 마저 기입 ? 
AND BONUS IS NOT NULL
;

-- 한국과 일본에서 근무하는 직원의 사원명, 부서명, 근무지역, 근무국가를 조회
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMP E, DEPT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND NATIONAL_NAME IN ('한국' , '일본')
;

SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMP E
JOIN DEPT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
JOIN NATIONAL N USING (NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국' , '일본')
;

-- 각 부서별 평균 급여를 조회하여 부서명, 평균 급여(정수 처리)를 조회
-- 부서 배치가 안 된 사원의 평균도 같이 나오게끔 작성

SELECT NVL(DEPT_TITLE,'- 부서 없음 -') 부서명, TO_CHAR(ROUND(AVG(SALARY)),'999,999,999')평균급여 
FROM EMP, DEPT
--WHERE DEPT_CODE(+) = DEPT_ID
WHERE DEPT_CODE = DEPT_ID(+)
GROUP BY DEPT_TITLE
ORDER BY DEPT_TITLE
;

SELECT NVL(DEPT_TITLE,'- 부서 없음 -') 부서명, TO_CHAR(ROUND(AVG(SALARY)),'999,999,999')평균급여 
FROM EMP
LEFT JOIN DEPT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
ORDER BY 평균급여 DESC
;


-- 각 부서별 총 급여의 합이 1,000만원 이상인 부서명, 급여의 합 조회
SELECT DEPT_TITLE 부서명, TO_CHAR(SUM(SALARY),'L999,999,999') 급여합
FROM EMP, DEPT
WHERE DEPT_CODE = DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= '10000000'
ORDER BY 급여합
;
SELECT DEPT_TITLE 부서명, TO_CHAR(SUM(SALARY),'L99,999,999') 급여합
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) >= 10000000
ORDER BY 급여합 DESC
;

--
SELECT EMP_ID, EMP_NAME, JOB_NAME, 
    DECODE(SAL_LEVEL, 'S1','고급', 'S2','고급',
                      'S3','중급', 'S4','중급',  
                      'S5','초급', 'S6','초급', '그.사.세') 급여등급
FROM EMP
JOIN JOB ON (EMP.JOB_CODE = JOB.JOB_CODE)
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL)
;

SELECT EMP_ID 사번, EMP_NAME 사원명, JOB_NAME 직급명, SAL_LEVEL 급여등급,
    CASE WHEN SAL_LEVEL IN ('S1', 'S2') THEN '고급'
         WHEN SAL_LEVEL IN ('S3', 'S4') THEN '중급'
         WHEN SAL_LEVEL IN ('S5') THEN '초급'
         ELSE '그.사.세' END 구분
FROM EMP, JOB, SAL_GRADE
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND SALARY BETWEEN MIN_SAL AND MAX_SAL
ORDER BY EMP_ID
;

-- 보너스를 받지 않는 직원 중 직급 코드가 J4 또는 J7인 직원의 사원명, 직급명, 급여 조회
SELECT EMP_NAME, JOB_NAME, JOB_CODE, SALARY
FROM EMP
LEFT JOIN JOB USING (JOB_CODE)
WHERE BONUS IS NULL
AND JOB_CODE IN ('J4', 'J7')
;

SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND BONUS IS NULL
AND JOB.JOB_CODE IN ('J4', 'J7')
;

-- 부서가 있는 직원의 사원명, 직급명, 부서명, 근무지역
SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 근무지역
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
;

SELECT EMP_NAME 사원명, JOB_NAME 직급명, DEPT_TITLE 부서명, LOCAL_NAME 근무지역
FROM EMP, DEPT, JOB, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND EMP.JOB_CODE = JOB.JOB_CODE
AND LOCATION_ID = LOCAL_CODE
;

-- 해외영업팀에 근무하는 직원 중 2013-01-01 이후 입사자의 사원명, 직급명, 부서 코드, 부서명을 조회
SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM EMP E, JOB J, DEPT D
WHERE E.JOB_CODE = J.JOB_CODE
AND DEPT_CODE = DEPT_ID
AND DEPT_TITLE LIKE '해외영업%'
AND HIRE_DATE >= '20130101'
;
--AND HIRE_DATE >= '2013-01-01'     -- 날짜 형식이 여러가지니까요... DATE 타입으로 자동형변환 되기 때문에 상관없다.
--;

SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM EMP
JOIN JOB USING (JOB_CODE)
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_ID IN ('D5', 'D6', 'D7')
AND HIRE_DATE >= '13/01/01'
;

-- 이름에 '형'자가 들어있는 직원의 사번, 사원명, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMP, JOB
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND EMP_NAME LIKE '%형%'
;
-- 주로 게시글 조회 시 자주 사용된다. (~을 포함하고있는)
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMP
JOIN JOB USING (JOB_CODE)
WHERE EMP_NAME LIKE '%형%'
;


















