/*
    ========== ========== <���� �Լ�> ========== ==========
    - �������� ��쿡 ������ �� �� �ִ� ����� �����ϴ� �Լ�
    
    1) decode(�÷�, ����1, ���1[, ����2, ���2, ...], �����)
                -- ����1�� true�� ���1 ����2�� true�� ���2 ��� �ƴϸ�(false��) �����
       decode(�÷�, ����1, ���1, ���2)
                -- ������ true�� ���1 false�� ���2
*/

select decode(substr('1111294056520',7,1), 1,'��' ,3,'��' ,2,'��' ,4,'��', '^_^') from dual;
select decode(5, 1,'��' ,3,'��' ,2,'��' ,4,'��', '^_^') ���ä����Ť� from dual; 
                            -- ��� �ƴϸ� ������ ���� ���, ������ �����ص��������� null�� ���´� !

-- 1111294265952
-- 9511294265952

select to_char(sysdate, 'yyyy') - decode(substr('1111294056520',7,1)
        , 4, '20'||substr('1111294056520',1,2))+1 "2000���� ����"
from dual;

select to_char(sysdate, 'yyyy') - decode(substr('9511292265952',7,1)
        , 2, '19'||substr('9511294265952',1,2))+1 "1900���� ����"
from dual;


create table user01 (
    name varchar2(30)
    , jumin char(13)
    , telno varchar2(20)
); 

insert into user01 values (
'������', '1111294056520', '010-0000-0000');

insert into user01 values (
'����', '9511294265952', '010-1111-1111');

update user01
set jumin = '9511291265952'
where name = '����';

select * from user01;

select jumin, substr(jumin,7,1) "�ֹι�ȣ ����"
                , decode(substr(jumin,7,1)
                , '1','19' , '2','19'
                , '3','20' , '4','20'
                , '') || substr(jumin,0,2) ����⵵
                , to_char(sysdate, 'yyyy') ����1
                , extract(year from sysdate) ����2
                
                , extract(year from sysdate) - (decode(substr(jumin,7,1)
                , '1','19' , '2','19'
                , '3','20' , '4','20'
                , '') || substr(jumin,0,2)) ����
from user01;

/*
    ���� �ڵ尡 AD_VP �̸� 10% �λ� (salary*1.1)
              SA_REP �̸� 15% �λ�   (salary*1.15)
              IT_PROG �̸� 20% �λ�   (salary*1.2)
                �� �� ������ 5% �λ�   (salary*1.05)
*/

select TITLE_KOR ������ ,MIN_SALARY "���� �޿�"
    , decode(JOB_ID, 'AD_VP', MIN_SALARY*1.1
                    , 'SA_REP', MIN_SALARY*1.15
                    , 'IT_PROG', MIN_SALARY*1.2
                    ,MIN_SALARY*1.05 ) "�λ�� �޿�"
from JOBS;

select NAME_KOR ����� ,SALARY "���� �޿�"
    , decode(JOB_ID, 'AD_VP', SALARY*1.1
                    , 'SA_REP', SALARY*1.15
                    , 'IT_PROG', SALARY*1.2
                    ,SALARY*1.05 ) "�λ�� �޿�"
from EMP;

/*
    2)case
        case when ���ǽ�1 then �����1
            when ���ǽ�2 then �����2
            ...
            else �����        -- ��� ������ �ƴ� �� ��������� ���� ~
        end
*/

select name �̸�, case when substr(jumin,7,1) = '1' then '��' 
            when substr(jumin,7,1) = '3' then '��'
            when substr(jumin,7,1) = '2' then '��'
            when substr(jumin,7,1) = '4' then '��'
            else '^_^' end ����
from user01;

select CUST_NAME �̸�, CUST_YEAR_OF_BIRTH ����⵵, extract(year from sysdate) - CUST_YEAR_OF_BIRTH ����
                     ,case  when (extract(year from sysdate) - CUST_YEAR_OF_BIRTH) >= 50 and extract(year from sysdate) - CUST_YEAR_OF_BIRTH <60 then '50��'
                            when (extract(year from sysdate) - CUST_YEAR_OF_BIRTH) >= 40 and extract(year from sysdate) - CUST_YEAR_OF_BIRTH <50 then '40��'
                            when (extract(year from sysdate) - CUST_YEAR_OF_BIRTH) >= 30 and extract(year from sysdate) - CUST_YEAR_OF_BIRTH <40 then '30��'
                      else '��Ÿ' end ���ɴ�          
from CUSTOMERS
order by CUST_YEAR_OF_BIRTH desc;

select CUST_NAME �̸�
    , case  when trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10) = 3 then '30��'
            when trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10) = 4 then '40��'
            when trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10) = 5 then '50��'
    else '��Ÿ' end ���ɴ�  
from CUSTOMERS;

select CUST_NAME �̸�, decode(trunc((to_char(sysdate,'yyyy') - CUST_YEAR_OF_BIRTH)/10)
                        , '3','30��' , '4','40��', '5','50��', '6','60��', '��Ÿ') ���ɴ� 
from CUSTOMERS;
-- �ڵ尡 ���������� ���ؼ��� �˻��� ���� �̸� �����صδ°� ���ڴ� !

/*
    ========== ========== <���� �Լ�> ========== ==========
    *�� : �÷�, ���ڿ�(���ͷ�)
    
    greatset(��1,��2...)
    - �Ű������� ������ �� �� �� ū ���� ��ȯ
    
    least(��1,��2...)
    - �Ű������� ������ �� �� ���� ���� ���� ��ȯ
*/

select greatest(1,10) from dual;
select greatest('A','a') from dual;

select least(1,10,3,-30) from dual;
select least(1,10,3,-30) from dual;


select name 
from user01 order by name;







