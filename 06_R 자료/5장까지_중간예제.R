#### [문제1] 1부터 10사이의 벡터를 만들어서 v1 이라는 변수에 저장한다.####
v1 <- c(1:10)
v1
# 각 원소 값들에 2를 곱한 결과로 벡터 v2 를 만든다.
v2 <- v1 * 2
v2
# v2 에서 최대값을 추출하여 max_v 에 저장한다.
max_v <- max(v2)
# v2 에서 최소값을 추출하여 min_v 에 저장한다.
min_v <- min(v2)
# v2 에서 평균값을 추출하여 avg_v 에 저장한다.
avg_v <- mean(v2)
# v2 에서 합을 추출하여 sum_v 에 저장한다.
sum_v <- sum(v2)
# v2 에서 5번째 원소를 제외하고 v3 라는 변수에 저장한다.
v3 <- v2[-5]
# v1, v2, v3, max_v, min_v, avg_v, sum_v를 화면에 출력한다
v1; v2; v3; max_v; min_v; avg_v; sum_v

cat('v1=',v1,'\nv2=',v2,'\nv3=',v3,'\nmax_v=',max_v,'\tmin_v=',min_v,'\navg_v=',avg_v,'\tsum_v=',sum_v)

#### [문제2]  10 에서 38사이의 숫자 중에서 2씩 증가한 값으로 벡터를 생성하고
# 3행 5열의 매트릭스를 만들어 m1 에 저장한다.(행 우선 저장)####
m1 <- matrix(seq(10,38,2), nrow=3, ncol=5, byrow=TRUE)
m1
# 각 원소 값들에 +100 한 결과로 매트릭스 m2 를 만든다
m2 <- m1+100
m2
# m1 에서 최대값을 추출하여 m_max_v 에 저장한다. 
m_max_v <- max(m1)
m_max_v
# m1 에서 최소값을 추출하여 m_min_v 에 저장한다.   
m_min_v <- min(m1)
m_min_v

# m1 에서 행 단위의 최대값을 추출하여 row_max 에 저장한다.
row_max <- apply(m1, 1, max)
m1
row_max
# m1 에서 열 단위의 최대값을 추출하여 col_max 에 저장한다.
col_max <- apply(m1, 2, max)
col_max

# m1, m2, m_max_v, m_min_v, row_max, col_max를 화면에 출력한다.
m1;m2
cat('m_max_v=',m_max_v,'\nm_min_v=',m_min_v,'\nrow_max=',row_max,'\ncol_max=',col_max)

# [문제3] seq() 또는 rep() 함수를 이용하여 다음 결과가 나오도록 명령을 작성한다.
# (1) 1, 3, 5, 7, 9
seq(1,9,2)
# (2) 1, 1, 1, 1, 1
rep(1,5)
# (3) 1, 2, 3, 1, 2, 3, 1, 2, 3
rep(seq(1,3), times=3)
rep(seq(1,3), 3)
# (4) 1, 1, 2, 2, 3, 3, 4, 4
rep(seq(1,4), each=2)
?rep

# [문제4] 1부터 10 까지 출력하는데 3씩 증가 되는 형태로(1 4 7 10)저장되는 벡터를 정의하여 v3 변수에 저장한다.(또한 각각 값마다 "A", "B", "C", D" 라는 이름을 부여한다.)
v3 <- seq(1, 10, 3)
# names(v3) <- c('A','B','C','D')
names(v3) <- LETTERS[1:4]
LETTERS # R에서 제공되는 벡터
letters # R에서 제공되는 벡터
month.name # R에서 제공되는 벡터
month.abb # R에서 제공되는 벡터

