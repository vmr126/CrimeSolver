library(rpart)
library(randomForest)
library(DWwR)

## Decision Tree
murder_tree <- rpart(Solved ~., master.train)
murder_tree.pred = predict(murder_tree , master.test, type="class")
murder_tree.conf_matrix = as.matrix(table(Actual = master.test$Solved, Predicted = murder_tree.pred))

## Random Forest
rF_murder_tree = randomForest(Solved~.,data=master.train, subset=sample(1:nrow(master.train), nrow(master.train)*0.8), importance=TRUE)
rF_murder_tree.pred = predict(rF_murder_tree, master.test, type="class")
rF_murder_tree.conf_matrix = as.matrix(table(Actual = master.test$Solved, Predicted = rF_murder_tree.pred))


# train model
control <- trainControl(method="repeatedcv", number=5, repeats=1)
tunegrid <- expand.grid(.mtry=c(3,4,5,6,7), .ntree=c(10, 100, 500))
set.seed(26)
custom <- train(Solved~., data=master, method=customRF, metric='Accuracy', tuneGrid=tunegrid, trControl=control)
summary(custom)
plot(custom)
