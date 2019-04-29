## TO RUN AFTER ALL OTHER SCRIPTS:
## (1) Packages
## (2) Data Aggregation
## (3) Logistic Regression
## (4) Decision Tree


library(ROCit)
library(glmnet)
library(sandwich)
library(ggstance)
library(ROSE)
library(ROCR)
library(cvTools)
library(rattle)
library(rpart.plot)
library(RColorBrewer)


## Confusion Tables
# Confusion tables for logit using regular training and balanced training
confusion.logit.test
# Balanced training
confusion.logit.balanced.test
# K Fold Confusion Matrix
confusion.logit.kfold
# Lasso confusion matrix
confusion.lasso
# Tree confusion matrix
murder_tree.conf_matrix
# Random Forst confusion matrix
rF_murder_tree.conf_matrix


## Summarizing Results

# Lasso Coefficients
lasso.coef
lambda.1se <- lasso.logit$lambda.1se
lasso.coef <- coef(lasso.logit,s=lambda.1se)

# Estimate for coef + SE, z, and p for logit
logit.train.summary <- summ(train.logistic_regression)

# Robust and standardized SEs by 2 SD
logit.train.robustSE <- summ(train.logistic_regression, 
                       robust = TRUE, 
                       scale = TRUE,
                       n.sd = 2,
                       exp = TRUE
                       )

# Confidence intervals for logit
logit.train.CI <- summ(train.logistic_regression,
                 confint = TRUE,
                 digits = 3
                 )

## Accuracy of test predictions on logit
logit.test.accuracy <- accuracy.meas(
        response = master.test$Solved, 
        predicted = test.glm.prob
        )

logit.lasso.accuracy <- accuracy.meas(
                        response = master.test$Solved,
                        predicted = lasso.prob
)

# Precision = true pos/true pos + false pos
# Recall = true pos/true pos + false neg
# F measure = precision/

## Tree Performance Metric
# Decision Tree
decision_tree.performance = tree_performance(murder_tree.conf_matrix)

# Random Forest
rF.performance = tree_performance(rF_murder_tree.conf_matrix)

## ROC curves

# Logistic test ROC
logit.test.roc <- roc.curve(master.test$Solved,
                      test.glm.prob,
                      plotit=T
                      )
# Decision Tree ROC
decision.tree.roc <- roc.curve(master.test$Solved,
                               murder_tree.pred,
                               plotit=T)

# Random Forest ROC
rF.roc <- roc.curve(master.test$Solved,
                    rF_murder_tree.pred,
                    plotit=T)


# Print all ROCs

logit.test.roc
decision.tree.roc
rF.roc

## Visualizing Results

# Plots the effect of a variable on prob of solved for logit
effect.VicRace <- effect_plot(train.logistic_regression, 
                           pred = VicRace, 
                           interval = TRUE, 
                           plot.points = TRUE
)

effect.WHITE <- effect_plot(train.logistic_regression, 
                              pred = WHITE, 
                              interval = TRUE, 
                              plot.points = TRUE
)

effect.VicSex <- effect_plot(train.logistic_regression, 
                              pred = VicSex, 
                              interval = TRUE, 
                              plot.points = TRUE
)

effect.Month <- effect_plot(train.logistic_regression, 
                             pred = Month, 
                             interval = TRUE, 
                             plot.points = TRUE
)


effect.VicRace
effect.VicSex
effect.WHITE
effect.Month

# Decision Tree Model
fancyRpartPlot(murder_tree, palettes=c("Blues", "Oranges"), caption = NULL, split.fun=split.fun)

# Plot rF_murder_tree
layout(matrix(c(1,2),nrow=1),
       width=c(4,1)) 
par(mar=c(5,4,4,0)) #No margin on the right side
plot(rF_murder_tree, main = "Random Forest Model Error Rate")
par(mar=c(5,0,4,2)) #No margin on the left side
plot(c(0,1),type="n", axes=F, xlab="", ylab="")
legend("top", colnames(rF_murder_tree$err.rate),col=1:4,cex=0.8,fill=1:4)

# Random Forest Importance
randomForest::importance(rF_murder_tree)
varImpPlot(rF_murder_tree, main = "Random Forest - Important Variables")

# Lasso Plot
# For interpretation:
# https://stats.stackexchange.com/questions/68431/interpretting-lasso-variable-trace-plots
op <- par(mfrow=c(1,2))
plot(lasso.logit$glmnet.fit,"norm",label=TRUE)
plot(lasso.logit$glmnet.fit,"lambda",label=TRUE)
par(op)

plot(lasso.logit)

