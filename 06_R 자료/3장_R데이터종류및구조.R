#────────────────────────────────────#
##### 3장. R 데이터 종류 및 구조 #####
#────────────────────────────────────#
#### 1. 데이터 종류 ####
     # 기본데이터타입: (문자,숫자,논리,복소수) = 스칼라타입
     # factor(남,여), vector, list, matrix, array, data.frame, 날짜, 특별한값(결측치..)
a <- 10+7i; #complex
class(a) # 타입 출력

#### 2. 기본 데이터 타입 ####
          #  └──→ character, numeric, logical(TRUE:T, FALSE:F), complex
# character : 문자, 문자열
a <- 'Hello'
a <- "Hello"
a <- 'I say, "HELLO"'
a <- 'Hello
R'
a <- 'Hello\nR'
cat(a)
class(a) # 타입
mode(a)
typeof(a)
methods(is) # is로 시작하는 함수들들
is.character(a) # a변수가 character인지 여부
as.character(100) # 100을 character로 형변환한 결과 반환

# numeric : 정수, 실수 
b <- 10.1
b <- 10
is.numeric(b)
as.character(b)
methods(as)
as.integer(10.9) # 매개변수를 정수로 (내림)

# logical
c <- TRUE;
is.logical(c)
class(c)
as.numeric(c)
as.character(c)

str(a) # str() R의 내부 구조를 간결하게 표시
str(b)
str(c)

#### 3. 특별한 값(Null, NA; 결측치, NaN, Inf) ####
result <- 0
add <- function(a, b){
  result <<- a+b
  return ()
}
( temp <- add(1,2) )
result
( temp <- add(b=10, a=1)) # Null : 값이 없음을 의미
is.null(temp)

d <- c(2, 4, NA, 6, NaN, 10/0) #vector(동일 자료형 집합)
d
mean(d) # 평균계산(결측치가 있으면 결측치)
mean(d, na.rm=TRUE) # 결측치를 제외한 값들의 평균균
d <- c(2, 4, NA, 6, NaN)
mean(d, na.rm = T)

# 결측치(NA) 관련함수
# is.na(d) : 결측치인지 아닌지 여부 반환
# complete.case(d) : d변수에 결측치가 아니면 TRUE
# na.omit(d) : 결측치 제외
# na.pass(d) : NA 여부와 상관없이 처리
d <- c(2, 4, 6, NA, 8, 10)
d[1] # 인덱스는 1부터 시작
is.na(d)
is.na(d[4])
?is.na
complete.cases(d)
# d에서 결측치가 아닌 값만 뽑아내기
d[c(TRUE, TRUE, TRUE, FALSE, TRUE, TRUE)]
d[complete.cases(d)]
na.omit(d)
mean(d, na.rm = TRUE)
boxplot(d)

#### 4. 팩터(fator) : 범주형데이터, 순서식(미리 정해진 여러개 값 중 하나) ####
gender1 <- c('남','여','여','남')
gender1[4]
gender1[5] <- '중성'
gender1
class(gender1) # vector변수의 타입은 요소 하나 하나의 타입
str(gender1)
gender <- factor(c('남','여','여','남'), levels=c('남','여'))
gender
gender[5]<-'중성'
gender
class(gender) # factor변수의 타입은 factor
str(gender)
na.omit(gender)

nlevels(gender) # level의 갯수
levels(gender)  # 카데고리 출력

level <- factor(c('좋음','보통','보통'), 
                levels=c('매우싫음','싫음','보통','좋음','매우좋음'),
                ordered=TRUE)
level
level[4]='매우좋음'
level[5]='몰라'
level
nlevels(level)
levels(level)

gender <- c('남','남','여','NA')
gender
class(gender)
# character <-> factor
gender <- as.factor(gender) # 범주형 변수로 변환(비추)
gender <- as.character(gender) # 범주형 변수를 character 벡터 변수로 변환
class(gender)
gender
gender <- factor(gender, levels=c('남','여')) # 범주형 변수로 변환(추천) 
gender
gender <- as.character(gender)
gender <- factor(gender, labels=c('남','여')) # 범주형 변수로 변환(추천) 
gender # 5장 전처리에서 

