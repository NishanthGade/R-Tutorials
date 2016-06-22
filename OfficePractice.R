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

# Move only Applicant.ID, Job.ID, View.Start, View.End, View.Duration
library(dplyr)
dat1 <- jv %>% filter(Dur) %>% select(Applicant.ID, Job.ID, View.Start, View.End, View.Duration)

starttime <- as.POSIXlt(dat1$View.Start)
startsec <- starttime$hour*3600 + starttime$min*60 + starttime$s

endtime <- as.POSIXlt(dat1$View.End)
endsec <- endtime$hour*3600 + endtime$min*60 + endtime$s

dat1 <- dat1 %>% mutate(abs(starttime$hour-endtime$hour)*3600)
summary(startdate)
