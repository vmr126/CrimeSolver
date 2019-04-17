master.index <- createDataPartition(
        master$ED_RATE,
        times = 1,
        p = 0.8,
        list = FALSE
)
master.train <- master[master.index,]
master.test <- master[-master.index,]

logistic_regression <- glm(
        formula = Solved_No ~.,
        family = "binomial",
        data = master
)
