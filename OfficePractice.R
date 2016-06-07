library(kernlab)
kkfit <- kkmeans(as.matrix(d), centers=3)
withinss(kkfit)

dat <- attitude
str(dat)
summary(dat)

dat <- dat[,-1]
c <- cov(dat)
diag(c) <- 0
c

library(gclus)
dta.r <- abs(cor(dat))
