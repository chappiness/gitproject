--�׷��Լ�--
--���� �� �Ǵ� ���̺� ��ü�� �࿡ ���� �Լ��� ����Ǿ� �ϳ��� ������� �������� �Լ�
--SQL �Լ��� �������Լ�,�׷��Լ�
--INPUT 1��>OUTPUT 1�� �������Լ�
--INPUT 1��>OUTPUT 1�� �׷��Լ�
--GROUP BY,HAVING,COUNT,MIN,MAX

--�ϳ� �̻��� ���� �׷����� ���� �����Ͽ� ����,��� �� �ϳ��� ����� ��Ÿ��
--SUM,AVG,COUNT,MAX,MIN,STDDEV,VARIANCE
SELECT SUM(SAL),MAX(SAL),MIN(SAL),AVG(SAL),ROUND(AVG(SAL),2) FROM EMP; --��°�ڸ����� �ø�
SELECT ENAME,SAL,COMM FROM EMP;
SELECT SUM(COMM) FROM EMP;--NULL ���� �Ƚ�Ŵ
SELECT AVG(COMM) FROM EMP;--NULL ���� ����
SELECT MAX(ENAME),MIN(ENAME),MIN(HIREDATE) FROM EMP; --���ĺ� ū���� �ƽ�
SELECT MAX(HIREDATE),MIN(HIREDATE) FROM EMP; --MIN ���� MAX �ֱ�
SELECT STDDEV(SAL),STDDEV(SAL)*STDDEV(SAL),VARIANCE(SAL) FROM EMP; --�л�=ǥ�������� ����
SELECT COUNT(*),COUNT(COMM) FROM EMP; --NULL �ƴ� ģ����
--SELECT SAL,MAX(SAL),MIN(SAL) FROM EMP; �������Լ� �׷��Լ��� ��� ��� �Ұ�
SELECT COUNT(JOB),COUNT(DISTINCT JOB) FROM EMP;
��-���� ���� ���� �Ի��� ����� �Ի��ϰ� �Ի����� ���� ������ ����� �Ի����� ���
SELECT MIN(TO_CHAR(HIREDATE,'YY/MM/DD:')),MIN(TRUNC(SYSDATE-HIREDATE)) FROM EMP;
SELECT MAX(TO_CHAR(HIREDATE,'YY/MM/DD:')),MAX(TRUNC(SYSDATE-HIREDATE)) FROM EMP;
��-10�� �μ� �Ҽ��� ��� �߿��� Ŀ�̼��� �޴� ����� ���� ���� ���ÿ�
SELECT COUNT(ENAME) FROM EMP WHERE DEPTNO=10;

--GROUP BY ��:� �÷� ���� �������� �׷��Լ��� ������ ��쿡 ��,�ڿ��� ��Ī �� �� ����
--FORMAT SELECT �÷���,�׷��Լ� FROM ���̺�� WHERE ���� GROUP BY �÷���
--�μ��� �޿� ���
SELECT DEPTNO,ROUND(AVG(SAL),2) FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO;
SELECT DEPTNO,COUNT(*),COUNT(COMM) FROM EMP GROUP BY DEPTNO;

--�׷��Լ� HAVING ���� (SELECT/FROM/WHERE/GROUP BY/HAVINGM/ORDER BY)
SELECT DEPTNO,AVG(SAL) FROM EMP GROUP BY DEPTNO HAVING AVG(SAL)>=2000;
SELECT DEPTNO,MAX(SAL),MIN(SAL) FROM EMP GROUP BY DEPTNO HAVING MAX(SAL)>2900;

--��� ���� ���� ���� �� ����<<ROLLUP Ȱ��
SELECT DEPTNO,SUM(SAL) FROM EMP GROUP BY DEPTNO;
SELECT DEPTNO,SUM(SAL) FROM EMP GROUP BY ROLLUP(DEPTNO);
SELECT DEPTNO,JOB,SUM(SAL) FROM EMP GROUP BY ROLLUP(DEPTNO,JOB);
SELECT DEPTNO,JOB,TRUNC(AVG(SAL)) FROM EMP GROUP BY ROLLUP(DEPTNO,JOB);

