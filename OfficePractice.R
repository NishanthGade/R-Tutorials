rm(list=ls())

dat <- read.csv("D:\\INSOFE\\Job recommendation engine\\TrainData.csv")

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

mat2 <- mat[,-1]

# Replace missing values with 0s
mat2[which(is.na(mat2))] <- 0

# Run SVD on the user job rating matrix
s <- svd(mat2)

# Get the Eigen values of the SVD
e <- s$d

# Get the variance explained by each eigen value
e_sqare_energy = (e/sum(e))*100

# Get the cumulative sum of varainces for each eigen value
cumsum(e_sqare_energy)[1:2021]

# Get the user space matrix with top n eigen vectors
user <- data.frame(s$u[,1:2021])
rownames(user) <- rownames(datmat)

# Get the job space matrix with top n eigen vectors
jobmat <- data.frame(s$v[,1:2021])
rownames(jobmat) <- names(datmat[,-1])

# Find cosine similarity of all users
for (i in 1:nrow(user))
{
  for(j in 1:nrow(user))
  {
    userCosineValues[i,j] <- getCosine(user[i,], user[j,])
  }
}

userCosineValues <- c()
getCosineSimilarityOfUsers <- function(Applicant,ratedUsers) 
{
  userCosineValues <- c()
  for(i in 1:nrow(ratedUsers))
  {
    if(ratedUsers$ApplicantID[i] != Applicant)
    {
      userCosineValues[i] <- getCosine(user[rownames(user)==Applicant,], user[rownames(user)==ratedUsers$ApplicantID[i],])     
    }

  }
  return(userCosineValues)
}

# getCosineSimilarityOfJobs <- function(Job,ratedJobs) 
# {
#   userCosineValues <- c()
#   for(i in 1:nrow(ratedJobs))
#   {
#     if(rownames(ratedJobs[i,]) != Job)
#     {
#       userCosineValues[i] <- getCosine(jobmat[rownames(jobmat)==Job,], jobmat[rownames(jobmat)==rownames(ratedJobs[i,]),])     
#     }
#     
#   }
#   return(userCosineValues)
# }

# Function to get average rating for a job
# getAverageRating <- function(job)
# {
#   # Find 10 most similar jobs
#   similarJobs <- getCosineSimilarityOfJobs(job, jobmat[rownames(jobmat)!=job, ])
#   return(similarJobs)
# }

# Get the master data frame with User, Job, Rating and no NAs
master <- datmat %>% melt(id=c("ApplicantID"), na.rm = T)
names(master) <- c("ApplicantID", "JobID", "Rating")

# Function to predict user rating
predictRating <- function(Applicant, Job)
{
  # Get all the users that gave rating for this job
  ratedUsers <- master %>% filter(JobID==Job & ApplicantID!=Applicant)
  
  if(nrow(ratedUsers) > 0)
  {
    # Get the cosine similarity scores of this Applicant with all other users who rated this job
    ratedUsers$UserCorrelations <- getCosineSimilarityOfUsers(Applicant, ratedUsers)
  
    # Get the Pearson's coefficient
    alpha <- 1/sum(abs(ratedUsers$UserCorrelations))
  
    # Get the predicted rating of 'Applicant' for JobID 'Job'
    PredictedRating <- alpha * sum(ratedUsers$Rating * ratedUsers$UserCorrelations)
  }
  else
    PredictedRating <- mean(master[master$ApplicantID==Applicant,3])
  return(PredictedRating)
  #return(ratedUsers)
}





# Get the predicted ratings of all applicants for jobs which they have given ratings
for (i in 1:nrow(master))
{
  master$PredictedRating[i] <- predictRating(as.numeric(master[i,1]), as.numeric(master[i,2]))
}

master <- master[!is.na(master$PredictedRating),]

#master$PredictedRating <- apply(master[,1], 1, predictRating, master[,2])
#master$PredictedRating <- lapply(master[,1], predictRating, master[,2])

# Evaluate the model for prediction
RMSE <- sqrt(sum((master$Rating-master$PredictedRating)*(master$Rating-master$PredictedRating))/nrow(master))
Accuracy <- nrow(master[abs(master$Rating-master$PredictedRating) < 0.75,])/nrow(master)

r <- predictRating(11314, 4073)

ru[ru$ApplicantID==9204 & ru$variable==456,]
master[master$ApplicantID==9204 & master$JobID==456,]
View(ru[1:10, 1:10])


View(datmat[1:10, 1:10])
View(userCosineValues[1:10, 1:10])

user42 <- datmat[1,]
user42T <- t(user42)
names(user42T) <- "42"
user42T[!is.na(user42T),]

user601 <- datmat[4,]
user601T <- t(user601)
names(user601T) <- "601"
user601T[!is.na(user601T),]
