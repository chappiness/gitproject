# 시각화 포트폴리오 문제 11~20번
library(ggplot2)
library(gapminder)
library(dplyr)
library(gridExtra)
# 11. datasets::cars데이터 셋을 이용하여 속도에 대한 제동거리의 산점도와 적합도(신뢰구간 그래프)를 나타내시오(단, 속도가 5부터 20까지 제동거리 0부터 100까지만 그래프에 나타냄).
?cars
ggplot(cars, aes(x=speed, y=dist)) +
  geom_point() +
  geom_smooth(method="lm", level=0.99) +
  coord_cartesian(xlim=c(5, 20), ylim=c(0,100))

ggsave('포트폴리오문제그래프들/ex11.png')
# 12. gapminder::gapminder 데이터 셋을 이용하여 1인당국내총생산에 대한 기대수명의 산점도를 대륙별 다른 색으로 나타내시오.
head(gapminder)
ggplot(data=gapminder, aes(x=gdpPercap, y=lifeExp)) +
  geom_point(aes(col=continent)) +
  coord_cartesian(xlim=c(0,30000), ylim=c(20,80))
ggsave('포트폴리오문제그래프들/ex12.png')

# 13. gapminder::gapminder 데이터 셋을 이용하여 개대 수명이 70을 초과하는 데이터에 대해 대륙별 데이터 갯수
gapminder %>% 
  filter(lifeExp>70) %>% 
  group_by(continent) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=continent, y=n, fill=continent)) +
  geom_bar(stat="identity") +
  labs(title="포트폴리오 13.",
       subtitle="기대수명이 70을 초과하는 데이터 빈도(대륙별)", 
       x ="대륙", y="빈도") +
  theme(axis.text.x=element_text(angle = 60, vjust=0.7))

ggplot(gapminder[gapminder$lifeExp>70,], aes(x=continent, fill=continent ))+
  geom_bar(stat="count") +
  labs(title="포트폴리오 13.",
     subtitle="기대수명이 70을 초과하는 데이터 빈도(대륙별)", 
     x ="대륙", y="빈도") +
  theme(axis.text.x=element_text(angle = 60, vjust=0.7))

ggsave('포트폴리오문제그래프들/ex13.png')

# 14. gapminder::gapminder 데이터 셋을 이용하여 기대수명이 70을 초과하는 데이터에 대해 대륙별 나라 갯수.
dim(gapminder)

gapminder %>% 
  filter(lifeExp>70) %>% 
  group_by(continent, country) %>%   # 에러 시 , .groups = "drop" 추가가
  summarise(n = n()) %>% 
  group_by(continent) %>% 
  summarise(n = n()) %>% 
  ggplot(aes(x=continent, y=n, fill=continent)) +
  #geom_bar(stat="identity") +
  geom_col() +
  labs(title = "포트폴리오 14.",
       subtitle="기대수명이 70을 초과하는 대륙별 나라 빈도",
       y="나라빈도") +
  theme(axis.text.x=element_text(angle = 60, vjust=0.7))

# 또는 아래와 같이

gapminder %>% 
  filter(lifeExp>70) %>% 
  group_by(continent) %>% 
  summarise(n = n_distinct(country)) %>% 
  ggplot(aes(x=continent, y=n, fill=continent)) +
  #geom_bar(stat="identity") +
  geom_col() +
  labs(title = "포트폴리오 14.",
       subtitle="기대수명이 70을 초과하는 대륙별 나라 빈도",
       y="나라빈도") +
  theme(axis.text.x=element_text(angle = 60, vjust=0.7))

# 또는 아래와 같이

gapminder %>% 
  filter(lifeExp>70) %>% 
  group_by(continent, country) %>% # 에러 시 , .groups = "drop" 추가가
  summarise(n = n()) %>% 
  ggplot(aes(x=continent, fill=continent)) +
  geom_bar(stat="count") +
  labs(title = "포트폴리오 14.",
       subtitle="기대수명이 70을 초과하는 대륙별 나라 빈도",
       y="나라빈도") +
  theme(axis.text.x=element_text(angle = 60, vjust=0.7))
