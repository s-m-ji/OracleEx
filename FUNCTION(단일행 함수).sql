/*
    <�Լ�>
    �÷��� ���� �о ��� ����� ��ȯ�Ѵ�.
    - ������ �Լ� : ��ȸ�� ������ŭ ��ȯ
    - �׷� �Լ� : ���� ���� �о �ϳ��� ������ ��ȯ
*/

/*
    ========== ========== [������ �Լ�] <���� ���� �Լ�> ========== ==========
    1) length / lengthb    => ���ڿ��� ������ �� �� ����
    - length(��) : ���ڼ��� ��ȯ
    - lengthb(��) : ������ ����Ʈ���� ��ȯ
        �ѱ� 3byte, ����/����/Ư������ 1byte  
        *����ϴ� �����ڵ忡 ���� �ѱ��� �νĵǴ� ����Ʈ�� �ٸ� �� ����..!
        
    �� : �÷�, ���ڿ�(���ͷ�)
    
    dual ���̺� : �Լ� �׽�Ʈ������ ���� ���Ǵ� ���̺�
    sys ����ڰ� �����ϴ� ���̺��̶� ��� ����ڰ� ���� �����ϴ�
    �� ���� ��� �� ���� �÷��� ������ �ִ� ���� ���̺�
    �Լ��� ����� ��ȸ�ϱ� ���� �ӽ÷� ����ϴ� ���̺�
*/

select * from dual;

select length('����Ŭ'), lengthb('����Ŭ') from dual;

-- ���� ����ϴ� �����ڵ带 ��ȸ
-- KO16MSWIN949 : 2byte, AL32YTF8 : 3byte
select * from nls_database_parameters
where parameter = 'NLS_CHARACTERSET';

select emp_name, length(emp_name), lengthb(emp_name)
from emp;


/*
    2) instr
    - instr(��, ����[,position])
    - ������ ��ġ���� ������ ���ڹ�°�� ��Ÿ���� ������ ������ġ�� ��ȯ�Ѵ�
*/

select instr('aabaacccaaacab', 'b') from dual; 
--b�� ��ġ��(3��°)�� ��ȯ
select instr('aabaacccaaacab', 'b', 5,1) from dual; 
-- 5��° ��ġ�������� 1��° 'b'�� �ڸ��� ��ȯ
select instr('aabaacccaaacabbb', 'b', -1,1) from dual; 
-- �ڿ��� 1��° ��ġ�������� 1��° 'b'�� �ڸ��� ��ȯ

select * from DEPT where instr('10|20|30', DEPARTMENT_ID)>0;

select emp_name || '�� �ȳ��ϻ���~~~' from emp;

select DEPARTMENT_ID, instr('10|20|30', DEPARTMENT_ID)
-- ��ȸ�� DEPARTMENT_ID�� instr �Լ��� �����ϴ°�
                    -- instr('10|20|30', 10)
                    -- instr('10|20|30', 20)
                    -- instr('10|20|30', 30) �̷��� �����´ٴ°�
from DEPT where instr('10|20|30', DEPARTMENT_ID)>0;

/* 
    3) lpad/rpad    => ���ڿ� ���ϰ� �ְ� ǥ���� �� ���� 
    - lpad/rpad(��, ����[,'������ ����'])
    - ���õ� ���� ������ ���ڸ� ���� �Ǵ� �����ʿ� �ٿ���
    ���� n���̸�ŭ ���ڿ��� ��ȯ�Ѵ�.
*/

-- 20���� ������ ���� ���� �� �������� ����/�������ڷ� ä��
select lpad(email, 20) from emp; 
select rpad(email, 20, ' ^_^ ')  from emp; 

/*
    4) ltrim/rtrim
    - ltrim/rtrim(��[,������ ����])
    - ���ڿ��� ���� Ȥ�� �����ʿ��� ���ڸ� ã�� ���� �� ����� ��ȯ

    5) trim
    - trim([leading|trailing|both] '������ ���ڰ�' from ��(�÷�|���ͷ�))
    - ���ڰ� ��,��,���ʿ� �ִ� ���� ���ڸ� ������ �������� ��ȯ
    - ���ڰ� ���� �� ���� ������ �����Ѵ�
*/

