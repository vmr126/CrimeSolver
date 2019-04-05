## Set Working Directory
# setwd('C:/Users/vmr12/OneDrive/Documents/GitHub/CrimeSolver')

## necessary packages
library(sqldf)

## import data
Race <- as.data.frame(read.csv("./Data/Race Data.csv", header=TRUE, sep=","))
Poverty_Rate <- as.data.frame(read.csv("./Data/Poverty Rate.csv", header=TRUE, sep=","))
#County_Income <- as.data.frame(read.csv("./Data/County Income Data.csv", header=TRUE, sep=","))
Education <- as.data.frame(read.csv("./Data/Education data.csv", header=TRUE, sep=","))

## pull data headers/descriptions from Census files
poverty_rate_hdrs <- t(sqldf::sqldf("select * from Poverty_Rate Limit 1"))
education_hdrs <- t(sqldf::sqldf("select * from Education Limit 1"))
race_hdrs <- t(sqldf::sqldf("select * from Race Limit 1"))

census_select_string <- "select substr(ed.GEO_display_label, 1, instr(ed.GEO_display_label, ' County,')-1) as County, 
                          substr(ed.GEO_display_label, instr(ed.GEO_display_label, ',') + 1) as State,  
                          ed.HC02_EST_VC17 as ED_RATE, 
                          pr.HC03_EST_VC01 as POV_RATE,
                          rc.HC03_VC93 as HISPANIC,
                          rc.HC03_VC75 as MULTIRACIAL,
                          rc.HC03_VC74 as OTHER,
                          rc.HC03_VC69 as PAC_ISLANDER,
                          rc.HC03_VC61 as ASIAN,
                          rc.HC03_VC56 as NATIVE_AM,
                          rc.HC03_VC55 as AFR_AM,
                          rc.HC03_VC54 as WHITE
                        from Education ed
                        left join Poverty_Rate pr
                        on ed.GEO_display_label = pr.GEO_display_label
                        left join Race rc
                        on ed.GEO_display_label = rc.GEO_display_label"

census_query <- sqldf::sqldf(census_select_string)
census_query = census_query[-1,]