# [문제5] 1부터 100으로 구성되는 7개의 중복되지 않는 데이터를 추출하여 count 라는 백터를 만든다. 
count <- sample(1:100, 7)
count
# week.korname 이라는 이름으로 “일요일”, “월요일”,”화요일”,…,”토요일” 값으로 벡터를 만든다. 
week.korname <- c("일요일","월요일","화요일","수요일","목요일","금요일", "토요일")
week.korname
# 다음 형식으로 구성되는 벡터를 생성하여 출력한다.
# 추출된 값이 – 21, 40, 11, 55, 70, 90, 30 이라면 다음과 같이 출력한다.
# 일요일 : 21   월요일 : 40   화요일 : 11 ……………..   토요일 : 30
paste(week.korname, count, sep=':', collapse = '  ')
cat(paste(week.korname, count, sep=':', collapse = '  '))
# 값이 가장 큰 요일의 명칭을 출력한다.
which.max(count) # count 가장 큰 값의 색인
week.korname[which.max(count)]
# 값이 가장 작은 요일의 명칭을 출력한다.
which.max(-count) # count 가장 작은 값의 색인
which.min(count)
week.korname[which.max(-count)]
# 50보다 큰 값에 해당하는 요일의 명칭을 출력한다.
paste(week.korname, count, sep=':', collapse = '  ')
count>50
week.korname[count>50]

# [문제6]  다음과 같이 값이 구성되는 매트릭스를 정의하여 m1 에 저장한다.
# 1,2,3 의 벡터 n1, 4,5,6 의 벡터 n2, 7,8,9 의 벡터 n3 를 이용하여 matrix를 생성한다.
n1 <- c(1,2,3)
n2 <- c(4,5,6)
n3 <- c(7,8,9)
m1 <- matrix(c(n1, n2, n3), nrow=3) # 방법1
m1 <- cbind(n1, n2, n3) # 방법2
m1

# [문제7] 다음과 같이 값이 구성되는 매트릭스를 정의하여 m2 에 저장한다.
# 1~9 의 벡터를 이용하여 matrix를 생성하고 출력한다.
m2 <- matrix(c(1:9), nrow=3, byrow = TRUE)
m2

# [문제8]  m2 를 가지고 다음과 같이 값이 구성되는 매트릭스를 정의하여 m3 에 저장하고 출력한다.
dimnames(m2) <- list(c("row1", "row2", "row3"),  c("col1", "col2", "col3")) # 방법1
colnames(m2) <- c("col1", "col2", "col3") # 방법2
rownames(m2) <- c("row1", "row2", "row3") # 방법2
(m3 <- m2)

# [문제9] 다음과 같이 구성 되는 2행 3열 매트릭스 alpha를 생성한 후에
alpha <- matrix(c('a','b','c','d','e','f'), nrow=2)
alpha <- matrix(letters[1:6], nrow = 2)
alpha
# alpha에 ‘x’, ‘y’, ‘z’ 라는 행을 추가하여 alpha2 를 만들고 출력한다.
alpha2 <- rbind(alpha, c('x','y','z'))
alpha2
# alpha에 ‘s’, ‘p’ 라는 열을 추가하여 alpha3 를 만들고 출력한다.
alpha3 <- cbind(alpha, c('s','p'))
alpha3

# [문제10] 다음과 같이 값이 구성되는 배열을 정의하여 a 라는 변수에 저장한다.
a <- array(c(1:24), dim=c(2,3,4))
a
# (1) 2행3열4층의 데이터를 출력한다.
a[2,3,4]
# (2) 각 층(면)마다 2행의 데이터를 출력한다.
a[2,,]
# (3) 각 층(면)마다 1열의 데이터를 출력한다.
a[,1,]
# (4) 3층(면)의 모든 데이터를 출력한다.
a[,,3]
# (5) a라는 배열을 구성하는 모든 데이터에 +100을 연산하여 출력한다.
a+100
# (6) 4층(면)의 모든 데이터들에 100을 곱한 결과를 출력한다.
a[,,4]+100
# (7) 각 층(면)의 1행, 2열과3열만 출력한다.
a[1,2:3,]
# (8) 2층(면)의 2행 데이터들의 값을 100을 더한 값으로 변경한다.
a[2,,2] <- a[2,,2]+100
a
# (9) 1층(면)의 모든 데이터들의 값에 2를 뺀 값으로 변경한다.
a[,,1] <- a[,,1]-2
a
# (10) a 배열의 모든 데이터 값들을 10을 곱한 값으로 변경한다.
a <- a*10
a
# (11) a 변수를 삭제한다.
rm(a)
remove(a)

