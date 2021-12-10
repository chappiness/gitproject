#────────────────────────────────────────────────────#
##### 5-1장. dplyr 패키지를 이용한 데이터 전처리 #####
#────────────────────────────────────────────────────#
#### 1. 외부파일 read / write ####
## 1.1 엑셀파일 읽어오기 - readxl 패키지 이용
install.packages("readxl")
library(readxl)
getwd()
exam <- read_excel('C:/bigdata/src/06_R/inData/exam.xlsx') #첫번째 sheet의 값을 read
exam <- read_excel('C:\\bigdata\\src\\06_R\\inData\\exam.xlsx')
exam <- read_excel('inData/exam.xlsx')
head(exam)
class(exam)
exam <- as.data.frame(exam)
class(exam)
head(exam)

exam2 <- read_excel('inData/exam.xlsx', sheet=2)
?read_excel
exam2 <- as.data.frame(exam)

# 데이터 파일에 컬럼명이 없는 경우
city <- read_excel('inData/data_ex.xls', col_names = F)
city <- as.data.frame(city)
colnames(city) <- c('id','gender','age','area')
head(city,3)

## 1.2 데이터 쓰기 (파일(csv)로 쓰기, 변수로 쓰기)
write.csv(exam, 'outData/exam.csv', row.names = TRUE) # csv에 쓰기
write.csv(exam, 'outData/exam.csv', row.names = FALSE)

save(exam, file='outData/exam.rda') # exam변수를 파일에 저장
rm(list=ls(all.names = TRUE)) # 히든 변수까지 모두 삭제
exam
load('outData/exam.rda') # 환경창에 변수 추가됨
head(exam)

#### 2. dplyr 패키지 이용을 위한 데이터 준비 & 데이터 파악하기 ####
# data(mpg, package = "ggplot2")
## 데이터 준비
mpg <- as.data.frame(ggplot2::mpg)
midwest <- as.data.frame(ggplot2::midwest)
## 데이터 파악하기
head(mpg)
tail(mpg, 1)
edit(mpg) # 확인용
View(mpg)
# dim() 차원  str() 구조 summary() 통계치 파악
dim(mpg)
str(mpg)
summary(mpg)

# 변수명(열이름) (cty->city, hwy->highway)
library(dplyr)
# mpg <- rename(mpg, city=cty)
mpg <- rename(mpg, c(city=cty, highway=hwy))
colnames(mpg)
# 파생변수 (total = (city+highway)/2 )
mpg$total <- (mpg$city + mpg$highway ) / 2
head(mpg, 3)
# 파생변수 (test = total연비가 평균보다 높은 pass, 평균보다 낮으면 fail)
boxplot(mpg$total) # (1)박스플롯(1,2,3사분위수, 이상치)
hist(mpg$total) # (2)히스토그램(연속된데이터의 빈도)
library(vioplot)
vioplot(mpg$total) # (3) 바이올릿플롯

mpg$test <- ifelse(mpg$total >= mean(mpg$total), 'pass', 'fail')
table(mpg$test) # 빈도표(결측치 미포함)
head(mpg)
library(ggplot2)
dev.off() # qplot이 에러날때
qplot(mpg$test) # 막대그래프(카테고리컬데이터의 빈도)

## 분석도전 ex(note p.1)
# 문제1. ggplot2의 midwest 데이터를 데이터 프레임 형태로 불러와서 데이터의 특성을 파악하세요.
midwest <- as.data.frame(ggplot2::midwest)

class(midwest)
dim(midwest) #차원 437행 28열

head(midwest,2)
tail(midwest,2)
View(midwest)
edit(midwest)
colnames(midwest) # 열이름
names(midwest) # 열이름

table(is.na(midwest)) # 결측치 갯수 파악
is.na(midwest)# 437행 28열
colSums(is.na(midwest))  # 열별 결측치 갯수
  
# 문제2. poptotal(전체 인구)을 total로, popasian(아시아 인구)을 asian으로 변수명을 수정하세요.
?midwest
# midwest <- rename(midwest, total=poptotal) 변수 하나만 수정
midwest <- rename(midwest, c(total=poptotal, asian=popasian))
colnames(midwest)
# 문제3. total, asian 변수를 이용해 '전체 인구 대비 아시아 인구 백분율' 파생변수를 만들고, 히스토그램을 만들어 도시들이 어떻게 분포하는지 살펴보세요.
midwest$ratioasian <- midwest$asian / midwest$total * 100 # 아시아인구 백분율율
head(midwest[,c('state', 'total', 'asian', 'ratioasian')])
hist(midwest$ratioasian)
# 문제4. 아시아 인구 백분율 전체 평균을 구하고, 평균을 초과하면 "large", 그 외에는 "small"을 부여하는 파생변수를 만들어 보세요.
midwest$group <- ifelse(midwest$ratioasian>mean(midwest$ratioasian), 
                         "large", "small")
