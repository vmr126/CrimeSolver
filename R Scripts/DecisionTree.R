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

rF_murder_tree = randomForest(Solved~.,data=master.train, subset=sample(1:nrow(master.train), nrow(master.train)*0.8), importance=TRUE)
rF_murder_tree.pred = predict(rF_murder_tree, master.test, type="class")
rF_murder_tree.conf_matrix = table(master.test$Solved, rF_murder_tree.pred)
#plot(rF_murder_tree)
layout(matrix(c(1,2),nrow=1),
       width=c(4,1)) 
par(mar=c(5,4,4,0)) #No margin on the right side
plot(rF_murder_tree, log="y")
par(mar=c(5,0,4,2)) #No margin on the left side
plot(c(0,1),type="n", axes=F, xlab="", ylab="")
legend("top", colnames(rF_murder_tree$err.rate),col=1:4,cex=0.8,fill=1:4)


importance(rF_murder_tree)
varImpPlot(rF_murder_tree)