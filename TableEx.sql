-- ���ǻ�鿡 ���� �����͸� ��� ���� ���ǻ� ���̺�(TB_PUBLISHER)
/*
 1) �÷� : PUB_NO(���ǻ� ��ȣ) *unique, not null
          PUB_NAME(���ǻ� �̸�) *not null
          PHONE(���ǻ� ��ȭ��ȣ) *�������� ����
*/

create table tb_publisher(
    PUB_NO number unique not null,
    PUB_NAME varchar2(100) not null,
    PHONE varchar2(20),
    CLOSE char(1) default 'n',
    CONSTRAINT closeCheck check(close in ('y','n'))
);


insert into tb_publisher values (2, '�ó���', '010-5678-xxxx', default);

select * from tb_publisher;

UPDATE tb_publisher
set phone = '031-000-0000'
where pub_no =2;

SELECT count(*)
from tb_publisher
where tb_publisher.pub_no = 2;

select * 
from tb_publisher
-- ���� order by �÷��� [asc/desc] 
order by pub_no desc;

select * from tb_publisher;

insert into tb_publisher (PUB_NO, PUB_NAME) values (3, 'test');

-- �Էµ� ������ ��ȸ�ϱ�
select *
from tb_publisher
where PUB_NO = 3;

-- Ŀ��Ʈ(�޸�) �Է��ϱ�
comment on column tb_publisher.PUB_NO is '���ǻ� ��ȣ';
comment on column tb_publisher.PUB_NAME is '���ǻ� �̸�';
comment on column tb_publisher.PHONE is '���ǻ� ��ȭ��ȣ';

select * from tb_publisher;

update tb_publisher
set tb_publisher.phone = '010-2222-3333'
where pub_no = '3';

select * from tb_publisher;

commit;

-- ������ �ۼ��ϴ� ��ɹ��� ��/�ҹ��� ���������, values ���� �����ϹǷ� �����ؼ� ���� ! 

-- �����ϱ� /* from�� ���� ������ */
delete from tb_publisher
where pub_no = '3';

select * from tb_publisher;

-- ���� ����ϱ�
rollback;


select * from tb_publisher;











