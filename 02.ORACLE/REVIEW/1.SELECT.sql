SELECT * FROM EMP;
SELECT * FROM DEPT;
DESC EMP;
DESC DEPT;
SELECT EMPNO,ENAME FROM EMP;
SELECT JOB,MGR FROM EMP;
SELECT HIREDATE,SAL FROM EMP;
SELECT COMM,DEPTNO FROM EMP;
-----------------------------------------------
SELECT EMPNO AS "���",ENAME AS "�̸�" FROM EMP;
SELECT EMPNO ���,ENAME �̸� FROM EMP;
SELECT JOB ����,MGR �Ŵ��� FROM EMP;
SELECT HIREDATE �����,SAL ���� FROM EMP;
SELECT COMM ������,DEPTNO �μ���ȣ FROM EMP;
-----------------------------------------------
SELECT * FROM EMP;
SELECT ENAME FROM EMP WHERE DEPTNO=20;
SELECT ENAME FROM EMP WHERE SAL!=3000;
SELECT ENAME FROM EMP WHERE SAL<3000;
SELECT ENAME FROM EMP WHERE SAL>3000;
SELECT ENAME FROM EMP WHERE SAL>2000 AND SAL<3000;
-----------------------------------------------
SELECT * FROM EMP;
SELECT SAL FROM EMP WHERE ENAME='KING';
SELECT SAL,COMM FROM EMP WHERE ENAME='FORD';
SELECT ENAME FROM EMP WHERE HIREDATE>'82/01/01';
SELECT ENAME �̸�,JOB ����,SAL ����,SAL*12 ���� FROM EMP;
-------------------------------------------------------
SELECT * FROM EMP;
SELECT * FROM EMP WHERE DEPTNO=10 AND SAL>2000;
SELECT * FROM EMP WHERE DEPTNO=20 AND SAL>1000;
SELECT * FROM EMP WHERE SAL>1000 AND SAL<2000;
SELECT * FROM EMP WHERE NOT DEPTNO=10;
SELECT * FROM EMP WHERE DEPTNO=10 OR SAL=3000;
-------------------------------------------------------
SELECT * FROM EMP;
SELECT ENAME �̸�,SAL ����,SAL+300 �ø����� FROM EMP;
SELECT ENAME,SAL,SAL*12,SAL*12+COMM FROM EMP;
SELECT ENAME,SAL*12,SAL*12+NVL(COMM,0) FROM EMP;
--------------------------------------------------------
SELECT * FROM EMP;
SELECT ENAME ||' '|| JOB AS "EMPLOYEES" FROM EMP;
SELECT ENAME ||' '|| JOB ||' '|| SAL AS "�̸�/����/����" FROM EMP;
SELECT ENAME ||'/'|| JOB ||'/'|| SAL AS "�̸�/����/����" FROM EMP;
SELECT ENAME ||','|| JOB ||','|| SAL AS "�̸�/����/����" FROM EMP;
SELECT ENAME ||'�� ������'|| SAL*12 AS "�������� ����" FROM EMP;
---------------------------------------------------------------
SELECT * FROM EMP;
SELECT DISTINCT DEPTNO FROM EMP;
SELECT DISTINCT EMPNO,DEPTNO FROM EMP;
--------------------------------------------------------------
--1. emp ���̺��� ���� ���
DESC EMP;
--2. emp ���̺��� ��� ������ ��� 
SELECT * FROM EMP;
--3. �� scott �������� ��밡���� ���̺� ���
SELECT * FROM TAB;
--4. emp ���̺��� ���, �̸�, �޿�, ����, �Ի��� ���
SELECT EMPNO,ENAME,SAL,HIREDATE FROM EMP;
--5. emp ���̺��� �޿��� 2000�̸��� ����� ���, �̸�, �޿� ���
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL<2000;
--6. �Ի����� 81/02���Ŀ� �Ի��� ����� ���, �̸�, ����, �Ի��� ���
SELECT EMPNO,ENAME,JOB,HIREDATE FROM EMP WHERE HIREDATE>'81/02/01';
--7. ������ SALESMAN�� ����� ��� �ڷ� ���
SELECT * FROM EMP WHERE JOB='SALESMAN';
--8. ������ CLERK�� �ƴ� ����� ��� �ڷ� ���
SELECT * FROM EMP WHERE JOB='CLERK';
--9. �޿��� 1500�̻��̰� 3000������ ����� ���, �̸�, �޿� ���
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>1500 AND SAL<3000; 
--10. �μ��ڵ尡 10���̰ų� 30�� ����� ���, �̸�, ����, �μ��ڵ� ���
SELECT EMPNO,ENAME,JOB,DEPTNO FROM EMP WHERE DEPTNO=10 OR DEPTNO=30;
--11. ������ SALESMAN�̰ų� �޿��� 3000�̻��� ����� ���, �̸�, ����, �μ��ڵ� ���
SELECT EMPNO,ENAME,JOB,DEPTNO FROM EMP WHERE JOB='SALESMAN' OR SAL>3000;
--12. �޿��� 2500�̻��̰� ������ MANAGER�� ����� ���, �̸�, ����, �޿� ���
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE SAL>2500 AND JOB='MANAGER';
--13.��ename�� XXX �����̰� ������ XX�١� ��Ÿ�Ϸ� ��� ���(������ SAL*12+COMM)
SELECT ENAME ||'��'|| JOB ||'�����̰� ������'|| (SAL*12+NVL(COMM,0))||'�̴�' FROM EMP;