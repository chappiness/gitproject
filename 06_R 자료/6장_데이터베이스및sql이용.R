#───────────────────────────────────────#
##### 6장. 데이터베이스 및 SQL 이용 #####
#───────────────────────────────────────#
 # 이장의 내용 : SQL문으로 데이터프레임과 DB(oracle, mySql) 테이블을 이용
rm(list=ls(all.names = T))
#### 1. SQL문으로 데이터 프레임 처리 ####
install.packages("sqldf")
library(sqldf) # sqldf() 함수를 통해 데이터프레임을 DB의 테이블 처럼 사용

sqldf("select * from iris")

# 중복행 제거하면 한행만 출력
sqldf("select distinct Species from iris")

# 행 제한 조건(setosa종만 출력)
sqldf("select * from iris where Species=='setosa'") # 1
iris[iris$Species=='setosa',] # 2
subset(iris, Species=='setosa') # 3
iris %>%  # 4
  filter(Species=='setosa')

# 컬럼에 .
ex<-sqldf("select `Sepal.Length`, Species from iris")
str(iris)
str(ex)

# 종별 Sepal.Length, Sepal.Width 평균
library(doBy)
summaryBy(Sepal.Length+Sepal.Width~Species, data=iris, FUN=mean)
sqldf("select Species, avg(`Sepal.Length`),  avg(`Sepal.Width`) from iris group by Species having avg(`Sepal.Length`)>6")

# iris를 Sepal.Length 기준으로 내림차순 정렬해서 11~15 등까지 출력
sqldf("select * from iris order by `Sepal.Length` DESC limit 5") # 0번째 5개
sqldf("select * from iris order by `Sepal.Length` DESC limit 10,5") # 10번째 5개

#### 2. 오라클 데이터 베이스 연결 ####
# 전작업 : ojdbc6.jar이용하므로 자바설치 -> 환경변수설정(JAVA_HOME)
getwd() # 작업디렉토리에 ojdbc6.jar를 복사해 둠
# 패키지 설치 및 로드 : RJDBC
install.packages("RJDBC")
require(RJDBC)
# 드라이버 클래스 로드
drv <- JDBC("oracle.jdbc.driver.OracleDriver", classPath = "ojdbc6.jar")
drv
# 데이터 베이스 연결
conn <- dbConnect(drv, "jdbc:oracle:thin:@127.0.0.1:1521:xe","scott","tiger")
conn
# SQL문 전송 + 결과 받기 
rs <- dbSendQuery(conn, "select * from emp")
emp <- fetch(rs, n=-1)
class(emp)
head(emp)
# SQL문 전송 + 결과 받기를 한꺼번에 하는 방법
dept <- dbGetQuery(conn, "select * from dept")
dept
str(dept)
dept[dept$DEPTNO<30,]  
colnames(dept)  <- c('deptno', 'dname','loc')

# 테이블 전체 데이터 조회
dept <- dbReadTable(con,"dept")
dept

# DB 데이터 수정 SQL 전송(update, insert, delete)
dbSendUpdate(conn, "insert into dept values (50, 'it', 'Seoul')")
dbSendUpdate(conn, "update dept set loc='PUSAN' where deptno=50")
dbSendUpdate(conn, "delete from dept where deptno=50")

# 데이터 연결 해제
dbDisconnect(conn)
# 드라이버 언로드 : DB연결해제 자동으로 언로드됨
dbUnloadDriver(drv)
# RJDBC 패키지 언로드
detach("package:RJDBC", unload = TRUE)

#### 3. MySQL 데이터 베이스 연결 ####
# 전작업 : 외부에서 엑세스 허용
# MySQL Workbench에서 
# ALTER USER '아이디'@'localhost' IDENTIFIED WITH mysql_native_password BY '비밀번호';
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'mysql';

install.packages("RMySQL")
library(RMySQL)
# 드라이버 로드
drv <- dbDriver("MySQL")
drv
# 데이터베이스 연결
conn <- dbConnect(drv, host="127.0.0.1", dbname="kimdb", user="root", password="mysql")
conn
# SQL전송+결과받기
rs <- dbSendQuery(conn, "select * from personal")
personal <- fetch(rs, n=-1)
personal
# SQL전송과 결과 받기를 한꺼번에
division <- dbGetQuery(conn, "select * from division")
division
# 테이블 전체 데이터를 한꺼번에 조회
person <- dbReadTable(conn, "personal")
person
# 데이터 베이스 연결 해제
dbDisconnect(conn)
# 드라이버 언로드
dbUnloadDriver(drv)
detach("package:RMySQL", unload = TRUE)
