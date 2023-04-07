/*
<DML(data manipulation language)>
    데이터 조작 언어로 테이블에 값을 삽입(insert) 수정(update) 삭제(delete)하는 구문이다.

    <insert>
    [표현법]
        1) insert into 테이블명 values (값, 값, ... 값);
            테이블에 있는 모든 컬럼에 값을 입력할 때 사용
        2) insert into 테이블명(컬럼명, 컬럼명, ... 컬럼명) values(값,값, ... 값);
            선택한 컬럼에 대한 값만 입력할 때 사용
            
    <update>
    [표현법]
        update 테이블명
        set 컬럼명 = 변경하려는 값,
            컬럼명 = 변경하려는 값, ...
        [where 조건];
        
    *** where절을 생략하게되면 테이블의 모든 행이  수정, 삭제되므로
    몇 건의 데이터를 처리하려는지 꼭 확인해야한다... 어흑마이깟
        
    <where> 조건문
    컬럼명 = 찾는 값
        
*/
desc book;

insert into book values(5,'니체와 함께 하는 산책2','작가2', 'n', sysdate, null); 

select * from book;

-- 사용자가 책을 대여할 경우 isrent = y, editdate = 현재시간날짜
-- 3번 책을 대여한다고 할 경우?

update book
set isrent = 'n', editdate = sysdate
where no = 3;

-- 수정 삭제하기 전, 데이터의 수를 확인 후 쿼리를 실행합니다.
select count(*)
from book
where no =3;

/*       
    <delete>
*/