# [문제11] 다음과 같이 값이 구성되는 데이터프레임을 정의하여 df1 에 저장한다.
df1 <- data.frame(x=c(1:5), y=seq(from=2, to=10, by=2)) # 방법1
x <- c(1:5)                    # 방법2
y <- seq(from=2, to=10, by=2)
df1 <- data.frame(x, y)
df1

# [문제12] 다음과 같이 값이 구성되는 데이터프레임을 정의하여 df2 에 저장한다.
df2 <- data.frame(col1=c(1:5), col2=letters[1:5], col3=c(6:10)) # 방법1
col1 <- c(1:5)         # 방법2
col2 <- letters[1:5]
col3 <- c(6:10)
df2 <- data.frame(col1, col2, col3)
df2

# [문제13] c() 함수로 먼저 벡터를 생성한 다음 data.frame()사용해서 다음과 같이 구성되는 데이터 프레임 df3를 만들어 출력해 본다.(제품명이 팩터형이 되지 않게 한다.)
제품명 <- c('사과','딸기','수박')
가격   <- c(1800, 1500, 3000)
판매량 <- c(24,38,13)
df3 <- data.frame(제품명, 가격, 판매량) # stringsAsFactors 기본값이 FALSE
str(df3) # 제품명이 팩터형이 아닌지 확인
df3 <- data.frame(제품명, 가격, 판매량, stringsAsFactors = TRUE) 
str(df3) # 제품명이 팩터형인지 확인

# [문제14] 앞에서 만든 데이터 프레임을 이용해서 과일들 가격 평균과 판매량 평균을 구하여 출력한다.
apply(df3[,c('가격','판매량')], 2, FUN=mean)

# [문제15] 다음 세 벡터를 이용하여 데이터프레임 df4를 생성하고, name 변수는 문자, gender 변수는 팩터, math 변수는 숫자 데이터의 유형이라는 것을 확인하시오.

name <- c("Potter", "Elsa", "Gates", "Wendy", "Ben")
gender <- factor(c("M", "F", "M", "F", "M"))
math <- c(85, 76, 99, 88, 40)
df4 <- data.frame(name, gender, math)
df4
str(df4)
class(df4$math)
# 위에서 만든 데이터프레임에 대해 다음 작업을 수행하시오. 
# (a) stat 변수를 추가하시오. stat <- c(76, 73, 95, 82, 35)
df4$stat <- c(76, 73, 95, 82, 35) # 변수 추가
df4
# (b) math 변수와 stat 변수의 합을 구하여 score 변수에 저장하시오. 
df4$score <- df4$math + df4$stat  # 파생변수 생성 방법을 주로 따름

df4$score <- apply(df4[,c('math','stat')],1 ,sum) 
df4
# (c) 논리 연산 인덱싱을 이용하여 score가 150 이상이면 A, 100 이상 150 미만이면 B, 70 이상 100 미만이면 C  등급을 부여하고 grade 변수에 저장하시오.	
df4$grade <- ifelse(df4$score>=150, 'A', ifelse(df4$score>=100, 'B', ifelse(df4$score>=70, 'C','X')))
df4
getGrade <- function(score){
  return (ifelse(df4$score>=150, 'A', ifelse(df4$score>=100, 'B', ifelse(df4$score>=70, 'C','X'))))
}
df4$grade <- apply(df4[,'score', drop=F], 2, getGrade)
df4
# [문제16] 다음과 같이 값이 구성되는 리스트를 정의하여 L1 에 저장한다.
L1 = list(name="scott", sal=3000)
L1
# 3000 을 추출하여 2를 곱한 후에 result1 변수에 저장한다.
result1 <- L1$sal *2
result1 <- L1[[2]] *2
result1

