#pnorm gives probability of of all values below x
pnorm(x, mean, sd)

#qnorm gives value of < x where probabilty is given
qnorm(probability, mean, sd)

#Gives z score
pnorm(prob, mean, sd)

#Binomial distr equivalent to P(x=r) = (ncr)*q^(r-1)*(p^r)
pbinom(r, n, p)

conf.interval <- function(data, confidenceLevel)
{
  zScore <- qnorm((1-confidenceLevel)/2, 0, 1, lower.tail =  FALSE)
  variance <- var(data)
  standardError <- sqrt(variance/length(data))
  marginOfError <- zScore*standardError
  c(mean(data) - marginOfError, mean(data) + marginOfError)
}

pregnancy <- read.csv("E:\\INSOFE\\CSE7315c\\PregnancyDuration.csv", header=T, sep=",")
pregnancy = pregnancy[,1]
summary(pregnancy)
var(pregnancy)
mean(pregnancy)
pnorm(349, mean(pregnancy), sd(pregnancy))
plot(pregnancy)

conf.interval(pregnancy, .95)

ttest()

