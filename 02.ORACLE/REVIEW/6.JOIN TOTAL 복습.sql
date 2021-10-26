SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;

SELECT ENAME,DEPTNO,SAL*12+NVL(COMM,0)���� FROM EMP ORDER BY ����;
SELECT ENAME,DNAME,E.DEPTNO,SAL*12+NVL(COMM,0) ����,GRADE FROM EMP E,DEPT D,SALGRADE S
                                WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN LOSAL AND HISAL ORDER BY ����;

--����,�����ٹ���,��������,�������,���,���ٹ���,������,�����>>��������,��������,����������
SELECT W.ENAME ����,D1.LOC "���� �ٹ���",W.SAL ����,S1.GRADE �������,M.ENAME ���,
                                D2.LOC "��� �ٹ���",M.SAL "��� ����",S2.GRADE �����
                                FROM EMP W,EMP M,DEPT D1,DEPT D2,SALGRADE S1,SALGRADE S2
                                WHERE W.DEPTNO=D1.DEPTNO AND M.DEPTNO=D2.DEPTNO AND W.MGR=M.EMPNO AND
                                W.SAL BETWEEN S1.LOSAL AND S1.HISAL AND M.SAL BETWEEN S2.LOSAL AND S2.HISAL;
--JONES�� �Ŵ��� �̸�,�Ŵ��� �Ҽ�
SELECT M.ENAME,M.DEPTNO,D.DNAME FROM EMP W,EMP M,DEPT D WHERE W.MGR=M.EMPNO AND D.DEPTNO=M.DEPTNO
                                                            AND W.ENAME='JONES';
--������ �Ŵ��� �̸�>>ŷ�� ����.�ƿ��� ����             ������ �Ŵ���,�Ŵ��� �̸�
SELECT W.ENAME ����,M.ENAME ��� FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;

--������ �Ŵ��� �̸�>>ŷ�� ����.�ƿ��� ����>������ �Ŵ��� ������
SELECT W.ENAME ����,M.ENAME ��� FROM EMP W,EMP M WHERE W.MGR=M.EMPNO(+);

--���ܻ�� ��� 
SELECT W.ENAME ����,M.ENAME ��� FROM EMP W,EMP M WHERE W.MGR(+)=M.EMPNO;

--�̸�, ����, �μ��ڵ�, �μ��� (������ ���� �μ��� ���)
SELECT ENAME,JOB,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;
SELECT ENAME,JOB,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO(+)=D.DEPTNO;

-- FORD�� �Ŵ����� JONES�Դϴ�.
SELECT M.ENAME FROM EMP M,EMP W WHERE W.MGR=M.EMPNO AND W.ENAME='FORD';

-- KING�� �Ŵ����� ���Դϴ�.
SELECT W.ENAME||'�� �Ŵ����� '|| NVL(M.ENAME,'��')||'�Դϴ�.' FROM EMP M,EMP W WHERE W.MGR=M.EMPNO(+) AND W.ENAME='KING';

--��� �̸��� �μ���ȣ,�μ��� ���
SELECT ENAME,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO(+)=D.DEPTNO;

--1. �̸�, ���ӻ��
SELECT W.ENAME,M.ENAME FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;

--2. �̸�, �޿�, ����, ���ӻ��
SELECT W.ENAME,W.SAL,W.JOB,M.ENAME FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;

--3. �̸�, �޿�, ����, ���ӻ��. (��簡 ���� �������� ��ü ���� �� ���.
--��簡 ���� �� '����'���� ���)
SELECT W.ENAME,W.SAL,W.JOB,NVL(M.ENAME,'����')��� FROM EMP W,EMP M WHERE W.MGR=M.EMPNO(+);

--4. �̸�, �޿�, �μ���, ���ӻ���
SELECT W.ENAME ����,W.SAL ��������,DNAME �����μ���,M.ENAME ���� FROM EMP W,EMP M,DEPT D 
                                    WHERE W.MGR=M.EMPNO AND W.DEPTNO=D.DEPTNO;  

--5. �̸�, �޿�, �μ��ڵ�, �μ���, �ٹ���, ���ӻ���, (��簡 ���� �������� ��ü ���� �� ���)
SELECT W.ENAME,W.SAL,W.DEPTNO,DNAME,LOC,M.ENAME FROM EMP W,EMP M,DEPT D
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO;
SELECT W.ENAME,W.SAL,W.DEPTNO,DNAME,LOC,M.ENAME �Ŵ��� FROM EMP W,EMP M,DEPT D
                                    WHERE W.MGR=M.EMPNO(+) AND D.DEPTNO=W.DEPTNO;
                                    
-- 6. �̸�, �޿�, ���, �μ���, ���ӻ���. �޿��� 2000�̻��� ���
SELECT W.ENAME,W.SAL,GRADE,DNAME,M.ENAME,W.SAL FROM EMP W,EMP M,SALGRADE,DEPT D
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO AND 
                                    W.SAL BETWEEN LOSAL AND HISAL AND W.SAL>2000;
