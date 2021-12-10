#────────────────────────────#
##### 5장. 데이터 전처리 #####
#────────────────────────────#

#### 1. 파일 입출력 ####
## 1.1 시스템 인코딩 조회
Sys.getlocale() # Windows는 CP949

## 1.2 write.table : 데이터를 파일에 저장
iris
class(iris)
getwd()
write.table(iris, file='outData/iris.csv', sep=',')
write.table(iris, file='outData/iris.csv', sep=',', row.names = FALSE)
InsectSprays
summary(InsectSprays)
str(InsectSprays)
write.table(InsectSprays, file='outData/insect.csv', sep=',', row.names = F)

## 1.3 read.table : 파일의 내용을 데이터프레임 형태로 읽어옴
irisData <- read.table('outData/iris.csv', sep=',') # 첫번째 행도 데이터로 읽어들임
head(irisData)
irisData <- read.table('outData/iris.csv', sep=',', header = TRUE,
                       encoding = 'utf-8')
head(irisData)
str(irisData) # Species가 문자형으로 읽어들임
irisData <- read.table('outData/iris.csv', sep=',', header=TRUE, 
                       stringsAsFactors = TRUE)
str(irisData)

emp <- read.table('inData/emp.csv', sep=',', header = TRUE,
                  stringsAsFactors = TRUE)
str(emp)

## 1.4 write.csv
write.csv(iris, file='outData/iris1.csv')
write.csv(iris, file='outData/iris1.csv', quote = FALSE, row.names = FALSE)

## 1.5 read.csv
newIris <- read.csv('outData/iris1.csv', header = TRUE)
head(newIris)
str(newIris)
?read.csv
newIris$Species <- as.factor(newIris$Species)
str(newIris)
newIris$Species <- as.character(newIris$Species)
newIris$Species <- factor(newIris$Species, 
                          levels = c('setosa', 'versicolor','virginica'))
str(newIris)
summary(newIris)

## 1.6 cat을 이용한 text 출력
cat('Hi, R', '\n',  file='outData/irisSummary.txt', append = TRUE)

irisSummary <- summary(iris)
class(irisSummary)
dim(irisSummary)
irisSummary[1,]
irisSummary[2,]
?cat
cat('iris 통계 요약치','\n',file='outData/irisSummary.txt')
for(i in 1:nrow(irisSummary)){
  cat(irisSummary[i,], '\n', file='outData/irisSummary.txt', append = TRUE)
}

#### 2. apply 계열 함수 적용 ####

## 2.1 apply
# iris데이터의 열별 평균(합계, 표준편차, 최소값, 최대값, 중앙값)
  # apply(대상자료, 1또는2, 함수)
iris[, -5]
iris[, 1:4]
apply(iris[,1:4], 2, mean) # 열별 평균
apply(iris[,1:4], 1, mean) # 행별 평균
# apply계열을 이용한 집계함수 : 평균, 합계, 표준편차, 최소값, 최대값, 중앙값
apply(iris[,1:4], 2, FUN=mean) #열별 평균
apply(iris[,1:4], 2, FUN=sum)  #열별 합계
apply(iris[,1:4], 2, FUN=sd)  #열별 표준편차
apply(iris[,1:4], 2, FUN=min)  #열별 최소값
apply(iris[,1:4], 2, FUN=max)  #열별 최대값
apply(iris[,1:4], 2, FUN=median) # 열별 중앙값

unique(iris$Species) # Species의 종류
levels(iris$Species) # Species의 종류
# 종별(setosa, versicolor, virginica) 열별 평균 구하기
setosa_m     <- apply(iris[iris$Species=='setosa',-5], 2, FUN=mean)
setosa_s     <- apply(iris[iris$Species=='setosa',-5], 2, FUN=sd)
versicolor_m <- apply(iris[iris$Species=='versicolor',-5], 2, FUN=mean)
versicolor_s <- apply(iris[iris$Species=='versicolor',-5], 2, FUN=sd)
virginica_m  <- apply(iris[iris$Species=='virginica',-5], 2, FUN=mean)
virginica_s  <- apply(iris[iris$Species=='virginica',-5], 2, FUN=sd)
data.frame(setosa_m, setosa_s, versicolor_m, versicolor_s, virginica_m, virginica_s)

