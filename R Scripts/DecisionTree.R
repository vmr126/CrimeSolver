library(rpart)
library(randomForest)

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

rF_murder_tree = randomForest(Solved~.,data=master, mtry = 4, importance=TRUE, ntree=10)
rf_murder_tree.conf_matrix = table(master.test$Solved, predict(rF_murder_tree, master.test, type="Class"))