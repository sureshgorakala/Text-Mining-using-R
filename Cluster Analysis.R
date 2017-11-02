data= read.csv("Cluster Analysis.csv")
APStats = data[which(data$STATE == 'ANDHRA PRADESH'),]
APMale = rowSums(APStats[,4:8])
APFemale = rowSums(APStats[,9:13])
APStats[,'APMale'] = APMale
APStats[,'APFemale'] = APFemale
data = APStats[c(2,3,14,15)]

library(cluster)
library(graphics)
library(ggplot2)

#factor the categorical fields
cause = as.numeric(factor(data$CAUSE))
data$CAUSE = cause

#Z-score for Year column
z = {}
m = mean(data$Year)
sd = sd(data$Year)
year = data$Year
for(i in 1:length(data$Year)){
z[i] = (year[i] - m)/sd
}
data$Year = as.numeric(z)

#Calculating K-means - Cluster assignment & cluster group steps
cost_df <- data.frame()

for(i in 1:100){
kmeans<- kmeans(x=data, centers=i, iter.max=100)
cost_df<- rbind(cost_df, cbind(i, kmeans$tot.withinss))
}
names(cost_df) <- c("cluster", "cost")

#Elbow method to identify the idle number of Cluster
#Cost plot
ggplot(data=cost_df, aes(x=cluster, y=cost, group=1)) +
theme_bw(base_family="Garamond") +
geom_line(colour = "darkgreen") +
theme(text = element_text(size=20)) +
ggtitle("Reduction In Cost For Values of 'k'\n") +
xlab("\nClusters") +
ylab("Within-Cluster Sum of Squares\n")

clust = kmeans(data,5)
clusplot(data, clust$cluster, color=TRUE, shade=TRUE,labels=13, lines=0)
data[,'cluster'] = clust$cluster
head(data[which(data$cluster == 5),])
