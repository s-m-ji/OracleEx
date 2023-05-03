/*
    <CURSOR> 
        특정 SQL문장의 처리결과집합을 담고 있는 영역을 가리키는 포인터
        커서를 이용하여 SQL문장의 처리결과집합에 접근 할 수 있다
        
    <묵시적 커서>
        오라클 내부에서 자동으로 생성되는 커서
        PL/SQL 블록에서 SQL문장이 실행 될때마다 자동으로 생성
        커서의 속성에 접근하여 여러가지 정보를 알 수 있다
        
        - 묵시적커서의 속성
            커서명%ISOPEN   : FALSE
            커서명%FOUND    : 결과 집합이 1개 이상인 경우
            커서명%NOTFOUND : 결과 집합이 0개인 경우
            커서명%ROWCOUNT : 최근 수행된 쿼리의 결과행 수
            
    <명시적 커서>
        사용자가 직접 정의하여 사용하는 커서
        SQL문장의 결과집합에 접근 하여 커서 사용 시 여러 행으로 나타난 처리 결과에 순차적으로 접근이 가능하다.
        
        커서선언(DECLARE)
            ↓
        커서열기(OPEN)
            ↓
        커서에서 데이터 가져오기(FATCH)    --  
            ↓                            ㅣ→ 반복  
        데이터처리 (데이터 입/출력 등등)                    --
            ↓
        커서닫기(CLOSE)
        
        [커서 속성]
            커서명%ISOPEN   : 커서가 OPEN 상태인 경우 TRUE, 아니면 FALSE
            커서명%FOUND    : 커서 영역에 남아있는 ROW 수가 한 개 이상일 경우 TRUE, 아니면 FALSE
            커서명%NOTFOUND : 커서 영역에 남아있는 ROW 수가 없다면 TURE, 아니면 FALSE
            커서명%ROWCOUNT : SQL 처리 결과로 얻어온 행(ROW)의 수
        
        [사용 방법]
            1) CURSOR 커서명 IS ..          : 커서 선언
            2) OPEN 커서명;                 : 커서 오픈
            3) FETCH 커서명 INTO 변수, ...   : 커서에서 데이터 추출(한 행씩 데이터를 가져온다.)
            4) CLOSE 커서명                 : 커서 닫기
        
        [표현법]
            CURSOR 커서명 IS [SELECT 문]
            
            OPEN 커서명;
            FETCH 커서명 INTO 변수;
            ...
            
            CLOSE 커서명;
*/

/*
    사원테이블에 등록된 사원의 사번과 이름을 출력하는 익명의 프로시저 (저장 X)
*/DECLARE
    -- 1. 커서 선언
    CURSOR C1 IS
    (
        SELECT
            EMP_ID,
            EMP_NAME
        FROM
            EMP
    );
                -- 변수 선언
    EID   EMP.EMP_ID%type;
    ENAME EMP.EMP_NAME%type;
BEGIN
    -- 2. 커서 오픈
 OPEN C1 ;
        LOOP
            -- 3. 패치 : 다음 행을 읽어서 변수에 담아준다.
            FETCH C1 INTO EID, ENAME;
            -- 4. 반복문을 탈출 ~~~~~
            --      커서 영역의 자료가 모두 FETCH되어 다음 영역이 존재하지 않으면 탈출
            EXIT WHEN C1%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
            DBMS_OUTPUT.PUT_LINE('사원명 : '||ENAME);
            
        END LOOP;
    -- 5. 커서 클로즈
    CLOSE C1;
END;
/

-- 급여가 3000000 이상인 사원의 사번, 이름, 급여를 출력
DECLARE
    CURSOR C2 IS
        (SELECT EMP_ID, EMP_NAME, SALARY
            FROM EMP
            WHERE SALARY >= 3000000);
    V_EID   EMP.EMP_ID%TYPE;
    V_ENAME EMP.EMP_NAME%TYPE;
    V_ESAL  EMP.SALARY%TYPE;
    V_CNT   NUMBER; 
    
