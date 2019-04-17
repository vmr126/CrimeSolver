master.index <- createDataPartition(
        master$ED_RATE,
        times = 1,
        p = 0.8,
        list = FALSE
)
master.train <- master[master.index,]
master.test <- master[-master.index,]

## Logistic regression on 100k obs w/o CntySt
master.CntyStFactor$CntySt <- NULL
master.CntyStFactor.sub <- master.CntyStFactor[1:100000,]
logistic_regression <- glm(
        formula = Solved_No ~.,
        family = "binomial",
        data = master.CntyStFactor.sub
)
glm.prob <- predict(logistic_regression,type="response")
glm.pred <- rep("UNSOLVED",100000)
glm.pred[glm.prob>0.5]<-"SOLVED"
table(glm.pred,master.CntyStFactor.sub$Solved_No)