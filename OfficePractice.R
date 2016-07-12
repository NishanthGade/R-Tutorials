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

### similarity

# Creating function to calculate the cosine between two vectors
getCosine <- function(x,y) 
{
  cosine <- abs(sum(x*y) / (sqrt(sum(x*x)) * sqrt(sum(y*y))))
  return(cosine)
}

# Get the users who rated more than 20 jobs
moreThan20 <- ratingCount %>% filter(NoOfRating>=20) %>% arrange(desc(NoOfRating)) %>% head(10)

# Convert dataframe to matrix form
mat <- as.matrix(datmat)

# Remove the 1st column Applicant Id
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

# Get the user space matrix with top 2021 eigen vectors which explain 90% variance
user <- data.frame(s$u[,1:2021])
rownames(user) <- rownames(datmat)

# Get the job space matrix with top 2021 eigen vectors which explain 90% variance
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

# Fucntion to find cosine similarity of each user with other users
getCosineSimilarityOfUsers <- function(Applicant,ratedUsers) 
{
  userCosineValues <- c()
  for(i in 1:nrow(ratedUsers))
  {
    # Consider users excluding current applicant
    if(ratedUsers$ApplicantID[i] != Applicant)
    {
      #Call function to get cosine value
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

# Get the best recommendation for a user based on all jobs
getRecommendationAllJobs <- function(Applicant)
{
  predictions <- data.frame(Job=0, Rating=0)
  # Get the predictions for all the jobs
  for(i in 2:ncol(datmat))
  {
    cat(i, " ")
    predictions[i,2] <- predictRating(Applicant, as.numeric(names(datmat)[i]))
    predictions[i,1] <- as.numeric(names(datmat)[i])
  }
  return(predictions[which(predictions$Rating==max(predictions$Rating)), 1])
}

# Get the best recommendation for a user based on similar users rated jobs
getRecommendationSimilarUSers <- function(Applicant)
{
  # Get distinct users
  distUsers <- master %>% group_by(ApplicantID) %>% count(ApplicantID)

  # Get cosine similarity with all users
  distUsers$UserCorrelations <- getCosineSimilarityOfUsers(Applicant, distUsers)

  # Get top 20 closest users
  distUsers <- distUsers %>% arrange(desc(UserCorrelations)) %>% head(20)

  return(distUsers)
}

r<-getRecommendationSimilarUSers(11314)
r <- predictRating(11314, 456)

#master$PredictedRating <- apply(master[,1], 1, predictRating, master[,2])
#master$PredictedRating <- lapply(master[,1], predictRating, master[,2])

# Evaluate the model for prediction
RMSE <- sqrt(sum((master$Rating-master$PredictedRating)*(master$Rating-master$PredictedRating))/nrow(master))
Accuracy <- nrow(master[abs(master$Rating-master$PredictedRating) < 0.75,])/nrow(master)
