/*
    < INDEX >
    SQL ��ɹ��� ó�� �ӵ��� ��� ��Ű�� ���ؼ� �÷��� ���� �����ϴ� ����Ŭ ��ü
    �÷��� �����Ͽ� ������ ���� ���ĵ� ������ �����͸� ��ȸ
    
    - �˻� �ӵ��� �������� �ý��ۿ� �ɸ��� ���ϸ� �ٿ� �ý��� ��ü ���� ���
    - �ε����� ���� �߰� ���� ������ �ʿ��ϰ� �ε����� �����ϴµ� �ð��� �ɸ�
    - �������� ���� �۾��� ���� �Ͼ�� ��� ������ ������ ���� �ɼ� ����
    
    [����]
    CREATE [UNIQUE] INDEX �ε����� ON ���̺��(�÷���, �÷��� | �Լ���, �Լ� ����);
*/
-- �ε��� ��ȸ 
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_INDEXES WHERE TABLE_NAME='TB_STUDENT';
SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME = 'TB_STUDENT';

-- ���̺� ���� ����
CREATE TABLE COPY_STUDENT AS SELECT * FROM TB_STUDENT WHERE 1=3;
-- ������ ���� (�⺻: 1���� �����Ͽ� 1�� ����)
CREATE SEQUENCE SEQ_TB_STUDENT_NO;

-- ������ ����
-- �л� ���̺��� �����͸� �����Ͽ� �Է�
-- STUDENT_NO : �������� ������ �̿� A�� �����ϴ� 8�ڸ� ���ڰ� (e,g A00000001)
-- STUDENT_SSN : �������� ���簪 �̿�

--INSERT INTO 

SELECT LPAD('A'||(SEQ_TB_STUDENT_NO.NEXTVAL),0,8) FROM DUAL;
SELECT 'A'||LPAD(SEQ_TB_STUDENT_NO.NEXTVAL,8,0), SEQ_TB_STUDENT_NO.CURRVAL FROM DUAL;

DESC COPY_STUDENT;

-- 588��
SELECT COUNT(*) FROM TB_STUDENT;
-- 
SELECT COUNT(*) FROM COPY_STUDENT;
SELECT * FROM COPY_STUDENT ORDER BY 1 DESC;
SELECT * FROM COPY_STUDENT ORDER BY 1;

INSERT INTO COPY_STUDENT
    ( SELECT 'A'||LPAD(SEQ_TB_STUDENT_NO.NEXTVAL,8,0)
        ,DEPARTMENT_NO
        ,STUDENT_NAME
        ,SEQ_TB_STUDENT_NO.CURRVAL
        ,STUDENT_ADDRESS
        ,ENTRANCE_DATE
        ,ABSENCE_YN
        ,COACH_PROFESSOR_NO
--    FROM TB_STUDENT
        FROM COPY_STUDENT   -- �ڱ��ڽ��� ����
    ) 
;
-- (INDEX ���� ��) ���� ��� : 0.093��
SELECT * FROM COPY_STUDENT WHERE STUDENT_NO = 'A00123456';
-- �ε��� ����
-- �÷��� �ߺ��� ���� ��� UNIQUE �ε����� ����
CREATE UNIQUE INDEX IDX_COPY_STUDENT_NO 
    ON COPY_STUDENT(STUDENT_NO);
    
CREATE UNIQUE INDEX IDX_COPY_STUDENT_NO 
    ON COPY_STUDENT(STUDENT_NAME);
    
-- (INDEX ���� ��) ���� ��� : 0.029��
SELECT * FROM COPY_STUDENT WHERE STUDENT_NO = 'A00123456';
-- �ε��� ����
DROP INDEX IDX_COPY_STUDENT_NO;
-- (INDEX ���� ��) ���� ��� : ����� ��� �� 1(0.051��)
SELECT * FROM COP  Y_STUDENT WHERE STUDENT_NO = 'A00123456';