ggsave('포트폴리오문제그래프들/ex14.png')

# 15. gapminder::gapminder 데이터 셋을 이용하여 대륙별 기대수명의 사분위수를 시각화
ggplot(gapminder[gapminder$year==2007,], aes(x=continent, y=lifeExp, col=continent)) +
  geom_boxplot() +
  coord_cartesian(ylim=c(40,85)) +
  labs(title="포트폴리오 15.",
       subtitle="대륙별 기대수명(2007년)의 사분위수")

ggsave('포트폴리오문제그래프들/ex15.png')

# 16. gapminder::gapminder 데이터 셋을 이용하여 년도별로 gdp와 기대수명과의 관계를 산점도를 그리고 대륙별 점의 색상을 달리 시각화
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp, col=continent))+
  geom_point(alpha=0.5)+
  facet_wrap(~year) +
  coord_cartesian(xlim=c(0, 40000))+
  # scale_x_log10() + 
  labs(title="포트폴리오 16.",
       subtitle="GDP와 기대수명과의 관계")+
  theme(axis.text.x=element_text(angle = 90))

ggsave('포트폴리오문제그래프들/ex16.png')

# 17.gapminder::gapminder 데이터 셋에서 북한과 한국의 년도별 GDP 변화를 산점도로 시각화하시오(북한:Korea, Dem. Rep.  한국:Korea, Rep.  substr(str, start, end)함수 이용)
ggplot(gapminder[substr(gapminder$country, 1, 5)=='Korea',],
       aes(x=year, y=gdpPercap, col=country, shape=country))+ # shape==pch
  geom_point() +
  labs(title="포트폴리오 17.",
       subtitle="GDP의 변화(한국과 북한)") +
  theme(legend.position = c(0.3, 0.8)) +
  scale_shape_manual(values = c(3, 16), breaks = c('Korea, Rep.','Korea, Dem. Rep.')) +
  scale_color_manual(values = c("red","blue"), breaks = c('Korea, Rep.','Korea, Dem. Rep.'))
  
gapminder %>% 
  filter(substr(country,1,5)=='Korea') %>% 
  ggplot(aes(x=year, y=gdpPercap, col=country, shape=country))+ # shape==pch
  geom_point() +
  labs(title="포트폴리오 17.",
       subtitle="GDP의 변화(한국과 북한)") +
  theme(legend.position = c(0.3, 0.8)) +
  scale_shape_manual(values = c(3, 16), breaks = c('Korea, Rep.','Korea, Dem. Rep.')) +
  scale_color_manual(values = c("red","blue"), breaks = c('Korea, Rep.','Korea, Dem. Rep.'))
  
temp <- gapminder[substr(gapminder$country, 1, 5)=='Korea',]
str(temp$country)
temp$country <- factor(temp$country, levels=c('Korea, Rep.','Korea, Dem. Rep.'))
str(temp$country)
table(temp$country)

ggplot(temp, aes(x=year, y=gdpPercap, col=country, shape=country))+ # shape==pch
  geom_point() +
  scale_shape_manual(values = c(3, 16)) +
  scale_color_manual(values = c('red','blue'))+
  labs(title="포트폴리오 17.",
       subtitle="GDP의 변화(한국과 북한)") +
  theme(legend.position = c(0.3, 0.8)) # 범례 없애고 싶으면 "none"

ggsave('포트폴리오문제그래프들/ex17.png')

# 18. gapminder::gapminder 데이터 셋을 이용하여 한중일 4개국별 GDP 변화를 산점도와 추세선으로 시각화 하시오.
table(gapminder$continent)
gapminder %>% 
  filter(substr(country,1,5)=='Korea' | country=='China' | country == 'Japan') %>%
  ggplot(aes(x=year, y=gdpPercap, col=country)) +
  geom_point() +
  geom_line() +
  labs(title="포트폴리오 18.",
       subtitle="한중일 4개국의 GDP변화의 산점도와 추세선") +
  theme(legend.position = "top")

