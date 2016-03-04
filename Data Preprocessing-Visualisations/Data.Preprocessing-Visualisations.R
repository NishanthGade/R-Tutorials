rm(list=ls(all=TRUE))
setwd("D:\\Archana\\INSOFE LAB CClasses\\7-FEB")

################################Data Exploration and Data Aggregation Methods#######################
##These form an important aspect especially for data exploration, data understanding and to processing
## the data for model building

library(plyr)
attach(baseball)
data<-baseball
str(data) ##outputs what to which type each variable belong to.
summary(data) ## gives the overall summary of the data

##Conversion of variable types if necessary
##We can consider "teams" as a factor ao that we can compare runs batted and home runs for teams
data$team<-as.factor(data$team)
str(data$team)


##Missing Values
##To count the number of missing values
sum(is.na(data)) 
#option1. Omit all records with NA values
data1<-na.omit(data)  

##several aggegation functions 
##Using tapply, aggragate function and ddply
##tapply function is very flexible function for summerizing a vector x.

tapply(data$rbi,data$team,FUN=mean,na.rm=T)

#aggregate(x,by,FUN,...)
aggregate(data$rbi,by=list(data$team),FUN=sum,na.rm=T)

##ddply
ddply(data,.(team),summarize, runs=sum(rbi,na.rm=T))

bdata <- data

detach(data)

##Please use R resources for exploring the above functions


#######Creating dummy variables and adding to original table#############

datamerged <- read.csv(file="dataMerged.csv",header=TRUE, sep=",")

str(datamerged)
head(datamerged)
summary(datamerged)

datamerged<-na.omit(datamerged)

datamerged$family <- as.factor(datamerged$family)
datamerged$edu <- as.factor(datamerged$edu)
datamerged$cc <- as.factor(datamerged$cc)
datamerged$cd <- as.factor(datamerged$cd)
datamerged$securities <- as.factor(datamerged$securities)
datamerged$online <- as.factor(datamerged$online)
datamerged$loan <- as.factor(datamerged$loan)


library(dummies)
EduDummyVars<-dummy(datamerged$edu)
head(EduDummyVars)
datamerged<-data.frame(datamerged,EduDummyVars)
head(datamerged)



#####################################Reshape############################

##Load in the CustTransDat.csv and Grade1.csv
Cust<-read.csv("CustTransDat.csv",header=T,sep=",")
Grade1<-read.csv("Grade1.csv",header=T,sep=",")

##Sometimes it may be useful to change the data the way it looks. Forexample we have  
## a transaction data of customers for a store. We would like to know the revenue generated 
##by year and by quarter. Then reshaphing would give a good representation

library(reshape2)
data2<-dcast(Cust,Quarter~Year,fun.aggregate = sum,value.var="Cost")


##Another Example
meltdata<-melt(data=Grade1,id="Student.id")
head(meltdata)

#aggregating the data based on subject and gender. This is also called the wide format.
data3<-dcast(data=meltdata,Student.id~variable,value="value") 
data4<-dcast(data=meltdata,variable~Student.id,value="value",fill=0) #Observe the difference in data2 and data3

###Resources for Reshape- http://seananderson.ca/2013/10/19/reshape.html

##########Randomly split  the data into two##############################
data <- datamerged
rows<-seq(1,nrow(data),1)
set.seed(1234)
trainrows<-sample(rows,0.7*nrow(data))
Train<-data[trainrows,]
Test<-data[-trainrows,]
##By using a package caTools
require(caTools)
set.seed(123) 
sample = sample.split(data$family, SplitRatio = .75)
train = subset(data, sample == TRUE)
test = subset(data, sample == FALSE)



######################Regular expression##############################
symbols =read.csv("Symbols.csv", header =T)
names(symbols)
summary(symbols)
str(symbols)
symbols$salespct=gsub("[%]","",symbols$salespct)
symbols$salespct =as.numeric(symbols$salespct)

A<-bdata[grep("gerhajo01",bdata$id),]  ## gives out the indices where it is there
A<-bdata[grepl("gerhajo01",bdata$id),] ##gives logical output if it is there or not



####################################Visualizations#################################################

data <- datamerged
attach(data)
names(data)

#Histogram
hist(inc, col="green", xlab="Income",main="Histogram of Income")

par(mfrow=c(1,2))
hist(age, col="green", xlab="Age",main="Histogram of Age")
hist(exp, col="blue", xlab="Experience",main="Histogram of Experience")

#BoxPlot
par(mfrow=c(1,2))
boxplot(inc, main="Income distribution")
abline(h = mean(inc), lty=2)

boxplot(inc~edu, main="Variation of income as a function of education", 
        xlab="Education", ylab="Income")
abline(h = mean(inc))

#BarPlot
par(mfrow=c(1,1))
barplot(table(data$loan), 
        main="Number oc customer in each class",)

detach(data)


#######Visualisations using ggplot###

library(ggplot2)
attach(mtcars)
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


##Histograms 
hist(mpg, breaks = c(10, 12, 14,18, 20, 22, 25, 28, 30,35 ), main ="distribution of mpg")
#using ggplot
m <- ggplot(mtcars, aes(x=mpg))
m + geom_histogram(bins=10,aes(fill=..count..)) ##adjusting the value of binwidth

m + geom_histogram(bins=10) 


###Boxplots
p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_boxplot()
p + geom_boxplot() + geom_jitter()
p + geom_boxplot(outlier.colour = "green", outlier.size = 3) + geom_jitter()
p + geom_boxplot(aes(fill=cyl))
p + geom_boxplot(aes(fill=factor(cyl), stats="identity"))


###Scatterplot in R
plot(mtcars$mpg,mtcars$disp)
##Task- label the axes, give the title  and plot with lines
install.packages("car")
library(car)
scatterplotMatrix(~mpg+disp+drat+wt|cyl, data=mtcars, main="Three Cylinder Options")


#connect points with line, #add regression line
p1 <- ggplot(mtcars, aes(x = hp, y = mpg))
p1 + geom_point(color="blue") + geom_line()                           
p1 + geom_point(color="red") + geom_smooth(method = "lm", se = TRUE)  