# [문제17] 다음과 같이 값이 구성되는 리스트를 정의하여 L2 에 저장한다.
L2 <- list("scott",c(100,200,300))
L2
# [문제18] 다음 리스트에서 A를 "Alpha"로 대체한다.
# list(c(3,5,7), c(“A”, “B”, “C”))
L3 <- list(c(3,5,7), c("A", "B", "C"))
L3[[2]][1] <- "Alpha"
L3
# [문제19] 다음 리스트에서 첫 번째 원소(alpha)의 각 값에 10을 더하여 출력한다.
# list(alpha=0:4, beta=sqrt(1:5), gamma=log(1:5))
L4 <- list(alpha=0:4, beta=sqrt(1:5), gamma=log(1:5))
L4$alpha + 10
L4[[1]]+10
# [문제20] 다음 리스트는 math, writing, reading의 중간고사 및 기말고사 점수이다. 
# 전체 평균을 계산하여 출력한다.
# (힌트 : unlist() 함수를 활용한다. unlist() : 리스트를 벡터형식의 데이터셋으로 풀어주는 함수)
# list(math=list(95, 90), writing=list(90, 85), reading=list(85, 80))
scores <- list(math=list(95, 90), writing=list(90, 85), reading=list(85, 80))
# 전체 평균
mean(unlist(scores))

# 과목별 평균
scores$math    <- unlist(scores$math)
scores$writing <- unlist(scores$writing)
scores$reading <- unlist(scores$reading)
scores
lapply(scores, mean) # 과목별 평균을 리스트형식으로 반환
sapply(scores, mean) # 과목별 평균을 벡터 형식으로 반환
vapply(scores, mean, FUN.VALUE = numeric(1))
# [문제21] iris 데이터에서 다름 기본 정보를 조회한다(기본정보조회)
# 타입, 구조, 차원, 변수이름, 기본통계량(평균, 표준편차, 사분위수)
class(iris) # 타입
str(iris) # 구조
dim(iris) # 차원
names(iris) # 변수이름
colnames(iris) # 변수이름
summary(iris) # 기본통계량
# [문제22] iris 데이터를 정렬한다
# Petal.Length를 기준으로 내림차순으로 정렬하세요
library(doBy)
orderBy(~-Petal.Length, data=iris)
iris[order(iris$Petal.Length, decreasing = TRUE),]
iris[order(-iris$Petal.Length),]

# Sepal.Width 를 내림차순 정렬하세요
sort(iris$Sepal.Length, decreasing = TRUE)
-sort(-iris$Sepal.Length)

# [문제 23] iris 데이터의 종별 데이터 개수 출력한다
table(iris$Species)

# [문제 24] 종별 Sepal.Length의 합을 출력한다.
tapply(iris$Sepal.Length, iris$Species, sum)
by(iris$Sepal.Length, iris$Species, sum)
summaryBy(Sepal.Length~Species, data=iris, FUN=sum)
aggregate(iris$Sepal.Length, by=list(iris$Species), sum)

# [문제 25] Sepal.Length, Sepal.Width, Petal.Length, Petal.Width의 평균을 출력
# Apply, lappy, sapply이용
apply(iris[,1:4], 2, mean)
lapply(iris[,1:4], mean)
sapply(iris[,1:4], mean)
vapply(iris[,1:4], mean, FUN.VALUE = numeric(1))

# 종별 Sepal.Length의 평균 출력
tapply(iris$Sepal.Length, iris$Species, mean)
by(iris$Sepal.Length,     iris$Species, mean)
summaryBy(Sepal.Length ~ Species, data=iris)
aggregate(iris$Sepal.Length, by=list(iris$Species), mean)

# [문제 26] 꽃받침의 길이(Sepal.Length)가 가장 긴 꽃의 종은 무엇인가요?
which.max(iris$Sepal.Length) # 꽃받침 길이 가 가장 긴 색인
iris[which.max(iris$Sepal.Length),'Species']  
iris[which.max(iris$Sepal.Length),5] # 팩터변수는 level정보도 같이 출력
as.character(iris[which.max(iris$Sepal.Length),5])