#### 5. 구조형 변수와 복합형 변수 : 변수 하나에 여러 값 할당 ####
    # (1) 구조형 변수 : 동일 자료형
    #         ex. 벡터(1차원), 행렬(2차원. 회귀분석 용이), 배열(n차원)
    # (2) 복합형 변수 : 서로 다른 자료형을 가질 수 있음
    #         ex. 리스트, 데이터프레임(cvs)

#### 6. 벡터 : 동일 자료형 ####
#자동 형변환 룰 : 문자 < 복소수 < 숫자 < logical
data <- c(11,22,33,'TEST') # 문자, 숫자 -> 문자
data <- c(11,22,33, TRUE)  # 숫자, logical -> 숫자
data <- c('a',TRUE)        # 문자, logical -> 문자자
data <- c(10,20, 1+10i, 'Hello', TRUE)
data
class(data)

data <- 1:10 #1~10까지의 정수
data[4] <- 40
data
# 
names(data)
names(data) <- c('A열','B열','C열','D열','E열','F열','G열','H열','I열','J열')
data
# 특정한 값 조회
data[1]  # 첫번째 값 반환
data['A열'] # A열 값 반환
data[c(1,2)] # 1번째, 2번째 값을 반환
# data[1,2] 에러
data[c('A열','B열','C열','D열')]# A열,B열,C열,D열 값 반환
data[c(1:4)] # 1,2,3,4번째 값을 반환
data[1:4]    # 1,2,3,4번째 값을 반환
# data[c('A열':'D열')] 에러
data[-2] # 2번째 값 제외 (음수는 제외)
data[-c(2,3)] # 2,3번째 값 제외
data[data>4] # 4보다 큰 값만 반환
data > 4
data[c(T,T,T,T,F,F,F,F,T,T)] #TRUE인 열만 값 반환

names(data) <- NULL
names(data)
data['A열']

# 항목갯수
length(data)
NROW(data)

2 %in% data  # data에 2가 포함되어 있는지 여부 T/F

# Q. (1) 시험점수 변수를 만들어 출력하고 (2)전체 평균을 구한 후 출력(평균=xx)
  # yi, kim, yun, lim, lee, park
  # 80. 100, 90,미응시, 70, 70
score <- c(80, 100, 90, NA, 70, 70)
score
names(score) <- c('yi', 'kim', 'yun', 'lim', 'lee', 'park')
score
avg <- mean(score, na.rm = TRUE)
cat('평균 =', avg)
paste('평균 =', avg)
# (3) 80점 이상의 점수만 출력(NA제외)
score[score>=80]
temp <- score[complete.cases(score)]
temp[temp>=80]

temp <- na.omit(score)
temp[temp>=80]


    # # # # # # # 함수 # # # # # # #
ax2_b.add <- function(a=0, b=0){
  return(2*a + b)
}
ax2_b.add()     # a=0,  b=0
ax2_b.add(10)   # a=10, b=0
ax2_b.add(b=10) # a=0,  b=10
ax2_b.add(10,1) # a=10, b=1
ax2_b.add(b=10, a=1)
# # # # # # # # # # # # # # # # 

# 6.1 character() : character 벡터 생성하는 함수
charVec <- character() # 길이0인 문자벡터 
charVec
is.vector(charVec)
class(charVec)
length(charVec)
charVec[1] <- 'R'
charVec
charVec <- character(5) # 길이가 5인 빈 문자 벡터
charVec
charVec[1]<-'안녕'; charVec[2]<-'R'; charVec[3]<-'수업중'
charVec
charVec[6] <- 'TEST'
charVec
charVec[8] <- 'test2'
charVec

# 6.2 numeric()
intVec <- numeric() # 길이가 0인 숫자 벡터
intVec
is.vector(intVec)
class(intVec)
intVec <- numeric(2) # 길이가 2인 숫자벡터 (0,0)
intVec
intVec[3] <- 12.2
intVec[5] <- 3.3
# intVec[6] <- 'Hello'
intVec

# 6.3 logical()
logicVec <- logical(3) # 길이가 3인 logical 벡터(FALSE, FALSE, FALSE)
logicVec[1] <- TRUE
logicVec[2] <- F
logicVec

