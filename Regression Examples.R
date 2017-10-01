# Regression Examples for study
# 
library(car)
model <- lm(wl2 ~ factor(group), data = WeightLoss)
summary(model)

# Cross-validation Examples
set.seed(1)
train.indices <- sample(1:nrow(mtcars), nrow(mtcars)/2)
training <- mtcars[train.indices,]
testing <- mtcars[-train.indices,]
model <- lm(mpg ~ ., data = training)
summary(model)

mean((predict(model) - training$mpg)^2) # MSE of the training set
mean((predict(model, newdata = testing) - testing$mpg)^2) # MSE of the testing set -> Overfitting

simpler.model <- lm(mpg ~ am + wt, data = training)
mean((predict(simpler.model) - training$mpg)^2) # MSE of the training set
mean((predict(simpler.model, newdata = testing) - testing$mpg)^2) # MSE of the testing set

library(boot) # library for CV function: only works for GLM
bad.model <- glm(mpg ~ ., data = mtcars)
better.model <- glm(mpg ~ am + wt, data = mtcars)

bad.cv.err <- cv.glm(mtcars, bad.model, K = 5)
bad.cv.err$delta[2]
better.cv.err <- cv.glm(mtcars, better.model, K = 5)
better.cv.err$delta[2]

# GLM Examples
# 
data("PimaIndiansDiabetes")
PID <- PimaIndiansDiabetes
train.indices <- sample(1:nrow(PID), nrow(PID)*4/5)
training <- PID[train.indices,]
testing <- PID[-train.indices,]
model <- glm(diabetes ~ ., data = PID, family = "binomial")
summary(model)

predictions <- round(predict(model, type = "response"))
PID$diabetes2 <- ifelse(PID$diabetes == "pos", 1, 0)
accuracy(PID$diabetes2, predictions)

# Cross-validation
set.seed(3)
library(boot)
cv.err <- cv.glm(PID, model, K=5)
cv.err$delta[2]
1 - cv.err$delta[2]

# Decision Tree Example
# 
library(tree)
our.big.tree <- tree(diabetes ~ ., data = training)
summary(our.big.tree)
plot(our.big.tree)
text(our.big.tree)

# cross-validation
set.seed(3)
cv.results <- cv.tree(our.big.tree, FUN=prune.misclass)
plot(cv.results$size, cv.results$dev, type="b")