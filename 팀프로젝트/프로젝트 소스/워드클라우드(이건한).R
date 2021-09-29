
Sys.setenv(JAVA_HOME="C:/Program Files/Java/jre1.8.0_291")
library(KoNLP)
useNIADic()

txt <- readLines('D:/R1/코딩/R11/inData/워드클라우드.txt')
txt
head(txt)
class(txt)
is.vector(txt)
length(txt)

library(stringr)
trim=function(str){
  return(gsub('^\\s+|\\s+$','',str))
}
trim("         hello           ")
temp<-gsub('\\W',' ',txt) # 특수 문자 제거
txt[864]
temp[864]
txt<-str_replace_all(txt,'\\W',' ')
table(temp==txt)
txt<-trim(txt)
length(txt)
head(txt)

##명사 추출
nouns<-extractNoun(txt)
nouns<gsub("^ㅋ"," ",nouns)
class(nouns)
length(nouns)
head(nouns)
length(unlist(nouns)) #추출된 명사 갯수:23877

table(c('하나','하나','셋'))
wordcount<-table(unlist(nouns))
class(wordcount)
length(wordcount) # 반복된 명사를 제외한 명사의 가지수 : 5129
sort(wordcount,decreasing=T)

library(dplyr)
df_word<-as.data.frame(wordcount,stringsAsFactors = F)
head(df_word)
df_word<-rename(df_word,word=Var1,freq=Freq)
head(df_word)
df_word
# 한글자 이상의 단어만 추출
df_word <- df_word %>% 
  filter(nchar(word)>1)

df_word <- filter(df_word, nchar(word)>1)
head(df_word)

# 자주 사용되는 단어 빈도표 top20 추출
top20<-df_word[order(df_word$freq,decreasing=T),][1:20,]
top20 <- df_word[order(-df_word$freq),][1:20,]
top20

# 자주 사용되는 단어 top20 그래프 그리기
library(ggplot2)
ggplot(top20,aes(x=reorder(word,freq),y=freq))+
  geom_col()+
  coord_flip()

ggplot(top20, aes(x=freq, y=reorder(word, freq))) +
  geom_col() +
  geom_text(aes(label=freq), col='red', nudge_x = 3.5)

library(wordcloud)
library(RColorBrewer)
display.brewer.all()
pal<-brewer.pal(9,"Set1")[1:9]# 워크 클라우드 쓸 파레트 변수 

set.seed(1234)
wordcloud(words = df_word$word, # 뿌려질 단어
          freq = df_word$freq,  # 단어 출현 빈도
          min.freq = 20,     # 최소 단어 빈도
          max.words = 200,  # 표현될 최대 단어 수
          random.order = F, # 최빈단어가 중앙 배치
          rot.per = 0.1,    # 회전 단어 비율
          scale = c(2,1.3),# 단어 크기 범위
          colors=pal)       # 단어 색상
