/*
    ========== ========== [null ó�� �Լ�] ========== ==========
    1) nvl(�÷�, �÷����� null�̸� ��ȯ�� ��)
    - null�� �Ǿ��ִ� �÷��� ���� ���ڷ� ������ ������ �����Ͽ� ��ȯ
*/
-- null�� ������� �ʾƼ� 0���� ���� �� ����
select name_kor, nvl(commission_pct, 0)
from emp;

select emp_name �����, commission_pct Ŀ�̼�
, salary + (salary*nvl(commission_pct, 0))*12 ����
--, salary + (salary*commission_pct)*12 ���� -- null�� ����Ұ�
from emp;

-- ����Ÿ���� �÷��� ��� �Ű������� ���ڸ� �־������
-- Ÿ���� ���� �ʴ� ��� "��ġ�� �������մϴ�." ���� �߻�
-- ���ڸ� �Է��ϰ���� ��� to_char()�Լ� �̿��ؼ�
-- ���ڸ� ���ڷ� : charŸ������ ��ȯ �� nvl()�Լ� �̿�
select emp_name, DEPARTMENT_ID, nvl(to_char(DEPARTMENT_ID), '�μ� ����')
from emp;

select to_timestamp(sysdate) from dual;

/*
    2)nvl2(�÷�, ������ ��1, ������ ��2)
    - �÷��� null�� �ƴϸ� ������ ��1
                null�̸� ������ ��2
*/

-- emp ���̺��� Ŀ�̼��� ����ϴµ� ����Ǿ 0.1�� ǥ���Ѵٸ� ?

select name_kor, COMMISSION_PCT ����
    , nvl2(commission_pct, 0.1, 0) ����
    , salary + salary*nvl2(commission_pct, 0.1, 0) "���� �޿�"
    , (salary + (salary*nvl2(commission_pct, 0.1, 0)))*12 "���� ����"
from emp
order by "���� �޿�" desc;

-- ��������1)
select emp_name �̸�, salary �޿�,  nvl(commission_pct, 0) Ŀ�̼�
, (salary+(salary*nvl(commission_pct,0)))*12 ����
from emp
where (salary+(salary*nvl(commission_pct,0)))*12 >= 200000
order by ���� desc;

-- ��������2)
/*
    select '1111294045862' from dual;
    select '9511294045862' from dual;
    
    1900���� �ֹε�Ϲ�ȣ ���ڸ��� ù��° ���ڰ� 1,2
    2000���� �ֹε�Ϲ�ȣ ���ڸ��� ù��° ���ڰ� 3,4
    
    ���̸� ���ϱ� ���ؼ��� ����⵵�� �˾ƾ��� -> �ֹι�ȣ���� �⵵�� 2�ڸ��� ǥ����
*/

select to_char(sysdate ,'yyyy') - ('20'||substr('1111294045862',1,2))+1 ���� from dual;

    select to_char(sysdate, 'yyyy') - '20'||substr('1111294045862',1,2) from dual;
    -- ����� 200311�� ���� : ������ ���������� ����Ǳ� ������ 2023 - 20�� ���� ����
    
    select '���̴� ' || (to_char(sysdate, 'yyyy') - ('19'||substr('9511294045862',1,2))+1) || '�� �Դϴ�.' ���� from dual;

/*
    3) nullif(�񱳴��1, �񱳴��2)
    - �� ���� ���� �����ϸ� null�� ��ȯ
    - �� ���� ���� �������� ������ �񱳴��1�� ��ȯ
*/
    select nullif('���', '���') from dual;    -- null ��ȯ
    select nullif('���', '����Ƽ') from dual;  -- ��� ��ȯ






























