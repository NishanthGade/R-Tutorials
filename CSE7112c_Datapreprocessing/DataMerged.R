getwd()
setwd("E:\\INSOFE\\R\\CSE7112c_Datapreprocessing")

dataMerged<-read.csv("dataMerged.csv")

#Understanding data
str(dataMerged)
head(dataMerged) #1st 6 records
tail(dataMerged) #last 6 records
edit(dataMerged)
names(dataMerged) #column names
summary(dataMerged)

#Missing values handling

sum(is.na(dataMerged)) #to check null values

#Drop records with missing values
data2<-na.omit(dataMerged)
rm(data2)

#To identify rows where more than 20% attributes are null
library(DMwR)
length(manyNAs(dataMerged,0.2))
dataMerged[74,]

#Convert applicable columns to factors

#View(dataMerged)
data3<-dataMerged
data5<-subset(dataMerged,select=c("family","edu","securities","cd","online","cc"))

data3$family<-as.factor(data3$family)
data3$edu<-as.factor(data3$edu)
data3$securities<-as.factor(data3$securities)
data3$cd<-as.factor(data3$cd)
data3$online<-as.factor(data3$online)
data3$cc<-as.factor(data3$cc)

summary(data3)

data4<-data.frame(apply(data5,2,as.factor)) #apply is used to apply a function to either rows or columns. 1 for rows, 2 for columns
str(data4)

dat<-cbind(dataMerged[,1:3],data4)
dat<-data.frame(subset(dataMerged,select=-c(family,edu,securities,cd,online,cc)),data4)
dat<-merge()

#Central Imputation
str(dat)
datCI<-centralImputation(dat)
sum(is.na(datCI))

#lapply & #tapply
la<-data.frame(lapply(datCI[,c("age","inc","exp")],mean))
ta<-data.frame(meandat=tapply(datCI$inc,datCI$family,mean))

#knnImputation
dataKI<-knnImputation(dat,scale = T,k=5)
sum(is.na(data))

library(infotheo)
#binning - using frequency or width
Freq<-discretize(datCI$age,disc="equalfreq",nbins=4)

tapply(datCI$age, Freq, max)

dataFreq<-data.frame()
dataFreq<-cbind(datCI,ageFreq=Freq$X)

#binning or discretize to convert continuos variables to discrete
Width<-discretize(datCI$age,disc="equalwidth",nbins=4)

#tapply - See how a variable compares with a categorical factor
tapply(datCI$age, Width, max)

dataWidth<-data.frame()
dataWidth<-cbind(datCI,ageWidth=Width$X)

#decostand - To get the values into the sme standardized form. Should only be numeric attributes
library(vegan)
dataStd.<-decostand(dataMerged[,1:6],"standardize")

#Dummy variables to make new columns with distinct values of a variable
library(dummies)
dummyFamily<-dummy(dataMerged$family)
dummyData<-cbind(dataMerged,dummyFamily)
head(dummyData)
