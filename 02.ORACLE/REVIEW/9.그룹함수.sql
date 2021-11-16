--그룹함수--
--여러 행 또는 테이블 전체의 행에 대해 함수가 적용되어 하나의 결과값을 가져오는 함수
--SQL 함수는 단일행함수,그룹함수
--INPUT 1개>OUTPUT 1개 단일행함수
--INPUT 1개>OUTPUT 1개 그룹함수
--GROUP BY,HAVING,COUNT,MIN,MAX

--하나 이상의 행을 그룹으로 묶어 연산하여 종합,평균 등 하나의 결과로 나타냄
--SUM,AVG,COUNT,MAX,MIN,STDDEV,VARIANCE
SELECT SUM(SAL),MAX(SAL),MIN(SAL),AVG(SAL),ROUND(AVG(SAL),2) FROM EMP; --셋째자리에서 올림
SELECT ENAME,SAL,COMM FROM EMP;
SELECT SUM(COMM) FROM EMP;--NULL 포함 안시킴
SELECT AVG(COMM) FROM EMP;--NULL 포함 안함
SELECT MAX(ENAME),MIN(ENAME),MIN(HIREDATE) FROM EMP; --알파벳 큰놈이 맥스
SELECT MAX(HIREDATE),MIN(HIREDATE) FROM EMP; --MIN 옛날 MAX 최근
SELECT STDDEV(SAL),STDDEV(SAL)*STDDEV(SAL),VARIANCE(SAL) FROM EMP; --분산=표준편차의 제곱
SELECT COUNT(*),COUNT(COMM) FROM EMP; --NULL 아닌 친구들
--SELECT SAL,MAX(SAL),MIN(SAL) FROM EMP; 단일행함수 그룹함수를 섞어서 사용 불가
SELECT COUNT(JOB),COUNT(DISTINCT JOB) FROM EMP;
­-가장 오래 전에 입사한 사원의 입사일과 입사한지 가장 오래된 사원의 입사일을 출력
SELECT MIN(TO_CHAR(HIREDATE,'YY/MM/DD:')),MIN(TRUNC(SYSDATE-HIREDATE)) FROM EMP;
SELECT MAX(TO_CHAR(HIREDATE,'YY/MM/DD:')),MAX(TRUNC(SYSDATE-HIREDATE)) FROM EMP;
­-10번 부서 소속의 사원 중에서 커미션을 받는 사원의 수를 구해 보시오
SELECT COUNT(ENAME) FROM EMP WHERE DEPTNO=10;

--GROUP BY 절:어떤 컬럼 값을 기준으로 그룹함수를 적용할 경우에 씀,뒤에는 별칭 쓸 수 없음
--FORMAT SELECT 컬럼명,그룹함수 FROM 테이블명 WHERE 조건 GROUP BY 컬럼명
--부서별 급여 평균
SELECT DEPTNO,ROUND(AVG(SAL),2) FROM EMP GROUP BY DEPTNO ORDER BY DEPTNO;
SELECT DEPTNO,COUNT(*),COUNT(COMM) FROM EMP GROUP BY DEPTNO;

--그룹함수 HAVING 조건 (SELECT/FROM/WHERE/GROUP BY/HAVINGM/ORDER BY)
SELECT DEPTNO,AVG(SAL) FROM EMP GROUP BY DEPTNO HAVING AVG(SAL)>=2000;
SELECT DEPTNO,MAX(SAL),MIN(SAL) FROM EMP GROUP BY DEPTNO HAVING MAX(SAL)>2900;

--결과 집합 내에 집계 값 생성<<ROLLUP 활용
SELECT DEPTNO,SUM(SAL) FROM EMP GROUP BY DEPTNO;
SELECT DEPTNO,SUM(SAL) FROM EMP GROUP BY ROLLUP(DEPTNO);
SELECT DEPTNO,JOB,SUM(SAL) FROM EMP GROUP BY ROLLUP(DEPTNO,JOB);
SELECT DEPTNO,JOB,TRUNC(AVG(SAL)) FROM EMP GROUP BY ROLLUP(DEPTNO,JOB);

