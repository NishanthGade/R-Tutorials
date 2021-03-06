rm(list=ls(all=TRUE))

dat<-read.csv("E:\\Nishanth\\Kaggle\\Datasets\\Titanic\\train.csv")

str(dat)

str(dat)
dat<-dat[,-c(1,4,9,11)]
dat$Survived<-as.factor(as.character(dat$Survived))
dat$Pclass<-as.factor(as.character(dat$Pclass))
dat$SibSp<-as.factor(as.character(dat$SibSp))
dat$Parch<-as.factor(as.character(dat$Parch))

sum(is.na(dat))

library(DMwR)
dat1 <- centralImputation(dat)

set.seed(24)
rows<-seq(1,nrow(dat1),1)
train<-sample(rows,nrow(dat1)*.7)
trainset<-dat1[train,]
testset<-dat1[-train,]

plot(trainset$Fare,trainset$Survived)
table(trainset$Embarked,trainset$Survived)

reg<-glm(Survived~.,family="binomial",data=trainset)

reg2<-glm(Survived~Pclass+Sex+Age+SibSp,family="binomial",data=trainset)

library(car)
vif(reg2)
summary(reg2)

trainset$pred<-predict(reg2,type="response")
table(trainset$Survived, trainset$pred>=0.6)


####################Ridge#################
datreg<-read.csv("E:\\Nishanth\\Kaggle\\Datasets\\Titanic\\train.csv")
datreg<-datreg[,-c(1,4,9,11)]
str(datreg)

library(DMwR)
datreg1 <- centralImputation(datreg)

set.seed(24)
rows<-seq(1,nrow(datreg1),1)
train<-sample(rows,nrow(datreg1)*.7)
trainset<-datreg1[train,]
testset<-datreg1[-train,]

library(glmnet)
str(trainset)

dummies <- model.matrix(trainset$Survived~trainset$Sex+trainset$Embarked)[,-1]
tr <- data.frame(trainset[,c(2,4,5,6,7)], dummies)
tr.mat <- as.matrix(tr)

cv <- cv.glmnet(tr.mat, trainset$Survived)
cv$lambda.min

ridge <- glmnet(tr.mat, trainset$Survived, lambda=cv$lambda.min, alpha=0)
coef(ridge)

trainset$PredRidge <- predict(ridge, tr.mat, type = "response")
table(trainset$Survived, trainset$PredRidge>=0.6)

lasso <- glmnet(tr.mat, trainset$Survived, lambda=cv$lambda.min, alpha=1)
coef(lasso)

trainset$PredLasso <- predict(lasso, tr.mat, type = "response")
table(trainset$Survived, trainset$PredLasso>=0.56)

elastic <- glmnet(tr.mat, trainset$Survived, lambda=cv$lambda.min, alpha=0.5)
coef(elastic)

trainset$PredElastic <- predict(elastic, tr.mat, type = "response")
table(trainset$Survived, trainset$PredElastic>=0.6)

########################Decision Trees###############
dat<-read.csv("D:\\Practice\\Titanic\\train.csv")
#install.packages("KRLS")
str(dat)
dat<-dat[,-c(1,9)]
dat$Survived<-as.factor(as.character(dat$Survived))
dat$Pclass<-as.factor(as.character(dat$Pclass))
dat$SibSp<-as.factor(as.character(dat$SibSp))
dat$Parch<-as.factor(as.character(dat$Parch))

sum(is.na(dat))

library(DMwR)
dat1 <- centralImputation(dat)

levels(dat1$Embarked)
table(dat1$Embarked)[1]

levels(dat1$Cabin)
table(dat1$Cabin)[1]

levels(dat1$Embarked)[1] = "missing"
levels(dat1$Cabin)[1] = "missing"

library(stringr)
cabin <- as.character(dat1$Cabin)
cabin1 <- ifelse(cabin != "missing", substr(cabin,1,1), "M")
cabin2 <- ifelse(cabin != "missing", as.numeric(substr(cabin,2,length(cabin))), 0)

name <- as.character(dat1$Name)
sum(name == "")
salulation <- substr(name, str_locate(name, ", ")+2, str_locate(name, ", ")+4)
salulation <- as.factor(salulation)

library(dplyr)
cabin1 <- as.factor(cabin1)
dat1<- dat1 %>% mutate(cabin1, cabin2, salulation)

dat1<- dat1 %>% select(-Name, -Cabin, -Sex)

#library(infotheo)
#dat1_Num_binned <- discretize(X=dat1[,c("Age","Fare")],disc="equalfreq", nbins=3)
#dat2 <- data.frame(dat1[,-c(4,7)], dat1_Num_binned)

set.seed(25)
rows<-seq(1,nrow(dat1),1)
train<-sample(rows,nrow(dat1)*.7)
trainset<-dat1[train,]
testset<-dat1[-train,]

library(C50)

DT_C50 <- C5.0(Survived~.,data=trainset,rules=T)
DT_C50
summary(DT_C50)
C5imp(DT_C50, pct=TRUE)

trainset$pred <- predict(DT_C50, newdata = trainset)
table(trainset$Survived, trainset$pred)

testset$pred <- predict(DT_C50, newdata = testset)
table(testset$Survived, testset$pred)

###################dplyr & ggplot2################
library(dplyr)
library(ggplot2)

dat<-read.csv("E:\\Nishanth\\Kaggle\\Datasets\\Titanic\\train.csv")

dat<-dat[,-c(1,4,9,11)]
str(dat)
head(dat)

dat <- dat[complete.cases(dat),]

table(dat$Sex, dat$Survived)

MaleSurvivors <- dat %>% filter(Survived == 1 & as.character(Sex) == "male")

total <- seq(1,nrow(dat),1)
samprows <- sample(total, 0.3*nrow(dat))
samp <- dat[samprows,]

ggplot(samp, aes(x=Fare,y=Age,col=factor(Survived),shape=Sex))+
  geom_point()
