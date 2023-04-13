/* [�׷� �Լ�]
    �뷮�� �����ͷ� ����, ��� ���� �۾��� ó���ؾ��ϴ� ��� ���
    ��� �׷� �Լ��� null ���� �ڵ����� ������ => nvl() �Լ��� �Բ� ����ϴ°� ���� 
    
    1) sum(number)
    - �ش� �÷��� �� �հ踦 ��ȯ
    
    2) avg(number)
    - �ش� �÷��� ����� ��ȯ
    
    3) min(��� Ÿ��) / max(��� Ÿ��)
    - min : �ش� �÷��� �� �� ���� ���� ���� ��ȯ
    - max : �ش� �÷��� �� �� ���� ū ���� ��ȯ
    
    4) count(*|�÷�)
    - ������� ������ ���� ��ȯ
    - count(*) : ��ȸ����� �ش��ϴ� ��� �� ���� ��ȯ  -> null�� ���� ��
    - count(�÷�) : ������ �÷����� null�� �ƴ� �� ���� ��ȯ
    - count(distinct �÷�) : �ش� �÷��� �ߺ��� ������ �� �� ���� ��ȯ
*/

select  to_char(sum(salary), 'L999,999') "�� �޿�"
        ,to_char(avg(salary), 'L999,999') "��� �޿�"
from emp;

select  sum(salary) "�� �޿�"
        ,avg(salary) "��� �޿�"
        ,floor(avg(salary)) "��� �޿� floor"
        ,trunc(avg(salary)) "��� �޿� trunc"
        ,min(EMPLOYEE_ID) "ù��° ���"
        ,max(EMPLOYEE_ID) "������ ���"  -- max(EMPLOYEE_ID)+1 ���� �������� ����?�� ���� �� �⺻Ű�� �̷� ������ ���ٰ��
        ,min(salary) "�ּ� �޿�"
        ,max(salary) "�ִ� �޿�"
from emp;

select DEPARTMENT_ID 
from emp
where DEPARTMENT_ID is null; 

select count(DEPARTMENT_ID)
from emp;   -- 106�� *null �����ϰ� ��

select count(EMPLOYEE_ID)
from emp;   -- 107��

-- �ߺ��� ������ �Ǽ�   *null �����ϰ� �� => ��� �÷��� ������� ����� !
select count(distinct DEPARTMENT_ID) 
from emp;   -- 11��

select distinct DEPARTMENT_ID
from emp;   -- 12��

-- nvl �Լ��� �̿��ؼ� null ���� ġȯ �� ��ȸ
select count(distinct nvl(DEPARTMENT_ID,0))
from emp;   -- ���� ���̺� �̹� �ִ� ������ ġȯ�ϸ� �ߺ��� �ɷ��� ��Ȯ�� �� ������ �����

-- ��� �޿� �հ�, �ߺ� ������ �޿� �հ�, 
-- ��� �޿�, �ߺ� ������ ��� �޿�
-- �ּ� �޿�, �ߺ� ������ �ּ� �޿�  *�ּ�/�ִ밪�� �������̱⿡ �ߺ��� ���� ���� ����
select sum(salary), sum(distinct(salary))
,avg(salary), avg(distinct(salary))
,min(salary), min(distinct(salary))
from emp;

-- �л�� ǥ�� ����
select variance(salary), stddev(salary)
from emp;

/*
    ========== ========== <group by> ========== ==========
    �׷쿡 ���� ������ ������ �� �ִ� ����
    �������� ���� �ϳ��� �׷����� ��� ó���� �������� ���
    select
    from
    [where]
    [group by]
    [order by]
    ������ ������� �ۼ��Ǿ���� *[] ���������� ��
    - select ������ ���� �Լ��� group by ���� ��õ� �÷��� �� �� ����
*/
-- ��ü����� �ϳ��� �׷����� ��� ������ ���� ���
select sum(salary) from emp;
-- �μ��� ����� �޿� �հ�
select DEPARTMENT_ID �μ�, sum(salary) �ѱ޿�, count(*) ����� -- count(*) count(EMP_NAME) �䷱�� �����Լ�
from emp
group by DEPARTMENT_ID
order by 1;

