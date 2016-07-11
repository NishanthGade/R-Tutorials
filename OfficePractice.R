rm(list=ls())

dat <- read.csv("E:\\INSOFE\\Project\\Job Recommendation\\Dataset\\TrainData.csv")

str(dat)
sum(is.na(dat))

# Get the count of no. of jobs rated by each user
library(dplyr)
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

# Convert long format data to wide format to make a matrix with sers as rows and jobs as columns"
library(reshape2)
datmat <- dcast(dat, ApplicantID~JobID)
rownames(datmat) <- datmat[,1]

# Get no. of users who rated
nrow(datmat)

# Get no. of jobs that are rated
ncol(datmat)

# library(Matrix)
# M <- sparseMatrix(i=dat[,1], j=dat[,2], x=dat[,3])
# 
# library(irlba)
# s <- irlba(M, nu=100, nv=100)

### similarity

# Creating function to calculate the cosine between two vectors
getCosine <- function(x,y) 
{
  cosine <- abs(sum(x*y) / (sqrt(sum(x*x)) * sqrt(sum(y*y))))
  return(cosine)
}

# Get the users who rated more than 20 jobs
moreThan20 <- ratingCount %>% filter(NoOfRating>=20) %>% arrange(desc(NoOfRating)) %>% head(10)

# library(irlba)
# s <- irlba(M, nu=5, nv=5)
# 
# a <- as.vector(datmat[1,])

# Convert dataframe to matrix form
mat <- as.matrix(datmat)

mat2 <- mat

# Replace missing values with 0s
mat2[which(is.na(mat2))] <- 0

# Run SVD on the user job rating matrix
s <- svd(mat2)

# Get the Eigen values of the SVD
e <- s$d

# Get the variance explained by each eigen value
e_sqare_energy = (e/sum(e))*100

# Get the cumulative sum of varainces for each eigen value
cumsum(e_sqare_energy)[1:500]

# Get the user space matrix with top n eigen vectors
user <- data.frame(s$u[,1:2])

# Find cosine similarity of all users
userCosineValues <- data.frame()
for (i in 1:nrow(user))
{
  for(j in 1:nrow(user))
  {
    userCosineValues[i,j] <- getCosine(user[i,], user[j,])
  }
}

rownames(userCosineValues) <- rownames(datmat)
names(userCosineValues) <- rownames(datmat)

View(userCosineValues[1:10, 1:10])

user42 <- datmat[1,]
user42T <- t(user42)
names(user42T) <- "42"
user42T[!is.na(user42T),]

user601 <- datmat[4,]
user601T <- t(user601)
names(user601T) <- "601"
user601T[!is.na(user601T),]
