--JOIN 2�� �̻��� ���̺��� �����Ͽ� �����͸� �˻��ϴ� ���
SELECT * FROM EMP; --DEPTNO 14��
SELECT * FROM DEPT; --DEPTNO,DNAME,LOC 4��
SELECT * FROM SALGRADE; --GRADE,LOSAL,HISAL

--JOIN ���� �Ѵٸ�
--���̽��� �μ��̸�>>RESEARCH
SELECT * FROM EMP;
SELECT DEPTNO FROM EMP WHERE ENAME='SMITH';
SELECT DNAME FROM DEPT WHERE DEPTNO=20; 

--ũ�ν� ���� #Ű���� ���� ���̺� ����Ǵ� ���
SELECT * FROM EMP,DEPT; 56��

--���� ���� ������ �÷� �������� ����
SELECT ENAME,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;

--smith�� �μ��̸�,�μ���ġ
SELECT DNAME,LOC FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND ENAME='SMITH';

--smith�� �μ��̸�,�μ���ġ,�Ŵ���
SELECT DNAME,LOC,MGR FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND ENAME='SMITH';

--KING �μ��̸�,�μ���ġ,�Ŵ���
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT ENAME,DNAME,JOB,LOC,D.DEPTNO FROM EMP E,DEPT D 
                                        WHERE E.DEPTNO=D.DEPTNO AND ENAME='KING';
--	Equi Join : ������ �÷��� �������� ����
��-	Non-Equi Join : ������ �÷����� �ٸ� ������ ����Ͽ� ����
��-	Outer Join : ���� ���ǿ� �������� �ʴ� �൵ ��Ÿ���� ����
��-	Self Join : �� ���̺� ������ ����.

--��������-�μ���,�μ�������,�μ���ȣ
SELECT EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,E.DEPTNO,DNAME,LOC FROM EMP E,DEPT D
                                        WHERE E.DEPTNO=D.DEPTNO;
                                        
--?	���, �̸�, �޿�, �μ��ڵ�, �μ���
SELECT ENAME,SAL,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;

--?	�̸�, ����, �޿�, �μ���, �ٹ���. �޿��� 2000�̻�
SELECT ENAME,JOB,SAL,DNAME,LOC,SAL FROM EMP E,DEPT D 
                                    WHERE E.DEPTNO=D.DEPTNO AND SAL>2000;

--�̸�, ����, �μ���, �ٹ���. �ٹ����� CHICAGO�� ���
SELECT ENAME,JOB,DNAME,LOC FROM EMP E,DEPT D 
                                    WHERE E.DEPTNO=D.DEPTNO AND LOC='CHICAGO';                                     

--�̸�, ����, �ٹ���. deptno�� 10 �Ǵ� 20�� ���, �޿���
SELECT ENAME,JOB,LOC,D.DEPTNO,SAL FROM EMP E,DEPT D
WHERE E.DEPTNO=D.DEPTNO AND D.DEPTNO IN (10,20) ORDER BY SAL; --��������

--�̸�, �޿�, comm, ����(��Ī), �μ���, �ٹ���. ����
SELECT ENAME,SAL,COMM,SAL*12 ����,DNAME,LOC FROM EMP E,DEPT D
                                        WHERE E.DEPTNO=D.DEPTNO ORDER BY SAL;

--������ job�� salesman �Ǵ� manager ����̰� ������ ū�� ����
SELECT ENAME,SAL,COMM,SAL*12+NVL(COMM,0) ����,DNAME,LOC,JOB FROM EMP E,DEPT D
                                        WHERE E.DEPTNO=D.DEPTNO AND JOB IN ('SALESMAN','MANAGER')
                                        ORDER BY ���� DESC;

--�̸�, �޿�, �Ի���, �μ��ڵ�, �μ��� comm�� null�̰� �޿��� 1200�̻��� ���. �μ���� ����. �μŸ��� ������ �޿�ū��
SELECT ENAME,SAL,HIREDATE,D.DEPTNO,DNAME,COMM FROM EMP E,DEPT D 
                                        WHERE E.DEPTNO=D.DEPTNO AND SAL>1200 AND COMM IS NULL ORDER BY DNAME,SAL DESC;

��-���忡�� �ٹ��ϴ� ����� �̸��� �޿��� ����Ͻÿ�
SELECT ENAME,SAL,LOC FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO AND LOC='NEW YORK';

