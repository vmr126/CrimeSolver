## Set Working Directory
setwd("/Users/timothymichalak/Documents/GitHub/CrimeSolver/Data")

## necessary packages
library(dplyr)
library(sqldf)

## import data
unsolved_murders <- read.csv("unsolvedmurders10_17.csv")
solved_murders <- read.csv("solved_murders_individual_2010_2017.csv")

## filter data
unsolved_murders <- subset(unsolved_murders, Solved == "No")
solved_murders <- subset(solved_murders, Solved == "Yes")

## define SQL strings
unsolved_select_string <- "select substr(CNTYFIPS, 1, 
                instr(CNTYFIPS, ',')-1) as County, 
                substr(CNTYFIPS, instr(CNTYFIPS, ',') + 1) 
                as State, CNTYFIPS, State, Agentype, Solved,
                                     Year, StateName, Month, Incident,
                                Situation, VicAge, VicSex, VicRace,
                                Weapon  from unsolved_murders"

solved_select_string <- "select substr(CNTYFIPS, 1, 
                instr(CNTYFIPS, ',')-1) as County, 
                substr(CNTYFIPS, instr(CNTYFIPS, ',') + 1) 
                as State, CNTYFIPS, State, Agentype, Solved,
                                     Year, StateName, Month, Incident,
                                Situation, VicAge, VicSex, VicRace,
                                Weapon  from solved_murders"

## query subset of data 
unsolved_murders_split <- sqldf::sqldf(select_string)
solved_murders_split <- sqldf::sqldf(solved_select_string)