# 학생 데이터 #
name <- c('김','홍','박','이','윤')
kor  <- c(90,95,97,96,80)
eng  <- c(80,90,95,97,100)
mat  <- c(70,75,86,91,100)
student <- data.frame(name, kor, eng, mat)
student
rownames(student) <- name
apply(student[,-1], 1, mean)
 # 학생별 평균
m <- apply(student[,-1], 1, mean)
names(m) <- name
m
 # 과목별 평균
apply(student[,-1], 2, mean)

## 2.2 lapply : list apply (결과도 list)
lapply(iris[1:4], mean)  # (1)
list.iris <- as.list(iris[1:4])
lapply(list.iris, mean)  # (2)
exp(-3:3) # e의 -3승부터 3까지 7개 데이터
x <- list(a=1:10, beta=exp(-3:3), logic = c(TRUE,FALSE,FALSE,TRUE,TRUE))
lapply(x, mean)
lapply(x, quantile)
lapply(x, quantile, 1:3/4)
 quantile(c(1:10), probs = 1:3/4)
 quantile(exp(-3:3))

## 2.3 sapply : lapply와 유사하나 결과가 행렬이나 벡터로 반환
sapply(iris[1:4], mean)
sapply(x, mean)
sapply(x, quantile)
sapply(x, quantile, 1:3/4)

fivenum(1:100)
seq(1, 100, length.out=5)
i39 <- sapply(c(3:9), seq)
i39
lapply(i39, fivenum)
sapply(i39, fivenum)

## 2.4 vapply : sapply와 유사하나 FUN의 결과값이 FUN.VALUE와 호환되는지 
vapply(i39, FUN=fivenum, FUN.VALUE=c(numeric(1),numeric(1),numeric(1),numeric(1),numeric(1) ))

sapply(iris[1:4], mean)
vapply(iris[1:4], mean, FUN.VALUE = numeric(1))

citis <- c('Seoul','Busan', 'New York','Tokyo')
nchar(citis)
lapply(citis, nchar) # 결과가 list
sapply(citis, nchar) # 결과가 벡터
vapply(citis, nchar, FUN.VALUE = numeric(1)) # 적용 함수의 값 체크

## 2.5 mapply : 함수 적용시 여러개의 인자를 함수에 전달
rep(x=c(1,2,3),times=3)
rep(x=c(1,2,3), each=2)
mapply(rep, x=1:4, times=4:1) 
mapply(rep, x=1:4, each=c(4,3,2,1)) 

# 직업별 수입
job <- c(3,3,5,2,2,3,5,3,4,4,6,3)
income <- c(4879, 6509, 4183, 0, 3894, 0, 3611, 6454, 4975, 8780, 0, 4362)
length(job)
length(income)
cust <- data.frame(job, income)
cust
income.avg <- c(862, 0, 3806, 3990, 3891, 3359, 3556, 2199, 227)
names(income.avg) <- 0:8
income.avg['2'] # job코드가 2번 직업의 평균수입
income.avg[3]   # job코드가 2번 직업의 평균수입

zero2mean <- function(job, income){
  if(income==0 & job!=1){
    # return (income.avg[as.character(job)])
    return(income.avg[job+1])
  }else{
    return(income)
  }
}
cust
#for(i in 1:nrow(cust)){
#  cust[i,'income'] <- zero2mean(cust[i,'job'], cust[i,'income'])
#}

cust$income2 <- mapply(zero2mean, cust$job, cust$income)
cust

unique(iris$Species)
setosa <- apply(iris[iris$Species=='setosa',-5], 2, mean)
versicolor <- apply(iris[iris$Species=='versicolor',-5], 2, mean)
virginica <- apply(iris[iris$Species=='virginica',-5], 2, mean)
data.frame(setosa, versicolor, virginica)

