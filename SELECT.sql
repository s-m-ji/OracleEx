/*
    select �÷�, �÷�, ...
    from   ���̺��
    
    - �����͸� ��ȸ�� �� ����ϴ� ����
    - SELECT ������ ���� ��ȸ�� ������� RESULT SET(��ȸ�� ����� ����)�̶�� �Ѵ�.
    - ��ȸ�ϰ����ϴ� �÷��� �ݵ�� ���̺� �����ϴ� �÷��̾���Ѵ�.
    
*/

-- ���̺��� ��ü �÷�, ��ü ���ڵ带 ��ȸ
select * from EMPLOYEES; 

-- EMPLOYEES ���̺��� ��ü ����� ���, �̸�, ������ ��ȸ
select EMPLOYEE_id, emp_name, salary
from EMPLOYEES;

/*
    <�÷� ���� ���� ��� ����>
    select ���� �÷��� �Է� �κп��� ��� ������ �̿��� ����� ��ȸ�� �� �ִ�.
    - �÷��� ��Ī�� ���� ������ ����� �״�� ���� e.g)salary*12
*/

-- ������ ���� ���ϱ�
select emp_name, salary ���޿�, salary*12 ���� 
from EMPLOYEES;

-- ��� ���� �� null���� ������ ��� ��� ������ ����� null�� �ȴ�.

-- ����((�޿�+(�޿�*���ʽ�))*12) *���ʽ��� ���� ��� null�� �Ǵ� ��!
select emp_name, salary ���޿�, salary*12 ����,
        (salary + (salary* commission_pct))*12 "���ʽ� ���Կ���"
from EMPLOYEES;

-- EMPLOYEES ���̺��� ������, �Ի���, �ٹ��ϼ�(���� ��¥ - �Ի���)
-- date ���ĳ����� ������ �����ϴ�
-- sysdate�� ���� ��¥�� ����Ѵ�

-- dual�� ����Ŭ���� �����ϴ� ���� ���̺�
SELECT sysdate from dual;

SELECT emp_name, HIRE_DATE, floor(sysdate-hire_date)
from EMPLOYEES;

/*
    <�÷��� ��Ī �����ϱ�>
    �÷��� as ��Ī / �÷��� ��Ī / �÷��� "��Ī"
    - ��� ���� �� �÷����� ������⶧���� ��Ī�� �ٿ��� ����ϰ� ó���Ѵ�
    - ������ ��: ���� �Ǵ� Ư�����ڰ� ���Ե� ��� " " �ֵ���ǥ�� �����ش�
*/

/*
    <DISTINCT>
    �ߺ� ����: �÷��� ���Ե� ���� �ѹ����� ǥ���ϰ��� �� ��
    select ���� �ѹ��� ����� �� �ִ�
*/

select DISTINCT job_id
from EMPLOYEES;

/*
    <���� ������> ||
    ���� �÷� ���� �ϳ��� �÷��� ��ó�� �����ϰų�,
    �÷��� ���ͷ�(�� ��ü)�� ������ �� �ִ�.
    
*/

-- "��� �̸��� ������ ���޿� �Դϴ�." ��� ���.
select emp_name || '�� ���޿��� ' || salary || '�Դϴ�.'
from EMPLOYEES;


/*
    <where��(������)>
    select �÷�, �÷�, ...
    from ���̺��
    where ���ǽ�;
    - ���̺��� �ش� ������ �����ϴ� ����� ��ȸ�ϰ����� �� ����Ѵ�
    - ���ǽĿ� �پ��� �����ڵ��� �̿��� �� �ִ�
    - ũ�� �� >, <, <=, >=
    - ���� �� =(����), !=, ^=, <>(���� �ʴ�) 
*/

-- employees ���̺��� �μ� �ڵ尡 100�� ��ġ�ϴ� ������� ��� �÷� ������ ��ȸ
select *
from employees
where DEPARTMENT_ID = 100;

-- employees ���̺��� �μ� �ڵ尡 90, 80, 50�� �ƴ� ������� ��� �÷� ������ ��ȸ
select *
from emp
where department_id != 90 and department_id <> 80 and department_id ^= 50; 

-- employees ���̺��� �޿��� 7000 �̻��� ������� �����, �μ��ڵ�, �޿��� ��ȸ
select emp_name, name_kor, department_id, salary
from emp
where salary >= 7000;

-- emp ���̺��� ������ 80,000 �̻��� ������ �̸�, �޿�, ����, �Ի����� ��ȸ
select emp_name "���� �̸�", name_kor "�ѱ� �̸�",  salary �޿�, salary*12 ����, HIRE_DATE �Ի��� 
from emp
where salary*12 >= 80000;

/*
    <�� ������>
    �������� ������ ���� �� ����Ѵ�
    and (�׸���) 
    or (�Ǵ�)
*/

-- emp���� �μ��ڵ尡 100�̰� �޿��� 8000�̻��� ����� �̸�, �μ��ڵ�, �޿��� ��ȸ
-- to_char(�����, ����) : ���ϴ� �������� ���� ����� �� �ִ�
select emp_name "name", 
        name_kor �̸�, 
        department_id "�μ� �ڵ�", 
        salary as �޿�, 
        to_char(salary*12,'99,999,999') as ����
from emp
where department_id = 100 and salary >= 8000;

-- �޿��� 8000���� ũ�� 10000������ ����� ���, �̸�, �޿��� ��ȸ
select EMPLOYEE_ID ���, emp_name �̸�, to_char(salary, '999,999') �޿�
from emp
-- where salary >= 8000 and salary <= 10000;
-- where salary BETWEEN 8000 and 10000;
where not salary BETWEEN 8000 and 10000;

/*
    <between and>
    where �񱳴���÷� between ���Ѱ� and ���Ѱ�
    - where������ ���Ǵ� �������� ������ ���� ������ ������ �� ���
    - �񱳴���÷��� ���Ѱ� �̻�, ���Ѱ� ������ ��쿡 ��ȸ
    
    <not>
    �ش� ������ �����ϰ� ��ȸ
*/

-- �Ի��� 98/01/01 ~ 99/12/31
-- ��� �÷��� ��ȸ �� �Ի��� ������ �������� ����
select * 
from emp
where hire_date between '98/01/01' and '99/12/31'
--order by employee_id desc;
order by hire_date;

/*
    <like>
    where �� ��� �÷� like 'Ư�� ����'
    - ���Ϸ��� �÷� ���� ������ Ư�� ������ ������ ���
    - ���� ���� : %, _
                 
    % : 0���� �̻�
    Ư�� ���ڿ��� �����ϰų� Ư�� ���ڿ��� ������ ���
    �÷��� like    '%on' : on���� ������ ���ڰ� �ִ� ���� ��ȸ
    �÷��� like    'on%' : on���� �����ϴ� ���ڰ� �ִ� ���� ��ȸ
    �÷��� like    '%on%' : on�� �����ϴ� ���ڰ� �ִ� ���� ��ȸ
                
     _ : 1����
    �÷��� like    '_����' : ���� �տ� �� ���ڰ� ���� ���� ��ȸ
    �÷��� like    '__����' : ���� �տ� �� ���ڰ� ���� ���� ��ȸ
*/


-- ������� D�� �����ϴ� ����� �޿�, �Ի����� ��ȸ
select emp_name, salary, hire_date
from emp
where emp_name like 'D%'
order by salary desc;

select emp_name, salary, hire_date
from emp
where emp_name like '%L__';

-- ��ȭ��ȣ 5��°�ڸ� ���ڰ� 4�� �����ϴ� ����� ���, �����, ��ȭ��ȣ�� ��ȸ
select employee_id, emp_name, PHONE_NUMBER
from emp
where PHONE_NUMBER like '____4%'
order by employee_id;

select * from emp;

-- �̸����� ��ȸ�ϴµ� @jungang.com ���ڸ� �߰��Ͽ� ���
select EMAIL || '@jungang.com'
from emp;

-- ��ȭ��ȣ ù 3�ڸ��� 515�� �ƴ� ���
select emp_name, phone_number
from emp
--where not phone_number like '515%'; * not�� ��,�� ��� ���� ������� ??
where phone_number not like '515%';

select *
from dept
--where DEPARTMENT_NAME like '�Ǽ�%';
where DEPARTMENT_NAME = '�Ǽ���';


/*
    <is null / is not null>
    where �񱳴���÷� is [not] null;
    - �÷� ���� null�� �ִ� ��� null�� �񱳿� ���ȴ�.
    is null : �÷��� null�� ��� 
    is not null : �÷��� null�� �ƴ� ���
*/

select *
from emp
where commission_pct is not null and department_id is null
order by commission_pct desc;
-- where commission_pct = null; �̰� Ʋ�� ���� ! 
-- ����Ŭ���� null�� �� �����ڷ� �� �� ����.

select department_id "��� ��ȣ", emp_name as �����
from emp
where MANAGER_ID is null;

select '���� �Ƶ��̶�� �ǽɵǴ� ' || name_kor || '(' || emp_name || ')' as "�μ� ��ġ(x), ���ʽ�(o)"
from emp
where DEPARTMENT_ID is null and commission_pct is not null;

/*
    <in>
    where �񱳴���÷� in ('��','��', ...);
    �� ��� �� ��ġ�ϴ� ���� ���� ��� ��ȸ
    or�� �����ؼ� �� ���� ����
*/

select count(*)
from emp
--where DEPARTMENT_ID in ('30','40','50');
where DEPARTMENT_ID in (30,40,50);
--where DEPARTMENT_ID = 30 
--    or DEPARTMENT_ID = 40
--    or DEPARTMENT_ID = 50;

/*
    <order by [asc|desc] [nulls first|nulls last]>
    ! ���� ���� �� ���� ���� ��Ű�� ������ ���� �߻� !
    
    select �÷�, �÷�
    from ���̺��
    [where ����]  ������ ������ ���� ����
    order by ���Ľ�ų �÷��� / ��Ī / �÷����� 
        asc     �������� : �⺻��
        desc    ��������
        nulls first     null���� �� ó������ ����
        nulls last      null���� �� ������ ���� : �⺻��`
*/

select commission_pct, emp_name �̸�, salary �޿�
from emp
where commission_pct is not null
--order by commission_pct nulls first;
-- Ŀ�̼� ��������, Ŀ�̼��� ������ �޿��� ��������
order by commission_pct, salary;