��- ACCOUNTING �μ� �Ҽ� ����� �̸��� �Ի����� ����Ͻÿ�
SELECT ENAME,HIREDATE,DNAME FROM EMP E,DEPT D 
                                    WHERE D.DEPTNO=E.DEPTNO AND DNAME='ACCOUNTING';
��-������ MANAGER�� ����� �̸�, �μ����� ����Ͻÿ�
SELECT ENAME,DNAME FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO AND JOB='MANAGER';

��-Comm�� null�� �ƴ� ����� �̸�, �޿�, �μ��ڵ�, �ٹ����� ����Ͻÿ�.
SELECT ENAME,SAL,D.DEPTNO,LOC,COMM FROM EMP E,DEPT D 
                            WHERE D.DEPTNO=E.DEPTNO AND COMM IS NOT NULL;
SELECT ENAME,SAL,D.DEPTNO,LOC,COMM FROM EMP E,DEPT D 
                            WHERE D.DEPTNO=E.DEPTNO AND COMM IS NULL;                           
--NOT EQUAL JOIN >>���� ���ǿ� Ư�� ���� ���� �ִ��� �����ϱ� ���� ��
SELECT * FROM EMP;
SELECT * FROM DEPT; --DEPTNO,DNAME,LOC
SELECT * FROM SALGRADE; --GRADE,LOSAL,HISAL
--CROSS JOIN
SELECT * FROM EMP,SALGRADE; --14*5=70��

--NOT EQUAL JOIN
SELECT ENAME,JOB,SAL,GRADE FROM EMP,SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL;
SELECT EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,GRADE,NVL(COMM,0),DEPTNO FROM EMP E,SALGRADE S
                                WHERE SAL BETWEEN LOSAL AND HISAL;
--ALLEN �ٹ���ġ,�μ��̸�,����,���޵��
SELECT ENAME,LOC,DNAME,SAL,GRADE FROM EMP E,DEPT D,SALGRADE S
                                            WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;

��-Comm�� null�� �ƴ� ����� �̸�, �޿�, ���, �μ���ȣ, �μ��̸�, �ٹ����� ����Ͻÿ�.
SELECT ENAME,SAL,GRADE,E.DEPTNO,DNAME,LOC FROM EMP E,DEPT D,SALGRADE
                                    WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;
--�̸�, �޿�, �Ի���, �޿����
SELECT ENAME,SAL,HIREDATE,GRADE FROM EMP E,DEPT D,SALGRADE
                                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;
--�̸�, �޿�, �Ի���, �޿����, �μ���, �ٹ���
SELECT ENAME,SAL,HIREDATE,GRADE,DNAME,LOC FROM EMP E,DEPT D,SALGRADE
                                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
                                ORDER BY GRADE,HIREDATE;
--�̸�, �޿�, ���, �μ��ڵ�, �ٹ���. �� comm �� null�ƴ� ���
SELECT ENAME,SAL,GRADE,D.DEPTNO,LOC,COMM FROM EMP E,DEPT D,SALGRADE
                                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
                                AND COMM IS NOT NULL ORDER BY GRADE;
--�̸�, �޿�, �޿����, ����, �μ���, �μ��� ���, �μ��� ������ ������. ����=(sal+comm)*12 comm�� null�̸� 0
SELECT ENAME,SAL,GRADE,SAL*12+NVL(COMM,0) ����,DNAME,D.DEPTNO FROM EMP E,SALGRADE,DEPT D
                                    WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY DNAME,���� DESC;
--�̸�, ����, �޿�, ���, �μ��ڵ�, �μ��� ���. �޿��� 1000~3000����. �������� : �μ���, �μ������� ������, ���������� �޿� ū��
SELECT ENAME,JOB,SAL,GRADE,E.DEPTNO,DNAME FROM EMP E,DEPT D,SALGRADE
                                    WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN 1000 AND 3000
                                    AND SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY DNAME,JOB,SAL DESC;
--�̸�, �޿�, ���, �Ի���, �ٹ���. 81�⿡ �Ի��� ���. ��� ū��
SELECT ENAME,GRADE,HIREDATE,LOC FROM EMP E,DEPT D,SALGRADE
                            WHERE E.DEPTNO=D.DEPTNO AND HIREDATE LIKE '81%' AND
                            SAL BETWEEN LOSAL AND HISAL ORDER BY GRADE;