library(rpart)
library(randomForest)

## Decision Tree
murder_tree <- rpart(Solved ~., balanced_data)
murder_tree.pred = predict(murder_tree , master.test, type="class")
murder_tree.conf_matrix = as.matrix(table(Actual = master.test$Solved, Predicted = murder_tree.pred))

## Random Forest
rF_murder_tree = randomForest(Solved~.,data=balanced_data, subset=sample(1:nrow(balanced_data), nrow(balanced_data)*0.8), importance=TRUE)
rF_murder_tree.pred = predict(rF_murder_tree, master.test, type="class")
rF_murder_tree.conf_matrix = as.matrix(table(Actual = master.test$Solved, Predicted = rF_murder_tree.pred))



## Optimizers

customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("mtry","ntree"), class = rep("numeric", 2), label = c("mtry","ntree"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, mtry = param$mtry, ntree=param$ntree, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
  predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

# train model
control <- trainControl(method="repeatedcv", number=5, repeats=1)
tunegrid <- expand.grid(.mtry=c(3,4,5,6,7), .ntree=c(10, 100, 500))
set.seed(26)
custom <- train(Solved~., data=master, method=customRF, metric='Accuracy', tuneGrid=tunegrid, trControl=control)
summary(custom)
plot(custom)
