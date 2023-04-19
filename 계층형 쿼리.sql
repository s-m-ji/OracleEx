/*  
    계층형 쿼리
        상위코드와 하위코드를 이용해서 TREE 형태로 조회
        E.G) 회사 조직도, 메뉴 등등
        
        MANAGER_ID : 매니저 사번
        ROOT NODE : 최상위 노드
        
        0. LEVEL
            계층 구조 쿼리의 수행 결과 DEPTH를 표현하는 의사컬럼 (ROOT=1)
                (의사컬럼: 테이블의 컬럼은 아니지만 컬럼처럼 동작)       
        1. 계층형 쿼리의 정렬
            ORDER SIBLINGS BY 컬럼명 (계층형 쿼리가 깨지지 않고 정렬)
        2. 최상위 노드 반환
            CONNECT_BY_ROOT 컬럼명
        3. 최하위 노드이면 1, 아니면 0
            CONNECT_BY_ISLEAF
        4. 계층형 쿼리에서 루트노드로 시작해 자신의 행까지 연결된 경로를 반환
            SYS_CONNECT_BY_PATH(컬럼명, '구분자')
*/

SELECT EMP_ID, MANAGER_ID, EMP_NAME, LEVEL
        , LPAD(' ', (LEVEL-1)*3) || EMP_NAME AS "계층구조"       -- ROOT를 제외한 하위계층부터 3칸씩 들여쓰기
        , CONNECT_BY_ROOT EMP_NAME AS "ROOTNAME"                -- 1DEPTH를 기준으로 ROOT의 이름을 표시
        , CONNECT_BY_ISLEAF AS "ISLEAF"                         -- 최하위노드면 1, 아니면 0
        , SYS_CONNECT_BY_PATH(EMP_NAME, '>') AS "INFO"          -- 계층형 쿼리에서 루트노드~자신까지 연결된 형태로 반환
FROM EMP
-- 루트 노드의 조건 또는 값 (기준은 내가 지정한다 !)                  
START WITH MANAGER_ID IS NULL
-- CONNECT BY PRIOR (상위 노드의)EMP_ID = (하위 노드의)MANAGER_ID     -- 내가 가진 EMP_ID를 MANAGER_ID로 쓰는 애들을 하위로 삼는다.
-- 계층 관계를 명시 
CONNECT BY PRIOR EMP_ID = MANAGER_ID
--ORDER BY EMP_NAME                                             -- 이렇게 일반적인 ORDER BY를 쓸 경우 계층 와르르멘션
ORDER SIBLINGS BY EMP_NAME                                      -- 각 레벨별로 순서 정렬해줌.
;

-- 
SELECT JOB_NAME
        , LPAD(' ', (LEVEL-1)*5) || JOB_NAME 계층구조
        , LPAD(' ', (LEVEL-1)*2.5) || DEPT_TITLE 계층구조2
        , SYS_CONNECT_BY_PATH(EMP_NAME, '> ')
FROM EMP, JOB, DEPT
WHERE EMP.JOB_CODE = JOB.JOB_CODE
AND DEPT_CODE = DEPT_ID
START WITH MANAGER_ID IS NULL
CONNECT BY PRIOR EMP_ID = MANAGER_ID
;









