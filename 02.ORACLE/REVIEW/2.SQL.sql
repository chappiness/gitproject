SELECT * FROM EMP;
SELECT ENAME,SAL FROM EMP WHERE SAL BETWEEN 1000 AND 2000;
SELECT ENAME,SAL FROM EMP WHERE SAL NOT BETWEEN 1000 AND 2000;
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE FROM EMP WHERE EMPNO IN (7902,7934);
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE FROM EMP WHERE SAL IN (3500,3000);
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE FROM EMP WHERE SAL IN (200,100);
-----------------------------------------------------------------------
-- 2.LIKE
SELECT ENAME,MGR,SAL FROM EMP;
SELECT ENAME,MGR,SAL FROM EMP WHERE ENAME LIKE 'M%'; --ó���� ������ �����Ҷ�
SELECT ENAME,MGR,SAL FROM EMP WHERE ENAME LIKE '%M%'; --�߰��� ��������
SELECT ENAME,MGR,SAL FROM EMP WHERE ENAME LIKE '%S'; --���� S�� ���� ��
SELECT ENAME,MGR FROM EMP WHERE ENAME LIKE '_L%'; --�ι�°�� ���� ������

--EMP ���̺��� hiredate�� 1982���� ����� empno,ename,job,sal,hiredate,deptno �� ����Ͻÿ�
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE,DEPTNO FROM EMP 
                                WHERE HIREDATE BETWEEN '82/01/01' AND '82/12/31';
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE,DEPTNO FROM EMP WHERE HIREDATE LIKE '82%';
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE,DEPTNO FROM EMP WHERE HIREDATE LIKE '___12%';
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE,DEPTNO FROM EMP 
                                WHERE HIREDATE>=TO_DATE('1982/01/01','yyyy/mm/dd') AND
                                HIREDATE<=TO_DATE('1982/12/31','yyyy/mm/dd');
                                
-- EMP ���̺��� �Ի����� 1���� ����� EMPNO, ENAME, JOB, SAL, HIREDATE�� ����Ͻÿ�
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE FROM EMP WHERE HIREDATE LIKE '___01%';
SELECT EMPNO,ENAME,JOB,SAL,HIREDATE FROM EMP WHERE HIREDATE LIKE '__/01/__';

--IN ����
SELECT ENAME,DEPTNO FROM EMP WHERE DEPTNO IN (10,30);
SELECT ENAME,DEPTNO FROM EMP WHERE DEPTNO NOT IN (10,30);
SELECT * FROM EMP;
SELECT EMPNO,ENAME,JOB,SAL,DEPTNO FROM EMP WHERE JOB IN ('CLERK','ANALYST');
SELECT EMPNO,ENAME,JOB,SAL,DEPTNO FROM EMP WHERE JOB NOT IN ('CLERK','ANALYST');

--ODER BY ����
SELECT ENAME,EMPNO,JOB,HIREDATE FROM EMP ORDER BY HIREDATE;
SELECT ENAME,EMPNO,JOB FROM EMP ORDER BY EMPNO DESC; --��������
SELECT ENAME,EMPNO,JOB FROM EMP ORDER BY EMPNO; --��������
SELECT * FROM EMP;
SELECT * FROM EMP ORDER BY SAL;
SELECT ENAME,SAL FROM EMP ORDER BY SAL DESC;

--������ ���� �ͺ��� ������� ���(������ ������ �Ի��Ϸ� ������ ��� ������ ����)
SELECT * FROM EMP ORDER BY SAL,HIREDATE DESC; --��������
--% ����
SELECT ENAME,EMPNO,JOB FROM EMP WHERE ENAME LIKE '%K';
SELECT ENAME,EMPNO,JOB FROM EMP WHERE ENAME LIKE 'K%';

--1.EMP ���̺��� sal�� 3000�̻��� ����� empno, ename, job, sal�� ���
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE SAL>3000;
--2.EMP ���̺��� empno�� 7788�� ����� ename�� deptno�� ���
SELECT ENAME,DEPTNO FROM EMP WHERE EMPNO=7788;
--3.����(SAL*12+COMM)�� 24000�̻��� ���, �̸�, �޿� ��� (�޿�������)
SELECT EMPNO,ENAME,SAL,SAL*12+NVL(COMM,0) ���� FROM EMP 
                                    WHERE SAL*12+NVL(COMM,0)>24000 ORDER BY ����;
