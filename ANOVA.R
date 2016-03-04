data <- data.frame(scores = c(643,655,702,469,427,525,484,456,402),method = factor(rep(c("M1","M2","M3"),c(3,3,3))))
model= aov(scores~method,data=data)
model
summary(model)
