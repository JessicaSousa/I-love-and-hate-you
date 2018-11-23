library(dplyr) 
library(purrr)
library(stringr)
library(stringi)
library(magrittr)

clean_tweets <- function(df){
  df$stripped_text <- df$text %>%
                      tolower() %>% #Colocar as letras em minúsculas
                      str_replace_all("http\\S+\\s*", " ") %>% #Remover links
                      str_replace_all("\\b(.)\\1+"," ")%>% # Remover palavras formadas por apenas uma letra
                      str_replace_all("[^\x01-\x7F]", "") %>% #Remover emojis
                      stri_trans_general("Latin-ASCII") %>% #Remover acentuações
                      str_replace_all("\\B([@#][\\w_-]+)", " ") %>%  #Remover hashtags e menções
                      str_replace_all("[\r\n]", " ") %>% #Remover quebras de linhas
                      str_replace_all("[:punct:]"," ")%>% # Remover pontuações
                      str_replace("\\d+", " ") %>% # Remover digitos
                      str_replace_all("\\s+"," ") %>% #Remover excesso de espaços em brancos
                      str_trim() %>% #Remover espaço em branco do começo e fim
                      
  return(df)
}


###---- Pré-processamento básico------

tweets_1o_turno <- readRDS("tweets_1o_turno.rds")
tweets_2o_turno <- readRDS("tweets_2o_turno.rds")

tweets_1o_turno <- clean_tweets(tweets_1o_turno)
tweets_2o_turno <- clean_tweets(tweets_2o_turno)

saveRDS(tweets_1o_turno, 'clean_tweets_1o_turno.rds')
saveRDS(tweets_2o_turno, 'clean_tweets_2o_turno.rds')


##Preparar para extrair os textos para marcar:
#tweets_1o_turno %<>% mutate(tweet_id = row_number())
#tweets_2o_turno %<>% mutate(tweet_id = row_number())

##Remover tweets repetidos
#tweets_1o_turno %<>% distinct(stripped_text, .keep_all = TRUE)
#tweets_2o_turno %<>% distinct(stripped_text, .keep_all = TRUE)

##Extrair 500 tweets por candidate
#tweets_1o_turno %<>% group_by(candidate) %>%
#               slice(1:500)

##Extrair 1500 tweets por candidato
#tweets_2o_turno %<>% group_by(candidate) %>%
#                slice(1:1500)

#write.table(tweets_1o_turno$stripped_text,'text_1o_turno.txt', row.names = F, col.names = F)
#write.table(tweets_2o_turno$stripped_text,'text_2o_turno.txt', row.names = F, col.names = F)
