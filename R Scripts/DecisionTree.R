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