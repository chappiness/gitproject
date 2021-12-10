#────────────────────────────────────#
##### 7장. 데이터 처리 성능 향상 #####
#────────────────────────────────────#
# 이장의 내용 : ① plyr패키지(apply계열 함수 대치) ② 데이터 구조변경(melt, cast) ③ 데이터테이블
#### 1. plyr 패키지 ####
install.packages("plyr")
library(plyr)
apply(iris[,1:4], 2, FUN=mean)
apply(iris[,1:4], 2, FUN=function(col){mean(col)})

x <- data.frame(v1=c(4,9,16),    # 2의제곱, 3의 제곱, 4의제곱
                v2=c(16,81,196)) # 4의제곱, 9의제곱, 14의제곱곱
x
apply(x, 2, sum)
apply(x, 2, FUN=function(col){sum(sqrt(col))})
adply(.data=x, .margins = 2, .fun = function(col){sum(sqrt(col))})

# 종별 Sepal.Length평균, Sepal.Width평균
library(doBy)
summaryBy(Sepal.Length+Sepal.Width ~ Species, data=iris, FUN=mean)
ddply(.data=iris, .(Species), function(group){
  data.frame(SL.mean=mean(group$Sepal.Length),
             SW.mean=mean(group$Sepal.Width))
})
# summarise : 명시된 변수들만 출력
# transform : 기존의 iris뒤에 명시된 변수가 추가되서 출력
ddply(.data=iris, .(Species), summarise, SL.mean=mean(Sepal.Length),
                                        SW.mean=mean(Sepal.Width))
ddply(.data=iris, .(Species), transform, SL.mean=mean(Sepal.Length),
      SW.mean=mean(Sepal.Width))

round(runif(29, min=18, max=54))
dfx <- data.frame(group=c(rep('A',8), rep('B',15),rep('C',6)),
                  gender=sample(c('M','F'), size=29, replace = TRUE), #복원추출
                  age = round(runif(29, min=18, max=54)) )
dfx

ddply(dfx, .(group, gender), summarise, mean=round(mean(age),2), sd=round(sd(age),2))
ddply(dfx, .(group, gender), transform, mean=round(mean(age),2), sd=round(sd(age),2))

library(doBy)
summaryBy(age~group+gender, dfx, FUN=c(mean,sd))

#### 2. 데이터 구조 변경 (melt, cast함수) ####
View(airquality)
install.packages("reshape2")
library(reshape2)
airquality.melt <- melt(airquality, id=c('Month','Day'), value.name = "val")
head(airquality.melt)
# melt를 통해 바뀐 구조(5월5일 데이터)
subset(airquality, Month==5&Day==5)
subset(airquality.melt, Month==5&Day==5)

airquality.melt <- melt(airquality, id=c('Month','Day'), na.rm = TRUE)
# melt를 통해 바뀐 구조(5월5일 데이터)
subset(airquality, Month==5&Day==5)
subset(airquality.melt, Month==5&Day==5)

# melt된 데이터를 원상 복구 : dcast vs. acast
airquality.dc <- dcast(airquality.melt, Month+Day~variable)
head(airquality.dc, 2)
head(airquality,2)
airquality.dc[airquality.dc$Month==5 & airquality.dc$Day==1,] # 5월 1일 대기정보 데이터
airquality.ac <- acast(airquality.melt, Month+Day ~ variable)
head(airquality.ac,2)
airquality.ac['5_1',] # 5월 1일 대기정보 데이터

### 데이터 구조 변경 예

df1 <- read.csv('C:\\bigdata\\Download\\sharedBigdata\\전국 평균 평당 분양가격(2013년 9월부터 2015년 8월까지).csv')
df1
table(is.na(df1))
df1.melt <- melt(df1, id=c('지역'), value.name='price')
head(df1.melt)
str(df1.melt)
df1.melt$variable <- as.character(df1.melt$variable)

# variable에서 년도 뽑기
variable = 'X2013년12월'
as.integer(substr(variable, 2, 5))
df1.melt$연도 <- as.integer(substr(df1.melt$variable, 2, 5))
edit(df1.melt)

# variable에서 월 뽑기
variable <- 'X13년12월'
monthStr <- strsplit(variable, '년')[[1]][2]
monthStr <- substr(monthStr, 1, nchar(monthStr)-1)
as.integer(monthStr)

getMonth <- function(variable){
  monthStr <- strsplit(variable, '년')[[1]][2]
  monthStr <- substr(monthStr, 1, nchar(monthStr)-1)
  return(as.integer(monthStr))
}
getMonth('X2013년12월')
df1.melt$월 <- sapply(df1.melt$variable, getMonth)
edit(df1.melt)
df1.melt$variable <- NULL
head(df1.melt)

df2 <- read.csv('C:/bigdata/Download/sharedBigdata/주택도시보증공사_전국 신규 민간아파트 분양가격 동향_20210531.csv')
dim(df2) # 5780행 5열
head(df2)
df2 <- df2[df2$규모구분=='모든면적',]
head(df2)
df2$규모구분 <- NULL # 필요없는 변수 삭제제
head(df2)

