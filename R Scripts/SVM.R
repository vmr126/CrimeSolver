library (e1071)

svm_murder = svm(Solved~., data=master.train , type = "C-classification", cachesize = 2000, kernel ="linear", cost=0.001, scale=FALSE)