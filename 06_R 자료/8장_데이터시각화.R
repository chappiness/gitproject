#────────────────────────────#
##### 8장. 데이터 시각화 #####
#────────────────────────────#
#### 1. 시각화 개요 : 원본데이터나 분석된 결과 데이터를 그래프로 표현. 사용자에게 효과적으로 정보전달 목적 ####

## 1.1 R의 그래픽 시스템
# (1) base graphics system : 전통적인 함수 이용(고수준 그래프 함수, 저수준 그래프 함수)
        # 그래프 종류별 함수가 각기 달라 정교한 그래프 이용시 노력 필요
# (2) grid graphic system - base graphics system의 한계 극복을 위해 만든 패키지(ggplot2)
        # 유연한 그래프 환경 제공

# ex.
boxplot(mtcars$mpg) # 고수준 그래프 함수
plot(mtcars$wt, mtcars$mpg) # 고수준 그래프 함수
fit <- lm(mtcars$mpg ~ mtcars$wt)
fit <- lm(mpg ~ wt, data=mtcars)
abline(fit, col="red") # 저수준 그래프 함수

library(ggplot2) 
ggplot(data = mtcars, aes(x=wt, y=mpg)) + # grid graphic system
  geom_point(col="blue", pch=2) +
  labs(title="첫 산점도 예제") +
  geom_smooth(method="lm")

ggplot(data=iris, aes(x=Species, y=Sepal.Length)) +
  geom_boxplot(fill="red")

## 1.2 그래프 함수
 # 고수준 함수 : plot, barplot, boxplot, hist, pie,....
        # 그래프 함수 호출할 때마다 새로운 그래프를 시작
 # 저수준 함수 : lines, abline(회귀라인), point, text
        # 새로운 그래프를 생성하지 않음. 이미 그려진 그래프 위에 점, 라인, 글씨..

## 1.3 그래프 파라미터 : 그래프를 그리는 함수들은 다양한 파라미터가 존재. par()함수를 통해 변경
# (1) par() : 그래프를 조정하거나 특성을 지정 ex.bty(그래프박스유형), 선굵기, 색상...
  # par()함수의 리턴값은 실행전 특성 리턴.
?par
cars
plot(cars)
oldPar <- par(bty='L') # 파라미터 지정전 객체를 저장 
plot(cars) # 변경된 파라미터 대로 그래프가 그려짐
plot(iris)
par(oldPar) # oldPar 설정으로 복귀귀
plot(cars)
?plot
plot(cars, xlab="x label", ylab="y label", main="제목")
fit <- lm(dist~speed, data=cars)
abline(fit, col="saddlebrown", lwd=4, lty="dashed")
?par
colors()
# col : 1-black,2-red,3-green,4-blue,5-cyan,6-purple,7-yellow,8-gray

# par함수의 다른 파라미터 사용 예
x <- 1:100
y1 <- rnorm(100) # 평균0이고 표준편차가 1인 수 100개 추출(표준정규분포)
y2 <- rnorm(100)+100 # 평균이 100이고 표준편차가 1인 수 100개 추출출
?par
oldPar <- par(mar=c(5,5,5,5)) # 그래프 여백(하,좌,상,우)
?plot
plot(x, y1, pch=21, type="b", col="red", bg="pink", 
     ylim = c(-8,2), yaxt="n", bty="n", ylab="")
  # xlim, ylim : x, y축 눈금 조정
  # yaxt : y축 눈금 없애기
  # bty : 그래프 박스 type : o, ], L, 7, C
axis(side=2, at=c(-2,0,2), col="red")
  # side :1하,2좌, 3상, 4우
  # at 축과 눈금이 그려질 위치
mtext("red line(y1)", side=2, line=2, at=0, col=2)

par(new=TRUE) #기존그래프 지우지 않고 덧그림

plot(x, y2, pch=20, type="b", col="blue",
     yaxt="n", ylim=c(98,108), ylab="", bty="n")
axis(side=4, at=c(98,100,102), col="blue")
mtext("blue line(y2)", side=4, line=2, at=100, col="blue")

par(oldPar) # 그래프 영역 설정 원상 복구

