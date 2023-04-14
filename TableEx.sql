-- 출판사들에 대한 데이터를 담기 위한 출판사 테이블(TB_PUBLISHER)
/*
 1) 컬럼 : PUB_NO(출판사 번호) *unique, not null
          PUB_NAME(출판사 이름) *not null
          PHONE(출판사 전화번호) *제약조건 없음
*/

create table tb_publisher(
    PUB_NO number unique not null,
    PUB_NAME varchar2(100) not null,
    PHONE varchar2(20),
    CLOSE char(1) default 'n',
    CONSTRAINT closeCheck check(close in ('y','n'))
);


insert into tb_publisher values (2, '시나공', '010-5678-xxxx', default);

select * from tb_publisher;

UPDATE tb_publisher
set phone = '031-000-0000'
where pub_no =2;

SELECT count(*)
from tb_publisher
where tb_publisher.pub_no = 2;

select * 
from tb_publisher
-- 정렬 order by 컬럼명 [asc/desc] 
order by pub_no desc;

select * from tb_publisher;

insert into tb_publisher (PUB_NO, PUB_NAME) values (3, 'test');

-- 입력된 데이터 조회하기
select *
from tb_publisher
where PUB_NO = 3;

-- 커멘트(메모) 입력하기
comment on column tb_publisher.PUB_NO is '출판사 번호';
comment on column tb_publisher.PUB_NAME is '출판사 이름';
comment on column tb_publisher.PHONE is '출판사 전화번호';

select * from tb_publisher;

update tb_publisher
set tb_publisher.phone = '010-2222-3333'
where pub_no = '3';

select * from tb_publisher;

commit;

-- 쿼리를 작성하는 명령문은 대/소문자 상관없지만, values 값은 구분하므로 유의해서 기입 ! 

-- 삭제하기 /* from은 생략 가능함 */
delete from tb_publisher
where pub_no = '3';

select * from tb_publisher;

-- 실행 취소하기
rollback;


select * from tb_publisher;











