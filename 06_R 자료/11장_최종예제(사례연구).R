#───────────────────────────────#
### 11장. 최종예제(사례연구) ####
#───────────────────────────────#
#### 0. 패키지 설치 및 로드하기 ####
install.packages("foreign")
library(foreign) # SPSS 파일 불러오기
library(dplyr)  # 전처리
library(doBy)   # 전처리
library(ggplot2) # 시각화
library(readxl)  # 엑셀파일 불러오기(code_job의 데이터)
rm(list=ls(all.names = TRUE))
#### 1. 데이터를 불러와 원하는 필드만 추출 ####
# (1) SPSS파일을 데이터 프레임으로

raw_Welfare <- read.spss(file = 'C:/bigdata/Download/sharedBigdata/Koweps/Koweps_hpc10_2015_beta1.sav',
                         to.data.frame = TRUE) # 이 파라미터가 없으면 list형태로 받아옴
dim(raw_Welfare)
View(raw_Welfare)

raw_welfare <- read.spss('C:/bigdata/Download/sharedBigdata/Koweps/Koweps_hpc10_2015_beta6.sav', 
                         to.data.frame = TRUE,
                         reencode = "utf-8");
dim(raw_welfare)
View(raw_welfare)
head(raw_welfare,1)

# (2) 필요한 필드만 select
welfare <- raw_welfare[, c('h10_g3', 'h10_g4','h10_g10','h10_g11',
                       'h10_eco9','p1002_8aq1','h10_reg7')]
dim(welfare)
head(welfare)

# (3) 변수명 변경
welfare <- rename(welfare, gender=h10_g3, # 성별
                  birth=h10_g4,           # 태어난 연도
                  marriage = h10_g10,    # 혼인상태
                  religion = h10_g11,    # 종교
                  code_job = h10_eco9,   # 월급
                  income = p1002_8aq1,   # 직업코드
                  code_region = h10_reg7) # 지역코드
head(welfare)
table(is.na(welfare)) # 전체 데이터의 결측치 확인
colSums(is.na(welfare))  # 열별 결측치 확인
  
#### 2. 성별에 다른 월급 차이 분석 ####
# (1) gender 필드에 이상있는지 확인. 이상치 처리
table(welfare$gender, useNA = "ifany") # 이상치 없음
# (2) gender 필드 결측치 확인
table(is.na(welfare$gender)) # 결측치도 없음
# (3) gender가 1이면 "male"로 2면 "female"로 변경. factor로 변경
welfare$gender <- ifelse(welfare$gender==1,  "male","female")
table(welfare$gender)
welfare$gender <- factor(welfare$gender, levels=c('male','female'))
# (4) 성별 비율 도표와 그래프 시각화
gender.ratio <- welfare %>% 
  group_by(gender) %>% 
  summarise(ratio = n()/nrow(welfare)*100)
gender.ratio
pie(gender.ratio$ratio,
    labels=paste(gender.ratio$gender,
                 round(gender.ratio$ratio, 1),
                 '%'),
    clockwise = TRUE,
    col=c('skyblue','pink'))

ggplot(gender.ratio, aes(x=gender, y=ratio, fill=gender)) +
  #geom_col()
  geom_bar(stat="identity") +
  scale_x_discrete(limits=c('female','male')) + #축의 순서 
  scale_fill_discrete(limits=c('female','male')) +# 범례순서
  theme(legend.position = c(.3,.8),
        legend.title = element_text(face=3, color="red")) # 이텔릭체 빨간 글씨

ggplot(gender.ratio, aes(x="", y=ratio, fill=gender)) +
  geom_col() +
  coord_polar("y")

# (5) income의 최소값, 1~3사분위수, 최대값, 결측치 탐색, boxplot, income 빈도 그래프
summary(welfare$income)
boxplot(welfare$income)
ggplot(welfare, aes(y=income)) +
  geom_boxplot()
ggplot(welfare, aes(income)) +
  geom_histogram() + # 연속적인 자료 income을 계급으로 나누어 계급별 빈도그래프
  coord_cartesian(xlim=c(0,1200))
# (6) income이 0인 데이터는 이상치로 정하고 결측 처리.
b <- boxplot(welfare$income)$stat

table(welfare$income<=b[1])

