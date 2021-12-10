#──────────────────────────────────────#
### 10장. t-test분석 vs. ANOVA 분석 ####
#──────────────────────────────────────#
  # 두 그룹간의 평균 차이가 통계적으로 유의한지 검증 : t-test분석
  # 세그룹 이상의 집단 간의 평균 차이가 유의한지 검증 : ANOVA분석(분산분석)

#### 1. 두그룹간의 평균의 차이가 유의한지 분석 ####
ToothGrowth
table(ToothGrowth$supp, useNA = "ifany")
# (1)도표로 차이의 유의성을 표현(tapply, by, summaryBy, aggregate를 이용해서 mean, sd)
# (2)그래프로 시각화된 유의성 표현(바이올린도표, 산점도, 상자도표 or (1)의 결과를 막대도표)
# (3) 통계적으로 유의한지 검증

## 비타민의 종류가 기니피크 치아 성장에 영향을 미치는가?
rm(ToothGrowth)
dim(ToothGrowth) #60행
# 비밀리에 데이터 뻥튀기
ToothGrowth <- rbind(ToothGrowth, ToothGrowth) #3번 실행 -> 480행
nrow(ToothGrowth)
table(is.na(ToothGrowth)) # 결측치 확인
colSums(is.na(ToothGrowth)) # 열별 결측치 확인
# (1)
len.mean <- tapply(ToothGrowth$len, ToothGrowth$supp, FUN=mean)
len.sd   <- tapply(ToothGrowth$len, ToothGrowth$supp, FUN=sd)
data.frame(len.mean, len.sd)

library(doBy)
summaryBy(len~supp, data=ToothGrowth, FUN=c(mean, sd))

# (2) 그래프로 시각화
library(dplyr)
ToothGrowth %>% 
  group_by(supp) %>% 
  summarise(len.mean = mean(len)) %>% 
  ggplot(aes(x=supp, y=len.mean, fill=supp)) +
  geom_bar(stat="identity", width=0.6)+
  theme(legend.position = "none")

ggplot(data=ToothGrowth, aes(x=supp, y=len)) +
  geom_violin(fill="lightyellow") +
  geom_point(position = "jitter", col="orange", alpha=.3) +
  geom_boxplot(aes(fill=supp), width=0.3, notch = T) +
  theme(legend.position = "none")

# (3) 통계적 분석(일원표본 t-test < 이원표본 t-test)
# 일원표본 t-test
a <- ToothGrowth[ToothGrowth$supp=='OJ','len']
b <- ToothGrowth[ToothGrowth$supp=='VC','len']
t.test(a, b)
  # p-value가 0.05보다 작은 경우 귀무가설(두 그룹의 평균이 같다)을 기각함
  # p-value가 0.05보다 큰 경우 귀무가설을 기각하지 못한다.
# 이원표본 t-test (등분산성 테스트 -> t-test)
var.test(len~supp, data=ToothGrowth) # 등분산성 test
  # p-value가 0.05보다 작은 경우 귀무가설(두 그룹의 분산이 같다)을 기각함 - 등분산성이 성립 되지 않음.
  # p-value가 0.05보다 큰 경우 귀무가설을 기각하지 못한다. - 등분산성 성립
t.test(len~supp, data=ToothGrowth, var.equal=FALSE) # var.equal 등분산성 여부 값
  # p-value가 0.05보다 작은 경우 귀무가설(두 그룹의 평균이 같다)을 기각함
  # p-value가 0.05보다 큰 경우 귀무가설 기각하지 못한다.

rm(list=ls())
dim(ToothGrowth)
var.test(len~supp, data=ToothGrowth) # 등분산성 성립
t.test(len~supp, data=ToothGrowth, var.equal=TRUE) # 귀무가설 기각할 수 없음

## 예제 : datasets::sleep : extra(수면량) group(수면제종류)
  ## 수면제 group에 따라 수면량의 변화가 있는지를 분석하시오.
nrow(sleep)
sleep <- rbind(sleep, sleep) # 4번 수행해서 320개로 데이터 뻥튀기 
NROW(sleep)
table(sleep$group, useNA = "ifany") # 결측치 포함한 빈도표
library(ggplot2)
library(dplyr)
library(doBy)
# (1) 도표로 평균 차이 나타내기
summaryBy(extra~group, data=sleep, FUN=c(mean, sd))
# (2) 그룹간 차이를 시각화하기
sleep %>% 
  group_by(group) %>% 
  summarise(extra.mean = mean(extra)) %>% 
  ggplot(aes(x=reorder(group, extra.mean), y=extra.mean)) +
  geom_col()

ggplot(sleep, aes(x=group, y=extra)) +
  geom_point(position="jitter", col="yellow", alpha=.8) +
  geom_violin(width=.7) +
  geom_boxplot(aes(fill=group), notch = T, width=.3)
# (3) 통계적으로 유의미한 차이를 분석하기
var.test(extra~group, data=sleep) # p-value가 0.05보다 커서 등분산성 성립
t.test(extra~group, data=sleep, var.equal=TRUE) # p-value값이 의해 귀무가설(두 그룹간 평균이 같다) 기각
  # 귀무가설(두 그룹간 평균이 같다)
  # 대립가설(두 그룹간 평균이 같지 않다)

#### 2. 3개 이상의 그룹간 평균의 차이를 비교할 때 : 분산분석(ANOVA)

# (1) aov()
  # ex. iris데이터 셋에서 종에 따라 Sepal.Length의 평균이 다른지
table(iris$Species)
result <- aov(Sepal.Length ~ Species, data=iris)
summary(result)
  # F값이 0.05보다 작으면 귀무가설(그룹간 평균이 같다)을 기각
  # F값이 0.05보다 크면 귀무가설을 가각할 수 없다
# (2) anova()
  # ex. datasets::mtcars 데이터 셋에서 cyl
str(mtcars$cyl)
table(mtcars$cyl, useNA = "ifany")
## cyl에 따른 연비(mpg)의 차이가 있는지 분석하시오.
fit <- lm(mpg~cyl, data=mtcars)
fit
anova(fit) # F가 0.05보다 작으면 귀무가설을 기각

## 예제 : datasets::Orange ; 오렌지나무의 종류(Tree), 연령(age), 둘레(circumference)
  ## 오렌지 나무의 연령에 따른 둘레가 상이한지 분석하시오
head(Orange)
str(Orange$age)
table(Orange$age)
nrow(Orange)
fit <- lm(circumference~age, data=Orange)
fit
anova(fit)