#### 3. 데이터 그룹화 함수 적용 ####
## 3.1 tapply : 1개 열에 대해 1개의 함수로 그룹화 처리를 위한 apply
tapply(iris$Sepal.Length, iris$Species, FUN=mean)
tapply(iris[,'Sepal.Length'], iris$Species, FUN=mean)
tapply(iris[,'Sepal.Length'], iris['Species'], FUN=mean)
tapply(iris$Sepal.Length, iris$Species, FUN=sd)
boxplot(iris$Sepal.Length ~ iris$Species)
library(vioplot) # 에러나니까 패키지 설치
install.packages("vioplot")
require(vioplot)
vioplot(iris$Sepal.Length~iris$Species)

# 직업군별 
str(cust)
tapply(cust$income2, cust$job, FUN=mean)
cust$job <- as.factor(cust$job) # 비추
str(cust$job)
cust$job <- factor(cust$job, levels=0:8)
str(cust$job)
levels(cust$job)
tapply(cust$income2, cust$job, FUN=mean) # 없는 그룹은 NA
tapply(cust$income2, cust$job, FUN=mean, default = -1) #dafault값은 NA 대체값

datasets::InsectSprays
head(InsectSprays)
# spray의 종류에 따른 살충효과 점검해 보세요
str(InsectSprays)
tapply(InsectSprays$count, InsectSprays$spray, mean)
tapply(InsectSprays$count, InsectSprays$spray, sd)
boxplot(InsectSprays$count ~ InsectSprays$spray)
vioplot(InsectSprays$count ~ InsectSprays$spray)

# tapply(iris[,c('Sepal.Length','Sepal.Width')], iris['Species'], FUN=sum) 단점극복 by, aggregate
# tapply(iris$Sepal.Length, iris[,c('Species')], FUN=c(sum,min)) 단점극복 : summaryBy

## 3.2 by : 1개이상의 열에 대해 1개의 함수로 그룹화 처리(1개 이상의 열 summary)
tapply(iris[,c('Sepal.Length','Sepal.Width')], iris['Species'], FUN=mean)
by(iris[,c('Sepal.Length','Sepal.Width')], iris['Species'], FUN=summary)
by(iris$Sepal.Length, iris$Species, FUN=mean)
# cust 직업별 평균, 중위수, 1사분위수, 3사분위수, 최소값, 최대값을 income과 income2를 한꺼번에 (summary)
by(cust[, c('income','income2')], cust$job, FUN=summary)

## 3.3 doBy 패키지
.libPaths()
install.packages("doBy")
library(doBy)
# (1) summaryBy : 1개이상의 열에 대해, 1개 이상의 함수로 1개 이상의 그룹화 처리
summaryBy(Sepal.Length+Sepal.Width ~ Species, iris) # default FUN은 mean
summaryBy(Sepal.Length+Petal.Length ~ Species, iris, FUN=sd)
summaryBy(Sepal.Length+Petal.Length ~ Species, iris, FUN=c(mean, sd, median))

#문1. emp.csv 파일의 데이터를 받아, 부서별 급여와 상여금 비교(mean, sd)하시오
# na.rm=TRUE 결측치를 빼고 함수를 적용
getwd()
emp <- read.csv('inData/emp.csv', header = TRUE)
str(emp)
emp$deptno <- factor(emp$deptno, levels = seq(10, 40, 10))
str(emp)
levels(emp$deptno)
summaryBy(sal+comm ~ deptno, emp, FUN=c(mean, sd), na.rm=TRUE)
#문2. emp.csv 파일의 데이터를 받아, 부서별, job별 급여와 상여금 비교(mean, sd)하시오
str(emp)
emp
emp$job <- as.factor(emp$job)
summaryBy(sal + comm ~ deptno + job, emp, FUN=c(mean, sd), na.rm=T)

