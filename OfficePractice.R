rm(list=ls(all=T))
setwd("E:\\INSOFE\\CSE7306c\\Day 5\\20160529_Batch15_CSE7306_FullDayLab_Day06")

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

cor <- Corpus(DataframeSource(datnew))

