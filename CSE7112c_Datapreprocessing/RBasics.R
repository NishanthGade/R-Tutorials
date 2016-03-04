2+3
log(10)
log()
num<-1:15
num
num<-seq(1,10,2)
num<-c(1,2,9)

#Scalar is a single number or character
x<-5
x<-"abc"

#Vector - sequence of elements. Can only take same data type for all elements.
x<-c(1,3,7)
x<-c("a","b")

#When vector has combination of charatcter and numeric, it becomes a character vector
x<-c("abc",1,2)
x

#when number and boolean is given, it becomes a numeric
x<-c(1,3,T,F)
x

#when charactr and boolean is given, it becomes a character
x<-c("a",F)
x

help(c)

#class is fucmtion which gives the data type of the variable
class(x)

x<-c(1.32,"abc")
x

#Characters have to be explicetely be given with quotes
x<-c(1.32,abc)  #Gives error

#if there is already a variable, it takes variable by default
a<-5
x<-c(1.2,a)
x

#Characters can take single quotes as well
x<-c(1,'a')
x

#If arithmetic operators are applied, it takes corresponding positions
x<-c(1,3,5,7,9); y<-c(2,4,6,8,10)
x+y

#Gives error when arithmetic is given for character
a<-c("A"); b<-c("B")
a+b

#Gives warning if one is not a multiple of other
x<-c(1,2,3,4,5); y<-c(6,7,8)
x+y

#No warning
x<-c(1,2,3,4,5); y<-c(6,7)
x+y

#R is case sensitive

x<-c(1,3,5,7,9); y<-c(2,4,6,8,10)
#rbind is row bind. Makes the vectors as rows
#cbind is column bind. Makes vectors as columns
A<-rbind(x,y)
A

#If unequal number of elements, then repeat
x<-c(1,3,5,7,9); y<-c(2,4,6,"a")
b<-cbind(x,y)
b

#creates a matrix with 2 rows, 2 cols and fill by row
x<-matrix(c(1,2,3,4),nrow=2,ncol=2,byrow = T)
x
#rowSums gives sum of all rows
rowSums(x)
#rowSums gives sum of all columns
colSums(x)
#diag gives diagonal values starting from top left
sum(diag(x))
#Gives sum of all elements
sum(x)

x[1,1] #Extract 1st row and 1st column element
x[1,] #extract 1st row elements
x[,2] #extract 2nd column elements
x[2,1] #Extract 2nd row and 1st column element

#data frame is also a matrix representation but with different data types
#Have to specify all the values. If missing values, gives error. If missing, can specify NA
data<-data.frame(name=c("a","b","c"), marks=c(1,5,7), age=c(20,30,NA))
View(data)

d<-data.frame()
View(d)

#saves all the data and variables in the Environment to current working dir
save.image()

getwd()

#Clears variables and env
rm(list=ls())

#Gives list of all variables in the env
ls()

#Loads workspace env
load("C:/Users/ADMIN/Documents/.RData")

setwd("E:\\INSOFE\\R\\CSE7112c_Datapreprocessing")

#Saves only data variable into workspace
save(data,file="data.RData")

#Removes all the variables except one from the session
rm(list=setdiff(ls(),"x"))

load("data.RData")

#Export data to csv
write.csv(data,"data.csv",row.names = F) #row.names=F will removes the row numbers in the csv

#Read from csv
y<-read.csv("data.csv")
y

#.RDS compresses an variable/object. Is a good alternative to CSV files for storage
#.RDS can only be used for a single variable
#.RData does not compress variables
saveRDS(y,file="data.rds",compress = T)

#Read .RDS into a variable
d<-readRDS("data.rds")
d
