#──────────────────────────#
### 12장. 텍스트 마이닝 ####
#──────────────────────────#
# 문자로 된 비정형 텍스트 데이터로부터 가치있는 정보를 얻어내는 분석 : 텍스트 마이닝에서 가장 먼저 할 일은 형태소 분석
install.packages("rJava")
install.packages("memoise")
install.packages("KoNLP") # not available for this version of R

# google "KoNLP"를 검색후 "CRAN - Package KoNLP" 클릭 -> "archive." 클릭 후 "	KoNLP_0.80.2.tar.gz" 다운로드

# 우측 package 탭에서 수동으로 install 하기 위해 
install.packages("devtools")

# KoNLP가 의존하는 package 미리 install
install.packages("hash")
install.packages("tau")
install.packages("Sejong")
install.packages("RSQLite")

# 우측의 package탭의 install 도구를 이용하여 KoNLP install

# "scala-library-2.11.8.jar"파일을 "C:/Program Files/R/R-4.1.0/library/KoNLP/java" 폴더(폴더명은 개인별로 다름)에 복사

library(KoNLP)
useNIADic() # 사전 설정하기 에러 나면 https://github.com/youngwoos/Doit_R/blob/master/FAQ/install_KoNLP.md 참조
extractNoun(c("대한 민국의 영토는 한반도와 그 부속 도서로 한다","즐거운 수요일이다"))

#### 1. 힙합 가사 텍스트 마이닝 ####
## 1.1 텍스트 마이닝 할 텍스트 로드(필요한 data 확보)
txt <- readLines('inData/hiphop.txt') # 비정형 데이터
txt
head(txt)
class(txt)
is.vector(txt)
length(txt)

## 2.2 특수문자 제거(trim, 특수문자 제거)
# gsub(oldStr, newStr, string) ; string에 oldStr을 newStr로 바꿈
# str_replace_all(string, oldStr, newStr) ; string에 oldStr을 newStr로 바꿈

library(stringr)
trim = function(str){
  return(gsub('^\\s+|\\s+$','', str))
}
trim('     Hello    ')
temp <- gsub('\\W', ' ', txt) # 특수 문자 제거
txt[864]
temp[864]
txt <- str_replace_all(txt, '\\W',' ')
table(temp==txt)
txt <- trim(txt)
length(txt)
head(txt)

## 1.3 명사 추출
nouns <- extractNoun(txt)
class(nouns)
length(nouns) # 라인수
head(nouns)
length(unlist(nouns)) # 추출된 명사 갯수 : 14502

table(c('하나','하나','둘'))
wordcount <- table(unlist(nouns)) # 워드카운트(단어별 빈도표) 생성성
class(wordcount)
length(wordcount) # 반복된 명사를 제외한 명사의 가지수 : 3089
sort(wordcount, decreasing = T)

library(dplyr)
df_word <- as.data.frame(wordcount, stringsAsFactors = FALSE)
head(df_word)
df_word <- rename(df_word, word=Var1, freq=Freq)
head(df_word)
df_word$word <- trim(df_word$word)
head(df_word)
# 한글자 이상의 단어만 추출
df_word <- df_word %>% 
  filter(nchar(word)>1)
df_word <- filter(df_word, nchar(word)>1)
head(df_word)

# 자주 사용되는 단어 빈도표 top20 추출
top20 <- df_word[order(df_word$freq, decreasing = T),][1:20,]
top20 <- df_word[order(-df_word$freq),][1:20,]
top20
# 자주 사용되는 단어 top20 그래프 그리기
library(ggplot2)
ggplot(top20, aes(x=reorder(word,freq), y=freq)) +
  geom_col() +
  coord_flip()

ggplot(top20, aes(x=freq, y=reorder(word, freq))) +
  geom_col() +
  geom_text(aes(label=freq), col='red', nudge_x = 3.5)

df_word
# 워드 클라우드 
  # 1) 비정형 text 데이터 확보
  # 2) 패키지 설치 및 로드(KoNLP, wordcloud)
  # 3) 확보된 text 데이터 읽어오기 (벡터형태)
  # 4) 명사 추출
  # 5) 필요없는 데이터 삭제(특수문자, zz, ㅋㅋ, ㅎㅎ..)
  # 6) 워드 클라우드 생성 (dataFrame)
  # 7) wordcloud함수 이용해서 워드클라우드 생성
