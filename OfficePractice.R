dat <- attitude
str(dat)
summary(dat)

# removing the predictor variable
dat <- dat[,-1]

# Covariance matrix
c <- cov(dat)
diag(c) <- 0
c

library(gclus)
dta.r <- abs(cor(dat)) # get correlations
dta.col <- dmat.color(dta.r) # get colors

# reorder variables so those with highest correlation 
# are closest to the diagonal
dta.o <- order.single(dta.r)

cpairs(dat, dta.o, panel.colors=dta.col, gap=.5, main="Variables Ordered and Colored by Correlation" )

attLM <- lm(rating~., data=attitude)
summary(attLM)

attLMPred <- predict(attLM, dat)

library(DMwR)
regr.eval(attitude$rating, attLMPred)

#Now perform PCA. 
pca_data = princomp(dat) 
print(pca_data)

# understanding summary of PCA
summary(pca_data)

# Understanding new component weights
pca_data$loadings

# screeplot.default plots the variances against the number of the principal component. This is 
#also the plot method for classes "princomp" and "prcomp". 
screeplot(pca_data, type = "lines")

# New feature matrix 
pca_data$scores

final <- data.frame(rating=attitude$rating, pca_data$scores)

attLMPCA <- lm(rating~., data=final)
summary(attLMPCA)

attLMPredPCA <- predict(attLM, dat)

regr.eval(attitude$rating, attLMPredPCA)
