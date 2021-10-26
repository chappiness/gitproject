SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;

SELECT ENAME,DEPTNO,SAL*12+NVL(COMM,0)연봉 FROM EMP ORDER BY 연봉;
SELECT ENAME,DNAME,E.DEPTNO,SAL*12+NVL(COMM,0) 연봉,GRADE FROM EMP E,DEPT D,SALGRADE S
                                WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN LOSAL AND HISAL ORDER BY 연봉;

--직원,직원근무지,직원월급,직원등급,상사,상사근무지,상사월급,상사등급>>이퀄조인,셀프조인,낫이퀄조인
SELECT W.ENAME 직원,D1.LOC "직원 근무지",W.SAL 월급,S1.GRADE 직원등급,M.ENAME 상사,
                                D2.LOC "상사 근무지",M.SAL "상사 월급",S2.GRADE 상사등급
                                FROM EMP W,EMP M,DEPT D1,DEPT D2,SALGRADE S1,SALGRADE S2
                                WHERE W.DEPTNO=D1.DEPTNO AND M.DEPTNO=D2.DEPTNO AND W.MGR=M.EMPNO AND
                                W.SAL BETWEEN S1.LOSAL AND S1.HISAL AND M.SAL BETWEEN S2.LOSAL AND S2.HISAL;
--JONES의 매니저 이름,매니저 소속
SELECT M.ENAME,M.DEPTNO,D.DNAME FROM EMP W,EMP M,DEPT D WHERE W.MGR=M.EMPNO AND D.DEPTNO=M.DEPTNO
                                                            AND W.ENAME='JONES';
--직원의 매니저 이름>>킹이 없다.아우터 조인             직원의 매니저,매니저 이름
SELECT W.ENAME 직원,M.ENAME 상사 FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;

--직원의 매니저 이름>>킹이 없다.아우터 조인>직원의 매니저 없을때
SELECT W.ENAME 직원,M.ENAME 상사 FROM EMP W,EMP M WHERE W.MGR=M.EMPNO(+);

--말단사원 출력 
SELECT W.ENAME 직원,M.ENAME 상사 FROM EMP W,EMP M WHERE W.MGR(+)=M.EMPNO;

--이름, 업무, 부서코드, 부서명 (직원이 없는 부서명 출력)
SELECT ENAME,JOB,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;
SELECT ENAME,JOB,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO(+)=D.DEPTNO;

-- FORD의 매니저는 JONES입니다.
SELECT M.ENAME FROM EMP M,EMP W WHERE W.MGR=M.EMPNO AND W.ENAME='FORD';

-- KING의 매니저는 無입니다.
SELECT W.ENAME||'의 매니저는 '|| NVL(M.ENAME,'무')||'입니다.' FROM EMP M,EMP W WHERE W.MGR=M.EMPNO(+) AND W.ENAME='KING';

--사원 이름과 부서번호,부서명 출력
SELECT ENAME,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO(+)=D.DEPTNO;

--1. 이름, 직속상사
SELECT W.ENAME,M.ENAME FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;

--2. 이름, 급여, 업무, 직속상사
SELECT W.ENAME,W.SAL,W.JOB,M.ENAME FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;

--3. 이름, 급여, 업무, 직속상사. (상사가 없는 직원까지 전체 직원 다 출력.
--상사가 없을 시 '없음'으로 출력)
SELECT W.ENAME,W.SAL,W.JOB,NVL(M.ENAME,'없음')상사 FROM EMP W,EMP M WHERE W.MGR=M.EMPNO(+);

--4. 이름, 급여, 부서명, 직속상사명
SELECT W.ENAME 직원,W.SAL 직원월급,DNAME 직원부서명,M.ENAME 상사명 FROM EMP W,EMP M,DEPT D 
                                    WHERE W.MGR=M.EMPNO AND W.DEPTNO=D.DEPTNO;  

--5. 이름, 급여, 부서코드, 부서명, 근무지, 직속상사명, (상사가 없는 직원까지 전체 직원 다 출력)
SELECT W.ENAME,W.SAL,W.DEPTNO,DNAME,LOC,M.ENAME FROM EMP W,EMP M,DEPT D
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO;
SELECT W.ENAME,W.SAL,W.DEPTNO,DNAME,LOC,M.ENAME 매니저 FROM EMP W,EMP M,DEPT D
                                    WHERE W.MGR=M.EMPNO(+) AND D.DEPTNO=W.DEPTNO;
                                    
-- 6. 이름, 급여, 등급, 부서명, 직속상사명. 급여가 2000이상인 사람
SELECT W.ENAME,W.SAL,GRADE,DNAME,M.ENAME,W.SAL FROM EMP W,EMP M,SALGRADE,DEPT D
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO AND 
                                    W.SAL BETWEEN LOSAL AND HISAL AND W.SAL>2000;
