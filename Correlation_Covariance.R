View(faithful)

waiting <- faithful$waiting
eruptions <- faithful$eruptions

plot(x=waiting,y=eruptions)

cov(waiting,eruptions)
cor(waiting,eruptions)