# 6.4 seq
?seq
seq(from=1, to=10)
seq(1, 10)
seq(1, 10, 2)
seq(from=1, to=10, by=2)
seq(from=1, to=100, length.out=11)
a <- seq(1, 100, 11)
is.vector(a)
class(a)
seq(10, -10, -2)
seq(0, 1, 0.1)
seq(1, 9, pi)
pi <- 3
pi
rm(pi)
pi
cat <- function(a, b){
  return (a+b)
}
cat('pi값은 ',pi)
rm(cat)

# 6.5 rep()
? rep
# rep(x, times=1, length.out = NA, each=1)
rep(1:4, 2)
rep(1:4, times=2)  # 1 2 3 4 1 2 3 4
rep(1:4, each=2)   # 1 1 2 2 3 3 4 4 

rep(1:4, times=2, each=2) # 1 1 2 2 3 3 4 4 1 1 2 2 3 3 4 4
rep(1:4, 2, 5, 2)
rep(1:4, times=2, length.out=5, each=2)

# 6.6 벡터의 연산 (+,-,*,/,%%, 결합, 교집합, 합집합, 차집합, 벡터비교연산)
a <- c(1,  2,  3)
b <- c(10, 20, 30, 3)
# 벡터의 사칙연산은 요소별 연산
a + b
a - b
a * b
a / b
a %% b # 나머지 연산
c(a, b) # 결합

a <- c(1,2,3)
b <- c('Hello', 'R')
c <- c(TRUE, FALSE)
c(a, b, c) # 다른 타입의 벡터 결합시 타입이 자동 바뀜
# 자동형변환 룰 : character > complex > numeric > logical
a <- append(a, c(4,5,6))
a <- append(a, 7)
a
a[8] <- 8
a[10] <- 10
a

# 벡터의 집합 연산 : 합집합(union), 교집합(intersect), 차집합(setdiff), 비교(setequal)
a <- c(1,2,3,4, 5, 6)
b <- c(2,4,6,8,10,12)
union(a, b)      # 합집합 1,2,3,4,5,6,8,10,12
union(b, a)
intersect(a, b)  # 교집합 2 4 6
intersect(b, a)
setdiff(a, b)    # a-b차집합 1 3 5
setdiff(b, a)    # b-a차집합 8 10 12
setequal(a, b)
setequal(c(1,2,1), c(2,1))
setequal(a, c(intersect(a, b), setdiff(a, b) ))

#### 7. 리스트 ####
        # ; 복합 구조형(키값 형태로 데이터를 담는 복합 구조형)
student <- list(name='홍길동', age=25)
student
student$name   # ★
student['name']
student[1]   # $name [1]홍길동
student[[1]] # [1]홍길동
student$age <- NULL # student의 age 제거
student$score <- 100 #student의 score 추가
student$expel <- FALSE # student의 expel 추가
student
NROW(student)   #항목 갯수
length(student) #항목 갯수

studentVect <- unlist(student) # list를 벡터로 (동일 자료형으로 변환)
is.vector(studentVect)
studentVect
student2 <- as.list(studentVect) #벡터를 list형으로
student2
student

#### 8. 행렬 ####
colMatrix <- matrix(1:15, nrow=5, ncol=3)
colMatrix
?matrix
# dimnames는 반드시 list
rowMatrix <- matrix(1:15, nrow=5, ncol=3, byrow = TRUE,
                    dimnames = list(c("R1", "R2", "R3", "R4", "R5"), 
                                    c("C1","C2","C3"))
                    )
rowMatrix
rowMatrix[1,3]  # 1행3열 데이터
rowMatrix['R1','C3'] # R1행 C3열 데이터
rowMatrix[1:3, 1:2]  # 1~3행, 1~2열 데이터
rowMatrix['R1':'R3', 'C1':'C2']
rowMatrix[c(1,3,5) , ] # 1,3,5행 데이터
rowMatrix[c('R1','R3','R5'), ] # R1,R3,R5행 모든 열 데이터
rowMatrix[, c('C2','C3')]      # c2, c3열 모든 행 데이터
rowMatrix[c(1,3,5)]
rowMatrix