#### 2. 고수준 그래프 함수 #### (base graphic system)
## 2.1 plot : type에 따라 여러 유형의 그래프를 그림. 산점도 함수
# 3행2열로 그래프 영역 분리하고 type속성에 따른 그래프 
?par # mfrow
oldPar <- par(mfrow=c(2,3))
plot(cars, type="p", main="p 타입") # 일반적 산점도
plot(cars, type="l", main="l 타입") # 추세선
plot(cars, type="b", main="b 타입") # 선과 점 겹치지 않게게
plot(cars, type="s", main="s 타입") # 계단 형태
plot(cars, type="n", main="n 타입") # 안 보여여
plot(cars, type="o", main="o 타입") # 선과 점 겹치게
par(oldPar)

plot(cars, main="speed and Stopping Dsitance of cars",
     xlab="speed(mph)", ylab="stopping distance(ft)",
     las=1)
    #las;축눈금라벨방향 0축과평행, 1가로 2축과수직 3세로
?plot

## 2.2 barplot : 막대그래프
datasets::VADeaths
class(VADeaths)
VADeaths
rownames(VADeaths)
?par
?barplot
barplot(VADeaths, main="버지니아 사망율", font=2,
        border="red", legend=rownames(VADeaths),
        density=50, angle=c(10,30,50,70,120),
        col=c("#0000FF","azure","red","pink","cyan"))
colors()
  # font : 1기본값 2굵게 3이텔릭체 4굵은이텔릭체
  # legend : 오른족 상단 범례
  # density : 막대그래프 안에 칠할 선 수
  # angle : 빗금 각도
barplot(VADeaths, main="버지니아 사망율", font=2,
        border="red", legend=rownames(VADeaths),
        density=60, angle=c(10,30,50,70,120),
        beside=TRUE, col=rainbow(5))
  # beside=TRUE : 막대 선분을 분리
  # col에는 R에서 제공되는 파레트 함수사용


# 파레트 패키지 이용
install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()
pal <- brewer.pal(5, "Set1")
barplot(VADeaths, main="버지니아 사망율", font=2,
        border="red", legend=rownames(VADeaths),
        density=60, angle=c(10,30,50,70,120),
        beside=TRUE, col=pal)

## 2.3 boxplot : 상자그림(상자도표, 사분위수 그래프)
datasets::InsectSprays
class(InsectSprays)
names(InsectSprays) <- c('cnt','spray')
InsectSprays
rm(InsectSprays)
head(InsectSprays)
boxplot(InsectSprays$count)
# boxplot(InsectSprays$count~InsectSprays$spray)
boxplot(count ~ spray, data=InsectSprays, col=pal)
tapply(InsectSprays$count, InsectSprays$spray, median)
by(InsectSprays$count, InsectSprays$spray, summary)
tapply(InsectSprays$count, InsectSprays$spray, summary)
library(doBy)
?summaryBy
summaryBy(count~spray, data=InsectSprays, FUN=summary)
aggregate(InsectSprays$count, by=list(InsectSprays$spray), FUN=summary)

## 2.4 hist : 히스토그램(도수분포표 - 연속된 데이터의 도수분포)
x <- c(1,1, 2,2,2, 3, 4,4 )
hist(x)
hist(x, breaks=c(1,2,3,4,5,6))
  # breaks : 구간
h <- hist(x, breaks=c(0.5,1.5,2.5,3.5,4.5),
          ylim=c(0,3.5))
h
text(h$mids, h$counts, paste(h$counts, '개', sep=''), col="blue", adj=c(0.5, -0.5)) # adj 위치 재조정

text(h$mids, h$counts, paste(h$counts, '개', sep=''), adj=c(0,0), col="red") # 텍스트의 왼쪽아래가 기준점
text(h$mids, h$counts, paste(h$counts, '개', sep=''), adj=c(0,1), col="black") # 텍스트의 왼쪽위가 기준점
text(h$mids, h$counts, paste(h$counts, '개', sep=''), adj=c(1,0), col="green") # 텍스트의 오른쪽 아래가 기준점
text(h$mids, h$counts, paste(h$counts, '개', sep=''), adj=c(1,1), col="purple") # 텍스트의 오른쪽 위가 기준점

islands # 1만 평방마일을 초과하는 주요대륙 넓이 정보보
class(islands)
is.vector(islands)
hist(islands)
hist(sqrt(islands), breaks = c(2, 30, 70,100,140))

