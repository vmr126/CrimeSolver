## To run after DataAggregation

library(caret)
library(jtools)
library(ROSE)
library(DMwR)
library(caret)
library(boot)
library(glmnet)

#master.train$CntySt <- NULL
# Logit model on training data
train.logistic_regression <- glm(
        formula = Solved ~.,
        family = "binomial",
        data = master.train
        )
# Generate probabilities w/ training logit
train.glm.prob <- predict(
                train.logistic_regression,
                type="response"
                )
## Create empty table for confusion matrix
train.glm.pred <- rep("No",
                      nrow(master.train)
                      )
## All predictions > 0.5 coded as SOLVED
train.glm.pred[train.glm.prob>0.5]<-"Yes"

## Confusion Matrix for training logit
confusion.logit.train <- table(
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
test.glm.pred <- rep("No",
                     nrow(master.test)
                     )
## Turn > 0.5 probabilities to SOLVED
test.glm.pred[test.glm.prob>0.5]<-"Yes"

## Confusion matrix for test logit
confusion.logit.test <- table(
        test.glm.pred,
        master.test$Solved
        )


## K-Fold

ctrl <- trainControl(method = "repeatedcv", number = 10, savePredictions = TRUE)

mod_fit <- train(Solved~.,
                 data=master.train, 
                 method="glm", 
                 family="binomial",
                 trControl = ctrl, 
                 tuneLength = 5
                 )

pred = predict(mod_fit, 
               newdata=master.test
               )
confusion.logit.kfold <- confusionMatrix(data=pred, master.test$Solved)


## Bootstrapping
#master.matrix <- model.matrix(Solved ~., data=master)
# boot_fn <- function(data, index, formula) {
#        data <- data[index,]
#        fit <- glm(formula, 
#                   data=data,
#                   family = "binomial"
#                   )
#        return(coef(fit))
#}

# boot_fit <- boot(
#        data = master.matrix,
#        statistic = boot_fn,
#        R = 2
#)

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
lasso.coef <- coef(lasso.logit,s=lambda.1se)
## Cross validate Lasso with training data
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
confusion.lasso <- table(pred=lasso.predict,
      true=master.test$Solved
      )
remove(x, y, x.test)
