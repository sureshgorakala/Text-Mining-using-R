library("twitteR")
library("tm")
library("wordcloud")
library("slam")
library("topicmodels")
library("readr")

Consumer_key<- ""
Consumer_secret <- ""
access_token <- ""
access_token_secret <- ""
setup_twitter_oauth(Consumer_key,Consumer_secret,access_token,access_token_secret)

numTweets <- 900

#get data set and save for later, e.g. to investigate anomalies 
tweetData <- searchTwitter("flight", n=numTweets, lang="en")
write.csv(twListToDF(tweetData), file="tweets.csv")

#Load Text
dataset <- read_csv("tweets.csv")
tweets <- dataset$text
#

#Clean Text
tweets = gsub("(RT|via)((?:\\b\\W*@\\w+)+)","",tweets)
tweets = gsub("http[^[:blank:]]+", "", tweets)
tweets = gsub("@\\w+", "", tweets)
tweets = gsub("[ \t]{2,}", "", tweets)
tweets = gsub("^\\s+|\\s+$", "", tweets)
tweets <- gsub('\\d+', '', tweets)
tweets = gsub("[[:punct:]]", " ", tweets)

corpus = Corpus(VectorSource(tweets))
corpus = tm_map(corpus,removePunctuation)
corpus = tm_map(corpus,stripWhitespace)
corpus = tm_map(corpus,tolower)
corpus = tm_map(corpus,removeWords,stopwords("english"))
#remove the Twitter related metadata
corpus = tm_map(corpus,removeWords, c("iphone","android","web", "tweetdeck", "ifttt"))
tdm = DocumentTermMatrix(corpus) # Creating a Term document Matrix

# create tf-idf matrix
term_tfidf <- tapply(tdm$v/row_sums(tdm)[tdm$i], tdm$j, mean) * log2(nDocs(tdm)/col_sums(tdm > 0))
summary(term_tfidf)
tdm <- tdm[,term_tfidf >= 0.1]
tdm <- tdm[row_sums(tdm) > 0,]

dtm <- as.DocumentTermMatrix(tdm)


lda <- LDA(dtm, k = 8) # find 8 topics
Terms <- terms(lda, 10) # first 4 terms of every topic
Terms
