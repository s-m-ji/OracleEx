-- ���� p174 ��������
-- 1) ������̺��� �Ի�⵵�� ������� ���ϴ� ������ �ۼ�
select to_char(HIRE_DATE, 'yyyy') �Ի�⵵
--select lpad(extract(year from HIRE_DATE)||'��',8) �Ի�⵵
        , lpad(count(*)||'��',7) �����
from emp
group by to_char(HIRE_DATE, 'yyyy')
--group by HIRE_DATE
order by 1 ;

-- 2) 2012�⵵ ����, ������, �����ܾ��� �հ�
select PERIOD, REGION, sum(LOAN_JAN_AMT)
from KOR_LOAN_STATUS
where PERIOD like '2012%'               -->  where���� ���͸��ϰų�
group by PERIOD, REGION
--having substr(period,1,4) = '2012'    --> having���� ���͸��ϰų�
;
select * from KOR_LOAN_STATUS;

-- 3) 2013�⵵ �Ⱓ�� ���������� �����ܾ��� �հ�
--select PERIOD �Ⱓ
select nvl(to_char(substr(PERIOD,1,4)||'�� ')||(substr(PERIOD,4,2)||'��'),'�հ�') �Ⱓ
        , lpad(nvl(to_char(GUBUN),'*�Ұ�*'),15) ����
        , to_char(sum(LOAN_JAN_AMT), 'L9,999,999') �����ܾ��հ�
from KOR_LOAN_STATUS
where period like '2013%'
group by PERIOD, rollup(GUBUN)
;

-- 4) �� ������ ���տ����ڷ� �ٲ� �Ẹ��

-- 4-1) 2013�⵵ �Ⱓ �� ���������� �����ܾ��� �հ�
select PERIOD �Ⱓ, GUBUN ����
        , to_char(sum(LOAN_JAN_AMT), 'L9,999,999') �����ܾ��հ�
from KOR_LOAN_STATUS
where period like '2013%'
group by PERIOD, GUBUN
    union                                 --> �� ������ �÷����� �ٸ� ��� : ���� �߻� "���� ����� ����Ȯ�� ���� ��� ���� ����������"  
                                        --> �� ������ ������ Ÿ���� �ٸ� ��� : ���� �߻� "�����ϴ� �İ� ���� ������ �����̾���Ե�"     
-- 4-2) 2013�⵵ �Ⱓ�� �����ܾ��� �հ�
select PERIOD �Ⱓ, ''    -- '' : (null)�� ����� ����, '�Ұ�' �� ���ڸ� �����ϸ� �÷� �� ���� ������ �ٲ��. 
        , to_char(sum(LOAN_JAN_AMT), 'L9,999,999') �����ܾ��հ�
from KOR_LOAN_STATUS
where period like '2013%'
group by PERIOD
;

-- 5) �Ⱓ�� ��.��.��, ��.�� ���ϱ�

-- 5-1) select������ decode �Ǵ� case�� ����Ͽ�, ���� �÷��� ���� ��.��.���� ����� �� ���ϱ�

-- * �ǹ� ���̺� : ���� �����͸� ���� �Ӹ��۷� ��� 

-- 5-2) select���� ��� ������ ���̺�ó�� ���   
--> ��� ������ ���� �÷�(�Ⱓ, ���ô㺸����, ��Ÿ����)�� select ��ȸ ����  
--> �Ⱓ&������ sum���� ���ľ� �� �ٷ� ǥ���� �� ���� 

select decode(grouping(�Ⱓ),1, '�Ⱓ�� �Ұ�', �Ⱓ) as �Ⱓ       --> �׷쿡 ���� null ���̹Ƿ� nvl���� grouping�� �� ��Ȯ�� �� ���ٰ� �Ͻ�. 
--select nvl(�Ⱓ, '�Ⱓ�� �Ұ�') as �Ⱓ
            , sum(���ô㺸����) as ���ô㺸���� 
            , sum(��Ÿ����) as ��Ÿ����
            , sum(���ô㺸���� + ��Ÿ����) as "�Ⱓ�� �հ�"