set.seed(14)
x <- rnorm(1000) # 평균0이고, 표준편차가 1인 데이터 1000개 
hist(x)

## 2.5 pie
x <- c(20, 30, 30, 20, 15, 5)
pie.lang <- x/sum(x)
pie.lang
pie.lang <- c(0.1, 0.3, 0.2,0.15,0.1,0.15)
sum(pie.lang)

names(pie.lang) <- c('c','java','python','R','Oracle','Hadoop')
pie(pie.lang) # 반시계방향으로
pie(pie.lang, clockwise = TRUE, col=c("red","orange","yellow","green","blue","navy"))

pie(pie.lang, clockwise = TRUE, col=brewer.pal(6, "Set3")) # pdf 68.
pie(pie.lang, clockwise = TRUE, col=rainbow(6)) #pdf 19.

## 2.6 mosaicplot : 배열형식의 표를 이용해 모자이크 플롯 출력
Titanic
class(Titanic)
mosaicplot(~Sex+Age+Survived, data=Titanic, color=T)
?mosaicplot
mosaicplot(~Class+Age+Survived, data=Titanic, color=T)

#### 3. 저수준 그래프 함수 ####
## 3.1 points
plot(-4:4, -4:4, type="n")
?par
points(rnorm(100),rnorm(100), pch=3, col="brown")

## 3.2 lines : 선
head(cars,10) # speed별 제동거리
plot(cars, main="속도와 제동거리와의 관계",pch=20)
fit <- lm(dist ~ speed, cars)
fit
lines(cars$speed, cars$speed*3.932-17.579, col="blue", lty="dashed", lwd=2)

## 3.3 abline : 회귀식선
abline(fit, col="red", lwd=4, lty="dotted")
  # lwd : line width (?par 참조)
  # lty : line type

## 3.4 text(x, y, 출력할텍스트, 그외옵션들)

plot(-1:1, -1:1, type="n", xlab="X")
points(0,0, pch=3, cex=4, lwd=3) # cex크기

text(0,0,"hello")
text(0,0,"red", col="red", font=2,   cex=3, adj=c(0,0))
text(0,0,"blue", col="blue", font=2, cex=3, adj=c(1,0))
text(0,0,"green", col="green", font=2, cex=3, adj=c(0,1))
text(0,0,"purple", col="purple", font=2, cex=3, adj=c(1,1))
# 수식 출력
plot(1:5,1:5, type="n")
text(3,3, 'A', adj=c(0,0), col="red")
text(1.5, 4,  expression(hat(beta)==(X^t)*X ^ {-1} * X^t*y), 
          adj=c(0,0))

#### 4. ggplot2 패키지 함수 ####
install.packages("ggplot2")
library(ggplot2)
# 1. 그래프초기화(데이터셋, 변수설정)하는 ggplot - 그 자체로는 그래프 표현 X
# 2. 그래프의 결과물에 대응하는 geom 함수
# 3. 부가 요소를 추가 함수
# + 기호를 이용해서 함수들을 연결하는 방식으로 그래프 생성

# ggplot(data, aes(x= , y= )) +
#   geom함수(어떤 그래프를 그릴지) + 
#   labs(제목, x축,y축 label, 서브제목, 출처) +
#   scale함수() +
#   theme() +
#   coord_cartesian()

ggplot(data=mtcars, aes(x=wt, y=mpg)) +
  geom_point(aes(col=cyl)) +
  labs(title="wt & mpg",
      subtitle="(차량 무게와 연비와의 관계)",
      x = "weight(1,000lbs)",
      y = "Fuel consumption(miles per gallon)",
      caption="source : mpg datasets") +
  geom_smooth()