# 문제 5. 빈도표, 빈도그래프(히스토그램-연속변수, 막대그래프-카테고리컬변수)
table(midwest$group) # 빈도표
dev.off()
qplot(midwest$group, fill=midwest$group) 
  
#### 3. 파악한 데이터를 dplyr 패키지를 이용하여 전처리 및 분석하기 ####
## 3.1 조건에 맞는 데이터 추출하기 : filter() ; '%>%' ctrol+shift+m 핫키
getwd()
exam <- read.csv('inData/exam.csv', header=TRUE)
library(dplyr)
# class가 1인 행만 추출
exam %>% filter(class==1)

subset(exam, class==1)
exam[exam$class==1,]

# class가 1이거나 2이거나 3인 데이터 추출
exam %>% 
  filter(class==1 | class==2 | class==3)
exam %>% 
  filter(class %in% c(1,2,3))

# class가 1이거나 2이고, english가 80이상인 데이터 추출
exam %>% 
  filter(class %in% c(1,2) & english>=80)

## 3.2 필요한 변수 추출하기 : select()
exam %>% 
  select(class, english, math) # 추출하고자 하는 변수만 select함수 안에
# subset(exam, select=c('class', 'english', 'math')) 과 동일한 결과 
exam %>% 
  select(-math) # math변수만 제외하고 다 출력력
# class가 1이거나 2인 행중에서 영어,수학데이터만 출력
exam %>% 
  filter(class %in% c(1,2)) %>% 
  select(english, math)
exam %>% 
  filter(class %in% c(1,2)) %>% 
  select(3,4)
# class가 1이거나 2인 행중에서 수학(3번째열),영어(4번째열),과학(5번째열)데이터만 출력
exam %>% 
  filter(class %in% c(1,2)) %>% 
  select(math, english, science)
  
exam %>% 
  filter(class %in% c(1,2)) %>% 
  select(math:science)

exam %>% 
  filter(class %in% c(1,2)) %>% 
  select(3:5)
  
# class가 1,2,3인 행에서 영어,수학 데이터만 앞 5개만 추출
exam %>% 
  filter(class %in% c(1,2,3)) %>% 
  select(english, math) %>% 
  head(5) # 앞 5개

exam %>% 
  filter(class %in% c(1,2,3)) %>% 
  select(english, math) %>% 
  head # 앞6개 cf. 뒤6개는 tail

## 3.3 정렬하기 : arrange()
exam %>% arrange(math) # math기준으로 오름차순 정렬
exam %>% arrange(desc(math)) # math기준으로 내림차순 정렬
exam %>% arrange(-math)      # math기준으로 내림차순 정렬
exam %>% arrange(class, desc(math)) #class 오름차순, math내림차순 정렬
exam %>% arrange(class, -math)      #class 오름차순, math내림차순 정렬
# id가 1부터 10인 학생의 영어, 수학성적을 영어성적 기준으로 오름차순 정렬하여 top 6만
exam %>% 
  filter(id %in% c(1:10)) %>% 
  select(english, math) %>% 
  arrange(english) %>% 
  head
## 3.4 파생변수 추가 : mutate()
exam %>% 
  mutate(total = math+english+science) %>% 
  filter(total >= 150) %>% 
  arrange(total) %>% 
  head
head(exam)
exam <- exam %>% mutate(total=math+english+science)
head(exam)
exam$total <- NULL # total변수 삭제
head(exam)

exam %>%  # 파생변수를 한꺼번에 두개이상 추가해서 분석하기
  mutate(total = math+english+science ,
         avg = round(math+english+science),
         group = ifelse(total>180, 'A','B'))
  
## 3.5 요약하기 : summarise()
# summarise 안에 들어갈 통계치 함수 : mean, sd, min, max, median, n(갯수)
exam %>% 
  summarise(mean_math=mean(math))
exam %>% 
  summarise(mean_math = mean(math),
            sd_math   = sd(math),
            mean_eng  = mean(english),
            sd_eng    = sd(english),
            cnt       = n())
  
## 3.6 집단별로 요약하기 : group_by() + summarise()
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math),
            sd_math   = sd(math),
            mean_eng  = mean(english),
            sd_eng    = sd(english),
            cnt       = n())