dim(rowMatrix) # 차원수 (행,열 수)
NROW(rowMatrix) # 행 수
nrow(rowMatrix) # 행 수
NCOL(rowMatrix) # 열 수
ncol(rowMatrix) # 열 수
dimnames(rowMatrix) # 차원이름
dimnames(rowMatrix) <- list(c('1행','2행','3행','4행','5행'),
                            c('A열','B열','C열'))
rowMatrix
rownames(rowMatrix) # 행 이름
rownames(rowMatrix) <- c('1월','2월','3월','4월','5월')
colnames(rowMatrix) # 열이름
colnames(rowMatrix) <- c('kim','park','lee')
rowMatrix

# 행렬 값 조회
rowMatrix['1월','kim', drop=FALSE] #1월kim열의 데이터를 Matrix형태로 반환
rowMatrix['1월',] # 1월 데이터가 벡터 형태로 반환
rowMatrix['1월', , drop=FALSE]# 1월 데이터가 Matrix 형태로 반환
rowMatrix[c(1:3), c(1:2)]
# rowMatrix[c('1월':'3월'), c('kim':'park')] 에러
rowMatrix[-3, c('kim','lee')]
rowMatrix[-3,] # 3행 제외한 모든 열 데이터
rowMatrix[-3]  # 3번째 데이터를 제외한 모든 데이터가 벡터형태로 1차원 반환

# 행렬의 곱(%*%), 전치행렬(행과 열을 교환), 대각행렬(cf. 단위행렬), 역행렬
# 행렬의 곱(%*%)
payMatrix <- matrix(c(12000,26000,18000), ncol=3)
payMatrix
dimnames(payMatrix) <- list(c('시간당수당'),c('철수','영희','길동'))
payMatrix
workerMatrix <- matrix(c(c(5,4,9), c(7,3,2)), nrow=3,
                    dimnames = list(c('철수','영희','길동'),
                                    c('5월','6월'))
)
workerMatrix
# payMatrix(1x3 행렬) workerMatrix(3x2 행렬)
cost <- payMatrix %*% workerMatrix
cost
rownames(cost) <- c('인건비')
cost['인건비',]
# 전치행렬 (행과열을 교환)
rowMatrix <- matrix(1:15, nrow=5, ncol=3, byrow = T,
                    dimnames = list(c('R1','R2','R3','R4','R5'),
                                    c('C1','C2','C3')))
rowMatrix  # 5x3 
t(rowMatrix) # 3x5

# 역행렬
X <- matrix(1:4, nrow=2, ncol=2, byrow = F)
X
solve(X) # 역행렬
X %*% solve(X)
solve(X) %*% X
# 단위행렬 ; 대각행렬을 구하는 diag() 함수 이용
diag(c(1,1)) # 2x2 단위행렬
diag(rep(1,2)) # 2x2 단위행렬렬
diag(rep(1,3)) # 3x3 단위행렬

# 행렬의 곱을 이용한 선형회귀식 도출(데이터가 2개)
x <- c(2, 4) # 독립변수: 공부량
y <- c(40,60) # 종속변수 : 점수

X <- matrix(c(x, rep(1, NROW(x)) ), nrow=NROW(x), ncol=2, byrow = FALSE )
X
Y <- matrix(y, ncol=1)
Y
#              X %*% ab =              Y
# solve(X) %*% X %*% ab = solve(X) %*% Y
#                    ab = solve(X) %*% Y
ab <- solve(X) %*% Y
ab
ab[1] # x의 기울기
ab[2] # 절편
plot(x, y)
lines(x, x*ab[1]+ab[2], col=2, lty='dotdash', lwd=4 )                      # 빨강,  선스타일, 선굵기
lines(x, y, col=1, lty=1)
# 공부량을 5시간으로 하면 예측되는 종속변수는?
ab[1]*5 + ab[2]

# 행렬의 곱을 이용한 선형회귀식 도출(데이터가 8개) pt.38참조
x <- c(32, 64, 96, 118, 126, 144, 152.5, 158) # 독립변수
y <- c(18, 24, 61.5, 49, 52, 105, 130.3, 125) # 종속변수
X <- matrix(c(x, rep(1, NROW(x))), nrow=NROW(x), ncol=2)
X
Y <- matrix(y, ncol=1)
Y
# X %*% ab = Y
# X가 8x2 행렬 t(X)가 2X8행렬 X %*% t(X) => 8x8 행렬
                          # t(X) %*% t   => 2x2 행렬