# (2) orderBy : 열기준 정렬한 데이터 프레임
orderBy(~Sepal.Length, data=iris) # Sepal.Length기준으로 오름차순 정렬
# Sepal.Length, Petal.Length기준으로 오름차순 정렬
orderBy(~Sepal.Length+Petal.Length, data=iris) 
# Species 알파벳 순, Species가 같은 경우 Sepal.Length 오름차순 정렬
orderBy(~Species+Sepal.Length, data=iris) 
# Sepal.Length기준으로 내림차순 정렬
orderBy(~-Sepal.Length, data=iris) 
# Sepal.Length기준으로 내림차순 정렬, Sepal.Length가 같으면 Species 알파벳순 
orderBy(~-Sepal.Length+Species, data=iris)
# Sepal.Length기준으로 내림차순 정렬, Sepal.Length가 같으면 Petal.Length기준으로 내림차순 정렬
orderBy(~-Sepal.Length + -Petal.Length, data=iris)
orderBy(~-Sepal.Length - Petal.Length, data=iris)

# 종별, Sepal.Length, Petal.Length 오름차순으로 정렬한 데이터의 Sepal.Length, Species, Petal.Length열만 출력
orderBy(~Species+Sepal.Length+Petal.Length, data=iris)[, c('Sepal.Length','Species', 'Petal.Length')]
orderBy(~Species+Sepal.Length+Petal.Length, data=iris)[, c(1,5,3)]
orderBy(~Species+Sepal.Length+Petal.Length, data=iris)[, c(-2,-4)]
orderBy(~Species+Sepal.Length+Petal.Length, data=iris)[, -c(2,4)]

# 문1. emp데이터셋에서 월급이 적은 순으로 ename, sal을 추출
orderBy(~sal, data=emp)[, c('ename','sal')]
# 문2. emp 데이터셋에서 월급이 적은 순으로 5명만 ename, sal을 추출
orderBy(~sal, data=emp)[1:5, c('ename','sal')]
head(orderBy(~sal, data=emp)[, c('ename','sal')],5 )

# (3) simpleBy : 그룹별 데이터를 sampling
library(doBy)
iris
sampleBy(~Species, data=iris) # frac는 기본값이 10%
sampleBy(~Species, data=iris, frac=0.2) # 종별 20%씩 비복원추출
sampleBy(~Species, data=iris, frac=0.2, replace = TRUE) # 종별 20%씩 복원추출
sampleBy(~Species, data=iris, frac=0.1, systematic = TRUE) # 계층적 추출

sample(1:150, 10) # 1~150중에서 10개 뽑기기
iris[sample(1:nrow(iris), 10), ]

#### 4. Formula : ~ + ####
## lm(종속변수 ~ 독립변수) :  선형회귀식 도출 함수 
x <- c(1,  2, 3, 4, 5) # 독립변수(공부량)
y <- c(20,45,55,82,99) # 종속변수(점수) 
y <- c('C', 'C', 'B', 'B', 'A')
y <- c(F,F,F,T,T) 
plot(x, y)
fit <- lm(y ~ x)
fit
# y = 19.5*x + 1.7
lines(x, x*19.5+1.7, col="red")
abline(fit, lty='dashed', lwd="3")

# 독립변수가 2개
x1 <- c(1,  2, 3, 4, 5)  # 독립변수(공부량)
x2 <- c(10, 20, 3, 4, 5) # 독립변수(기출문제집 푼 갯수)
y <- c(60, 80, 63, 84, 95) # x1과 x2 사이의 상관관계가 없다는 전제에서 독립변수를 2개
lm(y ~ x1 + x2)
# y = 11.083*x1 + 1.417*x2 + 31.250

# datasets::cars
cars # 속도에 따른 제동거리의 관계를 선형회귀식으로 도출하시오(그래프 시각화)
class(cars)
nrow(cars)
plot(cars) # plot(cars$speed, cars$dist)과 동일
fit <- lm(cars$dist ~ cars$speed)
fit <- lm(dist ~ speed, data = cars)
fit
# dist_hat = 3.932 * speed - 17.579
abline(fit, lty='dotted', lwd="3")
lines(cars$speed, 3.932*cars$speed-17.579, col="red")