# summaryBy을 이용하여 위의 식과 동일하게 만들기
library(doBy)
result1 <- summaryBy(math+english ~ class, data=exam, FUN=c(mean, sd)) # 집단별 요약
result2 <- table(exam$class) # 집단별 빈도수
result2 <- data.frame(result2) # 데이터프레임으로 형변환
names(result2) <- c('class','cnt')
merge(result1, result2)
# mpg데이터에서 회사별로 "suv 자동차의 도시와 고속도로 통합 연비 평균을 구해 내림차순으로 정렬하고 1~5위까지 출력하기
mpg = as.data.frame(ggplot2::mpg)
class(mpg)
head(mpg)
table(mpg$class)
#방법1. dplyr패키지
mpg %>% 
  filter(class=='suv') %>% 
  group_by(manufacturer) %>% 
  mutate(total = (cty+hwy)/2) %>% 
  summarise(tot_mean = mean(total)) %>% 
  arrange(desc(tot_mean)) %>% 
  head(5)
#방법2
df <- mpg[mpg$class=='suv',]
df$total <- (df$cty+df$hwy)/2
head(sort(tapply(df$total, df$manufacturer, mean), decreasing = T), 5)
sort(tapply(df$total, df$manufacturer, mean), decreasing = T)[1:5]

##########################
#####혼자해보기 (1) ######
##########################
mpg <- as.data.frame(ggplot2::mpg)
data(mpg, package="ggplot2")
library(dplyr)
library(doBy)
names(mpg)
# Q1. 자동차 배기량에 따라 고속도로 연비가 다른지 알아보려고 합니다. displ(배기량)이 4 이하인 자동차와 5 이상인 자동차 중 어떤 자동차의 hwy(고속도로 연비)가 평균적으로 더 높은지 알아보세요
# (1) dplyr 패키지 이용
mpg %>% 
  mutate(group=ifelse(displ<=4, "배기량4이하", ifelse(displ>=5, "배기량5이상", NA))) %>% 
  group_by(group) %>% 
  summarise(mean_total=mean(hwy)) %>% 
  filter(!is.na(group))

mpg %>% 
  filter(displ<=4 | displ>=5) %>% 
  mutate(group=ifelse(displ<=4, "배기량4이하", "배기량5이상")) %>% 
  group_by(group) %>% 
  summarise(mean_total=mean(hwy)) 

# (2) apply계열 함수 이용 : tapply, by, summaryBy(doBy), aggregate
df <- mpg
df$group <- ifelse(df$displ<=4, "배기량4이하", ifelse(df$displ>=5, "배기량5이상", NA))
table(df$group, useNA = "ifany") # useNA = "ifany"추가시 결측치까지 빈도
head(df)
tapply(df$hwy, df$group, mean)
by(df$hwy, df$group, mean) # 다수개 열일때는 mean은 안되고 summary, sum 등 됨
summaryBy(hwy~group, df, FUN=mean) # 다수개 열과 다수개 함수 가능(NA까지)
aggregate(df$hwy, by=list(df$group), mean) 

# summaryBy결과에 NA를 제외하고 출력하려면
df <- mpg[(mpg$displ>=5 | mpg$displ<=4),]
df$group <- ifelse(df$displ<=4, "배기량4이하", "배기량5이상")
table(df$group, useNA = "ifany")
tapply(df$hwy, df$group, mean)
by(df$hwy, df$group, mean) # 다수개 열일때는 mean은 안되고 summary, sum 등 됨
summaryBy(hwy~group, df, FUN=mean) # 다수개 열과 다수개 함수 가능(NA까지)
aggregate(df$hwy, by=list(df$group), mean) 

# Q2. 자동차 제조 회사에 따라 도시 연비가 다른지 알아보려고 합니다. "audi"와 "toyota" 중 어느 manufacturer(자동차 제조 회사)의 cty(도시 연비)가 평균적으로 더 높은지 알아보세요.
#(1) 방법
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty)) %>% 
  filter(manufacturer %in% c("audi", "toyota"))

mpg %>% 
  filter(manufacturer %in% c("audi", "toyota")) %>% 
  group_by(manufacturer) %>% 
  summarise(mean_cty = mean(cty))

#(2) 방법
df <- mpg[mpg$manufacturer %in% c("audi", "toyota"),]
head(df)
tapply(df$cty, df$manufacturer, mean)
by(df$cty, df$manufacturer, mean) # 다수개 열 가능
summaryBy(cty~manufacturer, df, FUN=c(mean)) # 다수개 열과 다수개 함수
aggregate(df$cty, by=list(df$manufacturer), mean) #다수개열 가능
##########################
#####혼자해보기 (2) ######
##########################
# Q1. mpg 데이터는 11개 변수로 구성되어 있습니다. 이 중 일부만 추출해서 분석에 활용하려고 합니다. mpg 데이터에서 class(자동차 종류), cty(도시 연비) 변수를 추출해 새로운 데이터를 만드세요. 새로 만든 데이터의 일부를 출력해서 두 변수로만 구성되어 있는지 확인하세요.
# (1) 방법
dim(mpg)
df <- mpg %>% select(class, cty)    
head(df)
# (2) 방법
df <- mpg[,c('class','cty')]
df <- subset(mpg, select=c('class','cty'))

