## Set Working Directory
setwd("/Users/timothymichalak/Documents/GitHub/CrimeSolver/Data")

## necessary packages
library(sqldf)

## import data
MAP_cleared_uncleared <- read.csv("unsolvedmurders10_17.csv")


## define SQL strings
select_string <- "select substr(CNTYFIPS, 1, 
                instr(CNTYFIPS, ',')-1) as County, 
                substr(CNTYFIPS, instr(CNTYFIPS, ',') + 1) 
                as State, CNTYFIPS, State, Solved, Agentype,
                                     Year, StateName, Month,
                                Situation, VicAge, VicSex, VicRace,
                                Weapon  from MAP_cleared_uncleared"


## query subset of data 
MAP_murders_split <- sqldf::sqldf(select_string)