--※	Guidelines
--(1)	SELECT 절에 그룹함수에 포함된다면 GROUP BY 절에 각각의 열이 명시되어야 한다.
--(2)	WHERE 절을 사용하여 행을 그룹으로 나누기 전에 행을 제외한다
--(3)	그룹에 대한 조건은 HAVING 절을 사용한다(그룹에 대한 조건을 WHERE절에서 기술 불가)
--(4)	GROUP BY 절에 열을 포함한다(열의 별칭은 사용할 수 없다)
--(5)	DEFAULT는 GROUP BY 절 다음에 기술된 순서로 오름차순으로 정렬되지만 ORDER BY 절을 이용하여 변경가능하다

-- 1. 사원 테이블에서 인원수,최대 급여,최소 급여,급여의 합을 계산하여 출력
SELECT COUNT(*),MAX(SAL),MIN(SAL),SUM(SAL) FROM EMP;
-- 2. 사원테이블에서 업무별 인원수를 구하여 출력하는 SELECT 문장을 작성하여라.
SELECT JOB,COUNT(*) FROM EMP GROUP BY JOB;
--- 3. 사원테이블에서 최고 급여와 최소 급여의 차이는 얼마인가 출력하는 SELECT문장을 작성하여라.
SELECT MAX(SAL)-MIN(SAL) FROM EMP;
-- 4. 각 부서별로 인원수, 급여 평균, 최저 급여, 최고 급여, 급여의 합을 출력하되 급여의 합이 많은 순으로 출력하라.
SELECT DEPTNO,COUNT(DEPTNO),ROUND(AVG(SAL),2),MIN(SAL),MAX(SAL),SUM(SAL)급여합 FROM EMP GROUP BY DEPTNO ORDER BY 급여합;
-- 5. 부서별, 업무별 그룹하여 결과를 부서번호, 업무, 인원수, 급여의 평균, 급여의 합을 
    --구하여 출력하라(출력결과는 부서번호, 업무순으로 오름차순 정렬)
SELECT DEPTNO,JOB,COUNT(*),AVG(SAL),SUM(SAL) FROM EMP GROUP BY DEPTNO,JOB ORDER BY DEPTNO,JOB;
-- 6. 업무별, 부서별 그룹하여 결과를  업무, 부서번호, 인원수, 급여의 평균, 급여의 합을 구하여 
-- 출력하라.(출력결과는 업무순, 부서번호 순 오름차순 정렬)
SELECT JOB,DEPTNO,COUNT(*),AVG(SAL),SUM(SAL) FROM EMP GROUP BY DEPTNO,JOB ORDER BY JOB,DEPTNO;
--7. 사원수가 5명이상 넘는 부서번호와 사원수를 출력하시오.
SELECT DEPTNO,COUNT(*) FROM EMP GROUP BY DEPTNO HAVING COUNT(*)>=5;
-- 8. 사원수가 5명이상 넘는 부서명과 사원수를 출력하시오
SELECT DNAME,COUNT(*) FROM EMP E,DEPT D WHERE D.DEPTNO=E.DEPTNO GROUP BY DNAME HAVING COUNT(*)>=5;
--9. 사원 테이블에서 업무별 급여의 평균이 3000이상인 업무에 대해서 업무명, 평균 급여, 
--급여의 합을 구하여 출력하라
SELECT JOB,ROUND(AVG(SAL),2),SUM(SAL) FROM EMP GROUP BY JOB HAVING AVG(SAL)>3000;
--10. 사원테이블에서 급여합이 5000을 초과하는 각 업무에 대해서 업무와 급여합계를 출력하라 
        --단, 급여 합계로 내림차순 정렬하라.
