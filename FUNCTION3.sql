/*
    [��¥ ���� �Լ�]
    1) sysdate
    - ���� ��¥�� �ð��� ��ȯ
*/
    select sysdate from dual;
/*
    2) months_between(date1, date2)
    - �Է� ���� �� ��¥ ������ �������� ��ȯ (date1 - date2)
    - ������� number Ÿ������ ��ȯ
*/

    select months_between(sysdate, add_months(sysdate, 4)) from dual;
    select months_between(add_months(sysdate, 4), sysdate)from dual;

/*
    3) add_months(date, number)
    - Ư�� ��¥�� �Է� ���� ���ڸ�ŭ�� �������� ���� ��¥�� ��ȯ
    - ��� ���� date Ÿ��
*/
    select add_months(sysdate, 4) from dual;

select emp_name �̸�, HIRE_DATE �Ի���
, to_char(months_between(sysdate, HIRE_DATE), 999) �ٹ�������to_char
, floor(months_between(sysdate, HIRE_DATE)) �ٹ�������floor
, ceil(months_between(sysdate, HIRE_DATE)) �ٹ�������ceil
from emp
order by months_between(sysdate, HIRE_DATE) desc;

/*
    4)next_day(date, ����(����|����))
    - Ư�� ��¥���� ���Ϸ��� ������ ���� ����� ��¥�� ��ȯ
    - ������� date Ÿ��
*/
    select sysdate, next_day(sysdate, 3), next_day(sysdate, '��')
    from dual;
    -- 1: ��, 2: ��, 3: ȭ, 4: ��, 5: ��, 6: ��, 7: ��
    
    -- ��� ������ ���� ���� �߻� ����
    select next_day(sysdate, 'sunday') from dual;
  
/*
    NLS : ������ ��� ����
    - ��� ���� ���� ���� ������ Ȯ�� �� ����
*/
    select * from nls_session_parameters;
    
    alter SESSION SET nls_language = american; -- ���� ��� ����
    alter SESSION SET NLS_CURRENCY = '��'; -- ȭ�� ���� ����
    
    alter SESSION SET nls_language = korean;
    
    alter SESSION SET nls_date_format = 'yyyy-mm-dd hh24:mi:ss';
    alter SESSION SET nls_date_format = 'yyyy/mm/dd';
    select sysdate from dual;
    
/*
    5)last_day(date)
    - �ش� ���� ������ ��¥�� ��ȯ
    - ������� date Ÿ��
*/    
    select sysdate, last_day(sysdate) from dual;

/*
    6)extract(year|month|day from date)
    - Ư�� ��¥���� ��,��,�� ������ �����Ͽ� ��ȯ
    - ������� number Ÿ��
*/
    select EXTRACT(year from sysdate), extract(month from sysdate)
    ,extract(day from sysdate) from dual;

-- Ȯ�� ����

select emp_name �̸�, extract(year from HIRE_DATE) �Ի�⵵
, extract(month from HIRE_DATE) �Ի��, extract(day from HIRE_DATE) �Ի��� 
from emp
where extract(year from hire_date) = 1998;

-- Ȯ�� ����
select EMPLOYEE_ID �����ȣ, EMP_NAME �����, HIRE_DATE �Ի���
, floor(months_between(sysdate, hire_date)/12)||'��' �ټӳ��
from emp
where floor(months_between(sysdate, hire_date)/12) >= 20
order by floor(months_between(sysdate, hire_date)/12) desc;

/*
    7)round(date, year|month|day)
    - �ݿø��� ��¥�� ��ȯ
*/
    select sysdate, round(sysdate, 'year')
    , round(sysdate, 'month'), round(sysdate, 'day')
    , round(to_date(20230620), 'month')round -- �ݿø�ó��
    , trunc(to_date(20230620), 'month')trunc -- ����ó��
    from dual;

/*
    8)trunc(date, year|month|day)
    - �߶󳽣������� ��¥�� ��ȯ
*/
    select sysdate, trunc(sysdate, 'year')
    , trunc(sysdate, 'month'), trunc(sysdate, 'day')
    from dual;






