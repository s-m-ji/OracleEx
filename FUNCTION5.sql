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