#                       2x8행렬    8x2행렬
#           X %*% ab =          Y
#  t(X) %*% X %*% ab = t(X) %*% Y
#  ---------- 좌우변에 solve(t(X) %*% X) %*% 추가
# solve(t(X) %*% X) %*% t(X) %*% X %*% ab = solve(t(X) %*% X) %*% t(X) %*% Y
# --------------------------------- 단위행렬은 생략 가능
# ab = solve(t(X) %*% X) %*% t(X) %*% Y
ab <- solve(t(X) %*% X) %*% t(X) %*% Y
ab
lm(y~x) # 회귀식을 도출하는 함수
plot(x, y)
lines(x, x*ab[1]+ab[2], col=2)

# 행렬의 곱을 이용한 다변량 선형회귀식 도출(독립변수 3개)
x1 <- c(60,65,55)      # 독립변수1 : 몸무게
x2 <- c(5.5, 5.0, 6.0) # 독립변수2 : 키
x3 <- c(1, 0, 1)       # 독립변수3 : 흡연유무
y  <- c(66, 74, 78)    # 수명

X <- matrix(c(x1, x2, x3), nrow=NROW(x1), ncol=3)
X
Y <- matrix(y, ncol=1)
Y
#              X %*% ab =              Y
# solve(X) %*% X %*% ab = solve(X) %*% Y
# ab = solve(X) %*% Y
ab <- solve(X) %*% Y
ab # w1=ab[1] , w2=ab[2], w3=ab[3]

solve(X, Y)
# 80Kg, 6.5ft, 금연 중인 사람의 기대 수명?
80*ab[1] + 6.5*ab[2] + 0*ab[3]

# 행렬을 데이터프레임으로 변환
X
dimnames(X) <- list(c('Lee','Park','Kim'),
                    c('몸무게','키','흡연유무'))
X
dataFrame <- as.data.frame(X)
dataFrame
class(dataFrame)
class(X)

# 행렬연산 ( *,+,-,/,%%,   %*%)
( a <- matrix(1:4, nrow=2, ncol=2) )
( b <- matrix(seq(0, 30, 10), nrow=2, ncol=2))
a %*% b # 행렬의 곱
a * b   # 행렬 요소별 연산 (+,*,/,-,%%나머지, ^승)
a + b
a - b
a / b
a %% b
a ^ b

#### 9. 배열 (n차원 동일 자료형의 집합) ####
dataArray <- array(1:24, dim=c(3,4,2)) # 3차원 numeric 배열 (3행4열2면)
dataArray
dataArray[3,2,1] # 3행2열1면
dim(dataArray)   # 차원
nrow(dataArray)  # 행수
NROW(dataArray)
ncol(dataArray)  # 열수
NCOL(dataArray)
length(dataArray) # 요소의 갯수 : 24
dataArray
dimnames(dataArray) <- list(c('1행','2행','3행'),
                            c('1열','2열','3열','4열'),
                            c('x면','y면'))
dataArray
dim(dataArray) <- c(3,8)
dataArray

dim(dataArray) <- c(3,4,2)       #reshape ★
dataArray
attr(dataArray, 'dim') <- c(3,8) #reshape
dataArray

#### 10. 데이터 프레임 ★ ####
# (1) 데이터 프레임 생성
student_id <- c('20211','20212','20213','20214')
student_name <- c('Jin','Eric','Den','Kei')
student_kor  <- c(100,95,90,85)
student_eng  <- c(99,94,98,84)
student_gender <- c('남','여','남','여')
student_data <- data.frame(student_id, student_name, student_kor,
                           student_eng, student_gender)