-- �� �μ��� �����
select DEPARTMENT_ID �μ�, count(*) �����
from emp
group by DEPARTMENT_ID
order by 2 desc;

-- �μ��� Ŀ�̼��� �ִ� �����
select DEPARTMENT_ID �μ�, COMMISSION_PCT ���ʽ�, count(*) �����
from emp
group by DEPARTMENT_ID, COMMISSION_PCT
order by 2;

-- ���� null�� �־ count(COMMISSION_PCT)�� 0���� �����⵵ �Ѵ�
--select DEPARTMENT_ID �μ�, count(COMMISSION_PCT) "���ʽ� �����"
select DEPARTMENT_ID �μ�, count(*) "���ʽ� �����", COMMISSION_PCT Ŀ�̼�
from emp
group by DEPARTMENT_ID, COMMISSION_PCT
order by 2;

select JOB_ID �μ�, to_char(trunc(avg(salary)), 'L999,999') "��� �޿�", count(DEPARTMENT_ID) �����,  count(*) �����
from emp
group by JOB_ID;

-- �μ���
select DEPARTMENT_ID �μ�, lpad(count(*)||'��',8) as �����
        , lpad(decode(count(COMMISSION_PCT), 0,' ', count(COMMISSION_PCT)||'��'),8) as Ŀ�̼�
        , to_char(sum(salary), '999,999') as �޿��հ�, floor(avg(salary)) as ���
        , min(salary) as �����޿� , max(salary) as �ְ�޿�
from emp
group by DEPARTMENT_ID
order by 1;

SELECT CUST_GENDER, count(*)
from CUSTOMERS
group by CUST_GENDER
order by 1 desc;

-- �Ұ踦 ���ϴ� �Լ�: rollup   => �ұ׷� �հ踦 ��ȯ
--SELECT nvl(decode(CUST_GENDER, 'F','��','M','��'), 'F��M') ����, count(*) ����
SELECT decode(CUST_GENDER, 'F','��','M','��', '����') ����, count(*) ����
from CUSTOMERS
group by rollup(CUST_GENDER);

SELECT count(*) from CUSTOMERS;

-- ���� �÷��� �����ؼ� �׷��� ������ ����
-- �μ��� ���޺� ������� �޿��� ����
select DEPARTMENT_ID as "�μ�", JOB_ID as "����"
        , count(*) as "�μ��� ���޺� �����", sum(salary) as " �μ��� ���޺� �޿� ����"
        
from emp
group by DEPARTMENT_ID, JOB_ID
order by 1,2
;

/*
    ========== ========== <having> ========== ==========
    - �׷쿡 ���� ������ ������ �� ����ϴ� ����
    - �׷� �Լ��� ����� ������ �񱳸� ����
    
    * ���� ����
        5.select    ��ȸ�� �÷���|����|�Լ���|[as]��Ī
        1.from      ��ȸ�� ���̺��
        2.where     ���ǽ�
        3.group by  �׷� ���ؿ� �ش��ϴ� �÷���|����|�Լ���
        4.having    �׷쿡 ���� ���ǽ�
        6.order by  ���� ���ؿ� �ش��ϴ� �÷���|[as]��Ī|�÷� ����
*/

select JOB_ID, sum(salary) 
from emp
-- where sum(salary) >= 10000   --- => �׷��Լ��� where���� �� �� ����! �㰡 ���� �߻���
group by JOB_ID
having sum(salary) >= 10000
order by sum(salary) desc;

select nvl(to_char(DEPARTMENT_ID), '�μ�����') �μ�
    , trim(to_char(floor(avg(salary)), 'L999,999'),20) ��ձ޿�
    , lpad(count(*)||'��', 7) �����
from emp
group by DEPARTMENT_ID
having avg(salary) >= 7000
order by avg(salary);

