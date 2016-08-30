rm(list=ls(all=T))
library(dplyr)
#install.packages("caTools")
#install.packages("DMwR", dependencies = T, repos="http://cran.rstudio.com/")
#install.packages("C50", dependencies = T, repos="http://cran.rstudio.com/")
library(caTools)
library(DMwR)
library(C50)
library(e1071)
library(h2o)

setwd("D:\\Datasets\\Redhat")
dat <- read.csv("act_train.csv")
datp <- read.csv("people.csv")

head(dat)
nrow(dat)
str(dat)
summary(dat)
View(dat[1:10,])

head(datp)
nrow(datp)
str(datp)
summary(datp)
View(datp[1:10,])

colSums(is.na(datp))

datf <- merge(datp, dat, by.x = "people_id", by.y = "people_id")
View(datf[30:100,])
nrow(datf)
table(datf$outcome)
summary(datf)
datf$outcome <- as.factor(datf$outcome)
datf$date.x <- as.Date(datf$date.x)
datf$date.y <- as.Date(datf$date.y)
datf$datdiff=as.numeric(difftime(datf$date.y, datf$date.x, units = c("days")))

fin <- datf %>% select(-people_id, -activity_id, -group_1, -date.x, -date.y, -char_10.y)
f <- sample.split(fin, SplitRatio = 0.7)
ftrain <- fin[f==T,]
ftest <- fin[f==F,]

localh2o = h2o.init(ip='localhost', port = 54321, max_mem_size = '1g',nthreads = 1)

#Converting R object to an H2O Object
train.hex <- as.h2o(localh2o, object = ftrain, key = "train.hex")
test.hex <- as.h2o(localh2o, object = ftest, key = "test.hex")
