## To run after DataAggregation

library(caret)
library(jtools)
library(ROSE)
library(DMwR)
library(caret)
library(boot)
library(glmnet)

# Logit model on training data
balanced.logistic_regression <- glm(
        formula = Solved ~.,
        family = "binomial",
        data = balanced_data
        )

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

balanced.glm.prob <- predict(
        balanced.logistic_regression,
        type="response"
)

## Predict test data
test.glm.prob <- predict(
                train.logistic_regression, 
                newdata=master.test,
                type="response"
                )

balanced.test.glm.prob <- predict(
        balanced.logistic_regression, 
        newdata=master.test,
        type="response"
        )

## Create empty table with UNSOLVED
balanced.test.glm.pred <- rep("No",
                     nrow(master.test)
                     )

test.glm.pred <- rep("No",
                     nrow(master.test)
                     )
## Turn > 0.5 probabilities to SOLVED
test.glm.pred[test.glm.prob>0.5]<-"Yes"
balanced.test.glm.pred[balanced.test.glm.prob>0.5]<-"Yes"

## Confusion matrix for test logit
confusion.logit.test <- table(
        test.glm.pred,
        master.test$Solved
        )

confusion.logit.balanced.test <- table(
        balanced.test.glm.pred,
        master.test$Solved
        )

## Coercing matrix for K-Fold Lasso
x.train <- model.matrix(Solved~.,
                  balanced_data
                  )
y.train <- ifelse(balanced_data$Solved=="Yes",
            1,
            0
            )

x.test <- model.matrix(Solved~.,
                       master.test
                       )

## 10 K-Fold Logistic Regression
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

## Lasso Model with K-Fold
lasso.logit <- cv.glmnet(x.train, 
                      y.train,
                      alpha=1,
                      family = "binomial",
                      type.measure="mse",
                      nfolds = 10
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
remove(x.test, x.train, y.train, pred, lasso.predict, test.glm.prob,
       train.glm.prob, balanced.glm.prob, balanced.test.glm.prob,
       balanced.test.glm.pred, ctrl, master.index)