-- �μ��� ���ʽ��� �޴� ����� ���� �μ��鸸 ��ȸ
select DEPARTMENT_ID, count(commission_pct)
from emp
--where commission_pct is null
group by DEPARTMENT_ID
having count(commission_pct) = 0;

/*
    ========== ========== <���� �Լ�> ========== ==========
    �׷캰 ������ ��� ���� �߰� ���踦 ������ִ� �Լ�
*/

select nvl(to_char(JOB_ID),'��ü �޿� �հ�') as "���� ���" , sum(salary) as "���޺� �޿� �հ�"
from emp
group by rollup(JOB_ID)
order by 1 desc;

-- cube
select JOB_ID, sum(salary)
from emp
group by cube(JOB_ID)
;

-- �μ� �ڵ嵵 ���� ���� �ڵ嵵 ���� ������� �׷� ��� �޿��� �հ踦 ��ȸ
select DEPARTMENT_ID, JOB_ID,  sum(salary)
from emp
group by rollup(DEPARTMENT_ID, JOB_ID)
order by 1,2;

select DEPARTMENT_ID, JOB_ID,  sum(salary)
from emp
group by cube(DEPARTMENT_ID, JOB_ID)
order by 1,2;

/*
    ========== ========== <grouping> ========== ==========
    rollup, cube�� ���� ����� ���� 
    �ش� �÷��� ���� ���⹰�̸� 0�� ��ȯ �ƴϸ� 0�� ��ȯ
*/

select DEPARTMENT_ID, JOB_ID,  sum(salary)
        , grouping (DEPARTMENT_ID)
        , grouping (JOB_ID)
from emp
group by rollup(DEPARTMENT_ID, JOB_ID)
order by 1,2;

/*
    ========== ========== <���� ������> ========== ==========
    - �������� �������� ������ �ϳ��� �������� ����
    - ������ 
        union       : �� �������� ������ ����� ���� �� �ߺ� ���� ����
        union all   :               "              �ߺ� �൵ ��� 
    - ������
        intersect   : �� �������� ������ ����� �ߺ��� ������� ����
    - ������
        minus       : ���� ������տ��� ���� ��������� �� ������ ������� ����
*/
 -- 2�� ����
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20   
;
-- 3�� ����
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000      
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
        or      ------ or �� ����
    SALARY between 5000 and 6000      
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    union       ------ �ߺ� ���� ������ *or�� ���� ���
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    union all      ------ �ߺ� ��� ������
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
        and      ------ and �� ����
    SALARY between 5000 and 6000      
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    intersect       ---- ������ *and�� ���� ���
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where DEPARTMENT_ID = 20
    minus       ---- ������ 
select EMPLOYEE_ID, EMP_NAME, DEPARTMENT_ID, SALARY
from emp
where SALARY between 5000 and 6000 
;

select * from KOR_LOAN_STATUS;

select PERIOD, GUBUN, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS
--where substr(PERIOD,1,4) = '2013'
where PERIOD like '2013%'
group by PERIOD, GUBUN
;

select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS 
group by PERIOD, REGION
having sum(LOAN_JAN_AMT) >= 100000
    intersect
select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS 
where PERIOD like '2012%'
--where REGION = '����'
group by PERIOD, REGION
;

select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS 
--where PERIOD like '2012%' and REGION = '����'
-- �÷����� ���� �Ұ踦 �� ���� ���� : �� ��� �� �հ�� ����� !
--group by rollup(PERIOD), REGION       ----> �Ⱓ�� ���� �Ұ�: �������� �ϳ��� ����� ����
--group by PERIOD, rollup(REGION)       ----> ������ ���� �Ұ�: �Ⱓ���� �ϳ��� ����� ����
group by rollup(PERIOD, REGION)         ----> �Ⱓ�� ������ ���� �Ұ�: ��� ���� �� ���� ���� ��ü ����� �ϳ� �� ���� 
--having sum(LOAN_JAN_AMT) >= 100000

