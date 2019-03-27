## Set Working Directory
# setwd('C:/Users/vmr12/OneDrive/Documents/GitHub/CrimeSolver')

## necessary packages
library(sqldf)

## import data
Poverty_Rate <- as.data.frame(read.csv("./Data/Poverty Rate.csv", header=TRUE, sep=","))
County_Income <- as.data.frame(read.csv("./Data/County Income Data.csv", header=TRUE, sep=","))
Education <- as.data.frame(read.csv("./Data/Education data.csv", header=TRUE, sep=","))

## pull data headers/descriptions from Census files
poverty_rate_hdrs <- t(sqldf::sqldf("select 1 from Poverty_Rate Limit 1"))

## define SQL strings
poverty_rate_select_string <- "select substr(GEO_display_label, 1, instr(GEO_display_label, ',')-1) as County, 
                              substr(GEO_display_label, instr(GEO_display_label, ',') + 1) as State, 
                              HC02_EST_VC01, 
                              HC02_MOE_VC01 
                              from Poverty_Rate 
                              Limit 5"

## query subset of data
subset_pov <- sqldf::sqldf(poverty_rate_select_string)




