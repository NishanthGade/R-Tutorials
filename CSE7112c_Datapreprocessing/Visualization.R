#Visualization
library(ggplot2)

#R comes with a set of pre-installed data sets in the form of data frames
attach(mtcars)
str(mtcars)
View(mtcars)

dt<-data.frame(row.names=c("Row1","Row2","Row3"),Names=c("abc","pqr","xyz"))

View(mtcars)
###Group bar charts
c <- ggplot(mtcars, aes(factor(cyl)))
c + geom_bar()
c+geom_bar(width=0.5)
c + geom_bar() +coord_flip()
#c + scale_fill_brewer()
c+geom_bar(fill="green", colour="darkgreen", width=0.5)

##Stacked bar plots
qplot(factor(cyl), data=mtcars, geom="bar", fill=factor(vs))
qplot(factor(cyl), data=mtcars, geom="bar", fill=factor(gear))

##Histograms in R
hist(mpg, breaks = c(10, 12, 14,18, 20, 22, 25, 28, 30,35 ), main ="distribution of mpg")
#using ggplot
m <- ggplot(mtcars, aes(x=mpg))
m + geom_histogram(bins=10,aes(fill=..count..)) ##adjusting the value of binwidth

m + geom_histogram(bins=10)

setwd("E:\\INSOFE\\R\\CSE7112c_Datapreprocessing")
data<-read.csv("GRade1.csv")
head(data)

data$dtEng<-ifelse(data$English1<40,"D",ifelse(data$English1<70,"B","A"))
head(data)

library(ggplot2)

p<-ggplot(data,aes(data$dtEng))
p+geom_bar()
p+geom_b