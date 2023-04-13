/*
    ========== ========== [����ȯ �Լ�] ========== ==========
    
    1) to_char(��¥|����[, ����])
    - ��¥,���� Ÿ���� �����͸� ���� Ÿ������ ��ȯ �� char�� ��ȯ
    ---> ��¥ �Ǵ� ���ڸ� �������� �������� �� �ִ�.
*/
    -- ���� -> ����
    select to_char(1234) from dual;
    -- 6ĭ�� ������ Ȯ��, ������ ����, 9: ��ĭ�� ���� 
    select to_char(1234, '999999') from dual;
    -- 0 : �� ������ 0���� ä���ش�. ��9, ��0 �̷��� ��ӵȰ� ^_^
    select to_char(1234, '000000') from dual;
    -- ���� ������ ����(LOCAL)�� ȭ�� ������ ���
    select to_char(1234, 'L999,999') from dual;
    
select emp_name �̸�, to_char(SALARY, 'L999,999,999') �޿�
from emp;

    -- ��¥ -> ����
    -- YYYY : 4�ڸ� �⵵    YY : 2�ڸ� �⵵
    -- MM : ���� ���ڷ�     MON : ���� ���ڷ�
    -- DAY : ���� ǥ��      DY : ������ ��� 
    select sysdate from dual;
    select to_char(sysdate, 'yyyy/mm/dd') from dual;
    select to_char(sysdate, 'yy/mon/day') from dual;
    -- ���� �� ���� �ٸ��� ��Ÿ�� 23/apr/wednesday   23/4�� /������
    
    -- �Ͽ� ���� ����
    select to_char(sysdate,'ddd') -- �� �ظ� �������� ��ĥ°����
            ,to_char(sysdate, 'dd') -- �� ���� �������� ��ĥ°����
            ,to_char(sysdate, 'd') -- �� �ָ� �������� ��ĥ°����
    from dual;
    
--select emp_name �����, to_char(HIRE_DATE, 'yyyy-mm-dd(dy)') �Ի���
select emp_name �����, to_char(HIRE_DATE, 'yyyy"��"mm"��"dd"��"(dy)') �Ի��� 
-- ���� �ȿ� ���ڸ� �ְ� �ʹٸ� " " ó���ϸ� �ȴ� ~~~
from emp;
    
/*
    to_date(����|����[, ����])
    - ���� �Ǵ� ������ �����͸� �Է� �޾Ƽ� ��¥ Ÿ������ ��ȯ �� date�� ��ȯ
*/
    -- ���ڸ� ��¥��
    select to_date(20230412) from dual;
    select to_date(20230412114150) from dual; -- ��:��:�� ���� 
    
    -- ���ڸ� ��¥��    
    select to_date('20230412') from dual;    
    select to_date('20230412 114150') from dual;    
    select to_date('23/04/12', 'yy-mm-dd') from dual;    -- �տ��� '/'���� '-'�������� ǥ��
    
/*
    ��¥data + ���� : ���ڸ�ŭ ������ ��¥
    ��¥data - ���� : ���ڸ�ŭ ������ ��¥
    ��¥data - ��¥data : �� ��¥data �� �ϼ� ��
    ��¥data + ��¥data : ������������!!!
*/    
    -- 100�� ��
    select sysdate+100 "100�� ��" from dual;
    
    -- d-day(20230721)
    select floor(months_between(to_date('20230721'), sysdate)*30) "d-day" from dual;
    -- 30, 31 �ϼ� ���̰� �ֱ� ������ ����Ȯ�� �� ����
    select trunc(to_date('20230721') - sysdate) "d-day" from dual;
    select to_date('20230721') - trunc(sysdate) "d-day" from dual;
    select to_date('20230721') from dual; -- �ð����� ����ϱ⶧���� 99.12334 ��¼����ް��� ����
    --->>> trunc�� ��� ó���ϴ��Ŀ� ���� d-day �ϼ��� �޶����� ������ ��Ȯ�� ����� �� �ֵ��� ����!

    -- ���� ���� ����
    select trunc(sysdate-1) "����", trunc(sysdate) "����", trunc(sysdate+1) "����" from dual;

    -- ������ �̹��� ������
    select add_months(sysdate, -1)"������", sysdate "�̹���"
    ,add_months(sysdate, +1)"������"  from dual;
    
    -- �۳� ���� ����
     select add_months(sysdate, -12)"�۳�", sysdate "����"
    ,add_months(sysdate, +12)"����"  from dual;
    

select NAME_KOR "�̸�", to_char(HIRE_DATE,'yyyy/mm/dd') "�Ի���"
from emp
--where EXTRACT(year from HIRE_DATE) >= 2007;
--where HIRE_DATE >= '2007/01/01';
where HIRE_DATE >= '2007-01-01'; -- ���ڸ� ��¥�� �ڵ�����ȯ�Ͽ� �񱳿�������

select 123+'1234' from dual; 
-- ����, ���� ���� �� ���ڸ� ���ڷ� �ڵ�����ȯ
select 123+'1234A' from dual; 
-- ���ڿ� ���� ���� ���ڰ� �����־ �ڵ�����ȯ ���� �ʰ� ���� �߻� !
    
/*
    3) to_number(�÷�|���ڿ�[, ����])
    - ���� Ÿ���� �����͸� ���� Ÿ������ ��ȯ �� number�� ��ȯ
*/    
    select '12345', 12345 from dual; -- ���ڴ� ���� ����, ���ڴ� ������ ������ �⺻
    select '12345', to_number('12345') from dual;
    
    select '10,000,000' + '10,000,000' from dual; -- ���� + ���ڶ� ���� �߻�
    
    select to_number('10,000,000', '99,999,999')
            ,to_number('10,000,000', '99,999,999')
    from dual;



-- ���� �����ϴ� ����� ���� �پ��� ! �� �߿� ���� ȿ������ ������� ����ϸ� �ǰ�����
select CUST_NAME �̸�, CUST_YEAR_OF_BIRTH ����⵵
    , months_between(trunc(sysdate,'month')
        , to_date(CUST_YEAR_OF_BIRTH,'yyyy'))/12+1 ����trunc
        
    , to_char(sysdate, 'yyyy') - CUST_YEAR_OF_BIRTH +1 ����tochar
    
    , floor(months_between(sysdate, to_date(CUST_YEAR_OF_BIRTH, 'yyyy'))/12)+1 ����months
    
    , extract(year from sysdate) - CUST_YEAR_OF_BIRTH ����extract
    
    , trunc(to_char(sysdate, 'yyyy') - CUST_YEAR_OF_BIRTH +1, -1) ���ɴ�
    
    -- ����/10 -> �Ҽ��� ����(floor) -> *10
from customers
--where extract(year from sysdate) - CUST_YEAR_OF_BIRTH between 30 and 40
where trunc(to_char(sysdate, 'yyyy') - CUST_YEAR_OF_BIRTH +1, -1) = 30
order by ����extract;

-- ������ ���� ���� : from > where > select > order �̷��� �ڵ尡 ���ƿ��� ������
-- select���� ������ �Լ��� where���� ���� �� �� ���� ! ������ ����� ������ �� ���� !







