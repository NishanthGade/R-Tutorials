from pyspark import SparkConf, SparkContext
conf = SparkConf().setAppName("First")
sc = SparkContext(conf=conf)

lang = sc.textFile("D:\Nishanth\Dataset\Job recommendation engine\Languages.csv")
cred = sc.textFile("D:\Nishanth\Dataset\Job recommendation engine\Credentials.csv")

lang.take(5)

l1f = lang.first()
c2f = cred.first()

l1 = lang.filter(lambda l : l != l1f and len(l.split(","))!=0 and l.split(",")[0]!="").map(lambda l: (int(l.split(",")[0]), l))
c2 = cred.filter(lambda l : l != l2f and len(l.split(","))!=0 and l.split(",")[0]!="").map(lambda l: (int(l.split(",")[0]), l))

final = l1.join(c2)
langCount = l1.map(lambda l: (l[1].split(",")[1], 1)).reduceByKey(lambda a,b: a+b).map(lambda (a,b): (b,a)).sortByKey(0).map(lambda (a,b): (b.replace('"',"")+","+str(a)))

l1.map(lambda l: (l[1].split(",")[1], 1)).countByKey()


samp = sc.textFile("D:\Nishanth\Dataset\Sample\samp.txt")
s = samp.cache()

# Total
samp1 = s.map(lambda l: (int(l.split("\t")[1]))).reduce(lambda a,b:a+b)
samp1

# Total
samp2 = s.map(lambda l: l.split("\t")).map(lambda l: (1,int(l[1]))).reduceByKey(lambda a,b: a+b).map(lambda l: l[1])
samp2.collect()

# Distict 
samp3 = s.map(lambda l: l[0]).distinct().count()
samp3

# Average
Avg = samp1/samp3
Avg

# Average per key
totalPerKey = s.map(lambda l: (l.split("\t")[0], int(l.split("\t")[1]))).reduceByKey(lambda a,b: a+b)
countPerKey = s.map(lambda l: (l.split("\t")[0],1)).reduceByKey(lambda a,b: a+b)
totalPerKey.collect()
countPerKey.collect()

for i in countPerKey.collect():
    print i
    
avgPerKey = totalPerKey.join(countPerKey).map(lambda l: (l[0], l[1][0]/l[1][1]))
avgPerKey.collect()

cpk = s.map(lambda l: (l.split("\t")[0], int(l.split("\t")[1]))).aggregateByKey(0, lambda acc,val:acc+1, lambda acc,val:acc+val)
tpk = s.map(lambda l: (l.split("\t")[0], int(l.split("\t")[1]))).aggregateByKey(0, lambda acc,val:acc+val, lambda acc,val:acc+val)
tpk.collect()
cpk.collect()

# in "w" does exact string matches. "w" in does wild card search
s.filter(lambda l: l.split("\t")[2] in "w").collect()
s.filter(lambda l: "w" in l.split("\t")[2]).collect()
    
s.filter(lambda l: "w" not in l.split("\t")[2]).collect()
    
gbk = s.map(lambda l: (l.split("\t")[0], int(l.split("\t")[1]))).groupByKey().map(lambda l: (l[0], sum(l[1])))
gbk.collect()
    
    
    
    
    
    
    
    
val dou = pi*2
println(s"Doubling of pi is ${f"$dou%.3f"}")
    
    
var f=0
var s=1
var n=0
var c=0
var str:String = f.toString()
while(c < 10)
 {
  str = str+", "+s
  n=f+s
  f=s
  s=n
  c+=1
 }
println(str)    
    

def userUpper(str: String): String = {
str.toUpperCase()
}
  
println(userUpper("hello"))
  
def testFunc(str: String, f: String => String): String = {
f(str)
}
  
println(testFunc("hello", userUpper))
  
println(testFunc("hello", str => str.toUpperCase()))    


val test = List(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)

for(a <- test)
{
  if(a%3 == 0)
    println(a)
}

val a = test.filter((x: Int) => x%3 == 0)
println(a)





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
