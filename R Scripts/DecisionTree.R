library(rpart)
library(randomForest)
library(DWwR)

murder_tree <- rpart(Solved ~., master.train)

printcp(murder_tree)
plotcp(murder_tree)

plot(murder_tree, uniform=TRUE)
text(murder_tree, use.n=TRUE, all=TRUE, cex=.8)
summary(murder_tree)

murder_tree.pred = predict(murder_tree , master.test, type="class")
murder_tree.conf_matrix = table(master.test$Solved, murder_tree.pred)

#set.seed(26)
#murder_tree.cv = xpred.rpart(murder_tree)
#murder_tree.cv.conf_matrix = table(master.train$Solved, murder_tree.cv)

rF_murder_tree = randomForest(Solved~.,data=master.train, mtry = sqrt(ncol(master.train)), importance=TRUE, ntree=500)
rF_murder_tree.conf_matrix = table(master.test$Solved, predict(rF_murder_tree, master.test, type="Class"))

importance(rF_murder_tree)

## Optimization
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("mtry", "ntree"), class = rep("numeric", 2), label = c("mtry", "ntree"))
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