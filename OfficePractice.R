rm(list=ls(all=T))
setwd("D:\\INSOFE\\Text Mining\\Lab day\\20160528_Batch15_CSE7306_FullDayLab_Day06")

dat <- read.csv("INSOFE_Data_New.csv", header=T)
head(dat,1)
str(dat)

dat1 <- subset(dat, select=c("SUMMARY","DATA","categories"))
dat1$SUMMARY <- as.character(dat1$SUMMARY)
dat1$DATA <- as.character(dat1$DATA)

ex <- dat1[1,2]
ex

table(dat1$categories)
dat1$categories <- as.character(dat1$categories)

library(stringr)
dat1$categories <- sub("asK_A_DOCTOR", "ASK_A_DOCTOR", dat1$categories)
dat1$categories <- sub("JUNK", "MISCELLANEOUS", dat1$categories)
dat1$categories <- sub("mISCELLANEOUS", "MISCELLANEOUS", dat1$categories)


a <- gsub("(\\{\\\\{1}).*(;\\}{1})", "", ex)
a <- gsub("(\\\\{1})([^ ]*)", "", a)
a <- sub("}", "", a)
a

dat1$DATA1 <- gsub("(\\{\\\\{1}).*(;\\}{1})", "", dat1$DATA)
dat1$DATA1 <- gsub("(\\\\{1})([^ ]*)", "", dat1$DATA1)
dat1$DATA1 <- gsub("Arial;\\}\\}\\}", "", dat1$DATA1)
dat1$DATA1 <- sub("}", "", dat1$DATA1)

dat1$NewText <- paste(dat1$SUMMARY, dat1$DATA1, sep = "", collapse = NULL, ignore_null = FALSE)

library(dplyr)
datnew <- dat1 %>% select(NewText)

library(tm)
cor <- Corpus(DataframeSource(datnew))

corAPPOINTMENTS <- Corpus(DataframeSource(subset(dat1, categories == "APPOINTMENTS", select = ("NewText"))))
corASK_A_DOCTOR <- Corpus(DataframeSource(subset(dat1, categories == "ASK_A_DOCTOR", select = ("NewText"))))
corLAB <- Corpus(DataframeSource(subset(dat1, categories == "LAB", select = ("NewText"))))
corMISCELLANEOUS <- Corpus(DataframeSource(subset(dat1, categories == "MISCELLANEOUS", select = ("NewText"))))
corPRESCRIPTION <- Corpus(DataframeSource(subset(dat1, categories == "PRESCRIPTION", select = ("NewText"))))

##### Pre-proessing on individual classes ########
library(lsa)
strsplit_space_tokenizer <- function(x)
  unlist(strsplit(as.character(x), "[[:space:]]+"))

corAPPOINTMENTS <- tm_map(corAPPOINTMENTS, content_transformer(tolower)) 
corAPPOINTMENTS <- tm_map(corAPPOINTMENTS, removePunctuation) 
corAPPOINTMENTS <- tm_map(corAPPOINTMENTS, removeNumbers) 
corAPPOINTMENTS <- tm_map(corAPPOINTMENTS, removeWords, stopwords("english")) 
corAPPOINTMENTS <- tm_map(corAPPOINTMENTS, stripWhitespace)
corAPPOINTMENTS <- tm_map(corAPPOINTMENTS, stemDocument, language ="english")

dtmAPPOINTMENTS <- DocumentTermMatrix(corAPPOINTMENTS)
smalldtmAPPOINTMENTS <- removeSparseTerms(dtmAPPOINTMENTS,sparse= 0.9)
dtm_final_APPOINTMENTS <- as.data.frame(as.matrix(smalldtmAPPOINTMENTS))

dAppt <- data.frame(TF = apply(dtm_final_APPOINTMENTS, 2, sum))
dAppt$Term <- row.names(dAppt)
dAppt <- dAppt %>% arrange(desc(TF))
########################################


###Data Preprocessing###
#Changing the character case
cor <- tm_map(cor, content_transformer(tolower)) 

