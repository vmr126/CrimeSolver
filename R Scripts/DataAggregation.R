## Set Working Directory
# setwd('C:/Users/vmr12/OneDrive/Documents/GitHub/CrimeSolver')

## necessary packages
library(sqldf)

## import data
Poverty_Rate <- as.data.frame(read.csv("./Data/Poverty Rate.csv", header=TRUE, sep=","))
#County_Income <- as.data.frame(read.csv("./Data/County Income Data.csv", header=TRUE, sep=","))
Education <- as.data.frame(read.csv("./Data/Education data.csv", header=TRUE, sep=","))

## pull data headers/descriptions from Census files
poverty_rate_hdrs <- t(sqldf::sqldf("select * from Poverty_Rate Limit 1"))
education_hdrs <- t(sqldf::sqldf("select * from Education Limit 1"))

census_select_string <- "select substr(ed.GEO_display_label, 1, instr(ed.GEO_display_label, ',')-1) as County, 
                          substr(ed.GEO_display_label, instr(ed.GEO_display_label, ',') + 1) as State,  
                          ed.HC02_EST_VC17 as ED_RATE, 
                          pr.HC03_EST_VC01 as POV_RATE,
                          ed.HC02_EST_VC69 as HISPANIC,
                          ed.HC02_EST_VC65 as MULTIRACIAL,
                          ed.HC02_EST_VC61 as OTHER,
                          ed.HC02_EST_VC57 as PAC_ISLANDER,
                          ed.HC02_EST_VC53 as ASIAN,
                          ed.HC02_EST_VC49 as NATIVE_AM,
                          ed.HC02_EST_VC45 as AFR_AM,
                          ed.HC02_EST_VC41 as WHITE
                        from Education ed
                        left join Poverty_Rate pr
                        on ed.GEO_display_label = pr.GEO_display_label"

census_query <- sqldf::sqldf(census_select_string)