BEGIN
    OPEN C2; 
        LOOP
            FETCH C2 INTO V_EID, V_ENAME, V_ESAL;
            EXIT WHEN C2%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(V_EID||' '|| V_ENAME ||' '||V_ESAL);       
            
        END LOOP;
    CLOSE C2;
    V_CNT := C2%ROWCOUNT;
--    DBMS_OUTPUT.PUT_LINE('총 '|| V_CNT || '건 조회 완료');
    DBMS_OUTPUT.PUT_LINE('총 '|| C2%ROWCOUNT || '건 조회 완료');
END;
/

-- 부서테이블에 전체 데이터를 조회 후 출력하는 프로시저 (저장 O)

-- 이름 PROC_CURSOR_DEPT 
-- V_DEPT DEPT 테이블의 모든 컬럼을 담기 
-- 커서 C1는 부서 테이블의 모든 정보를 조회 

CREATE OR REPLACE PROCEDURE PROC_CURSOR_DEPT
IS 
    V_DEPT  DEPT%ROWTYPE;
    CURSOR C1 IS
        SELECT * FROM DEPT;
BEGIN
    OPEN C1;
        LOOP
        -- TODO 다음의 변수를 한번에 다 조회해올 수는 없을까?
            FETCH C1 INTO V_DEPT.DEPT_ID, V_DEPT.DEPT_TITLE, V_DEPT.LOCATION_ID;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(V_DEPT.DEPT_ID ||' '|| V_DEPT.DEPT_TITLE ||' '|| V_DEPT.LOCATION_ID);
        END LOOP;
    CLOSE C1;
END;
/
EXEC PROC_CURSOR_DEPT;

/*
    FOR IN LOOP를 이용한 커서 사용
        
        FOR ~ IN:
        CURSOR를 선언할 필요가 없으며,
        CURSOR의 OPEN, CLOSE, FETCH가 자동으로 관리됨.
        
        FOR 변수명 IN (쿼리)
        쿼리 결과집합으로부터 한 건씩 읽어 변수에 담아준다.    
*/

CREATE OR REPLACE PROCEDURE PROC_CURSOR_DET_TITLE
IS
--    V_DEPT    DEPT.DEPT_TITLE%TYPE;
    V_DEPT    DEPT%ROWTYPE;
    -- DEPT의 전체 행을 조회해오는거라 수정했음.
BEGIN
--    FOR V_DEPT IN (SELECT * FROM DEPT)
    FOR V_DEPT IN (SELECT DEPT_TITLE FROM DEPT)
    LOOP
--        DBMS_OUTPUT.PUT_LINE(V_DEPT.DEPT_TITLE);
        DBMS_OUTPUT.PUT_LINE(V_DEPT.DEPT_ID||' - '||V_DEPT.DEPT_TITLE);
    END LOOP;
END;
/
EXEC PROC_CURSOR_DET_TITLE;

-- 사원의 사번, 이름, 부서명 출력 (레코드 타입을 선언 / 혹은 변수를 3개 선언)
CREATE OR REPLACE PROCEDURE PROC_EMP_INFO
IS
    TYPE E_RECORD_T IS RECORD(
        EID         EMP.EMP_ID%TYPE    
        EID         EMP.EMP_ID%TYPE    
        , ENAME     EMP.EMP_NAME%TYPE    
        , DTITLE    DEPT.DEPT_TITLE%TYPE    
    );
    -- 레코드를 변수의 타입으로 지정 : 그럼 여기서는 3가지를 갖게됨 
    V_INFO  E_RECORD_T;
BEGIN
    FOR V_INFO IN( SELECT EMP_ID, EMP_NAME, DEPT_TITLE
                    FROM EMP E, DEPT D
                    WHERE E.DEPT_CODE = D.DEPT_ID(+))
    LOOP
        DBMS_OUTPUT.PUT_LINE(V_INFO.EMP_ID||' '||V_INFO.EMP_NAME||' '||V_INFO.DEPT_TITLE);
    END LOOP;
END;
/
EXEC PROC_EMP_INFO;

-- TRIGGER
