welfare$income <- ifelse(welfare$income<=b[1], NA, welfare$income)
table(welfare$income<=b[1], useNA = "ifany")
table(welfare$income>b[5], exclude = NULL) # 상위 이상치보다 큰 값이 5%가량 되어 상위 이상치는 처리하지 않음.

  ## 결측치 처리
temp <- welfare[,c('gender','income')]
m <- tapply(temp$income, temp$gender, median, na.rm=T)
m
head(temp)
temp$income <- ifelse(is.na(temp$income), m[temp$gender], temp$income)
head(temp)

# (7) 결측치를 제외한 데이터를 이용하여 성별에 따른 월급차이 있는지 분석하시오.
summaryBy(income~gender, data=welfare, FUN=c(mean, sd), na.rm=T)
# na.omit()함수를 이용하여 결측치 제외
temp <- na.omit(welfare[,c('gender','income')])
summaryBy(income~gender, data=temp, FUN=c(mean, sd))

welfare %>% 
  group_by(gender) %>% 
  summarise(income.mean = mean(income, na.rm=T)) %>% 
  ggplot(aes(x=gender, y=income.mean))+
  geom_bar(stat="identity")
ggplot(welfare, aes(x=gender, y=income)) +
  geom_point(position = "jitter", 
             col="yellow", alpha=.3) + 
  geom_violin() +
  geom_boxplot(aes(col=gender),
               fill="lightyellow",
               width=.3,
               notch = T) +
  coord_cartesian(ylim=c(0,1000))

t.test(income~gender, data=welfare)
  # p-value가 0.05미만으로 성별에 따른 월급차이가 없다는 귀무가설을 기각한다.

#### 3. 나이와 월급의 관계 - 몇살때 월급이 가장 많을까 ####
# (1) birth와 income 변수의 이상치와 결측치 확인
class(welfare$birth)
table(is.na(welfare$birth), useNA = "ifany") # 결측치 없음
boxplot(welfare$birth) # 이상치 없음
# (2) birth 변수를 이용하여 나이 계산하고 age 필드 추가
welfare$age <- 2015 - welfare$birth + 1
boxplot(welfare$age)$stat
View(welfare)
ggplot(welfare, aes(y=age)) + 
  geom_boxplot() +
  theme(axis.text.x = element_blank())+ # x축 눈금을 없앰
  coord_cartesian(xlim=NULL)
# 나이의 분포를 그냥 봄
ggplot(data=welfare, aes(age)) +
  geom_histogram()
# (3) x축을 나이, y축을 월급으로 나이에 따른 월급 변화를 막대그래프나 선그래프로 시각화
# 나이별 월급 평균 및 표준편차 도표(income이 NA것은 제외)
age_income <- welfare %>% 
  filter(!is.na(welfare$income)) %>% 
  group_by(age) %>% 
  summarise(income.mean = mean(income),
            income.sd   = sd(income))
View(age_income)
# 나이별 월급 평균 시각화
ggplot(age_income, aes(x=age, y=income.mean)) +
  geom_col() # 막대그래프
ggplot(age_income, aes(x=age, y=income.mean)) +
  geom_line() # 선그래프
# (4) 나이에 따른 월급 차이가 있는지 통계분석
fit <- lm(income~age, data=welfare)
anova(fit) # F값이 0.05미만으로 나이에 따른 월급의 차이가 없다는 귀무가설을 기각
# (5) 몇 살때 월급을 가장 많이 받는지 : 53, 44, 49살
head(age_income[order(-age_income$income.mean),],5)

#### 4. 연령대에 따른 월급의 차이가 있는지 있으면 어떤 연령대가 월급이 가장 많은지 분석 ####
# (1) 파생변수 agegrade (young 30세 이하 / 31~60 middle / 61세 이상 - old)
welfare <- welfare %>%
  mutate(agegrade = ifelse(age<=30, "young",
                           ifelse(age<=60, "middle", "old")))
str(welfare$agegrade)
# welfare$agegrade를 factor형 변수로 변환 추천
welfare$agegrade <- factor(welfare$agegrade, levels = c('young','middle','old'))
# (2) agegrade 의 분포를 도표와 그래프로 시각화
table(welfare$agegrade, exclude = NULL) # NA포함한 도수분포표(빈도표). 결측치가 없음을 알 수 있음.