## 4.1 산점도, 적합도
# x축에 Petal.Length, y축에 Petal.Width의 산점도(점의 색은 종에 따라 다르게) 그리시오.
library(RColorBrewer)
ggplot(iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point(aes(col=Species)) +
  scale_color_manual(values =brewer.pal(3,"Set1")) + 
            #  c('black','red','orange')
  labs(title="iris 데이터의 산점도",
       x = "꽃잎길이", y="꽃잎넓이") +
  coord_cartesian(ylim = c(0, 2.25)) +
  geom_smooth(method="lm", level=0)
    # method = "lm" ; 회귀식
    # level=0 ; 신뢰구간 표시 안 함
?geom_smooth
?geom_point
?par

# airquality$Ozone과 airquality$Solar.R과의 관계를 산점도(월별 산점도 색상을 다르게)
table(airquality$Month, useNA = "ifany")
str(airquality$Month)
ggplot(airquality, aes(x=Solar.R, y=Ozone)) +
  geom_point(aes(col=Month)) +
  labs(title="태양복사량과 오존량과의 관계")

airquality$Month <- as.factor(airquality$Month)
str(airquality$Month)
levels(airquality$Month)

ggplot(airquality, aes(x=Solar.R, y=Ozone)) +
  geom_point(aes(col=Month)) +
  labs(title="태양복사량과 오존량과의 관계") +
  scale_color_manual(values=c('green','blue','navy','red','brown'))

# mtcars데이터의 wt, mpg
library(ggplot2)
ggplot(mtcars, aes(x=wt, y=mpg)) +
  geom_point(shape=21, color="blue", bg="red", size=1, stroke=2) +
  geom_smooth(method="lm", col="red", lwd=1, lty="dashed") +
  geom_text(label=rownames(mtcars), hjust=0, vjust=0, nudge_y = 0.5, size=2) +
  labs(title="차량 무게와 연비와의 관계",
       subtitle="(부제목)",
       x="차량무게(1,000lbs)",
       y="연비",
       caption="출처 : datasets::mtcars")
?geom_text
  # shape : pch와 동일
  # vjust (0위, 1아래) hjust(0우, 1좌)
?geom_point
?par
head(mtcars)
rownames(mtcars) <- 1:NROW(mtcars)
rownames(mtcars)
rm(mtcars)


library(car)
head(Salaries)
ggplot(Salaries, aes(x=yrs.since.phd, y=salary, col=rank, shape=sex)) +
  geom_point(size=2) +
  scale_color_manual(values=c("red","green","blue")) +
  scale_shape_manual(values=c(1,3))
# scale_color_manual : 점의 색상을 변경


## 4.2 히스토그램 : 연속형 자료형에서 도수분포표(범주형 도수분포는 불가)
mtcars$mpg
cat(min(mtcars$mpg), max(mtcars$mpg))

ggplot(mtcars, aes(x=mpg)) +
  geom_histogram()

# cyl 별로 히스토그램
table(mtcars$cyl)
str(mtcars$cyl)

ggplot(mtcars, aes(x=mpg)) +
  geom_histogram() +
  facet_grid(cyl ~ .)

mtcars$cyl <- factor(mtcars$cyl, levels=c(4,6,8), 
                     labels=c('4 cylinders','6 cylinders','8 cylinders'))
head(mtcars)

ggplot(mtcars, aes(x=mpg)) +
  geom_histogram() +
  facet_grid(cyl ~ .) +
  labs(title="실린더별 연비의 히스토그램")

ggplot(mtcars, aes(x=cyl)) +
  geom_histogram() # 범주형 데이터로 히스토그램은 에러

# ggplot2::mpg의 displ의 도수분포표(class에 따라 색상을 달리)
str(mpg$displ)
ggplot(data=mpg, aes(x=displ, fill=class)) +
  geom_histogram(bins=20, binwidth = 0.2) +
  theme(legend.position = "bottom",
        axis.text.x = element_text(color="red", size=5),
        axis.line= element_line(color="black",size=0.5),
        axis.text.y = element_blank(),
        panel.background = element_rect(fill="lightblue",
                                        linetype = "dotted", color="black"),
        plot.background = element_rect(fill="lightyellow"))
?geom_histogram
  # bins : 빈의 갯수를 지정하지 않으면 30
    #      binwidth를 지정하면 binwidth에 따라 빈의 갯수 설정
  # fill : 히스토그램의 색상
  # col : 히스토그램의 border 색상

## 4.3 상자도표(boxplot)
boxplot(iris$Sepal.Length)$stat # 이상치 처리하기 위해

# 전체 데이터에 대해 Sepal.Length의 boxplot
ggplot(iris, aes(y=Sepal.Length)) +
  geom_boxplot() +
  theme(axis.text.x = element_blank())

# 종별 Sepal.Length의 boxplot : 종별 차이가 있는지
library(RColorBrewer)
pal <- brewer.pal(3, "Set1")
ggplot(iris, aes(x=Species, y=Sepal.Length)) +
  geom_boxplot(aes(fill=Species), col="dimgray") +
  #scale_fill_manual(values=c('red','blue','green'))
  scale_fill_manual(values=pal)

# gapminder::gapminder 대륙별(contient) GDP의 차이가 있는지 boxplot
install.packages("gapminder")
library(gapminder)
dim(gapminder)
data(gapminder, package = "gapminder")
gapminder = gapminder::gapminder
edit(gapminder)
temp = gapminder[gapminder$continent == 'Asia',]
edit(temp)

tapply(gapminder$gdpPercap, gapminder$continent, FUN=median)
tapply(gapminder$gdpPercap, gapminder$continent, FUN=mean)
tapply(gapminder$gdpPercap, gapminder$continent, FUN=sd)

ggplot(gapminder, aes(x=continent, y=gdpPercap)) + 
  geom_boxplot(aes(fill=continent)) +
  coord_cartesian(ylim=c(0,90000)) +
  theme(axis.text.x = element_text(angle=45, vjust=0.6))

# car::Salaries에서 교수의 직급(rank)별 연봉(salary)의 boxplot
install.packages("car")
library(car)
dim(Salaries)
head(Salaries)
ggplot(Salaries, aes(x=rank, y=salary, col=rank)) +
  geom_boxplot(fill="lightyellow", notch=TRUE) +
  geom_point(position = "jitter", alpha=0.2, color="brown", pch=20) +
  geom_rug(sides='l', col="dimgray") # 관측값의 밀도 상태를 축에 표현
  
?geom_boxplot
  # notch=TRUE : 중위수에 대해 95% 신뢰구간을 표현.
?geom_point
  # position = "jitter" : 산점도를 분산
  # alpha :투명도

# mtcars데이터 cyl개수에 따른 연비(mpg)의 95% 중위수 신뢰구간을 boxplot으로 시각화하시오
ggplot(mtcars, aes(x=cyl, y=mpg)) +
  geom_boxplot(notch = TRUE)

## 4.4 바이올린 도표 : boxplot과 밀도도표를 합쳐

# 합창부 단원의 키와 성악부part의 관계
singer <- lattice::singer
dim(singer)
names(singer)
ggplot(singer, aes(x=voice.part, y=height)) +
  geom_violin(fill="honeydew2") +
  geom_boxplot(width=0.3, fill="green", notch = T) +
  geom_point(position = "jitter", alpha=0.5, col="orange")

## 4.5 밀도도표
rm(mtcars)
str(mtcars)
names(mtcars)
# 실린더수(cyl)에 따른 연비를 밀도도표
mtcars$cyl <- factor(mtcars$cyl, levels=c(4,6,8),
                     labels=c('4 cyl','6 cyl', '8 cyl'))
ggplot(mtcars, aes(x=mpg)) +
  geom_density(aes(fill=cyl)) +
  theme(legend.position = c(0.7, 0.8))

## 4.7 추세선 (시계열에서 데이터의 흐름 표현)
dim(economics)
head(economics)
# 시간(date)에 따른 실업률(unemploy)의 추세선
ggplot(economics, aes(x=date, y=unemploy)) +
  geom_line() + # 추세선
  geom_smooth(method="lm") # 적합도선

?geom_smooth

## 4.7 막대그래프(geom_bar()함수, geom_col()함수)
# 도수분포표 시각화 : 히스토그램(연속데이터), 막대그래프(범주형데이터)
# 히스토그램 : 연속된 자료를 계급으로 나우어 계급별 도수 geom_histogram()
# 막대그래프 : 범주형 데이터의 빈도를 나타냄 geom_bar()
#(cf) x, y축이 다 존재할 경우 geom_bar(), geom_col()
library(ggplot2)
table(mpg$manufacturer)
ggplot(mpg, aes(x=manufacturer)) + geom_histogram() # 범주형데이터에서 불가

ggplot(mpg, aes(x=displ)) + geom_histogram()
ggplot(mpg, aes(x=manufacturer)) +
  geom_bar(stat = "count") +
  theme(axis.text.x = element_text(angle=60, vjust = 0.7))
?geom_bar

# 제조회사별 빈도그래프(class별 다른 색상으로)
library(RColorBrewer)
display.brewer.all()
ggplot(mpg, aes(x=manufacturer, fill=class, col=class)) +
  geom_bar(stat="count") +
  labs(title="제조회사별 빈도",
       subtitle="(class별 분리)",
       x ="제조회사", y="빈도수", 
       caption="source:ggplot2::mpg") +
  theme(axis.text.x = element_text(angle=60, vjust = 0.7),
        legend.position = "bottom") +
  scale_fill_manual(values=brewer.pal(7, "Set3")) +
  scale_color_manual(values=rainbow(7)) +
  coord_cartesian(ylim=c(0,50))
length(unique(mpg$class)) # fill과 col의 지정 7개 필요

# ggplot2::diamonds 데이터셋에서 절단품질(cut)별 빈도수
table(diamonds$cut)
dim(diamonds)
ggplot(diamonds, aes(x=cut))+
  geom_bar(stat="count", aes(fill=cut))

# 품질(cut)별 색상(color)의 빈도수
table(diamonds$cut, diamonds$color)

library(dplyr)
diamonds %>% 
  group_by(cut, color) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=cut, y=n, fill=color)) + 
  #geom_bar(stat="identity")
  geom_col()

