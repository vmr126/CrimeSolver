## To run after DataAggregation
## Create test and training data
master.index <- createDataPartition(
        master.CntyStFactor$VicAge,
        times = 1,
        p = 0.8,
        list = FALSE
)
master.train <- master.CntyStFactor[master.index,]
master.test <- master.CntyStFactor[-master.index,]

## Logistic regression on 100k obs w/o CntySt
master.train$CntySt <- NULL
train.logistic_regression <- glm(
        formula = Solved_No ~.,
        family = "binomial",
        data = master.train
)
train.glm.prob <- predict(
                logistic_regression,
                type="response"
)
## Create empty table for confusion matrix
train.glm.pred <- rep("UNSOLVED",nrow(master.train))
## All predictions > 0.5 coded as SOLVED
train.glm.pred[train.glm.prob>0.5]<-"SOLVED"
## Confusion Matrix
train.confusionmatrix <- table(
                                train.glm.pred,
                               master.train$Solved_No
)
## Predict test data
test.glm.prob <- predict(
                logistic_regression, 
                newdata=master.test,
                type="response"
)
test.glm.pred <- rep("UNSOLVED",nrow(master.test))
test.glm.pred[test.glm.prob>0.5]<-"SOLVED"
test.confusionmatrix <- table(
        test.glm.pred,
        master.test$Solved_No
)

