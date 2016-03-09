########################################################

rm(list=ls(all=TRUE))
setwd("E:\\INSOFE\\CSE7202c")
data<-read.csv("CustomerData.csv",header=T)
summary(data)

str(data)

data<-data[,-1]

data$City<-as.factor(data$City)

rows <- seq(1,nrow(data),1)
set.seed(24)
trainrows <- sample(rows, 0.7*nrow(data))
traindata <- data[trainrows,]
testdata <- data[-trainrows,]

lm1 <- lm(TotalRevenueGenerated~., data = traindata)
summary(lm1)
plot(lm1)

lm2 <- lm(TotalRevenueGenerated~ City+NoOfChildren+MinAgeOfChild+
            FrquncyOfPurchase+NoOfUnitsPurchased+FrequencyOFPlay
          +NoOfGamesPlayed+NoOfGamesBought+FavoriteGame+
            FavoriteChannelOfTransaction, data = traindata)
summary(lm2)


lm3 <- lm(TotalRevenueGenerated~ City+NoOfChildren+MinAgeOfChild+
            FrquncyOfPurchase+NoOfUnitsPurchased+FrequencyOFPlay
          +NoOfGamesPlayed+NoOfGamesBought+
            FavoriteChannelOfTransaction, data = traindata)
summary(lm3)

library(DMwR)
regr.eval(traindata$TotalRevenueGenerated, lm3$fitted.values)

pred <- predict(lm3, testdata)
regr.eval(testdata$TotalRevenueGenerated, pred)