str(df2)
colnames(df2) <- c('지역','연도','월','price_per_meter')
str(df2$price_per_meter)
df2[df2$price_per_meter=='',]
colSums(is.na(df2))
df2$price_per_meter <- as.integer(df2$price_per_meter) # 형변환
colSums(is.na(df2)) # 빈스트링등 정수형으로 변환할 수 없는 것은 NA로 처리
df2$price <- df2$price_per_meter * 3.3

head(df1.melt,2)
head(df2[,c('지역','연도','월','price')],2)
df <- rbind(df1.melt, df2[,c('지역','연도','월','price')])
edit(df)

#### 3. 데이터 테이블 : 짧고 유연한 빠른 구문을 사용하기 위해 데이터프레임에서 상속받음####

flightDF <- read.csv('inData/flights14.csv', header=T)
dim(flightDF)
edit(flightDF)
head(flightDF,2)
tail(flightDF,2)
class(flightDF)

install.packages("data.table") # 데이터테이블을 사용하기 위해 패키지 설치
library("data.table")
flights <- fread('inData/flights14.csv') # csv파일을 데이터테이블로 받는 함수수
class(flights)

# flightDF(데이터프레임)에 대해 다음의 R명령어를 작성하시오

# 1. origin이 JFK이고 month가 5월인 모든 행을 result에 얻는다
result <- flightDF[flights$origin=='JFK' & flightDF$month==5,]
result <- subset(flightDF, origin=='JFK' & flightDF$month==5)

result <- flights[origin=='JFK' & month==5,]
result <- flights[origin=='JFK' & month==5]
head(result,2)
# 2. 처음 두 행을 result에 얻는다
result <- flightDF[1:2,]
result <- head(flightDF,2)

result <- flights[1:2]
result
# 3. origin으로 오름차순, dest로 내림차순으로 정렬하여 출력(order사용)

flightDF[order(flightDF$origin),]
flightDF[order(flightDF$dest, decreasing = T),]
# flightDF[order(-flightDF$dest),] #불가
library(dplyr)
flightDF[order(flightDF$origin, desc(flightDF$dest)),]

flights[order(flights$origin, -flights$dest)]
flights[order(origin, -dest)]

# 4. arr_delay열만 출력
flightDF[,'arr_delay'] # 벡터 형태로 출력
flightDF[,'arr_delay', drop=F] # 데이터프레임 형태로 출력
subset(flightDF, select='arr_delay')
subset(flightDF, select=arr_delay)

flights[,arr_delay] # 벡터형태로 출력
flights[, .(arr_delay)] #데이터 프레임(데이터 테이블) 형태로 출력
flights[, c('arr_delay')] #데이터 프레임형태로 출력
flights[, c(arr_delay)] # 벡터형태로 출력
flights[, list(arr_delay)] # 데이터 프레임 형태로 출력

# 5. year열부터 dep_time열까지 출력
colnames(flightDF)
flightDF[,1:4]
flightDF[,c("year","month","day","dep_time")]
# flightDF[,c("year":"dep_time")] 불가
subset(flightDF, select=1:4)
subset(flightDF, select=c("year","month","day","dep_time"))
# subset(flightDF, select=c("year":"dep_time")) 불가

flights[, year:dep_time]
subset(flights, select=c(year:dep_time))

# 6. year열과 dep_time열 출력
flightDF[, c('year','dep_time')]
subset(flightDF, select = c('year','dep_time'))

flights[,c(year, dep_time)] # 행렬형태로 출력(X)
flights[,list(year, dep_time)]
flights[,c('year', 'dep_time')]
flights[, .(year, dep_time)]
flights[, .(년도=year, 실제출발=dep_time)] # 출력되는 header(변수) 변경

# 7. arr_delay열과 dep_delay열을 출력하되 열이름을 delay_arr과 delay_dep로 변경
temp <- flightDF[,c('arr_delay','dep_delay')]
colnames(temp) <- c('delay_arr','delay_dep')
temp

flights[, .(delay_arr = arr_delay, delay_dep = dep_delay)]

# 8. 지연시간(arr_delay, dep_delay모두 0미만인 비행이 몇 번인지 출력
nrow(flightDF[flightDF$arr_delay<0 & flightDF$dep_delay<0,])

flights[arr_delay<0 & dep_delay<0, .(cnt=.N) ]  # .N : 갯수
flights[, sum(arr_delay<0 & dep_delay<0)]

# 8-1 지연시간의 합이 0미만인 비행이 몇 번인지 출력
nrow(flightDF[(flightDF$arr_delay + flightDF$dep_delay) < 0,])

flights[arr_delay+dep_delay<0, .(.N)]
flights[arr_delay+dep_delay<0, .N]

# 9. 6월에 출발 공항이 JFK인 모든 항공편의 도착지연 및 출발지연 시간의 평균을 계산
apply(subset(flightDF, origin=='JFK' & month==6, select = c('arr_delay', 'dep_delay')), 2, mean)
apply(flightDF[flightDF$origin=='JFK'& flightDF$month==6, c('arr_delay', 'dep_delay')], 2, mean)

