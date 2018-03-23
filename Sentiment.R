#include required libraries
library(plyr)
library(stringr)
library(readr)
# download https://github.com/uwescience/datasci_course_materials/blob/master/assignment1/AFINN-111.txt
# and put in your working directory this contains the list of words for sentiment analysis later on

# This is a follow on from "Topic Modelling.R" and takes a different look at the data

#get the tweets
dataset <- read_csv("tweets.csv")
tweets_txt <- dataset$text


#function to clean data
cleanTweets = function(tweets)
{
  tweets_cl = gsub("(RT|via)((?:\\b\\W*@\\w+)+)","",tweets)
  tweets_cl = gsub("http[^[:blank:]]+", "", tweets_cl)
  tweets_cl = gsub("@\\w+", "", tweets_cl)
  tweets_cl = gsub("[ \t]{2,}", "", tweets_cl)
  tweets_cl = gsub("^\\s+|\\s+$", "", tweets_cl)
  tweets_cl = gsub("[[:punct:]]", " ", tweets_cl)
  tweets_cl = gsub("[^[:alnum:]]", " ", tweets_cl)
  tweets_cl <- gsub('\\d+', '', tweets_cl)
  return(tweets_cl)
}

#function to calculate number of words in each category within a sentence
sentimentScore <- function(sentences, vNegTerms, negTerms, posTerms, vPosTerms){
  final_scores <- matrix('', 0, 5)
  scores <- laply(sentences, function(sentence, vNegTerms, negTerms, posTerms, vPosTerms){
    initial_sentence <- sentence
    #remove unnecessary characters and split up by word
    sentence = cleanTweets(sentence)
    sentence <- tolower(sentence)
    wordList <- str_split(sentence, '\\s+')
    words <- unlist(wordList)
    #build vector with matches between sentence and each category
    vPosMatches <- match(words, vPosTerms)
    posMatches <- match(words, posTerms)
    vNegMatches <- match(words, vNegTerms)
    negMatches <- match(words, negTerms)
    #sum up number of words in each category
    vPosMatches <- sum(!is.na(vPosMatches))
    posMatches <- sum(!is.na(posMatches))
    vNegMatches <- sum(!is.na(vNegMatches))
    negMatches <- sum(!is.na(negMatches))
    score <- c(vNegMatches, negMatches, posMatches, vPosMatches)
    #add row to scores table
    newrow <- c(initial_sentence, score)
    final_scores <- rbind(final_scores, newrow)
    return(final_scores)
  }, vNegTerms, negTerms, posTerms, vPosTerms)
  return(scores)
}


#load pos,neg statements
afinn_list <- read.delim(file='AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
names(afinn_list) <- c('word', 'score')
afinn_list$word <- tolower(afinn_list$word) 

#categorize words as very negative to very positive and add some movie-specific words
vNegTerms <- afinn_list$word[afinn_list$score==-5 | afinn_list$score==-4]
negTerms <- afinn_list$word[afinn_list$score==-3 | afinn_list$score==-2 | afinn_list$score==-1]
posTerms <- afinn_list$word[afinn_list$score==3 | afinn_list$score==2 | afinn_list$score==1]
vPosTerms <- afinn_list$word[afinn_list$score==5 | afinn_list$score==4]    

#Calculate score on each tweet
tweetResult <- as.data.frame(sentimentScore(tweets_txt, vNegTerms, negTerms, posTerms, vPosTerms))
tweetResult$'2' = as.numeric(tweetResult$'2')
tweetResult$'3' = as.numeric(tweetResult$'3')
tweetResult$'4' = as.numeric(tweetResult$'4')
tweetResult$'5' = as.numeric(tweetResult$'5')
counts = c(sum(tweetResult$'2'),sum(tweetResult$'3'),sum(tweetResult$'4'),sum(tweetResult$'5'))
names = c("Worst","BAD","GOOD","VERY GOOD")
mr = list(counts,names)
colors = c("red", "yellow", "green", "violet")
barplot(mr[[1]], main="Simple Twitter Sentiment Analysis", xlab="Number of votes",legend=mr[[2]],col=colors)

