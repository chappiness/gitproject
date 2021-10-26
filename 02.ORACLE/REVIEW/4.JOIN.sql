--JOIN 2개 이상의 테이블을 연결하여 데이터를 검색하는 방법
SELECT * FROM EMP; --DEPTNO 14행
SELECT * FROM DEPT; --DEPTNO,DNAME,LOC 4행
SELECT * FROM SALGRADE; --GRADE,LOSAL,HISAL

--JOIN 없이 한다면
--스미스의 부서이름>>RESEARCH
SELECT * FROM EMP;
SELECT DEPTNO FROM EMP WHERE ENAME='SMITH';
SELECT DNAME FROM DEPT WHERE DEPTNO=20; 

--크로스 조인 #키워드 없이 테이블 연결되는 경우
SELECT * FROM EMP,DEPT; 56행

--이퀄 조인 동일한 컬럼 기준으로 조인
SELECT ENAME,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;

--smith의 부서이름,부서위치
SELECT DNAME,LOC FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND ENAME='SMITH';

--smith의 부서이름,부서위치,매니저
SELECT DNAME,LOC,MGR FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO AND ENAME='SMITH';

--KING 부서이름,부서위치,매니저
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT ENAME,DNAME,JOB,LOC,D.DEPTNO FROM EMP E,DEPT D 
                                        WHERE E.DEPTNO=D.DEPTNO AND ENAME='KING';
--	Equi Join : 동일한 컬럼을 기준으로 조인
­-	Non-Equi Join : 동일한 컬럼없이 다른 조건을 사용하여 조인
­-	Outer Join : 조인 조건에 만족하지 않는 행도 나타나는 조인
­-	Self Join : 한 테이블 내에서 조인.

--이퀄조인-부서명,부서지역명,부서번호
SELECT EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,E.DEPTNO,DNAME,LOC FROM EMP E,DEPT D
                                        WHERE E.DEPTNO=D.DEPTNO;
                                        
--?	사번, 이름, 급여, 부서코드, 부서명
SELECT ENAME,SAL,D.DEPTNO,DNAME FROM EMP E,DEPT D WHERE E.DEPTNO=D.DEPTNO;

--?	이름, 업무, 급여, 부서명, 근무지. 급여가 2000이상
SELECT ENAME,JOB,SAL,DNAME,LOC,SAL FROM EMP E,DEPT D 
                                    WHERE E.DEPTNO=D.DEPTNO AND SAL>2000;

--이름, 업무, 부서명, 근무지. 근무지가 CHICAGO인 사람
SELECT ENAME,JOB,DNAME,LOC FROM EMP E,DEPT D 
                                    WHERE E.DEPTNO=D.DEPTNO AND LOC='CHICAGO';                                     

--이름, 업무, 근무지. deptno이 10 또는 20인 경우, 급여순
SELECT ENAME,JOB,LOC,D.DEPTNO,SAL FROM EMP E,DEPT D
WHERE E.DEPTNO=D.DEPTNO AND D.DEPTNO IN (10,20) ORDER BY SAL; --오름차순

--이름, 급여, comm, 연봉(별칭), 부서명, 근무지. 연봉
SELECT ENAME,SAL,COMM,SAL*12 연봉,DNAME,LOC FROM EMP E,DEPT D
                                        WHERE E.DEPTNO=D.DEPTNO ORDER BY SAL;

--위에서 job이 salesman 또는 manager 대상이고 연봉이 큰순 정렬
SELECT ENAME,SAL,COMM,SAL*12+NVL(COMM,0) 연봉,DNAME,LOC,JOB FROM EMP E,DEPT D
                                        WHERE E.DEPTNO=D.DEPTNO AND JOB IN ('SALESMAN','MANAGER')
                                        ORDER BY 연봉 DESC;

--이름, 급여, 입사일, 부서코드, 부서명 comm이 null이고 급여가 1200이상인 경우. 부서명순 정렬. 부셔명이 같으면 급여큰순
SELECT ENAME,SAL,HIREDATE,D.DEPTNO,DNAME,COMM FROM EMP E,DEPT D 
                                        WHERE E.DEPTNO=D.DEPTNO AND SAL>1200 AND COMM IS NULL ORDER BY DNAME,SAL DESC;

­-뉴욕에서 근무하는 사원의 이름과 급여를 출력하시오
SELECT ENAME,SAL,LOC FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO AND LOC='NEW YORK';