#### 5. 데이터분리 ####
## 5.1 split : 결과는 list형태
iris.species <- split(iris, iris$Species) # 종별로 iris데이터를 분리
iris.species # iris.species['setosa'], iris.species['versicolor'],.... list형태 반환
m <- mean(iris$Sepal.Length) # Sepal.Length의 평균
iris.sepal <- split(iris, iris$Sepal.Length > m)
iris.sepal$'TRUE' # Sepal.Length가 평균보다 큰 그룹
iris.sepal$'FALSE'# Sepal.Length가 평균이하인 그룹
iris.sepal['FALSE']

## 5.2 subset
# Sepal.Length가 4이상인 데이터만 추출(Sepal.Length, Petal.Length, Species)
subset(iris, subset=Sepal.Length>=4, select=c('Sepal.Length', 'Petal.Length', 'Species'))
subset(iris, subset=Sepal.Length>=4, select=c(1,3,5))
iris[iris$Sepal.Length>=4, c(1,3,5)]

#### 6. 데이터 합치기 ####
# 열합치기(컬럼합치기) cbind()
# 행합치기             rbind()
# 병합하기             merge()
## 6.1 cbind(열합치기)
( student.a <- data.frame(name=c('lee','kim'), score=c(100,90)) )
( student.b <- data.frame(id=c(101, 102), gender=c('여','남')) )
( student <- cbind(student.a, student.b)[,c(3,1,2,4)])

## 6.2 rbind(행합치기)
( student.a <- data.frame(name=c('lee', 'kim'), score=c(100,90)) )
( student.b <- data.frame(name=c('yun', 'ham','kum'), score=c(95,85,80)) )
( student <- rbind(student.a, student.b) )

## 6.3 merge(병합하기)
( student.a <- data.frame(name=c('lee', 'kim'), kor=c(100,90)) )
( student.b <- data.frame(name=c('lee', 'kim'), eng=c(95,90), mat=c(94,80)))
(student <- merge(student.a, student.b ))

( student.a <- data.frame(name=c('lee', 'park'), kor=c(100,90)) )
( student.b <- data.frame(name=c('lee', 'kim'), eng=c(95,90), mat=c(94,80)))
(student <- merge(student.a, student.b, all=T ))

#### 7. 데이터 정렬 ####
## sort() : 정렬된 데이터(1차원) 반환 / order() : 정렬된 데이터의 index를 반환
data <- c(10,30,100,1,3)
sort(data) # 오름차순 정렬
sort(data, decreasing = TRUE) # 내림차순 정렬
sort(iris$Sepal.Length)

data <- c(10,30,100,1,3)
names(data) <- c('1번째','2번째','3번째','4번째','5번째')
data
sort(data)
order(data) # c(4,5,1,2,3)
data[order(data)] # sort(data)

# iris데이터를 Sepal.Length기준으로 내림차순 정렬
orderBy(~-Sepal.Length, data=iris) # (1)

sort(iris$Sepal.Length, decreasing = T) # Sepal.Length기준으로 내림차순 정렬
order(iris$Sepal.Length, decreasing = T) # Sepal.Length기준으로 내림차순 정렬한 idx
iris[order(iris$Sepal.Length, decreasing = T), ] #  (1)과 동일

# iris데이터를 Sepal.Length기준으로 내림차순 정렬 (단, Sepal.Length, Species)
orderBy(~-Sepal.Length, data=iris)[,c('Sepal.Length','Species')]
iris[order(iris$Sepal.Length, decreasing = T), c('Sepal.Length','Species')]

# 문1. emp데이터셋에서 월급이 많은 순으로 ename,sal을 추출
emp[order(emp$sal, decreasing = T), c('ename', 'sal')]

# 문2. emp데이터셋에서 월급이 많은 top 5명의 ename, sal을 추출
head(emp[order(emp$sal, decreasing = T), c('ename', 'sal')], 5)
emp[order(emp$sal, decreasing = T), c('ename', 'sal')][1:5,]