#Q2. 자동차 종류에 따라 도시 연비가 다른지 알아보려고 합니다. 앞에서 추출한 데이터를 이용해서 class(자동차 종류)가 "suv"인 자동차와 "compact"인 자동차 중 어떤 자동차의 cty(도시 연비)가 더 높은지 알아보세요.
table(mpg$class)
# (1) 방법
df %>% 
  filter(class %in% c('suv','compact')) %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty))
df %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  filter(class %in% c('suv','compact'))
# (2) 방법
df <- df[df$class %in% c('suv','compact') ,]

tapply(df$cty, df$class, mean) # 결과가 벡터 형태
by(df$cty, df$class, mean)     # 결과가 list 형태
summaryBy(cty~class, df, FUN=mean) # 결과가 데이터프레임 형태
aggregate(df$cty, by=list(df$class), mean) # 결과가 데이터 프레임 형태

# Q3. "audi"에서 생산한 자동차 중에 어떤 자동차 모델의 hwy(고속도로 연비)가 높은지 알아보려고 합니다. "audi"에서 생산한 자동차 중 hwy가 1~5위에 해당하는 자동차의 데이터를 출력하세요.
# 방법(1)
mpg %>% 
  filter(manufacturer=='audi') %>% 
  arrange(desc(hwy)) %>% 
  head(5)

# 방법(2)
head(orderBy(~-hwy, mpg[mpg$manufacturer=='audi',]),5)

df<- mpg[mpg$manufacturer=='audi',]
head(orderBy(~-hwy, df),5)

head(df[order(df$hwy, decreasing = T),],5)

mpg[order(mpg[mpg$manufacturer=='audi',]$hwy, decreasing = T)[1:5],]
mpg[order(df$hwy, decreasing = T)[1:5],]

# cf."audi"에서 생산한 자동차 중에 어떤 자동차 모델의 hwy(고속도로 연비)가 높은지 알아보려고 합니다
#(1)방법 : dplyr 패키지
mpg %>% 
  filter(manufacturer=='audi') %>% 
  group_by(model) %>% 
  summarise(mean_hwy=mean(hwy)) %>% 
  arrange(-mean_hwy)
#(2)방법
df <- subset(mpg, manufacturer=='audi')
sort(round(tapply(df$hwy, df$model, mean),1), decreasing = T) # tapple이용
sort(round(by(df$hwy, df$model, mean),1), decreasing = T)    # by이용
orderBy(~-hwy.mean, summaryBy(hwy~model, data=df))         # summaryBy이용
result <- aggregate(df$hwy, by=list(df$model), mean)    # aggregate 이용
result[order(-result$x),]
##########################
#####혼자해보기 (3) ######
##########################
#Q1. mpg 데이터 복사본을 만들고, cty와 hwy를 더한 '합산 연비 변수'를 추가하세요.
# (1)방법
df <- mpg %>% 
  mutate(total = cty+hwy)

# (2) 방법
df<-mpg
df$total <- df$cty + df$hwy
df

#Q2. 앞에서 만든 '합산 연비 변수'를 2로 나눠 '평균 연비 변수'를 추가세요.
# (1) 방법
df <- df %>% 
  mutate(avg = (total)/2)

# (2) 방법
df$avg <- (df$total)/2

# Q3. '평균 연비 변수'가 가장 높은 자동차 3종의 데이터를 출력하세요.
# (1) 방법
df %>% 
  mutate(avg = (cty+hwy)/2) %>% 
  arrange(desc(avg)) %>% 
  head(3)
# (2) 방법
head(orderBy(~-avg, df),3)
orderBy(~-avg, df)[1:3,]
head(mpg[order(df$avg, decreasing = T),],3)
head(mpg[order(-df$avg),],3) # mpg$avg앞에 -를 붙여 내림차순정렬을 할 수 있는 것은 avg이 숫자이기 때문. 문자나 logical일 경우 아래와 같이 desc이용
head(df[order(desc(df$avg)),],3)
order(desc(df$manufacturer))