student_data
st <- edit(student_data)
st
d <- data.frame(id=c(1,2,3), name=c('김','홍','이'))
d
# (2) 데이터프레임에 열 추가 및 삭제
student_data$mat <- c(100,95,94,80) # 열 추가
student_data
student_data$age <- c(20,21,22,23) # 열 추가
student_data$age <- NULL        # 열 삭제
student_data
# (3) 데이터프레임의 열 형 변환
str(student_data) # 구조 보기
student_data$student_id <- as.numeric(student_data$student_id) # 수치형 변환
str(student_data)
student_data$student_gender <- as.factor(student_data$student_gender) # factor형
str(student_data)
student_data$student_gender <- as.character(student_data$student_gender) # 문자형
str(student_data)
student_data$student_gender <- factor(student_data$student_gender, 
                                    levels=c('남','여'))
str(student_data)
student_data$student_gender <- as.character(student_data$student_gender) # 문자형
str(student_data)
student_data$student_gender <- factor(student_data$student_gender, 
                                      labels=c('남','여'))
str(student_data) # 구조보기
summary(student_data) # 통계치 보기

# (4) 데이터프레임의 열이름 변경 (모든열이름변경, 특정열의 열이름만 변경)
library(reshape) # 에러
.libPaths() # install된 패키지가 설치된 폴더
install.packages("reshape") # 1. 패키지 설치
require(reshape) # 2. 패키지를 메모리에 로드드
library(reshape)
?rename
student <- rename(student_data, c("student_id"="id")) # 특정 열이름 변경
student <- rename(student, c("student_name"="name",
                             "student_kor"="kor",
                             "student_eng"="eng",
                             "student_gender"="gender"))
student
names(student_data) # 열들의 이름
names(student_data) <- c("id","name","kor","eng","gender","mat") #모든 열이름 변경 
student_data
# (5) 데이터 프레임 합치기 : cbind, rbind
# rbind : 행합치기
newStudent <- rbind(student, student_data)
newStudent
# cbind : 열합치기
student
add_data <- data.frame(age=c(30,31,35,28), nickname=c('개똥','말똥','길똥','소똥'))
add_data
cbind(student, add_data)

# (6) 데이터프레임의 부분 데이터 조회
student <- rbind(student, student) # 2회 실행 -> 16행
nrow(student)
ncol(student)
names(student)
student[1,1]     # 1행 1열
student[1, 'id'] # 1행 'id'열
student[1, ]     # 1행 모든 열 데이터
student[ , 1]    # 모든 행의 1열 데이터 (벡터 형태로 반환)
student[, 1, drop=FALSE] # 모든 행의 1열 데이터 (데이터 프레임 형태로 반환)
student[1:3, ] # 1~3행가지의 모든 열 데이터
student[, 2:5] # 모든 행의 2,3,4,5열 데이터
student[, c(2,3,4,5)] # 모든 행의 2,3,4,5열 데이터
student[, c("name","kor","eng","gender")]
student[-c(2,4,6),]  # 2,4,6행외의 모든 데이터
student[c(-2,-4,-6),]# 2,4,6행외의 모든 데이터
student[1:3, c(-1,-5)] # 1~3행 데이터에서 1열과 5열을 제외한 데이터
student[1:3, -c(1,5)] # 1~3행 데이터에서 1열과 5열을 제외한 데이터
student[seq(1,3), -c(1,5)] 
student[student$kor>=90, ] # kor점수가 90점 이상인 모든 열 데이터
student[student$kor>=90, c('name','kor')]# kor점수가 90점 이상인 사람의 이름과 kor 데이터
# subset함수 : 데이터프레임의 부분 데이터 조회
?subset
subset(student, subset=(student$kor>=90)) #  kor이 90이상인 모든 열 데이터
subset(student, student$kor>=90)
subset(student, subset = (student$kor>=90 & student$gender=='남') )# kor이 90이상인 남자의 모든 열 데이터
subset(student, select = c(1,4))
subset(student, select = c(1:4))
subset(student, select = c('id','name','kor','eng'))
# subset(student, select = c('id':'eng'))
subset(student, select = c(-1, -4)) # 1열과 4열 제외
subset(student, select = -c(1, 4)) # 1열과 4열 제외
subset(student, select = c('id', 'eng')) # id열과 eng열 제외
# mat가 90점이상인 여학생 데이터(id, name, mat, kor열만 출력)
subset(student, subset = (mat>=90 & gender=='여'), select=c('id','name','mat','kor'))


