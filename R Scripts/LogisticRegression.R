library(caret)

## To run after DataAggregation
## Create test and training data
master.index <- createDataPartition(
        master$VicAge,
        times = 1,
        p = 0.8,
        list = FALSE
)
master.train <- master[master.index,]
master.test <- master[-master.index,]

#master.train$CntySt <- NULL
train.logistic_regression <- glm(
        formula = Solved ~.,
        family = "binomial",
        data = master.train
)
train.glm.prob <- predict(
                train.logistic_regression,
                type="response"
)
## Create empty table for confusion matrix
train.glm.pred <- rep("UNSOLVED",nrow(master.train))
## All predictions > 0.5 coded as SOLVED
train.glm.pred[train.glm.prob>0.5]<-"SOLVED"
## Confusion Matrix for training logit
train.confusionmatrix <- table(
                                train.glm.pred,
                               master.train$Solved
)
## Predict test data
test.glm.prob <- predict(
                train.logistic_regression, 
                newdata=master.test,
                type="response"
)
## Create empty table with UNSOLVED
test.glm.pred <- rep("UNSOLVED",nrow(master.test))
## Turn > 0.5 probabilities to SOLVED
test.glm.pred[test.glm.prob>0.5]<-"SOLVED"
## Confusion matrix for text logit
test.confusionmatrix <- table(
        test.glm.pred,
        master.test$Solved
)

## Check accuracy of training and test predictions
train.accuracy <- accuracy.meas(
                response = master.train$Solved,
                predicted = train.glm.prob
                )
test.accuracy <- accuracy.meas(
                response = master.test$Solved, 
                predicted = test.glm.prob
                )
## ROC curves for training and test predictions
train.roc <- roc.curve(master.train$Solved,
                       train.glm.prob,
                       plotit=T
                       )
test.roc <- roc.curve(master.test$Solved,
                      test.glm.prob,
                      plotit=T
                      )

## Bootstrapping
boot_fn <- function(data, index) {
        data <- data[index,]
        fit <- glm(Solved~., 
                   data=data,
                   family = "binomial"
                   )
        return(coef(fit))
}

system.time(boot_fit <- boot(
        data = master,
        statistic = boot_fn,
        R = 10
))