--7. 이름, 급여, 등급, 부서명, 직속상사명, (직속상사가 없는 직원까지 전체직원 부서명 순 정렬)
SELECT W.ENAME,W.SAL,GRADE,DNAME,M.ENAME,W.SAL FROM EMP W,EMP M,SALGRADE,DEPT D
                                    WHERE W.MGR=M.EMPNO(+) AND D.DEPTNO=W.DEPTNO AND 
                                    W.SAL BETWEEN LOSAL AND HISAL;
--8. 이름, 급여, 등급, 부서명, 연봉, 직속상사명. 연봉=(급여+comm)*12 단 comm이 null이면 0
SELECT W.ENAME 직원 ,W.SAL 급여,GRADE 등급,DNAME 부서명 ,M.ENAME 매니저 ,W.SAL*12+NVL(W.COMM,0) 연봉
                                    FROM EMP W,EMP M,DEPT D,SALGRADE
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO AND
                                    W.SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY 연봉;
--9. 8번을 부서명 순 부서가 같으면 급여가 큰 순 정렬
SELECT W.ENAME 직원 ,W.SAL 급여,GRADE 등급,DNAME 부서명 ,M.ENAME 매니저 ,W.SAL*12+NVL(W.COMM,0) 연봉
                                    FROM EMP W,EMP M,DEPT D,SALGRADE
                                    WHERE W.MGR=M.EMPNO AND D.DEPTNO=W.DEPTNO AND
                                    W.SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY 부서명,급여 DESC;

--  PART2
--1.EMP 테이블에서 모든 사원에 대한 이름,부서번호,부서명을 출력하는 SELECT 문장을 작성하여라.
SELECT ENAME,E.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;
--2. EMP 테이블에서 NEW YORK에서 근무하고 있는 사원에 대하여 이름,업무,급여,부서명을 출력
SELECT ENAME,JOB,SAL,GRADE,E.DEPTNO,DNAME FROM EMP E,DEPT D,SALGRADE 
                                    WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;
--3. EMP 테이블에서 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력
SELECT ENAME,DNAME,LOC,SAL,COMM FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND COMM IS NOT NULL;
SELECT * FROM EMP;
--4. EMP 테이블에서 이름 중 L자가 있는 사원에 대하여 이름,업무,부서명,위치를 출력
SELECT ENAME,JOB,DNAME,LOC FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO AND ENAME LIKE '%L%';
--5. 사번, 사원명, 부서코드, 부서명을 검색하라. 사원명기준으로 오름차순정열
SELECT EMPNO,ENAME 사원명,E.DEPTNO,DNAME FROM EMP E,DEPT D 
                            WHERE D.DEPTNO=E.DEPTNO ORDER BY 사원명;
--6. 사번, 사원명, 급여, 부서명을 검색하라. 
    --단 급여가 2000이상인 사원에 대하여 급여를 기준으로 내림차순으로 정열하시오
SELECT EMPNO,ENAME,SAL 급여,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND 
                                                    SAL>2000 ORDER BY 급여 DESC;
--7. 사번, 사원명, 업무, 급여, 부서명을 검색하시오. 단 업무가 MANAGER이며 급여가 2500이상인
-- 사원에 대하여 사번을 기준으로 오름차순으로 정열하시오.
SELECT EMPNO,ENAME,JOB,SAL,DNAME FROM EMP E,DEPT D 
                                    WHERE E.DEPTNO=D.DEPTNO AND JOB='MANAGER' AND
                                    SAL>2500 ORDER BY EMPNO DESC;
--8. 사번, 사원명, 업무, 급여, 등급을 검색하시오. 단, 급여기준 내림차순으로 정렬하시오
SELECT EMPNO,ENAME,JOB,SAL,GRADE FROM EMP,SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL ORDER BY SAL DESC;
--9. 사원테이블에서 사원명, 사원의 상사를 검색하시오(상사가 없는 직원까지 전체)
SELECT W.ENAME 사원명,M.ENAME 상사 FROM EMP W,EMP M WHERE W.MGR=M.EMPNO;
SELECT W.ENAME 사원명,M.ENAME 상사 FROM EMP W,EMP M WHERE W.MGR=M.EMPNO(+);
--10. 사원명, 상사명, 상사의 상사명을 검색하시오
SELECT W.ENAME 사원,M1.ENAME 대리,M2.ENAME 과장 FROM EMP W,EMP M1,EMP M2 
                                    WHERE W.MGR=M1.EMPNO AND M1.MGR=M2.EMPNO;
--11. 위의 결과에서 상위 상사가 없는 모든 직원의 이름도 출력되도록 수정하시오
SELECT W.ENAME 사원,M1.ENAME 대리,M2.ENAME 과장 FROM EMP W,EMP M1,EMP M2 
                                    WHERE W.MGR=M1.EMPNO AND M1.MGR=M2.EMPNO(+);
SELECT W.ENAME 사원,M1.ENAME 대리,M2.ENAME 과장 FROM EMP W,EMP M1,EMP M2 
                                    WHERE W.MGR=M1.EMPNO(+) AND M1.MGR=M2.EMPNO(+);                                    