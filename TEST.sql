-- 04/11(ȭ)
select abs(-3) from dual; -- n�� ���밪 ��ȯ
select ceil(10.22) from dual; -- n�� ���ų� ���� ū ���� ��ȯ
select floor(10.22) from dual; -- n���� �۰ų� ���� ū ���� ��ȯ
select round(10.222,1) from dual; -- n�� �Ҽ��� ����(i+1)��°���� �ݿø��� ��� ��ȯ
select trunc(2.111111,3) from dual; -- n1�� �Ҽ��� ���� n2�ڸ����� �߶� ��� ��ȯ
select power(2,3) from dual; -- n2�� n1������ ����� ��ȯ (n2�� ������ n1�� �ݵ�� ����)
select sqrt(2) from dual; -- n�� ������ ��ȯ
select mod(3,2) from dual; -- n2�� n1���� ���� ������ ���� ��ȯ
select remainder(3,1) from dual; -- n2�� n1���� ���� ������ ���� ��ȯ
select exp(2) from dual;
select ln(2) from dual;
select log(10,100) from dual;
select initcap('hELLO wORLD') from dual;
select lower('hELLO wORLD') from dual;
select upper('hELLO wORLD') from dual;
select concat('��', '�̴���') from dual;
select substr('��Ͱ���',3,1) from dual;
select substrb('��Ͱ���',3,1) from dual;
select ltrim('�̷� ���񳯵���', '�̷�') from dual;
select rtrim('�� �Ϸ簭 ��ْD����', '����') from dual;
select rpad('�ʿ��ٸ�', 15, '*') from dual;
select lpad('��Ͱ���', 15, '*') from dual;
select replace('�̷���ģ������','��ģ','����') from dual;
select translate('�̷� ��ģ �̳� �̵� ����','��ģ','����') from dual;
select instr('�� �Ϸ簡 �Ǹ� ����','��', -1, 1) from dual;
select length('�ʿ��ٸ�') from dual; -- 4 ���
select lengthb('�ʿ��ٸ�') from dual; -- 8 ���
select sysdate from dual;
select systimestamp from dual;
select add_months(sysdate, 3) from dual;
select months_between(add_months(sysdate,3), sysdate) from dual;
select last_day(sysdate) from dual;
select round(sysdate, 'month') from dual;
select trunc(sysdate, 'month') from dual;
select next_day(sysdate, '�ݿ���') from dual;
select to_char(sysdate, 'yyyy-mm-dd') from dual;
select to_number('123456') from dual;
select to_date('20230411','yyyy-mm-dd') from dual;
select to_timestamp('20230411' ,'yyyy-mm-dd') from dual;



