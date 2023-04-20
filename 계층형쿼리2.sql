/*
    계층형 쿼리 
        노드(NODE): 계층형 쿼리를 이루고있는 항목
        루트 노드(ROOT): 계층형 트리구조의 최상위 노드
        리프 노드(LEAF): 하위노드가 없는 최하위 항목
        
        부모 노드: 트리구조의 상위에 있는 노드
        자식 노드: 트리구조의 하위에 있는 노드

        레벨(LEVEL): 루트노드의 레벨을 1로 시작하여 자식레벨로 넘어갈수록 1씩 증가된다.
*/
-- EMP_ID: 사원번호
-- MANAGER_ID: 사원을 관리하는 매니저의 사원번호
--    MANAGER_ID가 NULL이면 매니저가 배정되지않음을 뜻함  
SELECT MANAGER_ID 매니저번호, EMP_ID 사원번호, EMP_NAME 사원명
--          LEVEL을 이용해 들여쓰기
        , LPAD('---', 3*(LEVEL-1)) || EMP_NAME 사원계층
        , LPAD('---', 3*(LEVEL-1)) || DEPT_TITLE 부서계층
        , CONNECT_BY_ROOT DEPT_TITLE 최상위부서
        , SYS_CONNECT_BY_PATH(EMP_NAME,'>') 계층정보
--          리프노드면 1, 아니면 0
        , CONNECT_BY_ISLEAF 리프여부
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
-- 1. 루트노드의 조건 또는 값을 지정
START WITH MANAGER_ID IS NULL
-- 2. 계층 관계를 명시
--          PRIOR (상위노드의) 컬럼명 = (하위노드의) 컬럼명
CONNECT BY PRIOR EMP_ID = MANAGER_ID
;

-- MENU 테이블 생성
CREATE TABLE MENU(
    MENU_ID VARCHAR2(50 BYTE) PRIMARY KEY
    , UP_MENU_ID VARCHAR2(50 BYTE)
    , TITLE VARCHAR2(50 BYTE)
    , URL VARCHAR2(50 BYTE)
    , SORT NUMBER(2,0)
    , VISIBLE CHAR(1 BYTE)  -- 어드민이면 보여달라고 할 예정
);
-- M01 / M01_01 / M01_01_01
INSERT ALL
    INTO MENU VALUES ('M01', '', '대메뉴1', 'M1.com', 1, '')
    INTO MENU VALUES ('M02', '', '대메뉴2', 'M2.com', 1, '')
    INTO MENU VALUES ('M03', '', '대메뉴2', 'M3.com', 1, '')
SELECT * FROM DUAL
;

INSERT ALL
    INTO MENU VALUES ('M01_01', 'M01', '중메뉴1', 'M1-1.com', '', '')
    INTO MENU VALUES ('M02_01', 'M02', '중메뉴1', 'M2-1.com', '', '')
    INTO MENU VALUES ('M02_02', 'M02', '중메뉴2', 'M2-2.com', '', '')
    INTO MENU VALUES ('M03_01', 'M03', '중메뉴1', 'M3-1.com', '', '')
    INTO MENU VALUES ('M03_02', 'M03', '중메뉴2', 'M3-2.com', '', '')
    INTO MENU VALUES ('M03_03', 'M03', '중메뉴3', 'M3-3.com', '', '')
SELECT * FROM DUAL
;

SELECT * FROM MENU;

INSERT ALL
    INTO MENU VALUES ('M01_01_01', 'M01_01', '소메뉴1', 'M1-1-1.com', '', '')
    INTO MENU VALUES ('M02_01_01', 'M02_01', '소메뉴1', 'M2-1-1.com', '', '')
    INTO MENU VALUES ('M02_01_02', 'M02_01', '소메뉴2', 'M2-1-2.com', '', '')
    INTO MENU VALUES ('M03_01_01', 'M03_01', '소메뉴1', 'M3-1-1.com', '', '')
    INTO MENU VALUES ('M03_01_02', 'M03_01', '소메뉴2', 'M3-1-2.com', '', '')
    INTO MENU VALUES ('M03_01_03', 'M03_01', '소메뉴3', 'M3-1-3.com', '', '')
SELECT * FROM DUAL
;

-- 대메뉴2 > 중메뉴2 에 소메뉴1 만들기
INSERT INTO MENU (MENU_ID, UP_MENU_ID, TITLE) 
    VALUES ('M02_02_01', 'M02_02', '소메뉴1') ;

-- MENU_ID가 'M03'인 컬럼의 TITLE을 '대메뉴3'로 수정
UPDATE MENU SET TITLE = '대메뉴3' WHERE MENU_ID = 'M03' ;

SELECT LEVEL, MENU_ID 하위메뉴, UP_MENU_ID 상위메뉴
        , LPAD('-----', 5*(LEVEL-1)) || TITLE  메뉴이름
FROM MENU
START WITH UP_MENU_ID IS NULL
CONNECT BY PRIOR MENU_ID = UP_MENU_ID
;

-- ※ 지금은 하나의 세션에서 실습 중이기에 상관없지만,
-- 추후 실제 데이터를 이용할 경우에는 꼭 COMMIT을 해줘야 반영된 결과를 조회할 수 있다.
--DROP TABLE MENU;








