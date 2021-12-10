#──────────────────────────────────────────#
### 13장. 웹 데이터 수집(정적 웹크롤링) ####
#──────────────────────────────────────────#
install.packages("rvest")
installed.packages() # 설치된 패키지
library(rvest)

url <- 'https://movie.naver.com/movie/point/af/list.nhn'
html <- read_html(url, encoding = 'utf-8')
html

# 영화제목 : .movie (.color_b)
nodes <- html_nodes(html, '.movie')
as.character(nodes)
title <- html_text(nodes)
title
# 해당 영화 안내 페이지 :
movieInfo <- html_attr(nodes, 'href')
movieInfo <- paste0(url, movieInfo)
movieInfo 
# 평점 : .list_netizen_score em
nodes <- html_nodes(html, '.list_netizen_score em')
point <- html_text(nodes)
point
# 영화 리뷰 : td.title
nodes <- html_nodes(html, 'td.title')
text <- html_text(nodes)
text <- gsub('\t','',text) # \t없애기
text <- gsub('\n', '', text) # \n 없애기
text
review <- unlist( strsplit(text, '중[0-9]{1,2}') )[seq(2,20,2)]
review <- gsub('신고','', review)

df <- data.frame(title, movieInfo, point, review)
View(df)

page <- cbind(title, movieInfo)
page <- cbind(page, point)
page <- cbind(page, review)
View(page)

write.csv(page, 'outData/movie_review.csv')

#### 여러 페이지 정적 웹 크롤링(영화리뷰 1~100페이지까지)
home <- 'https://movie.naver.com/movie/point/af/list.nhn'
site = "https://movie.naver.com/movie/point/af/list.nhn?&page="
movie.review <- NULL

for(i in 1:100){
  url <- paste0(site, i)
  html <- read_html(url, encoding = 'utf-8')
  # 영화제목 : .movie (.color_b)
  nodes <- html_nodes(html, '.movie')
  title <- html_text(nodes)
  # 해당 영화 안내 페이지 :
  movieInfo <- html_attr(nodes, 'href')
  movieInfo <- paste0(home, movieInfo) # url 대신 home
  # 평점 : .list_netizen_score em
  nodes <- html_nodes(html, '.list_netizen_score em')
  point <- html_text(nodes)
  # 영화 리뷰 : td.title
  nodes <- html_nodes(html, 'td.title')
  text <- html_text(nodes)
  text <- gsub('\t','',text) # \t없애기
  text <- gsub('\n', '', text) # \n 없애기
  review <- unlist( strsplit(text, '중[0-9]{1,2}') )[seq(2,20,2)]
  review <- gsub('신고','', review)
  
  df <- data.frame(title, movieInfo, point, review)
  movie.review <- rbind(movie.review, df)
}
View(movie.review)
write.csv(movie.review, 'outData/movie_review100page.csv')
write.csv(movie.review, 'outData/movie_review100page.csv', row.names = FALSE)

?write.csv

# 영화 평점이 높은 top10

library(KoNLP)
library(stringr)
library(ggplot)
library(dplyr)
library(wordcloud)
library(ggplot2)

movie <- movie.review
str(movie)
movie$point <- as.numeric(movie$point)
result <- movie %>% 
  group_by(title) %>% 
  summarise(point.mean = mean(point),
            point.sum  = sum(point),
            n = n()   ) %>%
  filter(n>10) %>% 
  arrange(desc(point.mean), desc(point.sum)) %>% 
  head(10)
result
ggplot(result, aes(x=point.mean, y=reorder(title, point.mean))) +
  geom_col(aes(fill=title)) +
  geom_text(aes(label=paste('총점:',point.sum, '평균 ', round(point.mean,1))), hjust=1) +
  theme(legend.position = "none")
# 평점평균이 높은 영화10개의 리뷰 내용만 뽑아 최빈 단어 & 워드클라우드
movie1 <- movie %>%  # result$title에 있는 영화만 추출
  filter (title %in% result$title)
View(movie1)
nrow(movie1)

useNIADic()
# 특수문자 없애기
movie1$review <- gsub('\\W',' ', movie1$review)
movie1$review <- gsub('[ㄱ-ㅎㅏ-ㅣ]',' ', movie1$review)
View(movie1)

# 명사 추출
nouns <- extractNoun(movie1$review)

# 워드 카운드
wordcount <- table(unlist(nouns))
head(wordcount)
View(wordcount)
df_word <- as.data.frame(wordcount, stringsAsFactors = FALSE)
head(df_word)
df_word <- rename(df_word, word=Var1, freq=Freq)
df_word <- filter(df_word, nchar(word)>1 & word!='영화')

# 최빈 단어 10개 뽑기
top10 <- df_word[order(df_word$freq, decreasing = T), ][1:10,]
top10

library(wordcloud)
pal <- brewer.pal(8, 'Dark2')

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 5,
          max.words = 200,
          random.order = F,
          rot.per = 0.1,
          scale=c(2,0.3),
          colors=pal)








