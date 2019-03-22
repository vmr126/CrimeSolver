# setwd('C:/Users/vmr12/OneDrive/Documents/GitHub/CrimeSolver')

County_Income <- as.data.frame(read.csv("./Data/County Income Data.csv", header=TRUE, sep=","))
Education <- as.data.frame(read.csv("./Data/Education data.csv", header=TRUE, sep=","))
Poverty_Rate <- as.data.frame(read.csv("./Data/Poverty Rate.csv", header=TRUE, sep=","))
County_Clearance <- as.data.frame(read.csv("./Data/County Clearance Rates - UCR76_17a.csv", header=TRUE, sep=","))