diamonds %>% 
  group_by(cut, color) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=cut, y=n, fill=color)) + 
  #geom_bar(stat="identity", position = "dodge")
  geom_col(position = "dodge")
# position = "dodge" : beside=T 역할. 막대를 개별

# cut별 table(다이아몬드 상단 넓이) 갯수를 시각화(title을 가운데 정렬)
table(diamonds$cut, diamonds$table)

diamonds %>% 
  group_by(cut, table) %>% 
  summarise(n = n()) %>% # 에러 날 경우 , .groups = "drop"추가
  group_by(cut) %>% 
  summarise(cnt = n()) %>% 
  ggplot(aes(x=cut, y=cnt, fill=cut)) +
  #geom_bar(stat="identity") +
  geom_col() +
  labs(title = "다이아몬드 품질별 다이아몬드 상단 넓이 종류",
       subtitle="cut별 table 수") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust=.5),
        plot.subtitle = element_text(hjust=.5))

diamonds %>% 
  group_by(cut) %>% 
  summarise(n = n_distinct(table))%>% 
  ggplot(aes(x=cut, y=cnt, fill=cut)) +
  #geom_bar(stat="identity") +
  geom_col() +
  labs(title = "다이아몬드 품질별 다이아몬드 상단 넓이 종류",
       subtitle="cut별 table 수") +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust=.5),
        plot.subtitle = element_text(hjust=.5))


