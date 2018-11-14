library(dplyr) 
library(purrr)
library(stringr)
library(stringi)

clean_tweets <- function(df){
  #Preprocessing
  url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  # Get rid of URLs
  df$clean_tweet <- str_replace_all(df$text,url_pattern, " ")
  # Take out retweet header, there is only one
  df$clean_tweet <- str_replace(df$clean_tweet,"(RT|via)((?:\\b\\W*@\\w+)+)"," ")
  # Get rid of hashtags
  df$clean_tweet <- str_replace_all(df$clean_tweet,"#\\S+"," ")
  # Get rid of references to other screennames
  df$clean_tweet <- str_replace_all(df$clean_tweet,"@\\S+"," ") 
  #remover emojis
  df$clean_tweet <- str_replace_all(df$clean_tweet,"\\p{So}|\\p{Cn}", " ")
  #remover simbolos de comparação > <
  df$clean_tweet <- str_replace_all(df$clean_tweet,"&\\S+", " ")
  #remover quebra de linhas
  df$clean_tweet = str_replace_all(df$clean_tweet, "[\r\n]" , " ")
  #remover acentuação e caracteres estranhos
  df$clean_tweet <- stri_trans_general(df$clean_tweet, "Latin-ASCII")
  df$clean_tweet <- iconv(df$clean_tweet, "latin1", "ASCII", sub="")
  #get rid of unnecessary spaces
  df$clean_tweet <- str_replace_all(df$clean_tweet,"\\s+"," ")
  df$clean_tweet <- str_replace_all(df$clean_tweet, "^\\s+|\\s+$", "")
  #minusculas
  df$clean_tweet <- tolower(df$clean_tweet)
  df
}


###---- Pré-processamento básico------

tweets_1o_turno <- readRDS("~/SentimentAnalysis/tweets_1o_turno.rds")
tweets_2o_turno <- readRDS("~/SentimentAnalysis/tweets_2o_turno.rds")

tweets_1o_turno <- clean_tweets(tweets_1o_turno)
tweets_2o_turno <- clean_tweets(tweets_2o_turno)

#Remover tweets repetidos
tweets_1o_turno <- tweets_1o_turno %>% distinct(clean_tweet, .keep_all = TRUE)
tweets_2o_turno <- tweets_2o_turno %>% distinct(clean_tweet, .keep_all = TRUE)


saveRDS(tweets_1o_turno, 'clean_tweets_1o_turno.rds')
saveRDS(tweets_2o_turno, 'clean_tweets_2o_turno.rds')