#Q4. 1~3번 문제를 해결할 수 있는 하나로 연결된 dplyr 구문을 만들어 출력하세요. 데이터는 복사본 대신 mpg 원본을 이용하세요.
# (1) 방법
mpg %>% 
  mutate(avg = (cty+hwy)/2) %>% 
  arrange(desc(avg)) %>% 
  head(3)

# (2) 방법
mpg$avg <- (mpg$cty+mpg$hwy)/2
head(orderBy(~-avg, mpg),3)
head(mpg[order(mpg$avg, decreasing = T),],3)
##########################
#####혼자해보기 (4) ######
##########################
#Q1. mpg 데이터의 class는 "suv", "compact" 등 자동차를 특징에 따라 일곱 종류로 분류한 변수입니다. 어떤 차종의 연비가 높은지 비교해보려고 합니다. class별 cty 평균을 구해보세요.
table(mpg$class)
# (1) 방법
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty))

# (2) 방법
tapply(mpg$cty, mpg$class, mean)
by(mpg$cty, mpg$class, mean)
summaryBy(cty~class, mpg)
aggregate(mpg$cty, by=list(mpg$class), mean)

#Q2. 앞 문제의 출력 결과는 class 값 알파벳 순으로 정렬되어 있습니다. 어떤 차종의 도시 연비가 높은지 쉽게 알아볼 수 있도록 cty 평균이 높은 순으로 정렬해 출력하세요.
# (1) 방법
mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty=mean(cty)) %>% 
  arrange(desc(mean_cty))

# (2) 방법
sort(tapply(mpg$cty, mpg$class, mean), decreasing = T)
sort(by(mpg$cty, mpg$class, mean), decreasing = T)
orderBy(~-cty.mean, summaryBy(cty~class, mpg))
orderBy(~-x, aggregate(mpg$cty, by=list(mpg$class), mean))
result <- aggregate(mpg$cty, by=list(mpg$class), mean)
result[order(result$x, decreasing = T),]

#Q3. 어떤 회사 자동차의 hwy(고속도로 연비)가 가장 높은지 알아보려고 합니다. hwy 평균이 가장 높은 회사 세 곳을 출력하세요.
# (1) 방법
mpg %>% 
  group_by(manufacturer) %>% 
  summarise(mean_hwy = mean(hwy)) %>% 
  arrange(desc(mean_hwy)) %>% 
  head(3)

# (2) 방법
sort(tapply(mpg$hwy, mpg$manufacturer, mean), decreasing = T)[1:3]
sort(by(mpg$hwy, mpg$manufacturer, mean), decreasing = T)[1:3]
orderBy(~-hwy.mean, summaryBy(hwy~manufacturer, mpg, FUN=mean))[1:3,]
result <-aggregate(mpg$hwy, by=list(mpg$manufacturer), mean)
result # result가 data.frame형태
head(result[order(result$x, decreasing = T),] , 3)
result[order(result$x, decreasing = T),][1:3,]
result[order(-result$x),][1:3,]
head(orderBy(~-x, result), 3)
# Q4. 어떤 회사에서 "compact"(경차) 차종을 가장 많이 생산하는지 알아보려고 합니다. 각 회사별 "compact" 차종 수를 내림차순으로 정렬해 출력하세요.
# (1) 방법
mpg %>% 
  filter (class=='compact') %>% 
  group_by(manufacturer) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt))
# (2) 방법
sort(table(mpg[mpg$class=='compact',]$manufacturer), decreasing = T)
# (3) 방법
df <- mpg[mpg$class=='compact',]
df <- subset(mpg, mpg$class=='compact')
df <- subset(mpg, class=='compact')
df
sort(table(df$manufacturer), decreasing = T)

#### 4. 데이터 합치기 ####
  # 열합치기 : cbind, left_join(dplyr 패키지 함수)
  # 행합치기 : rbind, bind_rows(dplyr 패키지 함수)
  # cf. merge
detach("package:dplyr", unload = T)
library(dplyr)
## 4.1 열합치기(가로합치기)
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm=c(100,90,80,70,60))
test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(99,88,77,66,55),
                    teacherid=c(1,1,2,2,3))
teacher <- data.frame(teacherid=c(1,2,3),
                      teachername=c('Kim','Park','Bai'))
cbind(test1, test2) # 공통된 열이 중복 생성
merge(test1, test2)
left_join(test1, test2, by="id")

cbind(test2, teacher) # 행수가 맞지 않아 에러러
merge(test2, teacher, by="teacherid")
left_join(test2, teacher, by="teacherid")

test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(99,88,77,66,55),
                    teacherid=c(1,1,2,2,4))
teacher <- data.frame(teacherid=c(1,2,3),
                      teachername=c('Kim','Park','Bai'))
