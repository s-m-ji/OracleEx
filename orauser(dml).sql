/*
<DML(data manipulation language)>
    ������ ���� ���� ���̺� ���� ����(insert) ����(update) ����(delete)�ϴ� �����̴�.

    <insert>
    [ǥ����]
        1) insert into ���̺�� values (��, ��, ... ��);
            ���̺� �ִ� ��� �÷��� ���� �Է��� �� ���
        2) insert into ���̺��(�÷���, �÷���, ... �÷���) values(��,��, ... ��);
            ������ �÷��� ���� ���� �Է��� �� ���
            
    <update>
    [ǥ����]
        update ���̺��
        set �÷��� = �����Ϸ��� ��,
            �÷��� = �����Ϸ��� ��, ...
        [where ����];
        
    *** where���� �����ϰԵǸ� ���̺��� ��� ����  ����, �����ǹǷ�
    �� ���� �����͸� ó���Ϸ����� �� Ȯ���ؾ��Ѵ�... ���渶�̱�
        
    <where> ���ǹ�
    �÷��� = ã�� ��
        
*/
desc book;

insert into book values(5,'��ü�� �Բ� �ϴ� ��å2','�۰�2', 'n', sysdate, null); 

select * from book;

-- ����ڰ� å�� �뿩�� ��� isrent = y, editdate = ����ð���¥
-- 3�� å�� �뿩�Ѵٰ� �� ���?

update book
set isrent = 'n', editdate = sysdate
where no = 3;

-- ���� �����ϱ� ��, �������� ���� Ȯ�� �� ������ �����մϴ�.
select count(*)
from book
where no =3;

/*       
    <delete>
*/

