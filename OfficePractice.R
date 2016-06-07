rm(list=ls(all=T))

dat <- mtcars

str(dat)
summary(dat)

sum(is.na(dat))

library(vegan)

d <- decostand(dat, "range")

dis <- dist(d, method = "euclidean") # distance matrix
dis
fit <- hclust(dis, method="ward")
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
groups
# draw dendogram with red borders around the 5 clusters
rect.hclust(fit, k=5, border="red")


fit <- kmeans(d, centers=5)
fit
fit$withinss
sum(fit$withinss)
fit$centers
fit$cluster
fit$size

k <- data.frame(Clusters=(2:15),WithinSS=0)
for (i in 2:15)
{
  kfit <- kmeans(d, centers=i)
  x <- sum(kfit$withinss)
  k[k$Clusters==i,2] <- x
}

library(ggplot2)
ggplot(k, aes(x=factor(Clusters), y=WithinSS)) + geom_bar(stat="identity", fill="lightblue", colour="black")


install.packages("kernlab")
library(kernlab)