-- ��Ƽ������(Optimizer)�� ����ڰ� ������ SQL���� ���� ������ ���� ����� �����ϴ� ������ �����Ѵ�. 
-- �̷��� ������ ���� ����� �����ȹ(Execution Plan)�̶�� �Ѵ�. 
-- UNIQUE SCAN : �÷��� ������ ���̰� ��������(=)�� ��� ���

/*
    NONUNIQUE INDEX
    �ߺ����� �ִ� �÷��� ���� ������ �ε���
*/
-- (INDEX ���� ��) ���� ��� : 0.0005�� / 8192��
SELECT COUNT(*) FROM COPY_STUDENT WHERE STUDENT_NAME = '�����';
-- �ε��� ����
CREATE INDEX IDX_STUDENT_NAME ON COPY_STUDENT(STUDENT_NAME);
-- (INDEX ���� ��) ���� ��� : 0.0003��
SELECT * FROM COPY_STUDENT WHERE STUDENT_NAME = '�����';

-- ���� ��¥ �÷��� �ε����� �����غ��ϴ�.
CREATE INDEX IDX_ENTRANCE_DATE ON COPY_STUDENT(ENTRANCE_DATE);
SELECT COUNT(*) FROM COPY_STUDENT WHERE ENTRANCE_DATE <= '20070105';

DROP INDEX IDX_ENTRANCE_DATE;

/*
    �ε����� Ÿ�� �ʴ� ���
        - ���������� ������ ����ȯ�� �Ͼ�� ���
*/
-- �ֹι�ȣ�� �ε����� �����غ��ϴ�.
CREATE INDEX IDX_STUDENT_SSN ON COPY_STUDENT(STUDENT_SSN);
SELECT COUNT(*) FROM COPY_STUDENT WHERE SUBSTR(STUDENT_SSN,1,2) <= 9;
-- 0.059 -> 0.015
SELECT * FROM COPY_STUDENT WHERE STUDENT_SSN = '11111';
-- 0.153 -> 0.154 (���� ������ ���� ����)
SELECT * FROM COPY_STUDENT WHERE STUDENT_SSN = 11111;

/*
    <�ε��� �����>
    DML �۾��� ������ ���, �ε��� ��Ʈ���� �������θ� ���ŵ˴ϴ�.
    �ʿ���� ������ �����ϰ� ���� �ʵ��� �ε����� ����� ���ݴϴ�.
*/
ALTER INDEX IDX_STUDENT_SSN REBUILD;

/*
    <���� �ε���>
        �� �� �̻��� �÷��� ���
*/
CREATE INDEX IDX_COPY_A_P
                ON COPY_STUDENT(ABSENCE_YN, COACH_PROFESSOR_NO);
SELECT INDEX_NAME, COLUMN_NAME FROM USER_IND_COLUMNS
        WHERE TABLE_NAME = 'COPY_STUDENT' ORDER BY INDEX_NAME;
SELECT COUNT(*) FROM COPY_STUDENT WHERE ABSENCE_YN = 'Y' AND COACH_PROFESSOR_NO='P099';
DROP INDEX IDX_COPY_STUDENT_A_P;

/*
    < �Լ���� �ε��� >
        ���� ����ϴ� ������� �ε����� ����Ҽ� �ִ�
*/
CREATE INDEX IDX_COPY_STUDENT_ ON COPY_STUDENT(SUBSTR(STUDENT_SSN,3,1));
-- 0.233�� -> 0.225�� : WHERE ���ǿ� ���� ���� �ӵ��� ������ ���� �� �ֱ� ������ �����ϱ⳪��..?
SELECT COUNT(SUBSTR(STUDENT_SSN,3,1)) FROM COPY_STUDENT WHERE SUBSTR(STUDENT_SSN,3,1) IS NOT NULL; 
DROP INDEX IDX_COPY_STUDENT_;

