install.packages("wordcloud")
library(wordcloud)
display.brewer.all()
pal <- brewer.pal(9,"Blues")[5:9] # 워크 클라우드 쓸 파레트 변수 

set.seed(1234) # 난수 생성 결과를 일치시키려고
round(runif(6, min=1, max=45)) # 확인

# wordcloud함수 에러시 : 
install.packages("Rcpp")
library(wordcloud)
?wordcloud
set.seed(1234)
wordcloud(words = df_word$word, # 뿌려질 단어
          freq = df_word$freq,  # 단어 출현 빈도
          min.freq = 2,     # 최소 단어 빈도
          max.words = 200,  # 표현될 최대 단어 수
          random.order = F, # 최빈단어가 중앙 배치
          rot.per = 0.1,    # 회전 단어 비율(90도)
          scale = c(2, 0.2),# 단어 크기 범위
          colors=pal)       # 단어 색상
.libPaths()
#### 2. 국정원 트윗 데이터 텍스트 마이닝 ####
rm(list=ls(all.names = T))
library(KoNLP)
library(stringr)
library(dplyr)
library(ggplot2)
library(wordcloud)

twitter <- read.csv('inData/twitter.csv',
                    header = TRUE,
                    stringsAsFactors = FALSE,
                    fileEncoding = "UTF-8")
View(twitter)
head(twitter,1)

twitter <- rename(twitter, no=번호, id=계정이름, date=작성일, tw=내용)
View(twitter)

# 필요없는 문자 삭제
twitter$tw <- str_replace_all(twitter$tw, '\\W', ' ')
twitter$tw <- str_replace_all(twitter$tw, '[ㄱ-ㅎ]+',' ')
View(twitter)

# 명사 추출
class(twitter$tw)
nouns <- extractNoun(twitter$tw)

# wordcount 생성
wordcount <- table(unlist(nouns))
head(sort(wordcount, decreasing = T))

length(unlist(nouns)) # 추출된 명사 수 : 84,240
length(wordcount)     # 출현한 명사 갯수(중복제거) : 11,420

df_word <- as.data.frame(wordcount, stringsAsFactors = FALSE)
str(df_word)
names(df_word) <- c('word','freq')
str(df_word)
# 출현단어 중 2글자 이상만 분석
df_word <- filter(df_word, nchar(word)>1)
head(df_word)

# 최빈 단어 top20개 그래프
top20<-head(df_word[order(df_word$freq, decreasing = T), ] , 20)
ggplot(top20, aes(x=freq, y=reorder(word, freq))) +
  geom_bar(stat="identity")+
  geom_text(aes(label=freq), hjust=1, col="yellow",
            size=2)
# 워드 클라우드
set.seed(1234)
pal <- brewer.pal(8,"Dark2") 

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 5,
          max.words = 200,
          random.order = F, # 최빈 단어를 가운데로
          rot.per = 0.1,
          scale=c(2,0.2),
          colors=pal)

# 글 게시 횟수가 150회이상 트윗한 게시물에 대해 시각화 
idCount <- as.data.frame(table(twitter$id))
str(idCount)
colnames(idCount) <- c('id','count')
head(idCount)
twitter <- left_join(twitter, idCount)
View(twitter)

# 150회 이상 트윗한 계정의 정보만 추출
twitter1 <- subset(twitter, count>150)
View(twitter1)  

# 필요없는 문자 삭제 - 완료
# 명사 추출
nouns <- extractNoun(twitter1$tw)
# 워드카운트
wordcount <- table(unlist(nouns))
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
df_word <- rename(df_word, word=Var1, freq = Freq)  
head(df_word)
df_word <- filter(df_word, nchar(word)>1)

wordcloud(words = df_word$word,
          freq = df_word$freq,
          min.freq = 5,
          max.words = 200,
          random.order = F, # 최빈 단어를 가운데로
          rot.per = 0.1,
          scale=c(2,0.2),
          colors=pal)
