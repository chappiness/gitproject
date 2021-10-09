#흑점종류에 따른 흑점 크기(흑점번호에따라 다름)
#### 4. ggplot2 패키지 함수 ####
install.packages("ggplot2")
library(ggplot2)
sunspot<-read.csv('D:/R1/코딩/bigdata/과학기술정보통신부 국립전파연구원_태양흑점활동정보_20201231.csv')
class(sunspot)
# 1. 그래프초기화(데이터셋, 변수설정)하는 ggplot - 그 자체로는 그래프 표현 X
# 2. 그래프의 결과물에 대응하는 geom 함수
# 3. 부가 요소를 추가 함수
# + 기호를 이용해서 함수들을 연결하는 방식으로 그래프 생성


install.packages("ggplot2")
library(ggplot2)
library(dplyr)
library(RColorBrewer)

class(sunspot)
summary(sunspot)
sunspot<-rename(sunspot,c(year=연,month=월,day=일,time=시간,
                          sunNo=흑점번호,lat=위도,long=경도,
                          size=흑점크기,
                          kind=흑점종류,mag=자기장종류))
summary(sunspot)
colSums(is.na(sunspot)) #흑점번호,흑점크기 결측치


a<-paste(sunspot$year,'-',sunspot$month,'-',sunspot$day,sep="")
date<-as.Date(a)
sunspot$date<-date
#Sys.Date()
summary(sunspot)
View(sunspot)
#월별 흑점종류
# ggplot(data, aes(x= , y= )) +
#   geom함수(어떤 그래프를 그릴지) + 
#   labs(제목, x축,y축 label, 서브제목, 출처) +
#   scale함수() +
#   theme() +
#   coord_cartesian()
sunspot
install.packages('ggpmisc')
library(ggpmisc)
sunspot %>%
  filter(!is.na(sunNo)) %>%
  group_by(date,sunNo) %>%
  summarise(n=n()) %>%
  group_by(date) %>%
  summarise(number=sum(n,na.rm=T)) %>%
  #mutate(sunspot$number==number)
  ggplot(aes(x=date,y=number,fill='purple'))+
  geom_point()+
  geom_line()+
  stat_peaks(geom='text',colour='red',x.label.fmt ="%y-%m-%d",vjust=0.5)+
  stat_valleys(colour='blue')+
  #geom_smooth()+
  labs(title='1년치 흑점 개수 데이터')


#목표 일에 따른 흑점의 개수

sunspot<-read.csv("D:/R1/코딩/R11/inData/과학기술정보통신부 국립전파연구원_태양흑점활동정보_20201231.csv")

library(dplyr)

library(ggplot2)

library(dygraphs)

library(xts)

sunspot<-rename(sunspot,year='연',month='월',day='일',sunNo='흑점번호')

sunspot

head(sunspot)

class(sunspot)

View(sunspot)

head(paste(sunspot$year,'-',sunspot$month,'-',sunspot$day,sep=''))

date<-paste(sunspot$year,'-',sunspot$month,'-',sunspot$day,sep='')

date<-as.Date(date)

date

sunspot$date<-date

str(sunspot)

head(sunspot)

temp<-sunspot %>%
  
  filter(!is.na(sunNo)) %>%
  
  group_by(date,sunNo) %>%
  
  summarise(cnt=n()) %>%
  
  group_by(date)%>%
  
  summarise(number=sum(cnt))

temp

ggplot(temp,aes(y=number,x=date))+
  
geom_line(col='red')

#인터렉티브 시계열 그래프

spot<-xts(temp$number,order.by=temp$date)

colnames(spot)<-'흑점의개수'

head(spot,3)

dygraph(spot)
  
