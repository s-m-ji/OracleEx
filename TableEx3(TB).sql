/*
    SQL BASIC
*/
-- Ex1) �а� ���̺��� �а���� �迭 ��ȸ
SELECT  DEPARTMENT_NAME, CATEGORY FROM TB_DEPARTMENT;

SELECT DEPARTMENT_NAME || '�� ������ ' || CAPACITY || '�� �Դϴ�.' AS "�а��� ����"
    FROM TB_DEPARTMENT
;

-- Ex2) ������а��� �ٴϴ� ���л� �� �������� �л��� ��ȸ
SELECT * 
    FROM TB_STUDENT S, TB_DEPARTMENT D
    WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
    AND DEPARTMENT_NAME = '������а�'
    AND SUBSTR(STUDENT_SSN,8,1) IN (2,4) 
    AND ABSENCE_YN = 'Y'
;
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
    FROM TB_STUDENT
    JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
    WHERE DEPARTMENT_NAME = '������а�'
    AND SUBSTR(STUDENT_SSN,8,1) IN (2,4)
    AND ABSENCE_YN = 'Y'
;
    
-- Ex3) A513079, A513090, A513091, A513110, A513119
-- �̸��� ������� ��ȸ
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE STUDENT_NO IN ('A513079', 'A513090', 'A513091', 'A513110', 'A513119')
ORDER BY 1
;

-- Ex4) ������ �̸��� ��ȸ
-- ������ ������ ��� �������� �Ҽ� �а��� ������ ����.
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR
--LEFT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NO IS NULL
;
    
-- Ex5) �а��� �������� ���� �л��� ��ȸ ===========> �־��? �����. �����?? ���̺� �����.
SELECT *
FROM TB_STUDENT
LEFT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NO IS NULL
;
    
-- Ex6) ���������� �����ϴ� ������ �����ȣ�� ��ȸ   
SELECT DEPARTMENT_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL ;
    
-- Ex7) ���� ������ 20�� �̻� 30�� ������ �а��� �̸��� �迭�� ���
SELECT DEPARTMENT_NAME , CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY BETWEEN 20 AND 30;
--WHERE CAPACITY >= 20 CAPACITY <= 30;

-- Ex8) �а� �迭�� �ߺ� ���� ��ȸ
SELECT DISTINCT CATEGORY FROM TB_DEPARTMENT ORDER BY 1;
SELECT CATEGORY FROM TB_DEPARTMENT GROUP BY CATEGORY ORDER BY 1;

-- Ex8)02�й� ���� �����ڵ��� ���� (���л��� ����)
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE STUDENT_ADDRESS LIKE '%����%'
--AND EXTRACT(YEAR FROM ENTRANCE_DATE) = '2002';
AND TO_CHAR(ENTRANCE_DATE, 'YY') = '02'
AND ABSENCE_YN = 'N'
;

/*
    SELECT_FUNCTION �Լ�
*/
-- Ex1) ������ �л����� �й�, �̸�, ���г⵵�� ��ȸ
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�
    , TO_CHAR(ENTRANCE_DATE,'YYYY')||'��'
        || TO_CHAR(ENTRANCE_DATE,'MM')||'��'
            || TO_CHAR(ENTRANCE_DATE,'DD')||'��' ���г⵵1
    , EXTRACT(YEAR FROM ENTRANCE_DATE)||'��'
        || EXTRACT(MONTH FROM ENTRANCE_DATE)||'��'
            || EXTRACT(DAY FROM ENTRANCE_DATE)||'��' ���г⵵2
FROM TB_STUDENT
LEFT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '������а�'
ORDER BY 3
;
    
-- Ex2) �����̸� �� �̸��� 3���ڰ� �ƴ� �����?
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
--WHERE PROFESSOR_NAME NOT LIKE '___'
WHERE LENGTH(PROFESSOR_NAME)!= 3 
; 

-- Ex3) ���ڱ������� �̸��� ���̸� ��ȸ
-- ���̼���(��������)���� �����ϵ� ���̰� ���ٸ� �̸���(��������)���� ����
SELECT PROFESSOR_NAME �̸� 
        , TO_CHAR(SYSDATE,'YYYY') -
        (DECODE(SUBSTR(PROFESSOR_SSN,8,1), 1,19, 2,19, 3,20, 4,20 ,0)
        || SUBSTR(PROFESSOR_SSN,1,2)) || '��' AS ����
FROM TB_PROFESSOR
    WHERE SUBSTR(PROFESSOR_SSN,8,1) IN (1,3)
ORDER BY ���� DESC, �̸� 
;
    
-- Ex4) ���� �̸� ��� (���� ����)
SELECT PROFESSOR_NAME, SUBSTR(PROFESSOR_NAME,2) 
FROM TB_PROFESSOR
ORDER BY 1
;

-- Ex5) 2023�� ũ���������� ���� �����ϱ��?
SELECT TO_CHAR(TO_DATE(20231225),'DAY')
FROM DUAL;

-- Ex5) 2023�� �ֿ˸� ������ ���� �����ϱ��?
SELECT TO_CHAR(TO_DATE(20231228),'DAY')
FROM DUAL;

-- Ex6) 2000��� ���� �����ڵ��� �й��� A�� �����Ѵ�.
-- 2000��� ���� �й��� ���� ������� �й��� �̸��� ��ȸ
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT 
WHERE STUDENT_NO NOT LIKE 'A%'
ORDER BY 1
;
    
-- Ex7) �й��� A517178�� �ѾƸ� �л��� ���� �� ��������� ���ϱ�
--      �켱 ������ ���غ���
SELECT ROUND(AVG(POINT),1) ����
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

--      �й��� �̸��� �Բ� ��ȸ�ϱ� ���ؼ� �׷����� ���´�.
--      WHERE�� ���͸� �ϴ� ���
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�, ROUND(AVG(POINT),1) ����
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
GROUP BY STUDENT_NO, STUDENT_NAME
HAVING STUDENT_NO = 'A517178'
;
--      HAVING���� ���͸� �ϴ� ���
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�, ROUND(AVG(POINT),1) ����
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
WHERE STUDENT_NO = 'A517178'
GROUP BY STUDENT_NO, STUDENT_NAME
;

-- Ex8) �а��� �л����� ���ؼ� �а���ȣ, �л���(��)�� ��ȸ
-- �л����� ���� ������� ����
SELECT DEPARTMENT_NO �а���ȣ,  COUNT(*) �л���
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY 2 DESC
;
SELECT DEPARTMENT_NO �а���ȣ, DEPARTMENT_NAME �а���, COUNT(*) �л���
FROM TB_STUDENT
RIGHT JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
GROUP BY DEPARTMENT_NO, DEPARTMENT_NAME
ORDER BY 1 DESC
;

SELECT COUNT(*)
FROM TB_DEPARTMENT;                        

-- Ex9) ���������� �������� ���� �л��� �� ��?
SELECT COUNT(*)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;
    
-- Ex10) �й��� A112113�� ���� �л��� �⵵�� ����
--      ��ü ���� 
SELECT ROUND(AVG(POINT),1) 
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
;
--      �б⺰ ����
SELECT STUDENT_NO, TERM_NO, AVG(POINT)
FROM TB_GRADE
GROUP BY STUDENT_NO, TERM_NO
HAVING STUDENT_NO = 'A112113'
;
--     �⵵�� ����
SELECT STUDENT_NO, SUBSTR(TERM_NO,1,4), TRUNC(AVG(POINT),1)
FROM TB_GRADE
GROUP BY STUDENT_NO, SUBSTR(TERM_NO,1,4)
HAVING STUDENT_NO = 'A112113'
;
--      �й�, �̸�, ���� �Բ� ��ȸ : JOIN ���
SELECT STUDENT_NO �й�, STUDENT_NAME �̸�, SUBSTR(TERM_NO,1,4) �б�
        , ROUND(AVG(POINT),1) ����1, TRUNC(AVG(POINT),1) ����2
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
WHERE STUDENT_NO = 'A112113'
GROUP BY STUDENT_NO, STUDENT_NAME, SUBSTR(TERM_NO,1,4)
ORDER BY �б�
;    
--      �й�, �̸�, ���� �Բ� ��ȸ : �������� ���    
SELECT STUDENT_NO �й�
        , (SELECT STUDENT_NAME
            FROM TB_STUDENT
            WHERE STUDENT_NO = TB_GRADE.STUDENT_NO ) �̸�
        , SUBSTR(TERM_NO,1,4) �б�
        , ROUND(AVG(POINT),1) ����1, TRUNC(AVG(POINT),1) ����2
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113'
GROUP BY STUDENT_NO, SUBSTR(TERM_NO,1,4)
ORDER BY �б�
;


    
    
    
    
    
    
    
    
    
    
    
    
    
    