-- *** having���� ����ص� rollup�� ���(�Ұ�)�� ������ �ʴ´�
-- �Ұ迡�� �׷��� ������ ������� �ʾƼ� ???                 ----> ������ having ������ ���� �Ǵ°� ���� !
--having sum(LOAN_JAN_AMT) between 100000 and 500000      ----> ���� �Ұ谡 100���� �Ѵµ� having �������� 50���� ���� �ʴ� ���͸��� �ֱ� ������ ���迡�� �Ұ谡 ������ ����
                                                        ----> �Ұ迡 having ������ �ش���� ���� ��� ���迡 �ݿ����� �ʴ´�

-- having ������ �߰��� ��� �Ұ谡 ��ġ���� ���� �� �ִ�.      ----> having �������� ���͸� �� ���� ���迡 ������ �ʴ� ��  
-- having ������ ���� ���¿��� ������ ��� �Ұ� �ݾ��� ��ġ�ϴ� ���� Ȯ���� �� �ִ�.


/*
===== ��� : having���� ������տ� ���� ���͸��̶�� �� �� ����. �� !




*/

order by 1
;
-- 1023154.6
select DEPARTMENT_ID, JOB_ID,  sum(salary)
        , grouping (DEPARTMENT_ID)
        , grouping (JOB_ID)
from emp
group by rollup(DEPARTMENT_ID, JOB_ID)
order by 1,2;

-- ================= 04/13 ���� self-check ���� ���� ===================
create table e(
    id number(6), name varchar2(80), salary number(8,2), id2 number(6)
);

merge into ���̺��1 ��Ī1
    using(select �÷�1, �÷�2, �÷�3
        from ���̺��2
        where �÷�3 = ��2) ��Ī2
        on (��Ī1.�÷�1 = ��Ī2.�÷�1)
    when matched then
    update set ��Ī1.�÷�4 = ��Ī1.�÷�4 + ��Ī1.�÷�5*��2
    when not matched then
    insert(��Ī1.�÷�1, ��Ī1.�÷�4) values(��Ī2.�÷�1, ��Ī1.�÷�5*��3);
     


select substr('ABCDEFG',-2,4) from dual;

-- �ټӳ�� ���ϱ� : round((sysdate - hire_date)/365)
-- ���ɴ�(n�ɴ�) ���ϱ� : trunc((to_char(sysdate, 'yyyy')-birtrh_date)/10)

select round((sysdate - hire_date)/365)
from emp;

select TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH
from CUSTOMERS;

select sum(CUST_NAME) FROM CUSTOMERS;  

SELECT CUST_NAME, 
       CUST_YEAR_OF_BIRTH, 
       CASE WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 1 THEN '10��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 2 THEN '20��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 3 THEN '30��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 4 THEN '40��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 5 THEN '50��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 6 THEN '60��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10)  = 7 THEN '70��'
          ELSE '��Ÿ' END AS new_generation
FROM CUSTOMERS;  

SELECT period, 
       CASE WHEN gubun = '��Ÿ����'     THEN SUM(loan_jan_amt) ELSE 0 END ��Ÿ�����, 
       CASE WHEN gubun = '���ô㺸����' THEN SUM(loan_jan_amt) ELSE 0 END ���ô㺸�����
       
  FROM kor_loan_status
 WHERE period = '201311' 
 GROUP BY period, gubun;

SELECT period, SUM(loan_jan_amt) ���ô㺸�����, 0 ��Ÿ�����
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '���ô㺸����'
 GROUP BY period, gubun
 UNION all
SELECT period, 0 ���ô㺸�����, SUM(loan_jan_amt) ��Ÿ�����
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '��Ÿ����'
 GROUP BY period, gubun ;
 
SELECT period, 0 ���ô㺸�����, SUM(loan_jan_amt) ��Ÿ�����
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '��Ÿ����'
 GROUP BY period, gubun
   UNION all
 SELECT period, SUM(loan_jan_amt) ���ô㺸�����, 0 ��Ÿ�����
  FROM kor_loan_status
 WHERE period = '201311' 
   AND gubun = '���ô㺸����'
 GROUP BY period, gubun;