# 문3. emp데이터셋에서 월급이 적은 top 5명의 ename, sal을 추출
tail(emp[order(emp$sal, decreasing = T), c('ename', 'sal')], 5)
head(emp[order(emp$sal), c('ename', 'sal')], 5)
emp[order(emp$sal), c('ename', 'sal')][1:5,]
emp[order(emp$sal, decreasing = T), c('ename', 'sal')][nrow(emp)-5:nrow(emp),]

#### 8. 데이터 프레임 이름 생략하기 ####
## 8.1 with절, within절
iris.temp <- iris
iris.temp[c(1,3),1] <- NA
head(iris.temp, 3)
# Sepal.Length의 종별 중앙값
mps <- tapply(iris.temp$Sepal.Length, iris.temp$Species, FUN=median, na.rm=T)
mps['setosa']
mps['versicolor']
mps['virginica']
# iris.temp$Sepal.Length2 <- iris.temp$Sepal.Length # Sepal.Length가 NA가 아닐 경우
# iris.temp$Sepal.Length2 <- mps[iris.temp$Species] # Sepal.Length가 NA일 경우 

#iris.temp$Sepal.Length2 <- ifelse(is.na(iris.temp$Sepal.Length),
#                                  mps[iris.temp$Species], 
#                                  iris.temp$Sepal.Length)
#head(iris.temp[,c('Sepal.Length','Sepal.Length2')], 3)

head(iris.temp)
## with절 Sepal.Length의 결측치가 대치된 결과값 반환
## within절 : Sepal.Length의 결측치가 대치된 데이터 프레임이 반환
iris.temp$Sepal.Length2 <- with(iris.temp, {
  Sepal.Length <- ifelse(is.na(Sepal.Length), mps[Species], Sepal.Length)
})
head(iris.temp)
iris.temp <- within(iris.temp, {
  Sepal.Length <- ifelse(is.na(Sepal.Length), mps[Species], Sepal.Length)
})
head(iris.temp)

## 8.2 attach(), detach()
attach(iris) # 지금부터는 iris$를 생략하셔도 됨
summary(Species)
find("Species")
Sepal.Length
tapply(Petal.Length, Species, mean)
detach(iris) # attach 기능 해제

#### 9. 데이터 집계 ####
## 9.1 table() : 카테고리별 갯수 집계
table(iris$Species) # 종별 갯수

# InsectSprays 데이터 셋에서 spray 별 집계
table(InsectSprays$spray)

# emp데이터 셋에서 deptno별 집계
table(emp$deptno)

## 9.2 aggregate() : 1개이상의 열에 대해, 1개 이상의 그룹화 처리 (적용함수는 1씩)
aggregate(iris[,1:4], by=list(iris[,5]), FUN=mean)
tapply(iris$Sepal.Length, iris$Species, mean)
by(iris$Sepal.Length, iris$Species, mean)
summaryBy(Sepal.Length+Petal.Length ~ Species, data=iris, FUN=mean)

# 보험회사의 고객들의 보험금 청구 데이터에서 고객별 입원일 조회
cust_id <- c(1001, 1002, 1001, 1003, 1002, 1004, 1005, 1001, 1002, 1001)
hos_day <- c(2,      3,    20,   5,     1,    8,    2,    2,    3,    2)
data <- data.frame(cust_id, hos_day)
data
day_per_cust <- aggregate(data$hos_day, by=list(data$cust_id), FUN=sum)
class(day_per_cust)
names(day_per_cust) <- c('cust_id', 'hos_day')
day_per_cust
day_per_cust[order(-day_per_cust$hos_day), ]

#### 10. 조건으로 색인찾기 : which(), which.min(), which.max() ####
which(iris$Species=='setosa') # setosa 데이터의 색인
iris[which(iris$Species=='setosa'), ] # setosa 데이터터
which.min(iris$Sepal.Length)  # Sepal.Length 최소값이 있는 데이터의 색인
iris[which.min(iris$Sepal.Length),]

which.max(iris$Sepal.Length)  # Sepal.Length 최대값이 있는 데이터의 색인
iris[which.max(iris$Sepal.Length),]