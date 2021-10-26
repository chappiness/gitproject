SELECT * FROM EMP;
SELECT * FROM DEPT;
DESC EMP;
DESC DEPT;
SELECT EMPNO,ENAME FROM EMP;
SELECT JOB,MGR FROM EMP;
SELECT HIREDATE,SAL FROM EMP;
SELECT COMM,DEPTNO FROM EMP;
-----------------------------------------------
SELECT EMPNO AS "사번",ENAME AS "이름" FROM EMP;
SELECT EMPNO 사번,ENAME 이름 FROM EMP;
SELECT JOB 직업,MGR 매니저 FROM EMP;
SELECT HIREDATE 고용일,SAL 연봉 FROM EMP;
SELECT COMM 성과금,DEPTNO 부서번호 FROM EMP;
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
SELECT ENAME 이름,JOB 직업,SAL 월급,SAL*12 연봉 FROM EMP;
-------------------------------------------------------
SELECT * FROM EMP;
SELECT * FROM EMP WHERE DEPTNO=10 AND SAL>2000;
SELECT * FROM EMP WHERE DEPTNO=20 AND SAL>1000;
SELECT * FROM EMP WHERE SAL>1000 AND SAL<2000;
SELECT * FROM EMP WHERE NOT DEPTNO=10;
SELECT * FROM EMP WHERE DEPTNO=10 OR SAL=3000;
-------------------------------------------------------
SELECT * FROM EMP;
SELECT ENAME 이름,SAL 월급,SAL+300 올린월급 FROM EMP;
SELECT ENAME,SAL,SAL*12,SAL*12+COMM FROM EMP;
SELECT ENAME,SAL*12,SAL*12+NVL(COMM,0) FROM EMP;
--------------------------------------------------------
SELECT * FROM EMP;
SELECT ENAME ||' '|| JOB AS "EMPLOYEES" FROM EMP;
SELECT ENAME ||' '|| JOB ||' '|| SAL AS "이름/직업/연봉" FROM EMP;
SELECT ENAME ||'/'|| JOB ||'/'|| SAL AS "이름/직업/연봉" FROM EMP;
SELECT ENAME ||','|| JOB ||','|| SAL AS "이름/직업/연봉" FROM EMP;
SELECT ENAME ||'의 연봉은'|| SAL*12 AS "직원들의 연봉" FROM EMP;
---------------------------------------------------------------
SELECT * FROM EMP;
SELECT DISTINCT DEPTNO FROM EMP;
SELECT DISTINCT EMPNO,DEPTNO FROM EMP;
--------------------------------------------------------------
--1. emp 테이블의 구조 출력
DESC EMP;
--2. emp 테이블의 모든 내용을 출력 
SELECT * FROM EMP;
--3. 현 scott 계정에서 사용가능한 테이블 출력
SELECT * FROM TAB;
--4. emp 테이블에서 사번, 이름, 급여, 업무, 입사일 출력
SELECT EMPNO,ENAME,SAL,HIREDATE FROM EMP;
--5. emp 테이블에서 급여가 2000미만인 사람의 사번, 이름, 급여 출력
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL<2000;
--6. 입사일이 81/02이후에 입사한 사람의 사번, 이름, 업무, 입사일 출력
SELECT EMPNO,ENAME,JOB,HIREDATE FROM EMP WHERE HIREDATE>'81/02/01';
--7. 업무가 SALESMAN인 사람들 모든 자료 출력
SELECT * FROM EMP WHERE JOB='SALESMAN';
--8. 업무가 CLERK이 아닌 사람들 모든 자료 출력
SELECT * FROM EMP WHERE JOB='CLERK';
--9. 급여가 1500이상이고 3000이하인 사람의 사번, 이름, 급여 출력
SELECT EMPNO,ENAME,SAL FROM EMP WHERE SAL>1500 AND SAL<3000; 
--10. 부서코드가 10번이거나 30인 사람의 사번, 이름, 업무, 부서코드 출력
SELECT EMPNO,ENAME,JOB,DEPTNO FROM EMP WHERE DEPTNO=10 OR DEPTNO=30;
--11. 업무가 SALESMAN이거나 급여가 3000이상인 사람의 사번, 이름, 업무, 부서코드 출력
SELECT EMPNO,ENAME,JOB,DEPTNO FROM EMP WHERE JOB='SALESMAN' OR SAL>3000;
--12. 급여가 2500이상이고 업무가 MANAGER인 사람의 사번, 이름, 업무, 급여 출력
SELECT EMPNO,ENAME,JOB,SAL FROM EMP WHERE SAL>2500 AND JOB='MANAGER';
--13.“ename은 XXX 업무이고 연봉은 XX다” 스타일로 모두 출력(연봉은 SAL*12+COMM)
SELECT ENAME ||'은'|| JOB ||'업무이고 연봉은'|| (SAL*12+NVL(COMM,0))||'이다' FROM EMP;