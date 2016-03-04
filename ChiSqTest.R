#To test independence of events
tb<-matrix(c(200,150,50,250,300,50),c(2,3),byrow=T)
chisq.test(tb)

#To test goodness of fit
originalFrequencies<- c(21,109,62,15)
expectedProportions<- c(0.08,0.47,0.34,0.11) #given
expectedFrequencies<- c(16.56,97.29,70.38,22.77) #calculated based on proportions and observed 

chisq.test(originalFrequencies, p = expectedFrequencies /sum(expectedFrequencies))
#OR
chisq.test(originalFrequencies, p = expectedProportions)

#ch
a<-5