­- ACCOUNTING 부서 소속 사원의 이름과 입사일을 출력하시오
SELECT ENAME,HIREDATE,DNAME FROM EMP E,DEPT D 
                                    WHERE D.DEPTNO=E.DEPTNO AND DNAME='ACCOUNTING';
­-직급이 MANAGER인 사원의 이름, 부서명을 출력하시오
SELECT ENAME,DNAME FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO AND JOB='MANAGER';

­-Comm이 null이 아닌 사원의 이름, 급여, 부서코드, 근무지를 출력하시오.
SELECT ENAME,SAL,D.DEPTNO,LOC,COMM FROM EMP E,DEPT D 
                            WHERE D.DEPTNO=E.DEPTNO AND COMM IS NOT NULL;
SELECT ENAME,SAL,D.DEPTNO,LOC,COMM FROM EMP E,DEPT D 
                            WHERE D.DEPTNO=E.DEPTNO AND COMM IS NULL;                           
--NOT EQUAL JOIN >>조인 조건에 특정 범위 내에 있는지 조사하기 위해 씀
SELECT * FROM EMP;
SELECT * FROM DEPT; --DEPTNO,DNAME,LOC
SELECT * FROM SALGRADE; --GRADE,LOSAL,HISAL
--CROSS JOIN
SELECT * FROM EMP,SALGRADE; --14*5=70줄

--NOT EQUAL JOIN
SELECT ENAME,JOB,SAL,GRADE FROM EMP,SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL;
SELECT EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,GRADE,NVL(COMM,0),DEPTNO FROM EMP E,SALGRADE S
                                WHERE SAL BETWEEN LOSAL AND HISAL;
--ALLEN 근무위치,부서이름,월급,월급등급
SELECT ENAME,LOC,DNAME,SAL,GRADE FROM EMP E,DEPT D,SALGRADE S
                                            WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;

­-Comm이 null이 아닌 사원의 이름, 급여, 등급, 부서번호, 부서이름, 근무지를 출력하시오.
SELECT ENAME,SAL,GRADE,E.DEPTNO,DNAME,LOC FROM EMP E,DEPT D,SALGRADE
                                    WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;
--이름, 급여, 입사일, 급여등급
SELECT ENAME,SAL,HIREDATE,GRADE FROM EMP E,DEPT D,SALGRADE
                                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL;
--이름, 급여, 입사일, 급여등급, 부서명, 근무지
SELECT ENAME,SAL,HIREDATE,GRADE,DNAME,LOC FROM EMP E,DEPT D,SALGRADE
                                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
                                ORDER BY GRADE,HIREDATE;
--이름, 급여, 등급, 부서코드, 근무지. 단 comm 이 null아닌 경우
SELECT ENAME,SAL,GRADE,D.DEPTNO,LOC,COMM FROM EMP E,DEPT D,SALGRADE
                                WHERE E.DEPTNO=D.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
                                AND COMM IS NOT NULL ORDER BY GRADE;
--이름, 급여, 급여등급, 연봉, 부서명, 부서별 출력, 부서가 같으면 연봉순. 연봉=(sal+comm)*12 comm이 null이면 0
SELECT ENAME,SAL,GRADE,SAL*12+NVL(COMM,0) 연봉,DNAME,D.DEPTNO FROM EMP E,SALGRADE,DEPT D
                                    WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY DNAME,연봉 DESC;
--이름, 업무, 급여, 등급, 부서코드, 부서명 출력. 급여가 1000~3000사이. 정렬조건 : 부서별, 부서같으면 업무별, 업무같으면 급여 큰순
SELECT ENAME,JOB,SAL,GRADE,E.DEPTNO,DNAME FROM EMP E,DEPT D,SALGRADE
                                    WHERE D.DEPTNO=E.DEPTNO AND SAL BETWEEN 1000 AND 3000
                                    AND SAL BETWEEN LOSAL AND HISAL
                                    ORDER BY DNAME,JOB,SAL DESC;
--이름, 급여, 등급, 입사일, 근무지. 81년에 입사한 사람. 등급 큰순
SELECT ENAME,GRADE,HIREDATE,LOC FROM EMP E,DEPT D,SALGRADE
                            WHERE E.DEPTNO=D.DEPTNO AND HIREDATE LIKE '81%' AND
                            SAL BETWEEN LOSAL AND HISAL ORDER BY GRADE;