rm(list=ls(all=TRUE))
setwd("E:\\INSOFE\\CSE7202c")

bm <- read.csv("Data.csv", header = T)
str(bm)
summary(bm)

bm <- bm[,-1]

plot(bm$BigMacPrice, bm$NetHourlyWage)

rowlist <- seq(1,nrow(bm),1)
set.seed(24)
samplerows <- sample(rowlist, .7*nrow(bm))
trainbm <- bm[samplerows,]
testbm <- bm[-samplerows,]

library(DMwR)

lm1 <- lm(NetHourlyWage~BigMacPrice, data=trainbm)
summary(lm1)
regr.eval(trainbm$NetHourlyWage,lm1$fitted.values)
plot(lm1)

lm2 <- lm(NetHourlyWage~0+BigMacPrice, data=trainbm)
summary(lm2)
regr.eval(trainbm$NetHourlyWage,lm2$fitted.values)
plot(lm2)

plot(trainbm$BigMacPrice,trainbm$NetHourlyWage,
     xlab = "Big Mac Price", ylab =  "Net Hourly Wage",
     main = "Regression Line")
abline(lm2,col="Red",lwd=2)

plot(trainbm$BigMacPrice,lm2$residuals,
     xlab="Big Mac Price", ylab="Residuals",
     main="Residual Analysis")
abline(0,0,col="red")

##########Remove rows 3 and 23##########
View(bm)
bm1<-bm[c(-3,-23),]

plot(bm1$BigMacPrice, bm1$NetHourlyWage)

rowlist <- seq(1,nrow(bm1),1)
set.seed(24)
samplerows <- sample(rowlist, .7*nrow(bm1))
trainbm <- bm1[samplerows,]
testbm <- bm1[-samplerows,]

library(DMwR)

lm1 <- lm(NetHourlyWage~BigMacPrice, data=trainbm)
summary(lm1)
regr.eval(trainbm$NetHourlyWage,lm1$fitted.values)
plot(lm1)

lm2 <- lm(NetHourlyWage~0+BigMacPrice, data=trainbm)
summary(lm2)
regr.eval(trainbm$NetHourlyWage,lm2$fitted.values)
plot(lm2)

plot(trainbm$BigMacPrice,trainbm$NetHourlyWage,
     xlab = "Big Mac Price", ylab =  "Net Hourly Wage",
     main = "Regression Line")
abline(lm2,col="Red",lwd=2)

plot(trainbm$BigMacPrice,lm2$residuals,
     xlab="Big Mac Price", ylab="Residuals",
     main="Residual Analysis")
abline(0,0,col="red")

###########Changing data#########3
#lmchange<-lm(NetHourlyWage~sqrt(BigMacPrice),data=trainbm)
#plot(lmchr

trainbm<-trainbm[-23,]

plot(sqrt(bm$BigMacPrice),sqrt(bm$NetHourlyWage))
lmchange<-lm(sqrt(NetHourlyWage)~0+sqrt(BigMacPrice),data=trainbm)
plot(lmchange)

bm <- data.frame(NetHourlyWage=sqrt(bm$NetHourlyWage),BigMacPrice=sqrt(bm$BigMacPrice))

pred<-predict(lmchange,bm)

