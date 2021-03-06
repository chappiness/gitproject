--DML
--데이터 검색,수정
--INSERT,DELETE,UPDATE,SELECT
--INSERT : 데이터베이스 객체에 데이터를 입력
--DELETE : 데이터베이스 객체에 데이터를 삭제
--UPDATE : 기존에 존재하는 데이터베이스 객체 안의 데이터수정
--SELECT : 데이터베이스 객체로부터 데이터를 검색

--DDL
--데이터와 그 구조를 정의
--CREATE,DROP,ALTER,TRUNCATE
--CREATE : 데이터 베이스 객체 생성
--DROP : 데이터 베이스 객체를 삭제
--ALTER : 기존에 존재하는 데이터베이스 객체를 다시 정의
--TRUNCATE : 데이터베이스 객체 내용 삭제

--DCL
--데이터베이스 사용자의 권한 제어
--GRANT,REVOKE,COMMIT,ROLLBACK,SAVEPOINT
--GRANT : 데이터 베이스 객체에 권한 부여
--REVOKE : 이미 부여된 데이터베이스 객체의 권한을 취소
--COMMIT : 트랜잭션 확정 (TCL)
--ROLLBACK : 트랜잭션 취소 (TCL)
--SAVEPOINT : 복귀지점 설정 (TCL)
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

--ROWID:테이블에서 행의 위치를 지정하는 논리적인 주소값,중복 X
SELECT ROWID,EMPNO,ENAME FROM EMP;
--ROWNUM:테이블 행의 논리적 순서
SELECT ROWNUM,EMPNO,ENAME FROM EMP;

--부서번호,부서이름,부서위치 테이블 만들기
DROP TABLE DEPT01;
CREATE TABLE DEPT01(
    DEPTNO NUMBER(2),
    DNAME VARCHAR2(14),
    LOC VARCHAR2(20));
SELECT * FROM DEPT01;

--서브쿼리로 테이블 생성하기
DROP TABLE EMP02;
CREATE TABLE EMP02 AS SELECT * FROM EMP;
SELECT * FROM EMP02;

--기존 칼럼에서 원하는 컬럼만 복사해서 생성
DROP TABLE EMP03;
CREATE TABLE EMP03 AS SELECT EMPNO,ENAME,SAL FROM EMP;
SELECT * FROM EMP03;

--사원번호,사원이름,급여 칼럼으로 구성된 테이블 생성
DROP TABLE EMP04;
CREATE TABLE EMP04 AS SELECT ENAME,SAL,COMM,MGR FROM EMP;
SELECT * FROM EMP04;

--부서 10번인 사원들 출력
DROP TABLE EMP05;
CREATE TABLE EMP05 AS SELECT ENAME,DEPTNO FROM EMP WHERE DEPTNO=10;
SELECT * FROM EMP05;

--테이블의 구조만 복사>>WHERE 1=0; 활용!!
DROP TABLE EMP06;
CREATE TABLE EMP06 AS SELECT * FROM EMP WHERE 1=0;
SELECT * FROM EMP06;

--DEPT 구조만 가져오기
DROP TABLE DEPT02;
CREATE TABLE DEPT02 AS SELECT * FROM DEPT WHERE 1=0;
SELECT * FROM DEPT02;

--ALTER 테이블 구조 변경
--ADD 추가,MODIFY 수정,DROP 삭제

--ADD(1)
SELECT * FROM EMP03; --EMPNO,ENAME,SAL
ALTER TABLE EMP03 ADD(JOB VARCHAR2(9));
SELECT * FROM EMP03; --JOB 추가>>다 NULL

--ADD(2)
ALTER TABLE DEPT02 ADD(DMGR NUMBER(4)); 
SELECT * FROM DEPT02;

--MODIFY(1)
DESC EMP03; --직급을 30자로 수정
ALTER TABLE EMP03 MODIFY(JOB VARCHAR2(30));
DESC EMP03;

--MODIFY(2)
DESC DEPT02; --DMGR을 8자리 숫자로 수정
ALTER TABLE DEPT02 MODIFY (DMGR NUMBER(8));
DESC DEPT02;

--DROP(1)
SELECT * FROM EMP03;
ALTER TABLE EMP03 DROP COLUMN JOB;
--DROP(2)
SELECT * FROM EMP02;
ALTER TABLE EMP02 DROP COLUMN MGR;

--SET UNUSED 옵션 적용하기-컬럼을 삭제하는 것은 아니지만 컬럼의 사용을 논리적으로 제한
SELECT * FROM EMP02;
ALTER TABLE EMPO2 SET UNUSED(JOB);
ALTER TABLE EMP02 DROP UNUSED COLUMNS;

--DROP 테이블 구조 삭제하기
SELECT * FROM EMP01;
DROP TABLE EMP01;
CREATE TABLE EMP01(
    ENAME VARCHAR2(10),
    EMPNO NUMBER(5),
    HIREDATE DATE);
SELECT * FROM EMP01;
DROP TABLE EMP01;

--TRUNCATE 테이블의 모든 로우를 제거한다
SELECT * FROM EMP02;
TRUNCATE TABLE EMP02;--내용만 잘림
DESC EMP02;
DROP TABLE EMP02;

--되살리기(서브쿼리 활용)
CREATE TABLE EMP02 AS SELECT * FROM EMP;

--테이블 명을 변경하는 RENAME(A TO B)
RENAME EMP02 TO TEST;
SELECT * FROM TEST;

--딕셔너리 뷰
SELECT * FROM USER_CONSTRAINTS;
SELECT * FROM USER_TABLES;
SELECT * FROM USER_INDEXES;
SELECT * FROM USER_VIEWS;

DESC USER_TABLES;
SHOW USER;
DESC ALL_TABLES;