qplot(welfare$agegrade, xlim = c('young','middle','old'))
ggplot(data=welfare, aes(agegrade)) + 
  geom_bar(aes(fill=agegrade)) +
  #xlim(c('young','middle','old')) + # 아래와 같음 
  scale_x_discrete(limits=c('young','middle','old')) +
  theme(legend.position = "none")

welfare %>% 
  group_by(agegrade) %>% 
  summarise(cnt = n()) %>% 
  ggplot(aes(x="", y=cnt, fill=agegrade)) +
  geom_col()+
  coord_polar("y")

# (3) 연령대 별 월급의 boxplot
library(RColorBrewer)
boxplot(income~agegrade, data=welfare, col=brewer.pal(3, 'Set2'), ylim=c(0, 800))
ggplot(welfare, aes(x=agegrade, y=income, fill=agegrade)) +
  geom_boxplot(notch = T) +
  scale_fill_manual(values=topo.colors(3)) +
  coord_cartesian(ylim=c(0,800))
#(4) 연령대별 월급차이가 있는지 분석
  # 도표
summaryBy(income~agegrade, data=welfare, FUN=c(mean, sd), na.rm=T)
  # 시각화
ggplot(welfare, aes(x=agegrade, y=income, fill=agegrade)) +
  geom_point(position = "jitter",col="orange", alpha=.2) +
  geom_violin(width=1.2, alpha=0.5) +
  geom_boxplot(fill="lightyellow", width=.2, notch = T)+
  coord_cartesian(ylim=c(0,1000))+
  theme(legend.position = "none") +
  scale_x_discrete(limits=c('young','middle','old')) + # 축순서
  scale_fill_discrete(limits=c('young','middle','old')) # 범례순서
  # 통계분석(ANOVA분석)
result <- aov(income~agegrade, data=welfare[!is.na(welfare$income),])
summary(result)
result <- aov(income~agegrade, data=welfare)
summary(result)

#### 5. 성별에 따른 월급 차이는 연령대별로 다른지 ####
#(1) 결측치 확인(성별, 연령대, 월급)
table(is.na(welfare$gender))
table(is.na(welfare$agegrade))
table(is.na(welfare$income))
colSums(is.na(welfare[,c('gender','agegrade','income')]))
#(2) 연령대별 성별, 월급 평균, 표준편차, 빈도 출력
gender_agegrade_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(agegrade, gender) %>% 
  summarise(income.mean = mean(income),
            income.sd   = sd(income),
            n = n(), .groups="drop") # warning이 날 경우 , .groups="drop"추가
gender_agegrade_income

# (3) 성별에 따른 월급차이가 연령대별로 다른지 시각화
ggplot(gender_agegrade_income, aes(x=agegrade, y=income.mean, fill=gender)) +
  geom_bar(stat="identity", position = "dodge") +
  scale_x_discrete(limits=c('young','middle','old')) + # x축 순서(factor변수로 안했을 경우 순서 변경)
  scale_fill_manual(values=c('skyblue','pink'), breaks=c('male','female')) # fill 색상지정 및 범례 순서

# young 연령대 남녀 비교
young <- ggplot(subset(welfare, agegrade=='young'), 
                aes(x=gender, y=income)) +
  geom_point(position = "jitter", col='orange', alpha=0.6)+
  geom_violin() +
  geom_boxplot(aes(fill=gender),notch = T, width=0.7)+
  theme(legend.position = "none") +
  labs(title="young")
# middle 연령대 남녀비교
middle <- ggplot(subset(welfare, agegrade=='middle'), 
                 aes(x=gender, y=income)) +
  geom_point(position = "jitter", col='orange', alpha=0.3)+
  geom_violin() +
  geom_boxplot(aes(fill=gender),notch = T, width=0.6)+
  theme(legend.position = "none") +
  labs(title="middle")
# old 연령대 남녀비교
old <- ggplot(subset(welfare, agegrade=='old'), 
              aes(x=gender, y=income)) +
  geom_point(position = "jitter", col='orange', alpha=0.6)+
  geom_violin() +
  geom_boxplot(aes(fill=gender),notch = T, width=0.7)+
  theme(legend.position = "none") +
  labs(title="old")
library(gridExtra)
grid.arrange(young, middle, old, ncol=3)

