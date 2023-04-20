/*
    ������ ���� 
        ���(NODE): ������ ������ �̷���ִ� �׸�
        ��Ʈ ���(ROOT): ������ Ʈ�������� �ֻ��� ���
        ���� ���(LEAF): ������尡 ���� ������ �׸�
        
        �θ� ���: Ʈ�������� ������ �ִ� ���
        �ڽ� ���: Ʈ�������� ������ �ִ� ���

        ����(LEVEL): ��Ʈ����� ������ 1�� �����Ͽ� �ڽķ����� �Ѿ���� 1�� �����ȴ�.
*/
-- EMP_ID: �����ȣ
-- MANAGER_ID: ����� �����ϴ� �Ŵ����� �����ȣ
--    MANAGER_ID�� NULL�̸� �Ŵ����� �������������� ����  
SELECT MANAGER_ID �Ŵ�����ȣ, EMP_ID �����ȣ, EMP_NAME �����
--          LEVEL�� �̿��� �鿩����
        , LPAD('---', 3*(LEVEL-1)) || EMP_NAME �������
        , LPAD('---', 3*(LEVEL-1)) || DEPT_TITLE �μ�����
        , CONNECT_BY_ROOT DEPT_TITLE �ֻ����μ�
        , SYS_CONNECT_BY_PATH(EMP_NAME,'>') ��������
--          �������� 1, �ƴϸ� 0
        , CONNECT_BY_ISLEAF ��������
FROM EMP
JOIN DEPT ON (DEPT_CODE = DEPT_ID)
-- 1. ��Ʈ����� ���� �Ǵ� ���� ����
START WITH MANAGER_ID IS NULL
-- 2. ���� ���踦 ���
--          PRIOR (���������) �÷��� = (���������) �÷���
CONNECT BY PRIOR EMP_ID = MANAGER_ID
;

-- MENU ���̺� ����
CREATE TABLE MENU(
    MENU_ID VARCHAR2(50 BYTE) PRIMARY KEY
    , UP_MENU_ID VARCHAR2(50 BYTE)
    , TITLE VARCHAR2(50 BYTE)
    , URL VARCHAR2(50 BYTE)
    , SORT NUMBER(2,0)
    , VISIBLE CHAR(1 BYTE)  -- �����̸� �����޶�� �� ����
);
-- M01 / M01_01 / M01_01_01
INSERT ALL
    INTO MENU VALUES ('M01', '', '��޴�1', 'M1.com', 1, '')
    INTO MENU VALUES ('M02', '', '��޴�2', 'M2.com', 1, '')
    INTO MENU VALUES ('M03', '', '��޴�2', 'M3.com', 1, '')
SELECT * FROM DUAL
;

INSERT ALL
    INTO MENU VALUES ('M01_01', 'M01', '�߸޴�1', 'M1-1.com', '', '')
    INTO MENU VALUES ('M02_01', 'M02', '�߸޴�1', 'M2-1.com', '', '')
    INTO MENU VALUES ('M02_02', 'M02', '�߸޴�2', 'M2-2.com', '', '')
    INTO MENU VALUES ('M03_01', 'M03', '�߸޴�1', 'M3-1.com', '', '')
    INTO MENU VALUES ('M03_02', 'M03', '�߸޴�2', 'M3-2.com', '', '')
    INTO MENU VALUES ('M03_03', 'M03', '�߸޴�3', 'M3-3.com', '', '')
SELECT * FROM DUAL
;

SELECT * FROM MENU;

INSERT ALL
    INTO MENU VALUES ('M01_01_01', 'M01_01', '�Ҹ޴�1', 'M1-1-1.com', '', '')
    INTO MENU VALUES ('M02_01_01', 'M02_01', '�Ҹ޴�1', 'M2-1-1.com', '', '')
    INTO MENU VALUES ('M02_01_02', 'M02_01', '�Ҹ޴�2', 'M2-1-2.com', '', '')
    INTO MENU VALUES ('M03_01_01', 'M03_01', '�Ҹ޴�1', 'M3-1-1.com', '', '')
    INTO MENU VALUES ('M03_01_02', 'M03_01', '�Ҹ޴�2', 'M3-1-2.com', '', '')
    INTO MENU VALUES ('M03_01_03', 'M03_01', '�Ҹ޴�3', 'M3-1-3.com', '', '')
SELECT * FROM DUAL
;

-- ��޴�2 > �߸޴�2 �� �Ҹ޴�1 �����
INSERT INTO MENU (MENU_ID, UP_MENU_ID, TITLE) 
    VALUES ('M02_02_01', 'M02_02', '�Ҹ޴�1') ;

-- MENU_ID�� 'M03'�� �÷��� TITLE�� '��޴�3'�� ����
UPDATE MENU SET TITLE = '��޴�3' WHERE MENU_ID = 'M03' ;

SELECT LEVEL, MENU_ID �����޴�, UP_MENU_ID �����޴�
        , LPAD('-----', 5*(LEVEL-1)) || TITLE  �޴��̸�
FROM MENU
START WITH UP_MENU_ID IS NULL
CONNECT BY PRIOR MENU_ID = UP_MENU_ID
;

-- �� ������ �ϳ��� ���ǿ��� �ǽ� ���̱⿡ ���������,
-- ���� ���� �����͸� �̿��� ��쿡�� �� COMMIT�� ����� �ݿ��� ����� ��ȸ�� �� �ִ�.
--DROP TABLE MENU;