select ltrim('           ��')from dual;  -- ���� ���� ����
select length(rtrim('��           '))from dual;  -- ������ ���� ���� �� ���ڿ� ����
select ltrim(emp_name,'A') from emp;    -- 'A'�� �����ϴ� �̸� ����
select ltrim(rtrim('     ��     '))from dual;    -- ���� ���� ��� ����

select ltrim('0001111111', '0') from dual;      -- ���� '0' ����
select trim(both '0' from '00011110000') from dual;     -- ���� ��� '0'����
select trim('     1111    ') from dual;     -- ���� ���� ��� ����

select trim(leading 'z' from 'zzz1234567zzz') from dual;    -- ���� 'z' ����
select trim(trailing 'z' from 'zzz1234567zzz') from dual;   -- ������ 'z' ����

/*
    6) substr
    - substr(��, position [,length])
    - ���ڵ����Ϳ��� ������ ��ġ���� ������ ������ŭ�� ���ڿ��� ���� �� ��ȯ
    
*/

-- ���ڿ��� ����Ʈ ������ �������
select substrb('hello',2,3) from dual;
select substrb('�ȳ��ϼ���',2,3) from dual; 
-- ' ��'�̶�� ��µ� : �� ���ڴ� 2~3����Ʈ�� �����ϱ⶧���� 3�� ������Ⱑ �̻���

select substr('sakuraishow',7) from dual; -- 7��°���� ������
select substr('sakuraishow',7,2) from dual; -- 7��°���� 2������
select substr('sakuraishow',-7,2) from dual; -- ������ 7��°���� �ٽ� ������ 2������

select emp_name, instr(emp_name, ' '),
substr(emp_name, instr(emp_name, ' ')+1),
substr(emp_name, instr(emp_name, ' ')+1)
from emp; -- +1 ���ϸ� ������� �����

select emp_name, substr(emp_name, 0, instr(emp_name, ' ')-1) from emp;

-- ������ġ(position) : �⺻�� : 1
-- position >= 0 ���ۺ��� ���������� ���ʿ��� ���������� ã��
-- position < 0 �����ʿ��� �������� ã��

-- ���̺� ������Ʈ
update emp set email = email || '@jungang.com';
select * from emp;

select email, '�����ID: ' || substr(email, 1, instr(email, '@')-1) from emp;
-- ����Ŭ������ ���ڿ� �ε����� 1���� �����ؼ� �׷��� �ƴ���?��� �����ϼ���.. 
-- 0: ������ �� ó������ ����, 1: ù��°���� ���� => ��·�ų� ����� ������

select substr('123@jungang.com', 1, instr('123@jungang.com', '@')-1) from dual;

-- �ֹι�ȣ���� �����ڵ� ã��
select '1111292935310' from dual;
select substr('1111292935310', 7,1)from dual;

select rpad(substr('1111292935310',1,7),14,'*')from dual;

/*
    7) lower / upper / initcap
    lower|upper|initcap (�÷�|���ڰ�)
    - lower : ��� �ҹ��ڷ� ����
    - upper : ��� �빮�ڷ� ����
    - initcap : �ܾ� �� ���ڸ��� �빮�ڷ� ����
*/

select emp_name, lower(emp_name), upper(emp_name), initcap(emp_name)
from emp;

/*
    8) concat
    - concat(�÷�|'���ڿ�', �÷�|'���ڿ�')
    - ���ڵ����� 2���� ���޹޾Ƽ� �ϳ��� ��ģ �� ����� ��ȯ (�μ��� 3�� �̻� �ִ°� �ȵȴ�)
*/

select concat('�޸ӵ�', 'Ŀ��')from dual;
select concat('�޸ӵ�', '����', 'Ŀ��')from dual;
select concat(concat('�޸ӵ�', '����'), 'Ŀ��')from dual;
select '�޸ӵ�' || '����' || 'Ŀ��' from dual;

select concat (employee_id, department_id) from emp;

/*
    9) replace      => ġȯ
    - replace(�÷�|'���ڰ�', ������ ����, ���ο� ����)
*/

select replace('����� ������ ��ȭ�����', '������', '���빮��') "�ּ� �ٲٱ�" from dual;
select replace('������ ����� ������ ��ȭ����� ������', '������', '���빮��') from dual;
-- �������� ���� �� ��� �ٲ�

select replace(email, '@jungang.com' ,'') from emp;
update emp set email = replace(email, '@jungang.com' ,'');
select * from emp;