# facet_grid이나 facet_wrap을 이용하여 연령대별 남녀 비교 그래프
ggplot(welfare, aes(x=gender, y=income)) +
  geom_point(position = "jitter", col='orange', alpha=0.6)+
  geom_violin() +
  geom_boxplot(aes(fill=gender),notch = T, width=0.7)+
  theme(legend.position = "none")+
  facet_grid(agegrade~.)

ggplot(welfare,
       aes(x=gender, y=income))+
  geom_point(position = "jitter", col='brown', alpha=0.3)+
  geom_violin() +
  geom_boxplot(aes(fill=gender),notch = T, width=0.6) +
  theme(legend.position = "none") + 
  facet_wrap(~agegrade)
# 아래는 성별과 연령대에 따라 월급이 달라질 수 있냐는 보는 ANOVA분석이지 성별에 따른 월급의 차이가 연령대 별로 다른지는 분석하지는 않는다.
result <- aov(income~gender+agegrade, data=welfare)
summary(result)
# young 층 t-test결과 : p-value = 0.04184
var.test(income~gender, data=subset(welfare, agegrade=='young'))
t.test(income~gender, data=subset(welfare, agegrade=='young'), var.equal=F) 
# middle 층 t-test결과 : p-value < 2.2e-16
var.test(income~gender, data=subset(welfare, agegrade=='middle'))
t.test(income~gender, data=subset(welfare, agegrade=='middle'), var.equal=F) 
# old 층 t-test결과 : p-value < 2.2e-16
var.test(income~gender, data=subset(welfare, agegrade=='middle'))
t.test(income~gender, data=subset(welfare, agegrade=='middle'), var.equal=F) 
# 위의 결과에 따라 모든 연령대에서 남녀월급차이가 있고, 
# 특히 middle층과 old층에서 남녀 월급차이가 극명한 것으로 보여진다.

#### 6. 나이에 따른 월급 변화를 성별로 분리하여 시각화 ####
# (1) 나이와 성별로 그룹하여 월급평균, 월급표준편차, 월급중앙값, 최소값, 빈도 출력
gender_age_income <- welfare %>% 
  filter(!is.na(welfare$income)) %>% 
  group_by(age, gender) %>% 
  summarise(income.mean = mean(income),
            income.sd = sd(income),
            income.median = median(income),
            income.min = min(income),
            income.max = max(income),
            n=n())
gender_age_income
# (2) 나이에 따른 월급 평균의 추이를 시각화하고 저장
png(filename = 'result.png')
ggplot(gender_age_income, aes(x=age, y=income.mean, col=gender)) +
  geom_line() +
  scale_color_discrete(limits=c('female','male')) # 범례 순서 바꾸기
dev.off()

# 또는 아래와 같이 하여도 됨
ggplot(gender_age_income, aes(x=age, y=income.mean, col=gender)) +
  geom_line() +
  scale_color_discrete(limits=c('female','male')) # 범례 순서 바꾸기
ggsave(filename='result.png')

#### 7. 직업별 월급 차이 ####
# (1) 직업별 월급 평균, 표준편차, 빈도를 평균 월급 순으로 정렬하여 출력.
job_list <- read_excel('C:/bigdata/Download/sharedBigdata/Koweps/Koweps_Codebook.xlsx', col_names=T, sheet=2)
View(job_list)

welfare <- left_join(welfare, job_list, id="code_job")
View(welfare)
job_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(income.mean = mean(income),
            income.sd = sd(income),
            n=n()) %>% 
  arrange(desc(income.mean))
View(job_income) # 직업별 월급 평균, 표준편차, 빈도
nrow(job_income) # 직업갯수 : 142개
# 직업에 따른 월급의 차이가 없다는 귀무가설을 기각한다(ANOVA분석 결과 : F 값< 2e-16)
result <- aov(income~job, data=welfare)
summary(result)
# (2) 상위 소득 10개 직업군 출력
top10 <- head(job_income, 10)
ggplot(top10, aes(x=reorder(job, income.mean), y=income.mean))+
  geom_col()+
  coord_flip() # x축과 y축을 바꿈
ggplot(top10, aes(x=income.mean, y=reorder(job, income.mean))) +
  geom_bar(stat="identity")+
  labs(title = "상위 소득 10개 직업군", x="직업", 
       y="평균소득") 