--��	Guidelines
--(1)	SELECT ���� �׷��Լ��� ���Եȴٸ� GROUP BY ���� ������ ���� ��õǾ�� �Ѵ�.
--(2)	WHERE ���� ����Ͽ� ���� �׷����� ������ ���� ���� �����Ѵ�
--(3)	�׷쿡 ���� ������ HAVING ���� ����Ѵ�(�׷쿡 ���� ������ WHERE������ ��� �Ұ�)
--(4)	GROUP BY ���� ���� �����Ѵ�(���� ��Ī�� ����� �� ����)
--(5)	DEFAULT�� GROUP BY �� ������ ����� ������ ������������ ���ĵ����� ORDER BY ���� �̿��Ͽ� ���氡���ϴ�

-- 1. ��� ���̺��� �ο���,�ִ� �޿�,�ּ� �޿�,�޿��� ���� ����Ͽ� ���
SELECT COUNT(*),MAX(SAL),MIN(SAL),SUM(SAL) FROM EMP;
-- 2. ������̺��� ������ �ο����� ���Ͽ� ����ϴ� SELECT ������ �ۼ��Ͽ���.
SELECT JOB,COUNT(*) FROM EMP GROUP BY JOB;
--- 3. ������̺��� �ְ� �޿��� �ּ� �޿��� ���̴� ���ΰ� ����ϴ� SELECT������ �ۼ��Ͽ���.
SELECT MAX(SAL)-MIN(SAL) FROM EMP;
-- 4. �� �μ����� �ο���, �޿� ���, ���� �޿�, �ְ� �޿�, �޿��� ���� ����ϵ� �޿��� ���� ���� ������ ����϶�.
SELECT DEPTNO,COUNT(DEPTNO),ROUND(AVG(SAL),2),MIN(SAL),MAX(SAL),SUM(SAL)�޿��� FROM EMP GROUP BY DEPTNO ORDER BY �޿���;
-- 5. �μ���, ������ �׷��Ͽ� ����� �μ���ȣ, ����, �ο���, �޿��� ���, �޿��� ���� 
    --���Ͽ� ����϶�(��°���� �μ���ȣ, ���������� �������� ����)
SELECT DEPTNO,JOB,COUNT(*),AVG(SAL),SUM(SAL) FROM EMP GROUP BY DEPTNO,JOB ORDER BY DEPTNO,JOB;
-- 6. ������, �μ��� �׷��Ͽ� �����  ����, �μ���ȣ, �ο���, �޿��� ���, �޿��� ���� ���Ͽ� 
-- ����϶�.(��°���� ������, �μ���ȣ �� �������� ����)
SELECT JOB,DEPTNO,COUNT(*),AVG(SAL),SUM(SAL) FROM EMP GROUP BY DEPTNO,JOB ORDER BY JOB,DEPTNO;
--7. ������� 5���̻� �Ѵ� �μ���ȣ�� ������� ����Ͻÿ�.
SELECT DEPTNO,COUNT(*) FROM EMP GROUP BY DEPTNO HAVING COUNT(*)>=5;
-- 8. ������� 5���̻� �Ѵ� �μ���� ������� ����Ͻÿ�
SELECT DNAME,COUNT(*) FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO GROUP BY DNAME HAVING COUNT(*)>=5;
--9. ��� ���̺��� ������ �޿��� ����� 3000�̻��� ������ ���ؼ� ������, ��� �޿�, 
--�޿��� ���� ���Ͽ� ����϶�
SELECT JOB,ROUND(AVG(SAL),2),SUM(SAL) FROM EMP GROUP BY JOB HAVING AVG(SAL)>3000;
--10. ������̺��� �޿����� 5000�� �ʰ��ϴ� �� ������ ���ؼ� ������ �޿��հ踦 ����϶� 
        --��, �޿� �հ�� �������� �����϶�.