student[1:6, ]    #처음 6행만
student[c(1:6), ] #처음 6행만
head(student)     #처음 6행만
head(student, 3) # 처음 3행만
student[c((nrow(student)-3) : nrow(student)),] #마지막 3행만
tail(student, 3) # 마지막 3행만
tail(student)    # 마지막 6행만만

# 문
emp <- read.csv(file.choose()) # 탐색기에서 선택한 csv파일을 emp변수 할당
emp
head(emp)
tail(emp)
class(emp)
# 1. 직원이름만 (벡터형식, 데이터프레임형식)
emp$ename
emp[,2] # 벡터 형태로 반환
emp[,2,drop=FALSE] # 데이터프레임 형태로 반환
emp[,'ename']
emp[,'ename',drop=FALSE] # 데이터프레임 형태로 반환
subset(emp, select='ename', drop=TRUE) # 벡터 형태로 반환
subset(emp, select='ename')            # 데이터 프레임 형태로 반환

# 2. 직원이름, job, sal
names(emp) # empno, ename, job, mgr, hiredate, sal, comm, deptno
emp[,c(2,3,6)]
emp[,c('ename','job','sal')]
subset(emp, select=c(2,3,6))
subset(emp, select=c('ename','job','sal'))

# 3. 이름이 KING인 직원의 empno, job, hiredate, sal
subset(emp, subset=(emp$ename=='KING'), select=c('empno','job','hiredate','sal'))
subset(emp, subset=(ename=='KING'), select=c('empno','job','hiredate','sal'))
emp[emp$ename=='KING', c('empno','job','hiredate','sal')]

# 4. sal이 2000~3000사이인 직원의 ename, sal
subset(emp, subset=(sal>=2000 & sal<=3000), select=c('ename','sal'))
emp[emp$sal>=2000 & emp$sal <=3000, c('ename','sal')]

## 11. 타입 판별 및 타입 변환
class(iris)  #  타입 판별
class(iris$Species) # 타입 판별
is.factor(iris$Species) # 특정 타입 판별
str(iris$Species)  # 구조보기로 타입 판별
a <- c(1,2,3)
class(a) # 타입 판별
mode(a)  # 타입 판별
typeof(a)# 타입 판별

# 형변환
a <- as.integer(a)
typeof(a)# integer
class(a) # integer
mode(a)  # numeric

str(emp)
summary(emp)
emp$deptno <- as.factor(emp$deptno) # 데이터를 다운받을 경우 NA로 추정되는 값이 많이 비추
emp$deptno <- factor(emp$deptno, levels=c(10,20,30,40))
str(emp)
summary(emp)

## 12. 문자열과 날짜
name <- "Eric"
length(name) # 요소의 갯수 : 1
nchar(name)  # 문자 길이 : 4

names <- c('Eric','Larray','Curly')
length(names) # 요소의 갯수 : 3
nchar(names)  # 요소하나 하나의 문자 길이 : 4 6 5

# 하위 문자열 추출하기 : substr
?substr
substr('ABCDEF', 1, 4) # 1~4번째 문자 추출 : ABCD
substr('ABCDEF', 4, 16) # 4~16번째 문자 추출. 없는 번째 문자는 ""로 처리 
substring('ABCDEF', c(1, 2), c(2, 3)) # "AB" "BC"

names <- c('Eric','Larray','Curly')
class(names)
substr(names, 1, 2) # names 안에 각 문자 1~2번째 추출
# names안에 각각의 이름의 맨 마지막자리 앞글자부터 맨 마지막글자
# 결과 : "ic" "ay" "ly"
substr(names, nchar(names)-1, nchar(names))

# 문자열 연결하기 : paste() paste0()
names <- c('Eric','Larray','Curly')
paste(names, 'loves', 'stars.')
paste(names, 'loves', 'starts.', sep='♡')
paste0(names, 'loves', 'starts.')
paste(names, 'loves','stars', sep='♡', collapse=', ')

# 문
name <- c('Yi', 'Lim', 'Kim'); hobby<-c('swim','sleep','eat')
# 결과 : Yi의 취미는 swim이고, Lim의 취미는 sleep이고, Kim의 취미는 eat
paste(name, hobby, sep='의 취미는 ', collapse='이고, ')