# 위와 같이 하면 y축의 직업이 너무 길어 직업을 줄여 아래와 같이 시각화 하기도 한다. 순서는 꺼구로
top10_short_jobnames <- c('석유화학',
                          '건설전기',
                          '교육법률',
                          '문화예술',
                          '행정경영',
                          '제관판금',
                          '보험금융',
                          '고위공무원',
                          '의료진',
                          '금속재료')
ggplot(top10, aes(x=income.mean, y=reorder(job, income.mean))) +
  geom_bar(stat="identity")+
  labs(title = "상위 소득 10개 직업군", x="직업", 
       y="평균소득") +
  scale_y_discrete(labels=top10_short_jobnames)

# (3) 하위 소득 10개 직업
bottom10 <- welfare %>% 
  filter(!is.na(income) & !is.na(job)) %>%
  group_by(job) %>%
  summarise(mean.income=mean(income)) %>%
  arrange(mean.income) %>%
  head(10)
bottom10

ggplot(bottom10, aes(x=mean.income, y=reorder(job, -mean.income))) +
  geom_col(aes(fill=job))+
  labs(title = "소득 하위10직업군", x="직업군", y="평균소득") +
  theme(legend.position = "none") +
  scale_y_discrete(labels=c('판매단순', '음식단순',
                            '의료복지','농립어업',
                            '작물재배','약사한약사',
                            '환경미화','서비스단순',
                            '임업관련','가사도우미'))

#### 8. 성별 직업 빈도 : 성별로 어떤 직업이 많을까 ####
# (1)여성최빈 직업 상위 10
female10 <- welfare %>% 
  filter(!is.na(job) & gender=='female') %>% 
  group_by(job) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)
female10 # 여성최빈 직업
ggplot(female10, aes(x=cnt, y=reorder(job, cnt))) +
  geom_col()

# (2)남성최빈 직업 상위 10
male10 <- welfare %>% 
  filter(!is.na(job) & gender=='male') %>% 
  group_by(job) %>% 
  summarise(cnt = n()) %>% 
  arrange(desc(cnt)) %>% 
  head(10)
male10 # 남성최빈 직업
ggplot(male10, aes(x=cnt, y=reorder(job, cnt))) +
  geom_col()

#### 9. 종교 유무에 따른 이혼율
# (1)종교유무의 빈도 시각화
table(welfare$religion, useNA = "ifany") # NA포함 빈도표
welfare$religion <- ifelse(welfare$religion==1, "종교-有", "종교-無")
table(welfare$religion, exclude = NULL) # NA포함 빈도표

ggplot(welfare, aes(x=religion, fill=religion))+
  geom_bar(width=0.7) +
  theme(legend.position = "none")

ggplot(welfare, aes(x="", y=religion, fill=religion)) +
  geom_bar(stat="identity") +
  coord_polar("y") # 이 파이차트는 시간이 엄청 오래 걸림

# 시간이 얼마 안 걸리는 파이차트
welfare %>% 
  group_by(religion) %>% 
  summarise(ratio = n()/nrow(welfare)*100) %>% 
  ggplot(aes(x="", y=religion, fill=religion)) +
  geom_bar(stat="identity") +
  coord_polar("y")

# (2) 혼인 상태인 marriage에 따라, 파생변수 marriage_group 추가하고 종교 유무에 따른 이혼률 분석
# 파생변수 marriage_group 추가
welfare <- welfare %>%
  mutate(marriage_group =ifelse(marriage==1, "기혼", ifelse(marriage==3,"이혼", NA)))
head(welfare)
table(welfare$marriage, useNA='ifany')
table(welfare$marriage_group, useNA = "ifany")
# 종교유무에 따른 이혼률
temp <- welfare %>%
  filter(!is.na(marriage_group))
View(temp)
# 도표
table(temp$religion, temp$marriage_group)

religion_marriage  <- welfare %>%
  filter(!is.na(marriage_group)) %>%
  group_by(religion, marriage_group) %>%
  summarise(cnt = n(), .groups = "drop") %>% # warning시 , .groups = "drop"추가
  group_by(religion) %>% 
  mutate(tot_group = sum(cnt)) %>%
  mutate(ratio = round(cnt/tot_group*100,1))

religion_marriage
# 시각화
ggplot(religion_marriage, aes(x=religion, y=cnt, fill=marriage_group)) +
  geom_col(position="dodge")

