/*
<SEQUENCE>
    �������� ���������� �����ϴ� ������ �ϴ� ��ü
    [ǥ����]
    CREATE SEQUENCE ��������
        [START WITH ����] : ó�� �߻���ų ���� ��, �⺻�� 1
        [INCREAMENT BY ����] : ���� ���� ���� ����ġ, �⺻�� 1
        [MAXVALUE ����] : �߻���ų �ִ밪 10�� 27�� -1
        [MINVALUE ����] : �߻���ų �ּҰ� -10�� 26��
        [CYCLE | NOCYCLE] : �������� �ִ밪�� ������ ��� START WITH���� ���ư�
        [CACHE ����Ʈũ�� | NOCACHE]; : �޸� �󿡼� ������ �� ����(�⺻�� 20 ����Ʈ)
*/
CREATE SEQUENCE SEQ_EMP_COPY_ID 
START WITH 100;
-- ���� ������ ������ �ִ� �������鿡 ���� ������ ��ȸ
SELECT * FROM USER_SEQUENCES;

-- NEXTVAL�� �� ���̶� �������� �ʴ� �̻� CURRVAL�� ������ �� ����. (��ȸ�� ������ +1�� �ȴ�)
-- CURRVAL�� ���������� ����� NEXTVAL���� �����ؼ� �����ִ� ���̴�. (+1�� ���� ���� �� �״�θ� ������)

SELECT SEQ_EMP_COPY_ID.CURRVAL FROM DUAL;
SELECT SEQ_EMP_COPY_ID.NEXTVAL FROM DUAL;

-- �������� : SEQ_TEST
-- 300 ����
-- 5�� ����
-- 310
-- NOCYCLE
-- NOCACHE
-- ������ ����
CREATE SEQUENCE SEQ_TEST
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;
-- ������ �� Ȯ��
SELECT SEQ_TEST.NEXTVAL FROM DUAL;
SELECT SEQ_TEST.CURRVAL FROM DUAL;
SELECT SEQ_TEST.NEXTVAL FROM DUAL;
-- MAX�� �ʰ��� ���� �߻�
SELECT SEQ_TEST.NEXTVAL FROM DUAL; 

-- MAX���� 400 ���� ����
-- ���۰��� ���� �Ұ��� �մϴ�. 
-- ===>> ���۰��� �����ϰ� �ʹٸ� ������ �ٽ� �ۼ�
-- START WITH �������� �߻� 
ALTER SEQUENCE SEQ_TEST
--START WITH 200
INCREMENT BY 1
MAXVALUE 400;

-- SELECT ��� ������ ���̺�� ����
CREATE TABLE EMP_COYP
AS SELECT * FROM EMP;

-- SEQ_EMP_COPY : 207������ �����ؼ� 1�� �����ϴ� �������� ����
CREATE SEQUENCE SEQ_EMP_COPY
START WITH 207
INCREMENT BY 1;

DESC EMP_COYP;

SELECT * FROM EMP_COYP;

INSERT INTO EMP_COYP (EMP_ID, EMP_NAME, HIRE_DATE) 
            VALUES (SEQ_EMP_COPY.NEXTVAL , 'ȫ�浿', '2005-02-01');
            
 SELECT * FROM EMP_COYP ORDER BY EMP_ID DESC;           
            
SELECT  MAX(EMP_ID)
FROM    EMP_COYP;

/*
    �ǻ��÷�
    - ���̺��� �÷�ó�� ���� ������ ������ ���̺� ������� �ʴ� �÷�
    
    SEQUENCE ���� ���Ǵ� �ǻ��÷�
        NEXTVAL, CURRVAL
    ROWNUM : �������� ��ȯ�Ǵ� �� �ο��� ������ 
    ROWID : ���̺� ����� �� �ο찡 ����� �ּҰ�
*/ 
-- ����¡ ó�� �� �� ���
SELECT * 
FROM (
    SELECT ROWNUM RN, EMP_COYP.* 
    FROM EMP_COYP
)
WHERE RN BETWEEN 10 AND 19;