--7. �̸�, �޿�, ���, �μ���, ���ӻ���, (���ӻ�簡 ���� �������� ��ü���� �μ��� �� ����)
SELECT W.ENAME,W.SAL,GRADE,DNAME,M.ENAME,W.SAL FROM EMP W,EMP M,SALGRADE,DEPT D
                                    WHERE W.MGR=M.EMPNO(+) AND D.DEPTNO=W.DEPTNO AND 
                                    W.SAL BETWEEN LOSAL AND HISAL;
--8. �̸�, �޿�, ���, �μ���, ����, ���ӻ���. ����=(�޿�+comm)*12 �� comm�� null�̸� 0
SELECT W.ENAME ���� ,W.SAL �޿�,GRADE ���,DNAME �μ��� ,M.ENAME �Ŵ��� ,W.SAL*12+NVL(W.COMM,0) ����
                                    FROM EMP W,EMP M,DEPT D,SALGRADE
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO AND
                                    W.SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY ����;
--9. 8���� �μ��� �� �μ��� ������ �޿��� ū �� ����
SELECT W.ENAME ���� ,W.SAL �޿�,GRADE ���,DNAME �μ��� ,M.ENAME �Ŵ��� ,W.SAL*12+NVL(W.COMM,0) ����
                                    FROM EMP W,EMP M,DEPT D,SALGRADE
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO AND
                                    W.SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY �μ���,�޿� DESC;

--  PART2
--1.EMP ���̺��� ��� ����� ���� �̸�,�μ���ȣ,�μ����� ����ϴ� SELECT ������ �ۼ��Ͽ���.
SELECT ENAME,E.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;
--2. EMP ���̺��� NEW YORK���� �ٹ��ϰ� �ִ� ����� ���Ͽ� �̸�,����,�޿�,�μ����� ���
SELECT ENAME,JOB,SAL,GRADE,E.DEPTNO,DNAME FROM EMP E,DEPT D,SALGRADE 
                                    WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;
--3. EMP ���̺��� ���ʽ��� �޴� ����� ���Ͽ� �̸�,�μ���,��ġ�� ���
SELECT ENAME,DNAME,LOC,SAL,COMM FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL;
SELECT * FROM EMP;
--4. EMP ���̺��� �̸� �� L�ڰ� �ִ� ����� ���Ͽ� �̸�,����,�μ���,��ġ�� ���
SELECT ENAME,JOB,DNAME,LOC FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO AND ENAME LIKE '%L%';
--5. ���, �����, �μ��ڵ�, �μ����� �˻��϶�. ������������ ������������
SELECT EMPNO,ENAME �����,E.DEPTNO,DNAME FROM EMP E,DEPT D 
                            WHERE D.DEPTNO=E.DEPTNO ORDER BY �����;
--6. ���, �����, �޿�, �μ����� �˻��϶�. 
    --�� �޿��� 2000�̻��� ����� ���Ͽ� �޿��� �������� ������������ �����Ͻÿ�
SELECT EMPNO,ENAME,SAL �޿�,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND 
                                                    SAL>2000 ORDER BY �޿� DESC;
--7. ���, �����, ����, �޿�, �μ����� �˻��Ͻÿ�. �� ������ MANAGER�̸� �޿��� 2500�̻���
-- ����� ���Ͽ� ����� �������� ������������ �����Ͻÿ�.
SELECT EMPNO,ENAME,JOB,SAL,DNAME FROM EMP E,DEPT D 
                                    WHERE E.DEPTNO=D.DEPTNO AND JOB='MANAGER' AND
                                    SAL>2500 ORDER BY EMPNO DESC;
--8. ���, �����, ����, �޿�, ����� �˻��Ͻÿ�. ��, �޿����� ������������ �����Ͻÿ�
SELECT EMPNO,ENAME,JOB,SAL,GRADE FROM EMP,SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL ORDER BY SAL DESC;
--9. ������̺��� �����, ����� ��縦 �˻��Ͻÿ�(��簡 ���� �������� ��ü)
SELECT W.ENAME �����,M.ENAME ��� FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;
SELECT W.ENAME �����,M.ENAME ��� FROM EMP W,EMP M WHERE W.MGR=M.EMPNO(+);
--10. �����, ����, ����� ������ �˻��Ͻÿ�
SELECT W.ENAME ���,M1.ENAME �븮,M2.ENAME ���� FROM EMP W,EMP M1,EMP M2 
                                    WHERE W.MGR=M1.EMPNO AND M1.MGR=M2.EMPNO;
--11. ���� ������� ���� ��簡 ���� ��� ������ �̸��� ��µǵ��� �����Ͻÿ�
SELECT W.ENAME ���,M1.ENAME �븮,M2.ENAME ���� FROM EMP W,EMP M1,EMP M2 
                                    WHERE W.MGR=M1.EMPNO AND M1.MGR=M2.EMPNO(+);
SELECT W.ENAME ���,M1.ENAME �븮,M2.ENAME ���� FROM EMP W,EMP M1,EMP M2 
                                    WHERE W.MGR=M1.EMPNO(+) AND M1.MGR=M2.EMPNO(+);                                    