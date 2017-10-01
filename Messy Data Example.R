# Dealing with Messy Data Examples
# 
data("mtcars")
set.seed(2)
miss_mtcars <- mtcars

some_rows <- sample(1:nrow(mtcars), 7)
miss_mtcars$drat[some_rows] <- NA

some_rows <- sample(1:nrow(mtcars), 5)
miss_mtcars$mpg[some_rows] <- NA

some_rows <- sample(1:nrow(mtcars), 5)
miss_mtcars$cyl[some_rows] <- NA

some_rows <- sample(1:nrow(mtcars), 3)
miss_mtcars$wt[some_rows] <- NA

some_rows <- sample(1:nrow(mtcars), 3)
miss_mtcars$vs[some_rows] <- NA

only_automatic <- which(miss_mtcars$am == 0)
some_rows <- sample(only_automatic, 4)
miss_mtcars$qsec[some_rows] <- NA

library(mice) # package used for imputing missing data
md.pattern(miss_mtcars)
library(VIM)  # package for visualizing missing data
aggr(miss_mtcars, numbers = TRUE)
summary(aggr(miss_mtcars, plot = FALSE))
