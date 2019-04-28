## TO RUN AFTER ALL OTHER SCRIPTS:
## (1) Packages
## (2) Data Aggregation
## (3) Logistic Regression
## (4) Decision Tree


library(ROCit)
library(glmnet)
library(sandwich)
library(ggstance)

## Confusion Tables?


## Summarizing and Visualizing Data

logit.train.summary <- summ(train.logistic_regression)
## Robust and standardized SEs by 2 SD
logit.train.robustSE <- summ(train.logistic_regression, 
                       robust = TRUE, 
                       scale = TRUE,
                       n.sd = 2,
                       exp = TRUE
)
logit.train.CI <- summ(train.logistic_regression,
                 confint = TRUE,
                 digits = 3
)
effect.plot <- effect_plot(train.logistic_regression, 
            pred = VicRace, 
            interval = TRUE, 
            plot.points = TRUE
            )

## Check accuracy of training and test predictions
logit.train.accuracy <- accuracy.meas(
        response = master.train$Solved,
        predicted = train.glm.prob
)
logit.test.accuracy <- accuracy.meas(
        response = master.test$Solved, 
        predicted = test.glm.prob
)



## ROC curves for training and test predictions
logit.train.roc <- roc.curve(master.train$Solved,
                       train.glm.prob,
                       plotit=T
)
logit.test.roc <- roc.curve(master.test$Solved,
                      test.glm.prob,
                      plotit=T
)

