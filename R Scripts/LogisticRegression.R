## To run after DataAggregation
library(ROSE)
library(DMwR)
library(caret)
library(boot)
library(ROCit)
library(glmnet)

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
train.glm.pred <- rep("No",nrow(master.train))
## All predictions > 0.5 coded as SOLVED
train.glm.pred[train.glm.prob>0.5]<-"Yes"
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
test.glm.pred <- rep("No",nrow(master.test))
## Turn > 0.5 probabilities to SOLVED
test.glm.pred[test.glm.prob>0.5]<-"Yes"
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

## Lasso Model
x <- model.matrix(Solved~.,
                  master.train
                  )
y <- ifelse(master.train$Solved=="Yes",
            1,
            0
            )
lasso.logit <- cv.glmnet(x, 
                      y,
                      alpha=1,
                      family = "binomial",
                      type.measure="mse"
                      )
lambda.min <- lasso.logit$lambda.min
lambda.1se <- lasso.logit$lambda.1se
coef(lasso.logit,s=lambda.1se)
## Cross validate with training data
x.test <- model.matrix(Solved~.,
                       master.test
                       )
lasso.prob <- predict(lasso.logit,
                      newx = x.test,
                      s=lambda.1se,
                      type="response"
                      )
lasso.predict <- rep("NO",
                     nrow(master.test)
                     )
lasso.predict[lasso.prob>.5] <- "YES"
table(pred=lasso.predict,
      true=master.test$Solved
      )
mean(lasso.predict==master.test$Solved)