--4.EMP ���̺��� hiredate�� 1981�� 2�� 20�� 1981�� 5�� 1�� ���̿� �Ի��� ����� 
--ename,job,hiredate�� ����ϴ� SELECT ������ �ۼ� (�� hiredate ������ ���)
SELECT ENAME,JOB,HIREDATE �Ի��� FROM EMP 
                    WHERE HIREDATE BETWEEN '81/02/20' AND '81/05/01' ORDER BY �Ի��� DESC;
--5.EMP ���̺��� deptno�� 10,20�� ����� ��� ������ ��� (�� ename������ ����)
SELECT * FROM EMP WHERE DEPTNO IN (10,20) ORDER BY ENAME;
SELECT * FROM EMP WHERE DEPTNO=10 OR DEPTNO=20 ORDER BY ENAME;
--6.EMP ���̺��� sal�� 1500�̻��̰� deptno�� 10,30�� ����� ename�� sal�� ���
-- (�� TITLE�� employee�� Monthly Salary�� ���)
SELECT ENAME ����� ,SAL ���� FROM EMP WHERE SAL>1500 AND DEPTNO IN (10,30);
--7.EMP ���̺��� hiredate�� 1982���� ����� ��� ������ ���
SELECT * FROM EMP WHERE HIREDATE LIKE '82%' ORDER BY HIREDATE;

--8.�̸��� ù�ڰ� C����  P�� �����ϴ� ����� �̸�, �޿� �̸��� ����
SELECT * FROM EMP;
SELECT ENAME,SAL FROM EMP WHERE ENAME LIKE 'C%';
SELECT ENAME,SAL FROM EMP WHERE ENAME BETWEEN 'B' AND 'C'; --�ڿ� ���� �ȵ�
SELECT ENAME,SAL FROM EMP WHERE ENAME BETWEEN 'C' AND 'Q';

--9.EMP ���̺��� comm�� sal���� 10%�� ���� ��� ����� ���Ͽ� �̸�, �޿�, �󿩱��� 
--����ϴ� SELECT ���� �ۼ� 
SELECT ENAME,SAL,COMM FROM EMP WHERE COMM>SAL*0.1;

--10.EMP ���̺��� job�� CLERK�̰ų� ANALYST�̰� sal�� 1000,3000,5000�� �ƴ� ��� ����� ������ ���
SELECT * FROM EMP WHERE JOB='CLERK' OR JOB='ANALYST' AND SAL NOT IN (1000,3000,5000);

--11.EMP ���̺��� ename�� L�� �� �ڰ� �ְ� deptno�� 30�̰ų� �Ǵ� mgr�� 7782�� ����� 
--��� ������ ����ϴ� SELECT ���� �ۼ��Ͽ���.
SELECT * FROM EMP WHERE ENAME LIKE '%LL%';
SELECT * FROM EMP WHERE ENAME LIKE '%L%';
--12.��� ���̺��� �Ի����� 81�⵵�� ������ ���,�����, �Ի���, ����, �޿��� ���
SELECT EMPNO,ENAME,HIREDATE,JOB,SAL FROM EMP WHERE HIREDATE LIKE '81%';
--13.��� ���̺��� �Ի�����81���̰� ������ 'SALESMAN'�� �ƴ� ������ ���, �����, �Ի���, 
-- ����, �޿��� �˻��Ͻÿ�.
SELECT EMPNO,ENAME,HIREDATE,JOB,SAL FROM EMP WHERE HIREDATE LIKE '81%' AND JOB='SALESMAN';
SELECT EMPNO,ENAME,HIREDATE,JOB,SAL FROM EMP WHERE HIREDATE LIKE '81%' AND JOB!='SALESMAN';
--14.��� ���̺��� ���, �����, �Ի���, ����, �޿��� �޿��� ���� ������ �����ϰ�, 
-- �޿��� ������ �Ի����� ���� ������� �����Ͻÿ�.
SELECT EMPNO,ENAME,HIREDATE,JOB,SAL FROM EMP ORDER BY SAL DESC,HIREDATE ASC;

--15.��� ���̺��� ������� �� ��° ���ĺ��� 'N'�� ����� ���, ������� �˻��Ͻÿ�
SELECT EMPNO,ENAME FROM EMP WHERE ENAME LIKE '__N%';
--16.��� ���̺�������(SAL*12)�� 35000 �̻��� ���, �����, ������ �˻� �Ͻÿ�.
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL*12>35000;