left_join(test2, teacher, by="teacherid")
merge(test2, teacher, by="teacherid")    # 없는 데이터는 merge 안 됨
merge(test2, teacher, by="teacherid", all=TRUE) # 없는 데이터는 NA로 출력

## 4.2 행합치기 (세로 합치기)
group.a <- data.frame(id=c(1,2,3,4,5),
                      test=c(100,90,80,70,60))
group.b <- data.frame(id=c(6,7,8,9,10),
                      test=c(50,55,60,65,100))
rbind(group.a, group.b)   # 두 데이터프레임이 변수(열이름)가 같을 경우
bind_rows(group.a, group.b)
 # 두 데이터 프레임의 변수가 다소 다를 경우
group.a <- data.frame(id=c(1,2,3,4,5),
                      test1=c(100,90,80,70,60))
group.b <- data.frame(id=c(6,7,8,9,10),
                      test2=c(50,55,60,65,100))
rbind(group.a, group.b) # 에러
bind_rows(group.a, group.b)
merge(group.a, group.b) # 수행 안 됨
merge(group.a, group.b, all=T) # bind_rows와 결과 동일

##########################
##### 혼자해보기 (5) #####
##########################
dim(mpg) # 234행 11열
fuel <- data.frame(fl=c('c','d','e','p','r'),
                   kind=c('CNG','diesel','ethanol E85','premium','regular'),
                   price_fl=c(2.35,2.38,2.11,2.76,2.22))
fuel # 5행 3열
# Q1. mpg에 price_fl 변수 추가
# (1)방법
mpg <- left_join(mpg, fuel[,c('fl','price_fl')], by="fl")
# (2)방법
data(mpg, package = "ggplot2")
mpg <- merge(mpg, fuel[, c('fl','price_fl')], by="fl")
# Q2. 연료가격변수(price_fl) 잘 추가되었는 확인위해, model, fl, price_fl 추출해 앞5행
mpg %>% 
  select(model, fl, price_fl) %>% 
  head(5)
mpg[1:5, c('model','fl','price_fl')]
subset(mpg, select=c('model','fl','price_fl'))[1:5,]
head(subset(mpg, select=c('model','fl','price_fl')), 5)

# Q3. mpg에  kind변수도 추가
fuel[,c('fl','kind')]
mpg <- left_join(mpg, fuel[,c('fl','kind')], by="fl")
head(mpg)
# left_join을 쓰지 않고 apply을 이용하여 kind 변수 추가
data(mpg, package = "ggplot2") # 다시 mpg 가져옴
fuel[fuel$fl=='p','kind']

flToKind <- function(fl){
  kind <- fuel[fuel$fl==fl,'kind']
  return(kind)
}
flToKind('r')
mpg$kind <- apply(mpg[,'fl', drop=FALSE], 1, flToKind)
head(mpg)

#### 5. 데이터 정제하기 (결측치, 이상치) ####
## 5.1 결측치 정제하기
df <- data.frame(name=c('Kim', 'Yi', 'Yun', "Ma", "Park"),
                 gender =c('M','F', NA, 'M','F'),
                 score = c(5,4,3,4, NA),
                 income=c(2000,3000,4000,5000,6000))
df
df$gender <- as.factor(df$gender)
dim(df) # 5행 4열
is.na(df) # 결측치 여부를 5행 4열로 T/F
apply(is.na(df), 2, sum) # 열별 결측치 갯수
colSums(is.na(df)) # 열별 결측치 갯수
df
na.omit(df) # 결측치가 하나의 열이라도 있으면 그행은 모두 제거. 간편하지만, 같은행의 분석에 필요한 열의 정보까지 손실되는 단점. 

library(dplyr)
df %>% 
  filter(!is.na(score)) %>% 
  summarise(mean_score = mean(score))

# 결측치를 대체(중앙값, 평균값)
x <- c(1,1,1,2,2,2,2,3,3,3,3,3, NA, 4,4,4,4,5,5,5,100)
length(x)
mean(x) # 평균=7.85
median(x) # 3

exam <- read.csv('inData/exam.csv', header=T)
colSums(is.na(exam))
exam[c(3,8,15),'math'] <- NA # 결측치를 인위적으로 넣기
exam[1:2, 'english']   <- NA

# 결측치를 중앙값 대체
colSums(is.na(exam)) # 열별 결측치 확인
median(exam$math, na.rm=T) # math 열 결측치에 대체할 값
exam$math <- ifelse(is.na(exam$math), round(median(exam$math, na.rm=T)), exam$math)
exam$english <- ifelse(is.na(exam$english), round(median(exam$english, na.rm=T)), exam$english)
colSums(is.na(exam)) # 결측치 대체후 열별 결측치 확인
table(is.na(exam))
exam

