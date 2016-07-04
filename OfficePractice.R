rm(list=ls())

dat <- read.csv("E:\\INSOFE\\Project\\Job Recommendation\\Dataset\\TrainData.csv")

str(dat)
sum(is.na(dat))

library(dplyr)
# Get the count of no. of jobs rated by each user
ratingCount <- dat %>% group_by(ApplicantID) %>% summarise(NoOfRating = n())

par(mfrow=c(1,1))
# Bin the no. of jobs rated and plot it against no. of users
hist(ratingCount$NoOfRating, breaks =20, col="SkyBlue",
     xlab = "No. of Jobs Rated", ylab = "No. of USers",
     main="Distribution of Users with Number of Jobs Rated")

# Plot the Prob density of no. of jobs rated
d <- density(ratingCount$NoOfRating)
plot(d, main="Probability Density of Users with Number of Jobs Rated")
polygon(d, col="SkyBlue", border="black")

library(reshape2)
# Convert long format data to wide format to make a matrix with sers as rows and jobs as columns"
datmat <- dcast(dat, ApplicantID~JobID)
rownames(datmat) <- datmat[,1]

# Get no. of users who rated
nrow(datmat)

# Get no. of jobs that are rated
ncol(datmat)

library(Matrix)
M <- sparseMatrix(i=dat[,1], j=dat[,2], x=dat[,3])

library(irlba)
s <- irlba(M, nu=100, nv=100)

### similarity

# Creating function to calculate the cosine between two vectors
getCosine <- function(x,y) 
{
  cosine <- abs(sum(x*y) / (sqrt(sum(x*x)) * sqrt(sum(y*y))))
  return(cosine)
}

moreThan20 <- ratingCount %>% filter(NoOfRating>=20) %>% arrange(desc(NoOfRating)) %>% head(10)

head(M)


M[601,81]

library(irlba)
s <- irlba(M, nu=5, nv=5)

a <- as.vector(datmat[1,])

mat <- as.matrix(datmat)

mat2 <- mat
mat2[which(is.na(mat2))] <- 0

library(vegan)
mat2 <- decostand(mat2, method="range")
s <- svd(mat2)

#install.packages("irlba")
library(irlba)

dat[dat$ApplicantID==14616,]
nrow(dat)
ncol(datmat)
