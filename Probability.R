Gender = rep(c("M","F"),c(2500,3000))
Married = rep(c("N","Y","N","Y"),c(1200,1300,1800,1200))
Qualification = rep(c("Q1","Q2","Q3","Q4","Q1","Q2","Q3","Q4","Q1","Q2","Q3","Q4","Q1","Q2","Q3","Q4"),
                    c(264,327,227,286,650,145,577,301,221,420,396,328,663,302,260,133))
Data = data.frame(Gender,Married,Qualification)
str(Data)
summary(Data)
attach(Data)
table(Gender)
prop.table(table(Gender))
table <- 
  table(Gender, Qualification)
prop.table(table) #joint probability
prop.table(table,2)
View(table)