# 기혼상태만 시각화
welfare %>% 
  filter(marriage_group=='기혼') %>% 
  group_by(religion) %>% 
  summarise(tot = n()) %>% 
  mutate(pct = tot/sum(tot)*100) %>% 
  ggplot(aes(x=religion, y=pct, fill=religion)) +
  geom_col(width=.5) +
  theme(legend.position = "none")
# 이혼상태만 시각화
welfare %>% 
  filter(marriage_group=='이혼') %>% 
  group_by(religion) %>% 
  summarise(tot = n()) %>% 
  mutate(pct = tot/sum(tot)*100) %>% 
  ggplot(aes(x=religion, y=pct, fill=religion)) +
  geom_col(width=.5) +
  theme(legend.position = "none")

# t-test는 독립변수는 볌주형, 종속변수는 연속형이여야 적합하다.
temp <- welfare %>%
  filter(!is.na(marriage_group))
var.test(data=temp, marriage~religion)
t.test(data=temp, marriage~religion, var.equal=F) #p-value가 0.045로 종교유무에 따라 결혼상태가 다소 다를 수 있다.

#### 10. 지역별 연령대 비율 ; 노년층이 많은 지역은 어디? ####
# (1) 결측치 확인 및 region 파생변수를 지역명으로 추가
class(welfare$code_region)
table(welfare$code_region, useNA = "ifany") #결측치 없음
table(!is.na(welfare$agegrade)) # 연령대, 지역 모두 NA가 없음

# region파생변수 추가
region_list <- data.frame(code_region = c(1:7),
                          region=c('서울',
                                   '수도권(인천/경기)',
                                   '부산/경남/울산',
                                   '대구/경북',
                                   '대전/충남',
                                   '강원/충북',
                                   '광주/전남/전북/제주도'))
welfare <- left_join(welfare, region_list, by="code_region")
head(welfare)
table(welfare$region)
# (2) 지역별 연령대 비율을 분석한 도표 및 시각화 
region_agegrade <- welfare %>% 
  group_by(region, agegrade) %>% 
  summarise(cnt = n(), .groups = "drop") %>%  # warning 시 .groups = "drop" 추가
  group_by(region) %>% 
  mutate(tot_group = sum(cnt)) %>% 
  mutate(ratio = round(cnt/tot_group*100,2))
View(region_agegrade)

# 지역별 연령대 인구
ggplot(data=region_agegrade, aes(x=reorder(region, cnt), y=cnt, fill=agegrade)) + 
  geom_col(position = 'dodge') +
  theme(axis.text.x = element_text(angle = 70, vjust=0.7)) 
  # 노년층이 많은 지역은 광주/전남/전북/제주 

ggplot(data=region_agegrade, aes(x=reorder(region, cnt), y=ratio, fill=agegrade)) + 
  geom_col(position = 'dodge') +
  theme(axis.text.x = element_text(angle = 70, vjust=0.7)) 
  # 노년층 비율이 많은 지역은 대구/경북

# (3) 노년층이 많은 지역
# 노년층 인구가 많은 순
old_region <- region_agegrade %>% 
  filter(agegrade=='old') %>%
  arrange(desc(cnt))
cat('노년층 인구가 많은 순 :', old_region$region )
ggplot(old_region, aes(x=cnt, y=reorder(region, cnt))) +
  geom_col() +
  geom_text(aes(label=cnt), hjust=0) +
  coord_cartesian(xlim=c(0,1350))


# 노년층 비율이 높은 순
old_region_ratio <- region_agegrade %>% 
  filter(agegrade == 'old') %>% 
  arrange(desc(ratio))
old_region_ratio

cat('노년층 비율이 높은 순 :', old_region_ratio$region )
ggplot(old_region_ratio, aes(x=ratio, y=reorder(region, ratio))) +
  geom_col() +
  geom_text(aes(label=ratio), hjust=0) +
  coord_cartesian(xlim=c(0,60))
# ※  7개 변수 외에도 신체건강, 정신건강, 가족간의 관계, 주거환경, 교육수준 등 957개의 변수가 있습니다. 흥미로운 주제를 찾아 자신만의 데이터 분석 프로젝트를 수행해 보세요. 조사설계서 참조
