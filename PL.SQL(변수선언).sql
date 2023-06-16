/* 
    <PL/SQL>
        오라클 자체에 내장되어 있는 절차적 언어로 SQL 문장 내에서 변수의 정의, 조건 처리(IF), 반복 처리(LOOP, FOR, WHILE) 등을 지원한다.
        (다수의 SQL 문을 순서대로 실행 할 수 있다)
        
        [PL/SQL의 구조]
            1) 선언부(DECLAER SECTION)
                DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분이다.
                생략가능
            2) 실행부(EXECUTABLE SECTION) 
                BEGIN로 시작, SQL 문, 제어문(조건, 반복문) 등의 로직을 기술하는 부분이다.
            3) 예외 처리부(EXCEPTION SECTION) 
                EXCEPTION로 시작, 예외 발생 시 해결하기 위한 구문을 기술하는 부분이다.
                생략가능

*/

SET SERVEROUTPUT ON;
-- 프로시저를 사용하여 출력하는 내용을 화면에 보여주도록 설정하는 환경 변수
-- 하나의 세션마다 적용되는 것이므로 오라클 접속 시/ 워크시트 변경 시 마다 설정해줘야한다. 

SET SERVEROUTPUT OFF;
-- 출력 기능 끄기

SET TIMING ON;
-- 블록 실행 시 총 소요시간 표시

-- 하나의 블록
    -- 선언부(생략가능)
    DECLARE
        -- 변수명 변수타입
        vi_num NUMBER;
        
    -- 실행부
    BEGIN
        vi_num := 100;
        -- 변수 선언 후 초기화하지 않으면 NULL값이 할당되어 아무것도 안 보인다.
        
        DBMS_OUTPUT.PUT_LINE('앙뇽항셍용!');
        -- 위에서 SET SERVEROUTPUT ON; 으로 환경설정을 해주지 않으면 출력되지 않는다.
        
        DBMS_OUTPUT.PUT_LINE('vi_num : ' || vi_num);
        DBMS_OUTPUT.PUT_LINE(VI_NUM);               
        -- 변수명을 소문자로 선언했으나, 실행부에서 대문자로 기입해도 실행은 된다
    
    -- 예외부(생략가능)
    END;
/    
-- / : 하나의 PL/SQL 문장의 끝을 의미하는 표시
-- 한 페이지에 여러 개의 PL/SQL 문장이 있는 경우 /를 이용해서 구분함

-- 오늘 만든 블록들은 이름이 없어서 익명이지만, 이름을 부여하면 프로시저/ 함수 등등으로 별도 저장할 수 있다. (테이블, 뷰와 같이)

DECLARE
--    PI CONSTANT NUMBER;    
    -- 상수는 선언과 동시에 초기화를 진행해야한다.
    PI CONSTANT NUMBER := 3.14;
    
BEGIN
    PI := 2.14;
    -- 상수는 값을 변경 할 수가 없다.
    
    DBMS_OUTPUT.PUT_LINE('PI : '||PI);
END;
/

/*
    변수 선언 : radius = 5, pi(상수) = 3.14
*/

DECLARE
   -- 변수 선언과 동시에 초기화 가능
   radius NUMBER := 5;
   -- 상수는 선언과 동시에 초기화 필수
   pi CONSTANT NUMBER := 3.14; 
BEGIN
    radius := 10;
    DBMS_OUTPUT.PUT_LINE('원의 둘레 : '|| pi * radius * 2);
END;
/

---------- 문제1) eid, ename을 변수로 선언하고 초기화하여 아래와 같이 출력
--    eid : 999
--    ename : 나예리


DECLARE
    eid NUMBER := 999;
    ename VARCHAR2(20) := '나예리';
BEGIN

-- SQL문을 이용하여 조회된 결과를 변수에 담기
    SELECT EMP_ID, EMP_NAME
    INTO eid, ename     
    FROM EMP
    WHERE EMP_ID = '200';

/* 1. 파라미터를 입력 받는 방법
    사번에 대한 데이터값 입력 창이 뜨고, 사용자로부터 입력 받은 값으로 변경 해줌
    WHERE EMP_ID = &사번;
    
    2. SELECT문의 조회 결과를 변수에 담는 방법
    SELECT 조회할 컬럼명, ...
    INTO 담을 변수명, ... 
        -- INTO절 사용 시 주의점 : 컬럼의 갯수, 타입에 맞게 변수를 설정
*/
-- & : 사용자로부터 입력받은 값으로 대체
    SELECT EMP_ID, EMP_NAME
    INTO eid, ename     
    FROM EMP
    WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('eid : '|| eid);
    DBMS_OUTPUT.PUT_LINE('ename : '|| ename);
END;
/

RENAME EMPLOYEE TO EMP;
RENAME DEPARTMENT TO DEPT;

SELECT EMP_ID, EMP_NAME
FROM EMP
WHERE EMP_ID = '200';


DECLARE
    eid EMP.EMP_ID%TYPE;
    ename EMP.EMP_NAME%TYPE;
BEGIN

-- SQL문을 이용하여 조회된 결과를 변수에 담기
    SELECT EMP_ID, EMP_NAME
    INTO eid, ename     
    FROM EMP
    WHERE EMP_ID = '200';

    DBMS_OUTPUT.PUT_LINE('eid : '|| eid);
    DBMS_OUTPUT.PUT_LINE('ename : '|| ename);
END;
/

