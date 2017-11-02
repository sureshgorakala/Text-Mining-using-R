#WIP with further exploration of data from "Topic Modelling"

#Visualisation 1 - Frequency of terms
library(ggplot2)
term.freq <- rowSums(as.matrix(tdm))
term.freq <- subset(term.freq, term.freq >=5)
df <- data.frame(term = names(term.freq), freq = term.freq)
ggplot(df, aes(x=term, y=freq)) + geom_bar(stat = "identity") + xlab("Terms") + ylab("Count") +coord_flip()

#Visualisation 2 - explore associsations of terms found
findAssocs(tdm, "delta", 0.25)
findAssocs(tdm, "JFK", 0.25)
findAssocs(tdm, "delay", 0.25)

#Visualisation 3 - Create a WorldCloud
library(wordcloud)
m <- as.matrix(tdm$dimnames$Terms)
# calculate the frequency of words and sort it by frequency
word.freq <- sort(rowSums(m), decreasing = T)
wordcloud(words = names(word.freq), freq = word.freq, min.freq = 3,
          random.order = F)
          
#Visualisation 4 - Cluster tree diagram
# remove sparse terms
tdm2 <- removeSparseTerms(tdm, sparse = 0.97)
m2 <- as.matrix(tdm2)
# cluster terms
distMatrix <- dist(scale(m2))
fit <- hclust(distMatrix, method = "ward.D")
plot(fit)
rect.hclust(fit, k = 6) # cut tree into 6 clusters 