# 결측치를 중앙값 대체 2
exam <- read.csv('inData/exam.csv', header=T)
exam[c(3,8,15),'math'] <- NA # 결측치를 인위적으로 넣기
exam[1:2, 'english']   <- NA
exam[1,'science']      <- NA
table(is.na(exam))
colSums(is.na(exam))

m <- apply(exam[,3:5], 2, median, na.rm=T)
m
m['math'] # math열 중앙값
m['english']
# 결측치 처리 방법1 : within 블록 이용
colSums(is.na(exam))
exam <- within(exam, { # 결측치 대체를 위한 블록
  math    <- ifelse(is.na(math), m['math'], math)
  english <- ifelse(is.na(english), m['english'], english)
  science <- ifelse(is.na(science), m['science'], science)
})
colSums(is.na(exam))
# 결측치 처리방법2 : dplyr 패키지 이용
exam[c(3,8,15),'math'] <- NA # 결측치를 인위적으로 넣기
exam[1:2, 'english']   <- NA
exam[1,'science']      <- NA
colSums(is.na(exam))
m # 결측치를 대체할 중앙값들
library(dplyr)
exam <- exam %>% 
  mutate(
    math = ifelse(is.na(math), m['math'], math),
    english = ifelse(is.na(english), m['english'], english),
    science = ifelse(is.na(science), m['science'], science)
  )
table(is.na(exam))
  
## 5.2 이상치(=극단치, outlier) 정제
  # 논리적인 이상치(ex. 성별에 남여가 아닌 값)
  # 극단적인 이상치(정상범위 기준에서 벗어난 값)
  # 이상치는 결측치로 대체

# (1) 논리적인 이상치
outlier <- data.frame(gender=c(1,2,1,3,2), # 1은 남, 2는 여
                      score=c(90,95,100,99,101))
outlier
outlier$gender <- ifelse(outlier$gender!=1 & outlier$gender!=2, NA, outlier$gender)# 1
outlier$gender <- factor(outlier$gender, levels=c(1,2), labels = c('남','여')) # 2
table(outlier$gender)

outlier$score <- ifelse(outlier$score>100, NA, outlier$score)
outlier

# (2) 정상범위 기준으로 많이 벗어난 이상치 
#      : 상하위 0.3% 또는 평균-2.75*표준편차 ~ 평균+2.75*표준편차
mpg <- as.data.frame(ggplot2::mpg)
sort(mpg$hwy)
lowlimit <- mean(mpg$hwy) - 2.75*sd(mpg$hwy)
highlimit <- mean(mpg$hwy) + 2.75*sd(mpg$hwy)
lowlimit
highlimit
mpg$hwy[mpg$hwy>highlimit]  # 상향극단치보다 큰값 : 44 41
mpg$hwy[mpg$hwy<lowlimit]   # 하향극단치보다 작은값 : 없음

# boxplot을 이용한 이상치 확인
result <- boxplot(mpg$hwy)$stats
result[1] # 하향극단치 경계
result[5] # 상향극단치 경계계
mpg$hwy[mpg$hwy>result[5]] # 상향극단치보다 큰값 : 44 41
mpg$hwy[mpg$hwy<result[1]] # 하향극단치보다 작은값 : 없음

# 이상치를 결측치로 대체
mpg$hwy <- ifelse(mpg$hwy>result[5] | mpg$hwy <result[1], NA, mpg$hwy)
sum(is.na(mpg$hwy)) # 결측치 갯수
boxplot(mpg$hwy)
rm(list=ls())
###############################################
# # # # #   분    석     도     전    # # # # # 
###############################################
# 문제1. popadults는 해당 지역의 성인 인구, poptotal은 전체 인구를 나타냅니다. midwest 데이터에 '전체 인구 대비 미성년 인구 백분율' 변수를 추가하세요.
midwest <- as.data.frame(ggplot2::midwest)
colnames(midwest)
# 방법1
midwest <- midwest %>% 
  mutate(ratio_child = (poptotal-popadults)/poptotal *100)
# 방법2
midwest$ratio_child <- (midwest$poptotal-midwest$popadults)/midwest$poptotal *100
head(midwest, 2)

#문제2. 미성년 인구 백분율이 가장 높은 상위 5개 county(지역)의 미성년 인구 백분율을 출력하세요.
#방법1
midwest %>% 
  arrange(desc(ratio_child)) %>%  # ratio_child 내림차순 정렬
  select(county, ratio_child) %>%  # county, ratio_child 추출
  head(5)
