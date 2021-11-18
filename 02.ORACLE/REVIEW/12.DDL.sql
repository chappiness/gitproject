--DML
--������ �˻�,����
--INSERT,DELETE,UPDATE,SELECT
--INSERT : �����ͺ��̽� ��ü�� �����͸� �Է�
--DELETE : �����ͺ��̽� ��ü�� �����͸� ����
--UPDATE : ������ �����ϴ� �����ͺ��̽� ��ü ���� �����ͼ���
--SELECT : �����ͺ��̽� ��ü�κ��� �����͸� �˻�

--DDL
--�����Ϳ� �� ������ ����
--CREATE,DROP,ALTER,TRUNCATE
--CREATE : ������ ���̽� ��ü ����
--DROP : ������ ���̽� ��ü�� ����
--ALTER : ������ �����ϴ� �����ͺ��̽� ��ü�� �ٽ� ����
--TRUNCATE : �����ͺ��̽� ��ü ���� ����

--DCL
--�����ͺ��̽� ������� ���� ����
--GRANT,REVOKE,COMMIT,ROLLBACK,SAVEPOINT
--GRANT : ������ ���̽� ��ü�� ���� �ο�
--REVOKE : �̹� �ο��� �����ͺ��̽� ��ü�� ������ ���
--COMMIT : Ʈ����� Ȯ�� (TCL)
--ROLLBACK : Ʈ����� ��� (TCL)
--SAVEPOINT : �������� ���� (TCL)
-----------------------------
-----------DDL---------------
-----------------------------
DROP TABLE BOOK;
CREATE TABLE BOOK(
 BOOKID NUMBER,
 BOOKNUMBER VARCHAR(20),
 PUBLISHER VARCHAR(20),
 PRICE NUMBER,
 RDATE DATE,
 PRIMARY KEY(BOOKID));
SELECT * FROM BOOK;

DROP TABLE EMP01;
CREATE TABLE EMP01(
    EMPNO NUMBER(4),
    ENAME VARCHAR2(20),
    SAL NUMBER(7,2));
SELECT * FROM EMP01;

--ROWID:���̺��� ���� ��ġ�� �����ϴ� ������ �ּҰ�,�ߺ� X
SELECT ROWID,EMPNO,ENAME FROM EMP;
--ROWNUM:���̺� ���� ���� ����
SELECT ROWNUM,EMPNO,ENAME FROM EMP;

--�μ���ȣ,�μ��̸�,�μ���ġ ���̺� �����
DROP TABLE DEPT01;
CREATE TABLE DEPT01(
    DEPTNO NUMBER(2),
    DNAME VARCHAR2(14),
    LOC VARCHAR2(20));
SELECT * FROM DEPT01;

--���������� ���̺� �����ϱ�
DROP TABLE EMP02;
CREATE TABLE EMP02 AS SELECT * FROM EMP;
SELECT * FROM EMP02;

--���� Į������ ���ϴ� �÷��� �����ؼ� ����
DROP TABLE EMP03;
CREATE TABLE EMP03 AS SELECT EMPNO,ENAME,SAL FROM EMP;
SELECT * FROM EMP03;

--�����ȣ,����̸�,�޿� Į������ ������ ���̺� ����
DROP TABLE EMP04;
CREATE TABLE EMP04 AS SELECT ENAME,SAL,COMM,MGR FROM EMP;
SELECT * FROM EMP04;

--�μ� 10���� ����� ���
DROP TABLE EMP05;
CREATE TABLE EMP05 AS SELECT ENAME,DEPTNO FROM EMP WHERE DEPTNO=10;
SELECT * FROM EMP05;

--���̺��� ������ ����>>WHERE 1=0; Ȱ��!!
DROP TABLE EMP06;
CREATE TABLE EMP06 AS SELECT * FROM EMP WHERE 1=0;
SELECT * FROM EMP06;

--DEPT ������ ��������
DROP TABLE DEPT02;
CREATE TABLE DEPT02 AS SELECT * FROM DEPT WHERE 1=0;
SELECT * FROM DEPT02;

--ALTER ���̺� ���� ����
--ADD �߰�,MODIFY ����,DROP ����

--ADD(1)
SELECT * FROM EMP03; --EMPNO,ENAME,SAL
ALTER TABLE EMP03 ADD(JOB VARCHAR2(9));
SELECT * FROM EMP03; --JOB �߰�>>�� NULL

--ADD(2)
ALTER TABLE DEPT02 ADD(DMGR NUMBER(4)); 
SELECT * FROM DEPT02;

--MODIFY(1)
DESC EMP03; --������ 30�ڷ� ����
ALTER TABLE EMP03 MODIFY(JOB VARCHAR2(30));
DESC EMP03;

--MODIFY(2)
DESC DEPT02; --DMGR�� 8�ڸ� ���ڷ� ����
ALTER TABLE DEPT02 MODIFY (DMGR NUMBER(8));
DESC DEPT02;

--DROP(1)
SELECT * FROM EMP03;
ALTER TABLE EMP03 DROP COLUMN JOB;
--DROP(2)
SELECT * FROM EMP02;
ALTER TABLE EMP02 DROP COLUMN MGR;

--SET UNUSED �ɼ� �����ϱ�-�÷��� �����ϴ� ���� �ƴ����� �÷��� ����� �������� ����
SELECT * FROM EMP02;
ALTER TABLE EMPO2 SET UNUSED(JOB);
ALTER TABLE EMP02 DROP UNUSED COLUMNS;

--DROP ���̺� ���� �����ϱ�
SELECT * FROM EMP01;
DROP TABLE EMP01;
CREATE TABLE EMP01(
    ENAME VARCHAR2(10),
    EMPNO NUMBER(5),
    HIREDATE DATE);
SELECT * FROM EMP01;
DROP TABLE EMP01;

--TRUNCATE ���̺��� ��� �ο츦 �����Ѵ�
SELECT * FROM EMP02;
TRUNCATE TABLE EMP02;--���븸 �߸�
DESC EMP02;
DROP TABLE EMP02;

--�ǻ츮��(�������� Ȱ��)
CREATE TABLE EMP02 AS SELECT * FROM EMP;

--���̺� ���� �����ϴ� RENAME(A TO B)
RENAME EMP02 TO TEST;
SELECT * FROM TEST;

--��ųʸ� ��
SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_TABLES;
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_VIEWS;

DESC USER_TABLES;
SHOW USER;
DESC ALL_TABLES;