flights[origin=='JFK'& month==6, .(arr_mean = mean(arr_delay), 
                                   dep_mean = mean(dep_delay))]

# 10. 9번의 결과에 title에 mean_arr, mean_dep로 출력
x <- apply(subset(flightDF, origin=='JFK' & month==6, select = c('arr_delay', 'dep_delay')), 2, mean)
names(x)<- c('mean_arr', 'mean_dep')
x

flights[origin=='JFK'& month==6, .(mean_arr = mean(arr_delay), 
                                   mean_dep = mean(dep_delay))]

# 11. JFK 공항의 6월 운항 횟수
nrow(subset(flightDF,origin=='JFK' & month==6))
nrow(flightDF[flightDF$origin=='JFK' & flightDF$month==6,])

flights[origin=='JFK'&month==6, .(.N)]
flights[origin=='JFK'&month==6, .N]

# 12. JFK 공항의 6월 운항 데이터 중 arr_delay열과 dep_delay열을 출력
subset(flightDF, subset=(origin=='JFK' & month==6), select=c("arr_delay","dep_delay"))

subset(flightDF, origin=='JFK' & month==6, c("arr_delay","dep_delay"))

flightDF[flightDF$origin=='JFK' & flightDF$month==6, c("arr_delay","dep_delay")]

flights[origin=='JFK'&month==6, .(arr_delay, dep_delay)]
flights[origin=='JFK'&month==6, list(arr_delay, dep_delay)]
flights[origin=='JFK'&month==6, c('arr_delay', 'dep_delay')]

# 13. JFK 공항의 6월 운항 데이터 중 arr_delay열과 dep_delay열을 제외한 모든 열 출력
colnames(flightDF) # arr_delay열은 7번째, dep_delay열은 5번째
subset(flightDF, origin=='JFK' & month==6, select=c(-5,-7))
subset(flightDF, origin=='JFK' & month==6, select=-c(5,7))
# subset(flightDF, origin=='JFK' & month==6, select=-c('arr_delay','dep_delay')) # 불가
# subset(flightDF, origin=='JFK' & month==6, select=c(-'arr_delay',-'dep_delay')) # 불가
# flightDF[flightDF$origin=='JFK'&flights$month==6, c(-'arr_delay',-'dep_delay')] #불가
flightDF[flightDF$origin=='JFK'&flights$month==6, c(-5,-7)] 

flights[origin=='JFK'&month==6, -c("arr_delay", "dep_delay")]

# 14. 출발 공항(origin)별 비행 수 출력 (JFK 81483 LGA 84433 EWR 87400)
table(flightDF$origin)

flights[ , .(.N), by=.(origin)]
flights[, .N, by=origin]

# 15. 항공사코드(carrier)가 AA에 대해 출발공항별 비행횟수 계산
table(subset(flightDF, carrier=='AA')$origin)

flights[carrier=='AA', .(.N), by=.(origin)]

# 16. origin, dest별로 비행횟수 출력
table(flightDF$origin, flightDF$dest)

flights[, .(.N), by=.(origin, dest)]

# 17. 항공사코드(carrier)가 AA에 대해 origin, dest별로 비행횟수 출력
temp <- flightDF[flightDF$carrier=='AA',]
table(temp$origin, temp$dest)

flights[carrier=='AA', .(.N), by=.(origin, dest)]

# 18. 항공사 코드가 AA에 대해, origin, dest, 월별 평균arr_delay, 평균 dep_delay 출력
library(doBy)
temp <- flightDF[flightDF$carrier=='AA',]

summaryBy(arr_delay+dep_delay~origin+dest+month, data=temp, FUN=mean)

aggregate(temp[,c('arr_delay','dep_delay')], 
          by=list(temp$origin,temp$dest, temp$month),
          FUN=mean)

flights[carrier=='AA', .(mean_arr = mean(arr_delay), 
                         mean_dep = mean(dep_delay)),
        by=.(origin, dest, month)]

#  19. dep_delay>0가 참이거나 거짓, arr_delay>0가 참이거나 거짓인 각각의 비행횟수
table(flightDF$dep_delay>0, flightDF$arr_delay>0)

flights[, .(.N), by=.(dep_delay>0, arr_delay>0)]

#  20. Origin==“JFK”에 대해 월별 최대 출발 지연 시간 출력(month로 정렬)
temp <- subset(flightDF, origin=='JFK')
tapply(temp$dep_delay, temp$month, max)
result <- aggregate(temp$dep_delay, by=list(temp$month), max)
result
result[order(result$Group.1),]
library(doBy)
result <- summaryBy(dep_delay ~ month, data=temp, FUN=max)
result
result[order(result$month),]

# 지연 시간순으로 정렬
sort(tapply(temp$dep_delay, temp$month, max))

x <- flights[origin=='JFK', .(max=max(dep_delay)), by=.(month)] # x도 데이터테이블
x[order(month)]