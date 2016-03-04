setwd("E:\\INSOFE\\R\\CSE7112c_Datapreprocessing")

Grade1<-read.csv("Grade1.csv", header=T,)

#Gets the no of dimesnions
dim(Grade1)

#Gets the structure of object
str(Grade1)

#Gives summary of all variables of data frame
summary(Grade1)

#Convert variable to character
Grade1$Student.id<-as.character(Grade1$Student.id)

#Edit and store in another variable
grade1_missing<-edit(Grade1)

View(grade1_missing)

#Count the no of NAs
sum(is.na(grade1_missing))

#Count the no of NAs for specific column
sum(is.na(grade1_missing$Student.id))

summary(grade1_missing)

#Omit records with missing values
B<-grade1_missing[complete.cases(grade1_missing),]

#Omit records with missing values
C<-na.omit(grade1_missing)

#If missing values are few, use one of below
library(DMwR)

#Computes the mean and replace missing values
data3<-centralImputation(grade1_missing)
sum(is.na(data3))

#Computes the nearest neighbor and replace missing values.Can be used only for numerics.
data4<-knnImputation(grade1_missing[,2:5],scale=T,k=5)
sum(is.na(data4))

library(vegan)

#using range method
grade1range<-decostand(Grade1[2:5],"range")

#using range method
grade1std<-decostand(Grade1[2:5],"standardize")

#subset- 2 ways of doing
sub<-subset(Grade1,OverallPct1>60,select=Student.id:OverallPct1)
sub1<-Grade1[Grade1$OverallPct1>60,]

subset(Grade1,OverallPct1>60 & Math1>70,select=c("English1","Science1"))
Grade1[Grade1$English1<50 | Grade1$Math1 >60,c("OverallPct1")]

#Grade the students based on %
Grade1$class<-NA
i<-1
for(i in 1:nrow(Grade1))
{
  if(Grade1$OverallPct1[i]<40)
  {
    Grade1$class[i]<-"C"
  }
  else
  {
    if(Grade1$OverallPct1[i]<60)
    {
      Grade1$class<-"B"
    }
    else
    {
      Grade1$class<-"A"
    }
  }
}

#Above operation can also be performed by below
Grade1$Grade<-ifelse(Grade1$OverallPct1<40,"C",ifelse(Grade1$OverallPct1<60,"B","A"))

#Factors-Ordinal data. By default orders according to alphabetically
Grade1$Grade<-as.factor(Grade1$Grade)

#table gives count for each value
table(Grade1$Grade)