SELECT JOB,SUM(SAL) FROM EMP GROUP BY JOB HAVING SUM(SAL)>5000 ORDER BY SUM(SAL) DESC;
--11. 부서별 급여평균, 부서별 급여합계, 부서별 최소급여를 출력하라.
SELECT DEPTNO,ROUND(AVG(SAL),2),SUM(SAL),MIN(SAL) FROM EMP GROUP BY DEPTNO;
--12. 위의 11번을 수정하여, 부서별 급여평균 최대치, 부서별 급여합의 최대치, 
            --부서별 최소급여의 최대치를 출력하라.
SELECT DEPTNO,ROUND(AVG(SAL),2),MAX(SAL),MIN(SAL) FROM EMP GROUP BY DEPTNO;
--13. 사원 테이블에서 아래의 결과를 출력하는 SELECT 문장을 작성하여라.(년도별 연봉합)
--   H_YEAR	COUNT(*)	MIN(SAL)	MAX(SAL)	AVG(SAL)	SUM(SAL)
--     80	  1		    800		    800		    800		    800
--	81	 10		    950		    5000	    2282.5	  22825
--	82	  2		    1300	    3000	   2150		   4300
--	83	  1		    1100	    1100	    1100	   1100
 SELECT TO_CHAR(HIREDATE,'YY') 년도,MIN(SAL),MAX(SAL),AVG(SAL),SUM(SAL) 
                                    FROM EMP GROUP BY TO_CHAR(HIREDATE,'YY') ORDER BY 년도;
-- 14.  사원테이블에서 아래의 결과를 출력하는 SELECT 문 작성
--  1980     1	
--  1981     10
--  1982     2
--  1983     1
--  total    14	
SELECT EXTRACT(YEAR FROM HIREDATE) FROM EMP; #네자리로 나옴
SELECT DEPTNO,SUM(SAL),SUM(SUM(SAL)) FROM EMP GROUP BY DEPTNO;
SELECT NVL(TO_CHAR(EXTRACT(YEAR FROM HIREDATE)),'TOTAL') 년도,COUNT(*)
                                    FROM EMP GROUP BY ROLLUP(EXTRACT(YEAR FROM HIREDATE)) ORDER BY 년도;
--15. 사원테이블에서 최대급여, 최소급여, 전체급여합, 평균을 구하시오
SELECT MAX(SAL),MIN(SAL),SUM(SAL),ROUND(AVG(SAL),2) FROM EMP;
--16. 사원테이블에서 부서별 인원수를 구하시오
SELECT DEPTNO,COUNT(*) FROM EMP GROUP BY DEPTNO;
--17. 사원 테이블에서 부서별 인원수가 6명이상인 부서코드를 구하시오
SELECT DEPTNO,COUNT(*) FROM EMP GROUP BY DEPTNO HAVING COUNT(*)>=6;
--18. 사원테이블에서 급여가 높은 순서대로 등수를 부여하여 다음과 같은 결과가 나오게 하시오. 
-- (힌트 self join, group by, count사용)
--ENAME	    등수
--________________________
--KING		1
--SCOTT		2
--……
SELECT ENAME,SAL FROM EMP ORDER BY SAL DESC,ENAME DESC;
SELECT E1.ENAME,E1.SAL,E2.ENAME,E2.SAL FROM EMP E1,EMP E2 WHERE E1.SAL<E2.SAL(+); --SELF JOIN
SELECT E1.ENAME,COUNT(E2.ENAME)+1 RANK FROM EMP E1,EMP E2 
                                WHERE E1.SAL<E2.SAL(+) GROUP BY E1.ENAME ORDER BY RANK;
SELECT ENAME, RANK() OVER(ORDER BY SAL DESC) "RANK",
              DENSE_RANK() OVER(ORDER BY SAL DESC) "DENSE_RANK",
              ROW_NUMBER() OVER(ORDER BY SAL DESC) "ROW_NUM"
        FROM EMP; -- 함수 사용