ggsave('포트폴리오문제그래프들/ex18.png')

# 19. gapminder::gapminder 데이터 셋에서 한중일 4개국별 인구변화 변화를 산점도와 추세선으로 시각화 하시오(scale_y_continuous(labels = scales::comma)추가시 우측처럼)
g1<- gapminder %>% 
  filter(substr(country,1,5)=='Korea' | country=='China' | country == 'Japan') %>% 
  ggplot(aes(x=year, y=pop, col=country)) +
  geom_point() +
  geom_line() +
  labs(title="포트폴리오 19.",
       subtitle="한중일 4개국의 인구 변화의 산점도와 추세선") +
  theme(legend.position = "bottom")

g2 <- gapminder %>% 
  filter(substr(country,1,5)=='Korea' | country=='China' | country == 'Japan') %>% 
  ggplot(aes(x=year, y=pop, col=country)) +
  geom_point() +
  geom_line() +
  labs(title="포트폴리오 19.",
       subtitle="한중일 4개국의 인구 변화의 산점도와 추세선") +
  scale_y_continuous(labels = scales::comma) +
  theme(legend.position = "bottom")

grid.arrange(g1,g2,ncol=2,nrow=1)
ggsave('포트폴리오문제그래프들/ex19.png')

# 20. Ggplot2::economics 데이터 셋의 개인 저축률(psavert)가 시간에 따라 어떻게 변해 왔는지 알아보려 한다. 시간에 따른 개인 저축률의 변화를 나타낸 시계열 그래프와 추세선을 시각화하시오
ggplot(economics, aes(x=date, y=psavert)) +
  geom_line(color='red', size=2) +
  geom_smooth(col="#FF5555") +
  labs(title="포트폴리오 10.",
       subtitle="개인저축률 시계열 그래프") +
  geom_line(aes(x=date, y=unemploy))
ggsave('포트폴리오문제그래프들/ex20.png')

# 21. x=date, y=psavert 시계열그래프+추세선(적합도선) 
#              x=date, y=unemploy
dim(economics)
edit(economics[, c('date','psavert','unemploy')])
# economics$psavert의 최대값과 최소값의 차이
diff1 <- max(economics$psavert) - min(economics$psavert) # 15.1
# economics$unemploy의 최대값과 최소값의 차이
diff2 <- max(economics$unemploy) - min(economics$unemploy) # 12667
diffRate <- diff2/diff1 # 838

ggplot(data=economics, aes(x=date, y=psavert)) +
  geom_line(col="red", size=2) +
  geom_smooth(col="pink") +
  geom_line(aes(x=date, y=unemploy/diffRate)) +
  geom_smooth(col="gray") +
  scale_y_continuous(sec.axis = sec_axis(~.*diffRate, name="unemploy"))

# 시계열 데이터를 인터랙티브 시계열 그래프 만들기
library(ggplot2)
data(economics, package = "ggplot2")
# economics = ggplot2::economics
head(economics)
ggplot(economics, aes(x=date, y=unemploy)) +
  geom_line()

install.packages("dygraphs")
library(dygraphs)
library(xts)
head(economics)
str(economics)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)
dygraph(eco)
dygraph(eco) %>%  dyRangeSelector()
head(economics[,c('psavert','unemploy')])

# 여러값을 표현한 인터랙티브 시계열 그래프
eco_a <- xts(economics$unemploy, order.by = economics$date)
eco_b <- xts(economics$psavert, order.by = economics$date)
eco2 <- cbind(eco_a, eco_b)
head(eco2)
colnames(eco2) <- c('psavert','unemploy')
head(eco2)
dygraph(eco2)
