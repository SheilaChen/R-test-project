# Random Forest Examples
# Load some sample data
library(mlbench)
data("PimaIndiansDiabetes")
PID <- PimaIndiansDiabetes
PID$diabetes2 <- ifelse(PID$diabetes == "pos", 1, 0)

# Split training and testing data
set.seed(3)
ntrain <- round(nrow(PID)*4/5)
train <- sample(1:nrow(PID), ntrain)
training <- PID[train,]
testing <- PID[-train,]

# Random Forest
library(randomForest)
forest <- randomForest(diabetes ~ . - diabetes2, data = training,
                       importance = TRUE,
                       ntree = 2000,
                       mtry = 5)
library(SDMTools) # use the accuracy function
accuracy(training[, 10], ifelse(predict(forest) == "pos", 1, 0))

# Out-of-bag accuracy
predictions <- predict(forest, newdata = testing)
accuracy(testing[, 10], ifelse(predictions == "pos", 1, 0))