from (
        select PERIOD as �Ⱓ
                , decode(GUBUN, '���ô㺸����', sum(LOAN_JAN_AMT), 0) as ���ô㺸����
                , decode(GUBUN, '��Ÿ����', sum(LOAN_JAN_AMT), 0) as ��Ÿ����
        from KOR_LOAN_STATUS
        where PERIOD like '2013%'
        group by PERIOD, GUBUN
        order by 1
)
group by rollup(�Ⱓ)
;

-- 6) �� ������ ���տ����ڷ� ǥ���ϱ�
-- 6-1) 2013�� 11�� �ִ�� �հ�
-- 6-2) 2013�� 11�� ��Ÿ �հ�
select �Ⱓ, sum(�ִ��) as ���ô㺸����, sum(��Ÿ) as ��Ÿ����
from (
    select PERIOD as �Ⱓ, sum(LOAN_JAN_AMT)as �ִ�� , 0 as ��Ÿ
    from KOR_LOAN_STATUS
    where PERIOD = '201311' and GUBUN = '���ô㺸����'
    group by PERIOD, GUBUN
        union
    select PERIOD, 0 , sum(LOAN_JAN_AMT)            --> from table �� �� �ʿ��� ��Ī�� ������ٸ� �ٸ� ���� ���� �ʾƵ� �ȴܴ� 
    from KOR_LOAN_STATUS
    where PERIOD = '201311' and GUBUN = '��Ÿ����'
    group by PERIOD, GUBUN
)
group by �Ⱓ
;

-- 7) ������ �� ���� �������ܾ��� ���ϱ�

select region as "����"
        ,sum("201111") as "2011�� 11��", sum("201112") as "2011�� 12��"
        ,sum("201210") as "2012�� 10��", sum("201211") as "2012�� 11��", sum("201212") as "2012�� 12��"
        ,sum("201310") as "2013�� 10��", sum("201311") as "2013�� 11��"
from (
    select REGION, PERIOD, LOAN_JAN_AMT 
            ,decode(period, 201110, loan_jan_amt, 0) as "201110"
            ,decode(period, 201111, loan_jan_amt, 0) as "201111"
            ,decode(period, 201112, loan_jan_amt, 0) as "201112"
            ,decode(period, 201210, loan_jan_amt, 0) as "201210"
            ,decode(period, 201211, loan_jan_amt, 0) as "201211"
            ,decode(period, 201212, loan_jan_amt, 0) as "201212"
            ,decode(period, 201310, loan_jan_amt, 0) as "201310"
            ,decode(period, 201311, loan_jan_amt, 0) as "201311"
            ,decode(period, 201312, loan_jan_amt, 0) as "201312"
    from KOR_LOAN_STATUS
--    where region = '����' 
)
group by region
order by 1
;

/*
    - pivot �Լ�
    ���� ���� ��ȯ���ִ� �Լ� : 2������ ǥ�� ���
    ��� �۾��� ���
    11���� ���� pivot �Լ� ����
    
    select *
    from    ( �ǹ� ��� ������ )
    pivot   ( �׷��Լ�(�����÷�) for �ǹ��÷� in (�ǹ��÷���) )
*/

select *
from (
    select region, period, loan_jan_amt
    from kor_loan_status
)
pivot ( sum(loan_jan_amt) for period in (201111 as "2011�� 11��", 201112 as "2011�� 12��",  
                                        201210, 201211, 201212, 
                                        201310, 201311)
)
order by 1
;

-- �μ��� �⵵�� �Ի��ڼ�
select *
from (
    select DEPT_ID �μ�
            , to_char(HIRE_DATE, 'yyyy') �Ի�⵵
    from emp
)
pivot ( count(*) for �Ի�⵵ in (2000,2001,2002,2003,2004,2005)
);


-- �μ��� ���� �Ի��ڼ�
select *
from (
    select DEPT_ID �μ�
            , to_char(HIRE_DATE, 'fmmm') �Ի��
    from emp
)
pivot ( count(*) for �Ի�� in (1,2,3,4,5,6,7,8,9,10,11,12)
);