SELECT JOB,SUM(SAL) FROM EMP GROUP BY JOB HAVING SUM(SAL)>5000 ORDER BY SUM(SAL) DESC;
--11. �μ��� �޿����, �μ��� �޿��հ�, �μ��� �ּұ޿��� ����϶�.
SELECT DEPTNO,ROUND(AVG(SAL),2),SUM(SAL),MIN(SAL) FROM EMP GROUP BY DEPTNO;
--12. ���� 11���� �����Ͽ�, �μ��� �޿���� �ִ�ġ, �μ��� �޿����� �ִ�ġ, 
            --�μ��� �ּұ޿��� �ִ�ġ�� ����϶�.
SELECT DEPTNO,ROUND(AVG(SAL),2),MAX(SAL),MIN(SAL) FROM EMP GROUP BY DEPTNO;
--13. ��� ���̺��� �Ʒ��� ����� ����ϴ� SELECT ������ �ۼ��Ͽ���.(�⵵�� ������)
--   H_YEAR	COUNT(*)	MIN(SAL)	MAX(SAL)	AVG(SAL)	SUM(SAL)
--     80	  1		    800		    800		    800		    800
--	81	 10		    950		    5000	    2282.5	  22825
--	82	  2		    1300	    3000	   2150		   4300
--	83	  1		    1100	    1100	    1100	   1100
 SELECT TO_CHAR(HIREDATE,'YY') �⵵,MIN(SAL),MAX(SAL),AVG(SAL),SUM(SAL) 
                                    FROM EMP GROUP BY TO_CHAR(HIREDATE,'YY') ORDER BY �⵵;
-- 14.  ������̺��� �Ʒ��� ����� ����ϴ� SELECT �� �ۼ�
--  1980     1	
--  1981     10
--  1982     2
--  1983     1
--  total    14	
SELECT EXTRACT(YEAR FROM HIREDATE) FROM EMP; #���ڸ��� ����
SELECT DEPTNO,SUM(SAL),SUM(SUM(SAL)) FROM EMP GROUP BY DEPTNO;
SELECT NVL(TO_CHAR(EXTRACT(YEAR FROM HIREDATE)),'TOTAL') �⵵,COUNT(*)
                                    FROM EMP GROUP BY ROLLUP(EXTRACT(YEAR FROM HIREDATE)) ORDER BY �⵵;
--15. ������̺��� �ִ�޿�, �ּұ޿�, ��ü�޿���, ����� ���Ͻÿ�
SELECT MAX(SAL),MIN(SAL),SUM(SAL),ROUND(AVG(SAL),2) FROM EMP;
--16. ������̺��� �μ��� �ο����� ���Ͻÿ�
SELECT DEPTNO,COUNT(*) FROM EMP GROUP BY DEPTNO;
--17. ��� ���̺��� �μ��� �ο����� 6���̻��� �μ��ڵ带 ���Ͻÿ�
SELECT DEPTNO,COUNT(*) FROM EMP GROUP BY DEPTNO HAVING COUNT(*)>=6;
--18. ������̺��� �޿��� ���� ������� ����� �ο��Ͽ� ������ ���� ����� ������ �Ͻÿ�. 
-- (��Ʈ self join, group by, count���)
--ENAME	    ���
--________________________
--KING		1
--SCOTT		2
--����
SELECT ENAME,SAL FROM EMP ORDER BY SAL DESC,ENAME DESC;
SELECT E1.ENAME,E1.SAL,E2.ENAME,E2.SAL FROM EMP E1,EMP E2 WHERE E1.SAL<E2.SAL(+); --SELF JOIN
SELECT E1.ENAME,COUNT(E2.ENAME)+1 RANK FROM EMP E1,EMP E2 
                                WHERE E1.SAL<E2.SAL(+) GROUP BY E1.ENAME ORDER BY RANK;
SELECT ENAME, RANK() OVER(ORDER BY SAL DESC) "RANK",
              DENSE_RANK() OVER(ORDER BY SAL DESC) "DENSE_RANK",
              ROW_NUMBER() OVER(ORDER BY SAL DESC) "ROW_NUM"
        FROM EMP; -- �Լ� ���