# 문자 분할 (구분자로 분할하기)
path <- 'home/hadoop/data/speech.csv'
strsplit(path, '/')
customerInfo <- 'jin@gmail.com,010-8888-888,seoul Korea'
strsplit(customerInfo, ',010-8888-888,')
customers <- c('jin@gmail.com,010-8888-8888,seoul Korea',
               'yis@gmail.com,010-9999-9999,Inchon Korea',
               'kim@naver.com,02-716-6111,Mapo')
strsplit(customers, ',[0-9]{2,3}-[0-9]{3,4}-[0-9]{4},')

# 문자열 대체 sub(oldStr, newStr, string) 처음 나오는 oldStr을 newStr로 바꿈
#            gsub(oldStr, newStr, string) 다 바꿈
s <- 'Curly is the smart one. Curly is funny, too.'
sub('Curly','Kim', s)
gsub('Curly','Kim', s)
s <- 'Curly is the smart one. 

Curly is funny, too.♡ @#$%^'
s <- gsub('[♡@#$%^]','', s)
s <- gsub('\n',' ', s)
s

# 외적 : outer ; 문자열의 모든 쌍별 조합 만들기
a <- c('aa','bb','cc')
b <- c('11','22','33')
outer(a, b, FUN="paste")

# 날짜
today <- Sys.Date()
today
class(today)
thatDay <- as.Date('21-06-28', '%y-%m-%d') # %Y:년도4자리, %y:년도2자리, %m:월, %d:일
thisDay <- as.date('06/09/2021', '%m/%d/%Y')

if(thatDay < today){
  cat('thatDay보다 today가 훗날')
}
today

################총괄 연습문제 ###########################
# 문1
# 1) iris의 차원 확인
dim(iris)
dim(available.packages()) # CRAN에 공식 등록된 패키지 수
# 1) 컬럼이름 확인
colnames(iris)
names(iris)
# 1) 구조확인
str(iris)
# 1) 속성들
colnames(iris)

# 2) iris의 요약통계 정보
summary(iris)

# 2) 꽃받침길이(Sepal.Length) 처음 10개
head(iris$Sepal.Length,10)
iris[c(1:10),'Sepal.Length'] # 벡터 형태
iris[c(1:10),'Sepal.Length', drop=FALSE] # 데이터프레임 형태
head(iris[1], 10) # iris[1] 1번째 열만

# 3) virginica종만 추출
levels(iris$Species)
virginica <- iris[iris$Species == 'virginica',]
virginica <- subset(iris,subset=(iris$Species == 'virginica'))
virginica <- subset(iris,subset=iris$Species == 'virginica')
virginica <- subset(iris,iris$Species == 'virginica')
virginica <- subset(iris,Species == 'virginica')
head(virginica)
# 3) setosa종만 추출
setosa <- iris[iris$Species == 'setosa',]
setosa <- subset(iris,subset=(iris$Species == 'setosa'))
setosa <- subset(iris,subset=iris$Species == 'setosa')
setosa <- subset(iris,iris$Species == 'setosa')
setosa <- subset(iris,Species == 'setosa')
head(setosa)
# 4) 추출한 부분 데이터셋(virginica와 setosa)을 다시 결합해 봅니다.
rbind(virginica, setosa)

# 2. setosa 종의 꽃 받침(Sepal)의 폭과 길이 부분 데이터 셋을 추출
subset(iris, subset=(Species == 'setosa'), select = c('Sepal.Length', 'Sepal.Width'))
iris[iris$Species=='setosa', c('Sepal.Length', 'Sepal.Width')]

# 3.
pay <- matrix(c(12000,26000,18000), ncol=3,
              dimnames = list(c('시급'),c('A작업','B작업','C작업')))
pay # 1행 3열

work <- matrix(c(c(5,4,9),c(7,3,2)) , ncol=2,
               dimnames = list(c('A작업','B작업','C작업'), c('갑','을')))
work
salaray_cost <- pay %*% work
salaray_cost
rownames(salaray_cost) <- c('급여')
salaray_cost
