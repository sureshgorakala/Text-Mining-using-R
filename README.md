Text-Classification---R
=======================

Classifying documents into categories

[Document Classification using R](http://www.dataperspective.info/2013/07/document-classification-using-r.htmlhttp://www.dataperspective.info/2013/07/document-classification-using-r.html)

The file "Topic Modelling" is based on the blog post [Topic Modeling in R](http://www.bigdatanews.datasciencecentral.com/profiles/blogs/topic-modeling-in-r).

BEfore running on Windows I had some setup to do:

* Install R from https://cran.r-project.org/bin/windows/base/
* Install RStudio from https://www.rstudio.com/products/rstudio/download/
* Create a Twitter App to collect the data at https://apps.twitter.com/app/new - more details [Twitter Analytics Using R Part 1: Extract Tweets](https://www.credera.com/blog/business-intelligence/twitter-analytics-using-r-part-1-extract-tweets/)

Then in the console make sure all the packages required are installed (this is in the script "prereqs.R"):

```R
install.packages('twitteR')
install.packages("tm")
install.packages("wordcloud")
install.packages("slam")
install.packages("topicmodels")
install.packages('base64enc')
```
