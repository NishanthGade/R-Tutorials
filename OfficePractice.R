# Clear the env
rm(list=ls())

# Set the current working dir
setwd("D:\\INSOFE\\Project\\Job recommendation engine")

# Read the job views file
jv <- read.csv("Job_Views.csv", header=T)

# Get the structure of the dataset
str(jv)

# View the first few rows
head(jv)


dat1 <- jv %>% select(Title, Position, Company, City, View.Duration) 
datCC <- dat1[complete.cases(dat1),]
sum(is.na(datCC))

par(mfrow=c(3,2))
boxplot(datCC$View.Duration, main="All obervations")
boxplot(datCC[datCC$View.Duration<5000,]$View.Duration, main="Duration < 5000")
boxplot(datCC[datCC$View.Duration<2000,]$View.Duration, main="Duration < 2000")
boxplot(datCC[datCC$View.Duration<1000,]$View.Duration, main="Duration < 1000")
boxplot(datCC[datCC$View.Duration<800,]$View.Duration, main="Duration < 800")
boxplot(datCC[datCC$View.Duration<500,]$View.Duration, main="Duration < 500")

dat2 <- dat1 %>% filter(zscore < 2)

boxplot(dat1$View.Duration)

mean(dat6$View.Duration)
median(dat2$View.Duration)
sd(dat2$View.Duration)

dat3 <- dat2 %>% select(-zscore) %>% mutate(zscore=(View.Duration-mean(View.Duration))/sd(View.Duration))
dat4 <- dat3 %>% filter(zscore < 2)

d <- density(dat4$zscore)
plot(d)

mean(dat4$View.Duration)
median(dat4$View.Duration)
sd(dat4$View.Duration)

dat5 <- dat4 %>% select(-zscore) %>% mutate(zscore=(View.Duration-mean(View.Duration))/sd(View.Duration))
dat6 <- dat5 %>% filter(zscore < 2)

d <- density(dat6$zscore)
plot(d)

mean(dat6$View.Duration)
median(dat6$View.Duration)
sd(dat6$View.Duration)

dat7 <- dat6 %>% filter(zscore < 0.5)
max(dat6$View.Duration)

nrow(dat1[dat1$zscore>2,])

d <- density(jv[!is.na(jv$View.Duration) & jv$View.Duration < 3600,]$View.Duration)
plot(d)

# Move only Applicant.ID, Job.ID, View.Start, View.End, View.Duration
library(dplyr)


library(DMwR)

# Consider only those views that do not have NA value and Duration < 3600 (1 hour)

dat2 <- knnImputation(dat1, k=7, scale=T)

dat3 <- cbind(dat1, NewDuration=dat2$View.Duration)
