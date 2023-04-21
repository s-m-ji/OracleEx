/*
    <TCL (Transaction Control Language)>
        트랜잭션을 제어하는 언어
        
        * 트랜잭션
        - 하나의 논리적인 작업 단위
            예시) ATM에서 현금을 출금
                1. 카드 삽입
                2. 메뉴 선택
                3. 금액 확인 및 인증
                4. 계좌에서 금액 차감   -50000
                5. 현금 인출          +50000
                6. 종료
        - 각각의 작업들을 묶어서 하나의 작업 단위로 형성
        - 하나의 트랜잭션으로 이루어진 작업들은 반드시 한번에 완료가 되어야함
        - 그렇지 않으면 작업 취~소~~
        - 데이터의 변경사항(DML)을 묶어서 하나의 트랜잭션에 담아 처리한다.
            - 트랜잭션 제어 
            - COMMIT 트랜잭션 종료 처리 후 저장
            - ROLLBACK 트랜잭션 취소
            - SAVEPOINT 임시저장(한 위치로 이동)
*/

-- 사번, 사원명, 부서명
CREATE TABLE EMP_01 
  AS 
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE 
    FROM EMP 
   LEFT  JOIN DEPT ON (DEPT_CODE = DEPT_ID)
;
DROP TABLE EMP_01;

select * FROM EMP_01 ORDER BY EMP_ID;

-- 200번 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID  IN (200);

-- SAVEPOINT 지정
SAVEPOINT SP;

-- 201번 사원 삭제
DELETE FROM EMP_01 WHERE EMP_ID  IN (201);

-- SP 시점으로 돌아가기 : 201번 사원 삭제 전
ROLLBACK TO SP;

-- 예를 들어 데이터 삭제 후 테이블을 하나 생성하면?
-- DDL 구문을 실행하는 순간 기존 메모리 버퍼에 임시 저장된 변경사항이 DB에 커밋되면서
-- 데이터 삭제 전으로 롤백이 안된다..
