# 방법2
head(midwest[order(midwest$ratio_child, decreasing = T),c('county','ratio_child')],5)
midwest[order(midwest$ratio_child, decreasing = T),c('county','ratio_child')][1:5,]
midwest[order(-midwest$ratio_child),c('county','ratio_child')][1:5,]
#문제3. 분류표의 기준에 따라 미성년 비율 등급 변수를 추가하고, 각 등급에 몇 개의 지역이 있는지 알아보세요.
# midwest에 grade 변수 추가
midwest <- midwest %>%
  mutate(grade = ifelse(ratio_child >= 40, "large",
                        ifelse(ratio_child >= 30, "middle", "small")))
head(midwest,10)

table(midwest$grade)
table(midwest$grade, useNA = "ifany") # 결측치를 포함한 분포표

#문제4. popasian은 해당 지역의 아시아인 인구를 나타냅니다. '전체 인구 대비 아시아인 인구 백분율' 변수를 추가하고, 하위 10개 지역의 state(주), county(지역명), 아시아인 인구 백분율을 출력하세요.
# 방법1
midwest %>%
  mutate(ratio_asian = (popasian/poptotal)*100) %>%  # 백분율 변수 추가
  arrange(ratio_asian) %>%                           # 내림차순 정렬
  select(state, county, ratio_asian) %>%             # 변수 추출
  head(10)                       
# 방법2
midwest$ratio_asian <- midwest$popasian/midwest$poptotal*100
library(doBy)
###########################
##### 혼자해 보기 (6) #####
###########################
data(mpg, package = "ggplot2")
mpg[c(10, 14, 58, 93), "drv"] <- "k"                # drv 이상치 할당
mpg[c(29, 43, 129, 203), "cty"] <- c(3, 4, 39, 42)  # cty 이상치 할당
library(dplyr)
# Q1. drv에 이상치가 있는지 확인하세요. 이상치를 결측 처리한 다음 이상치가 사라졌는지 확인하세요. 결측 처리 할 때는 %in% 기호를 활용하세요.
table(mpg$drv) # 이상치('k') 확인
mpg$drv <- ifelse(mpg$drv %in% c('4','f','r'), mpg$drv, NA) # 이상치 처리 방법(1)

mpg <- mpg %>%                                               # 이상치 처리 방법(2)
  mutate(drv=ifelse(drv %in% c('4','f','r'), drv, NA))

table(is.na(mpg$drv))
table(mpg$drv)
table(mpg$drv, useNA='ifany') # NA 갯수까지 나옴
table(mpg$drv, exclude = NULL)# NA 갯수까지 나옴
?table
#	Q2. 상자 그림을 이용해서 cty에 이상치가 있는지 확인하세요. 상자 그림의 통계치를 이용해 정상 범위를 벗어난 값을 결측 처리한 후 다시 상자 그림을 만들어 이상치가 사라졌는지 확인하세요.
boxplot(mpg$cty)
result <- boxplot(mpg$cty)$stats # 상자 그림 생성 및 통계치 산출
mpg$cty[mpg$cty < result[1] | mpg$cty > result[5]] # 이상치
mpg$cty <- ifelse(mpg$cty < result[1] | mpg$cty > result[5], NA, mpg$cty) # 이상치 처리 방법(1)
mpg <- mpg %>% # 이상치 처리 방법(2)
  mutate(cty=ifelse(cty < result[1] | cty > result[5], NA, cty))
table(is.na(mpg$cty))
boxplot(mpg$cty)

#	Q3. 두 변수의 이상치를 결측처리 했으니 이제 분석할 차례입니다. 이상치를 제외한 다음 drv별로 cty 평균이 어떻게 다른지 알아보세요. 하나의 dplyr 구문으로 만들어야 합니다.

mpg %>%
  filter(!is.na(drv) & !is.na(cty)) %>%  # 결측치 제외
  group_by(drv) %>%                      # drv별 그룹 분리
  summarise(mean_hwy = mean(cty))        # cty 평균 구하기

mpg %>% 
  group_by(drv) %>%     
  summarise(mean_hwy = mean(cty, na.rm=T)) %>%
  filter(!is.na(drv))

tapply(mpg$cty, mpg$drv, mean, na.rm=T)
by(mpg$cty, mpg$drv, mean, na.rm=T)
library(doBy)
# summaryBy만 drv가 NA인 그룹도 평균을 내서 미리 NA 제외
summaryBy(cty~drv, mpg, FUN=mean, na.rm=T) #drv가 NA인 그룹도 나옴
summaryBy(cty~drv, mpg[!is.na(mpg$drv),], FUN=mean, na.rm=T)
aggregate(mpg$cty, by=list(mpg$drv), mean, na.rm=T)