# cut별 table 별 빈도수 시각화 (cut별로 따로)
table(diamonds$cut, diamonds$table)
diamonds %>% 
  group_by(cut, table) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=table, y=n)) +
  geom_bar(stat = "identity") +
  facet_wrap(~cut) + #cut별 시각화를 따로
  coord_cartesian(ylim=c(0,4000), xlim=c(50,80))

## 4.8 그래프를 파일에 저장
#(1) basic graph, ggplot패키지 모두 저장
jpeg("iris.jpg")
boxplot(iris$Sepal.Length)
dev.off()

getwd()
png("outData/iris.png", width=300, height=150)
ggplot(iris, aes(x=Petal.Length, y=Petal.Width)) +
  geom_point() +
  facet_wrap(~ Species)
dev.off()

# (2) ggplot2 패키지 그래프 함수에서만 저장할 수 있는 방법
ggplot(iris, aes(x=Petal.Length, y=Petal.Width, col=Species)) +
  geom_point(aes(size=Petal.Width), pch=2, alpha=0.5)
ggsave('outData/iris.jpg')

## 4.9 ggplot2에서 차트 분할 출력
install.packages("gridExtra")
library(gridExtra)
g1 <- ggplot(iris, aes(x=Petal.Width, y=Petal.Length)) +
  geom_point()
g1
g2 <- ggplot(iris, aes(x=Sepal.Width, y= Sepal.Length)) +
    geom_point()
g2
png("i.png") # grid된 그래프를 i.png로 저장
grid.arrange(g1, g2, ncol=2, nrow=1)
dev.off()
#### 5. 산점도 행렬 ####
plot(iris[-5])
pairs(iris[-5], panel = panel.smooth)