# remove punctuation 
cor <- tm_map(cor, removePunctuation) 

# remove numbers 
cor <- tm_map(cor, removeNumbers) 

# remove stopwords 
cor <- tm_map(cor, removeWords, stopwords("english")) 

# remove white space
cor <- tm_map(cor, stripWhitespace) 

# Stem words in a text document using Porter's stemming algorithm
cor <- tm_map(cor, stemDocument, language ="english")


###Constructing DocumentTermMatrix###

# Document Term Matrix using Binary Values and Unigram 
dtm <- DocumentTermMatrix(cor)

#Remove Sparse Elements
smalldtm <- removeSparseTerms(dtm,sparse= 0.9)

dtm_final <- as.data.frame(as.matrix(smalldtm))

dtm_final <- cbind(dtm_final, categories=dat1$categories)

##Stratified Sampling 
library(caTools)
set.seed(1258)
trainrows = sample.split(dtm_final$categories, SplitRatio=0.7)
Train = subset(dtm_final, trainrows == TRUE)
Test = subset(dtm_final, trainrows == FALSE)

TrainPredictor <- Train %>% select(-categories)
TrainOutcome <- Train %>% select(categories)

TestPredictor <- Test %>% select(-categories)
TestOutcome <- Test %>% select(categories)

##C5.0 Decision Trees##
library(C50)
mod_C50 = C5.0(x=Train[,-84], y=Train[,84], rules=TRUE)
d <- table(Test$categories,predict(mod_C50,newdata=Test,type="class"))
d_tr <- table(Train$categories,predict(mod_C50,newdata=Train,type="class"))
##End of C5.0##

mod_C50
summary(mod_C50)

### Model Accuracy of Train and Test ###
Acc_test<-sum(diag(d))/sum(d)
Acc_train<-sum(diag(d_tr))/sum(d_tr)

print (Acc_test)
print (Acc_train)

write.csv(d,"recall-test-randomforest.csv")
write.csv(d_tr,"recall-train-randomforest.csv")


############## Top Keywords for each class ###################
table(dat1$categories)
dtmAPPOINTMENTS <- dtm_final %>% filter(categories=="APPOINTMENTS") %>% select(-categories)
dAppt <- data.frame(TF = apply(dtmAPPOINTMENTS, 2, sum))
dAppt$Term <- row.names(dAppt)
dAppt <- dAppt %>% arrange(desc(TF)) %>% head(20)

dtmASK_A_DOCTOR <- dtm_final %>% filter(categories=="ASK_A_DOCTOR") %>% select(-categories)
dAAD <- data.frame(TF = apply(dtmASK_A_DOCTOR, 2, sum))
dAAD$Term <- row.names(dAAD)
dAAD <- dAAD %>% arrange(desc(TF)) %>% head(20)

dtmLAB <- dtm_final %>% filter(categories=="LAB") %>% select(-categories)
dLAB <- data.frame(TF = apply(dtmLAB, 2, sum))
dLAB$Term <- row.names(dLAB)
dLAB <- dLAB %>% arrange(desc(TF)) %>% head(20)

dtmMISCELLANEOUS <- dtm_final %>% filter(categories=="MISCELLANEOUS") %>% select(-categories)
dMISCELLANEOUS <- data.frame(TF = apply(dtmMISCELLANEOUS, 2, sum))
dMISCELLANEOUS$Term <- row.names(dMISCELLANEOUS)
dMISCELLANEOUS <- dMISCELLANEOUS %>% arrange(desc(TF)) %>% head(20)

dtmPRESCRIPTION <- dtm_final %>% filter(categories=="PRESCRIPTION") %>% select(-categories)
dPRESCRIPTION <- data.frame(TF = apply(dtmPRESCRIPTION, 2, sum))
dPRESCRIPTION$Term <- row.names(dPRESCRIPTION)
dPRESCRIPTION <- dPRESCRIPTION %>% arrange(desc(TF)) %>% head(20)