/*
< PL/SQL 선언부(DECLAER SECTION) >
        변수 및 상수를 선언해 놓는 공간
        선언과 동시에 초기화도 가능
    
    < 변수 및 상수의 타입 >
        1) 일반 타입 변수 
            - SQL 타입 (NUMBER, CHAR, VARCHAR2, DATE 등)
        2) 레퍼런스 타입 변수 
            - PL/SQL 타입 (테이블의 컬럼타입을 참조)
        3) ROW 타입 변수
            - PL/SQL 타입 (하나의 테이블의 모든 컬럼의 값을 한꺼번에 저장할 수 있는 변수)
        
    1) 일반 타입 변수의 선언 및 초기화
            [표현법]
                변수명 [CONSTANT] 자료형(크기) [:= 값];
      자료형 : NUMBER, CHAR, VARCHAR2 등 SQL
      
      
    2) 레퍼런스 타입 변수 선언 및 초기화
        [표현법]
            변수명 테이블명.컬럼명%TYPE;
        
        - 변수의 타입을 지정하는데
            테이블의 컬럼의 데이터 타입을 참조하여 지정
*/

---------- 문제2) 사원명을 입력받아서 사번, 사원명, 급여정보를
-- 각각 eid, ename, sal 변수에 대입 후 출력

DECLARE 
    eid EMP.EMP_ID%TYPE; 
    ename EMP.EMP_NAME%TYPE;
--    sal EMP.SALARY%TYPE;
    sal VARCHAR2(50);   --> TO_CHAR를 쓰기 위해 문자 타입으로 지정
BEGIN
    SELECT EMP_ID, EMP_NAME, TO_CHAR(SALARY, 'L99,999,999')
    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_NAME = '&사원명';
    -- 입력값이 숫자일때는 상관없지만, 문자타입이면 ' '(홑따옴표)로 감싸줘야함당..
    
    DBMS_OUTPUT.PUT_LINE('eid : '||eid);
    DBMS_OUTPUT.PUT_LINE('ename : '||ename);
    DBMS_OUTPUT.PUT_LINE('sal : '||sal);
END;
/

SELECT EMP_ID, EMP_NAME, SALARY
--    INTO eid, ename, sal
    FROM EMP
    WHERE EMP_NAME = '박나라';


---------- 문제3) 위의 결과에서 JOB_NAME까지 같이 출력
DECLARE 
    eid EMP.EMP_ID%TYPE; 
    ename EMP.EMP_NAME%TYPE;
    sal EMP.SALARY%TYPE;
    jname JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, JOB_NAME
    INTO eid, ename, sal, jname
--    FROM EMP
--    JOIN JOB USING (JOB_CODE)
    FROM EMP, JOB
    WHERE EMP.JOB_CODE = JOB.JOB_CODE
    AND EMP_NAME = '&사원명';
    
    DBMS_OUTPUT.PUT_LINE('eid : '||eid);
    DBMS_OUTPUT.PUT_LINE('ename : '||ename);
    DBMS_OUTPUT.PUT_LINE('sal : '||sal);
    DBMS_OUTPUT.PUT_LINE('jname : '||jname);
END;
/
--> 변수명 지정 시 참조할 테이블과 명칭이 같게되면 조회해올 때 헷갈림 : 오류 발생

/*
        3) ROW 타입 변수 선언 및 초기화
            [표현법]
                변수명 테이블명%ROWTYPE;
                
            - 하나의 테이블의 여러 컬럼의 값을 한꺼번에 저장할 수 있는 변수를 의미한다.
            - 모든 컬럼을 조회하는 경우에 사용하기 편리하다.
             
            * ERROR : 테이블이름과 같은 변수명은 오류를 발생
            * 조회 시에는 변수명.컬럼명 으로 값을 가져옴
*/

DECLARE
    e EMP%ROWTYPE;
BEGIN
    SELECT * INTO e
    FROM EMP
    WHERE EMP_ID = 218;

    -- 변수명.컬럼명으로 접근 가능
    -- 테이블에 모든 값을 넣어두었기 때문에 ID, NAME 등등을 원하는 값을 모두 가져올 수 있음
    DBMS_OUTPUT.PUT_LINE('사번 : ' || e.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || e.EMP_NAME);
END;
/

-- 학생 백업 테이블 생성 (테이블의 구조만 복사)
CREATE TABLE TB_STUDENT_BK
AS SELECT * FROM TB_STUDENT WHERE 1 > 5;

SELECT * FROM TB_STUDENT_BK;
DROP TABLE TB_STUDENT_BK;

---------- 문제4) 
/*
    실습
    변수선언
        student_info : TB_STUDENT테이블의 모든 컬럼정보를 담고 있습니다
        
    1. 학번이 A213046인 학생의 정보를 조회하여 변수에 담기
    2. 학생의 정보를 TB_STUDENT_BK테이블에 입력
*/

DECLARE
    student_info TB_STUDENT%ROWTYPE;
BEGIN
    SELECT * INTO student_info
    FROM TB_STUDENT
    WHERE STUDENT_NO = 'A213046';
      
    INSERT INTO TB_STUDENT_BK VALUES student_info;
    
/*    INSERT INTO TB_STUDENT_BK VALUES ( student_info.STUDENT_NO
                                         student_info.STUDENT_NAME      
                                         ...   );
*/
    
--    DBMS_OUTPUT.PUT_LINE('STUDENT_NO : ' || student_info.STUDENT_NO);
--    DBMS_OUTPUT.PUT_LINE('STUDENT_NAME : ' || student_info.STUDENT_NAME);
--    DBMS_OUTPUT.PUT_LINE('STUDENT_ADDRESS : ' || student_info.STUDENT_ADDRESS);
    
    DBMS_OUTPUT.PUT_LINE('STUDENT_모든 정보 : ' || student_info."*");
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '건 처리되었습니다.');
END;
/

INSERT INTO TB_STUDENT_BK VALUES
    (
    SELECT * 
--    INTO student_info
    FROM TB_STUDENT
    WHERE STUDENT_NO = 'A213046');

