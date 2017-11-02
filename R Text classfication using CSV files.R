
library(tm)
library(plyr)
library(class)
libs=c("tm","plyr","class")
lapply(libs,require,character.only = T)
options(stringsAsFactors= F)
cat = c("Oneliner.csv","Sickness.csv","Complaint.csv","ATC.csv","Availabilty.csv","Oneliner.csv")
pathname = "C:/Users/s769346/Desktop/New folder"
 cleanCorpus <-function(corpus) {
corpus.tmp = tm_map(corpus,removePunctuation)
corpus.tmp = tm_map(corpus.tmp,stripWhitespace)
corpus.tmp = tm_map(corpus.tmp,tolower)
corpus.tmp = tm_map(corpus.tmp,removeWords,stopwords("english"))
corpus.tmp = tm_map(corpus.tmp,stemDocument)
return(corpus.tmp)
}
 generateTDM <- function(cate,path) {
s.path =  sprintf("%s/%s",path,cate)
csv = read.csv(s.path)
s.cor = Corpus(DataframeSource(csv))
s.cor.cl = cleanCorpus(s.cor)
s.tdm= TermDocumentMatrix(s.cor.cl)
s.tdm = removeSparseTerms(s.tdm,0.7)
result <-list(name= cate,tdm = s.tdm)
}
tdm = lapply(cat,generateTDM,path = pathname)

# attach name
bindCategoryTDM <- function(tdm) {
s.mat = t(data.matrix(tdm[["tdm"]]))
s.df = as.data.frame(s.mat,stringsAsFactors = F)
s.df = cbind(s.df,rep(tdm[["name"]],nrow(s.df)))
colnames(s.df)[ncol(s.df)] <- "targetCat"
return(s.df)

}

catTDM = lapply(tdm,bindCategoryTDM)

#Stack 
tdm.stack = do.call(rbind.fill,catTDM)
tdm.stack[is.na(tdm.stack)] = 0

#holdout
train.idx <- sample(nrow(tdm.stack),ceiling(nrow(tdm.stack) * 0.7))
text.idx = (1:nrow(tdm.stack))[-train.idx]


#model
tdm.cat = tdm.stack[,"targetCat"]
tdm.stack.nl = tdm.stack[,!colnames(tdm.stack) %in% "targetCat"]
knn.pred = knn(tdm.stack.nl[train.idx,],tdm.stack.nl[text.idx,],tdm.cat[train.idx])


#accuracy
conf.mat = table("predictions" = knn.pred,Actual = tdm.cat[text.idx])
accuracy = sum(diag(conf.mat)/length(text.idx) *100)
accuracy
conf.mat 


---------------------------------------------------------------------
inspect(stem) - display the content in the Corpus
 corpus <- Corpus(DataframeSource(csvpath)) - read all the documents in csv
 findFreqTerms(tdm, 300) - frequency of terms
 
 
