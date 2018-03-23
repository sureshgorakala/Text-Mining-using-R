Text-Classification---R
=======================

Classifying documents into categories

[Document Classification using R](http://www.dataperspective.info/2013/07/document-classification-using-r.htmlhttp://www.dataperspective.info/2013/07/document-classification-using-r.html)

The file "Topic Modelling" is based on the blog post [Topic Modeling in R](http://www.bigdatanews.datasciencecentral.com/profiles/blogs/topic-modeling-in-r).

BEfore running on Windows I had some setup to do:

* Install R from https://cran.r-project.org/bin/windows/base/
* Install RStudio from https://www.rstudio.com/products/rstudio/download/
* Create a Twitter App to collect the data at https://apps.twitter.com/app/new - more details [Twitter Analytics Using R Part 1: Extract Tweets](https://www.credera.com/blog/business-intelligence/twitter-analytics-using-r-part-1-extract-tweets/)

the values from the Twitter app need to go into these lines in "Topic Modelling":

```R
Consumer_key<- "YOUR_CONSUMER_KEY"
Consumer_secret <- "YOUR_CONSUMER_SECRET"
access_token <- "YOUR_ACCESS_TOKEN"
access_token_secret <- "YOUR_TOKEN_SECRET"
```

Then in the console make sure all the packages required are installed (this is in the script "prereqs.R"):

```R
install.packages('twitteR')
install.packages("tm")
install.packages("wordcloud")
install.packages("slam")
install.packages("topicmodels")
install.packages('base64enc')
```
Now you are ready to run "Topic Modelling" in RStudio! There are two lines near the head of the file that can be used to tweak the number and type of of results:

```R
numTweets <- 900

tweetData <- searchTwitter("flight", n=numTweets, lang="en")
```

numTweets is used in the twitter search and later in to set the SEED for the analysis algorithm.

tweetData holds the data that we want to analyse. Here I have done a simple search for the text "flight" in English. See [Getting Data via twitteR](https://sites.google.com/site/miningtwitter/basics/getting-data/by-twitter) for more ideas. Look in "topic-exploration.R" and "Sentiment.R" for more ways to look at the data downloaded in "Topic Modelling.R"
