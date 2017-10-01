library(MASS) #
data("anscombe")  # dataset that compare different cases where data are good or bad for linear regression (lm)
plot(y3 ~ x3, data = anscombe)
abline(lm(y3 ~ x3, data = anscombe),
       col = "blue", lty = 2, lwd = 2)
abline(rlm(y3 ~ x3, data = anscombe),
       col = "red", lty = 1, lwd = 2)