## Set Working Directory
# setwd('C:/Users/vmr12/OneDrive/Documents/GitHub/CrimeSolver')

## necessary packages
library(sqldf)
library(fastDummies)

## import data
Race <- as.data.frame(read.csv("./Data/Race Data.csv", header=TRUE, sep=","))
Poverty_Rate <- as.data.frame(read.csv("./Data/Poverty Rate.csv", header=TRUE, sep=","))
#County_Income <- as.data.frame(read.csv("./Data/County Income Data.csv", header=TRUE, sep=","))
Education <- as.data.frame(read.csv("./Data/Education data.csv", header=TRUE, sep=","))
MAP_cleared_uncleared <- read.csv("./Data/unsolvedmurders10_17.csv")

## pull data headers/descriptions from Census files
poverty_rate_hdrs <- t(sqldf::sqldf("select * from Poverty_Rate Limit 1"))
education_hdrs <- t(sqldf::sqldf("select * from Education Limit 1"))
race_hdrs <- t(sqldf::sqldf("select * from Race Limit 1"))

## define SQL strings
select_string <- "select substr(CNTYFIPS, 1, instr(CNTYFIPS, ',')-1) || '-' || State as CntySt,
                  Solved, Agentype, Year, Month,
                  Situation, VicAge, VicSex, VicRace,
                  Weapon  from MAP_cleared_uncleared"

census_select_string <- "select substr(ed.GEO_display_label, 1, instr(ed.GEO_display_label, ' County,')-1) || '-' ||
                          trim(substr(ed.GEO_display_label, instr(ed.GEO_display_label, ',') + 1)) as CntySt,  
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
                        on ed.GEO_display_label = rc.GEO_display_label
                        where ed.GEO_display_label like '%County%'
                        union
                        select substr(ed.GEO_display_label, 1, instr(ed.GEO_display_label, ' Parish,')-1) || '-' ||
                          trim(substr(ed.GEO_display_label, instr(ed.GEO_display_label, ',') + 1)) as CntySt,  
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
                          on ed.GEO_display_label = rc.GEO_display_label
                          where ed.GEO_display_label like '%Parish%'
                        union
                        select substr(ed.GEO_display_label, 1, instr(ed.GEO_display_label, ' city,')-1) || '-' ||
                          trim(substr(ed.GEO_display_label, instr(ed.GEO_display_label, ',') + 1)) as CntySt,  
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
                        on ed.GEO_display_label = rc.GEO_display_label
                        where ed.GEO_display_label like '%city%'"

## query subset of data 
census_query <- sqldf::sqldf(census_select_string)
census_query = census_query[-1,]
MAP_murders_split <- sqldf::sqldf(select_string)

## join subsets to form master table
join_query <- "select *
              from MAP_murders_split a
              inner join census_query b
              on a.CntySt = b.CntySt"

## execute join query for census and MAP data
master <- sqldf::sqldf(join_query)

## Remove joined CntySt Column
master$CntySt..11 <- NULL

## list of missing counties due to irregular naming (e.g. Parishes, Boroughs, Independent Cities)
#missing_muni <- sqldf::sqldf("select distinct CntySt from master where ed_rate is null")

## Create Dummy Variables
## master <- dummy_columns(master, select_columns=c('CntySt', 'Solved', 'Agentype', 'Year', 'Month', 'Situation', 'VicSex', 'VicRace', 'Weapon'), remove_first_dummy = TRUE,
##                    remove_most_frequent_dummy = FALSE)

## Create dummy variables, no CntySt as dummy
master <- dummy_columns(master, select_columns=c('Solved', 'Agentype', 'Year', 'Month', 'Situation', 'VicSex', 'VicRace', 'Weapon'), 
                        remove_first_dummy = TRUE,
                        remove_most_frequent_dummy = FALSE)


## Remove columns that were turned into dummies
master$CntySt <- NULL
master$Solved <- NULL
master$Agentype <- NULL
master$Year <- NULL
master$Month <- NULL
master$Situation <- NULL
master$VicSex <- NULL
master$VicRace <- NULL
master$Weapon <- NULL

master$ED_RATE <- as.numeric(master$ED_RATE)
master$POV_RATE <- as.numeric(master$POV_RATE)
master$HISPANIC <- as.integer(master$HISPANIC)
master$MULTIRACIAL <- as.integer(master$MULTIRACIAL)
master$OTHER <- as.integer(master$OTHER)
master$PAC_ISLANDER <- as.integer(master$PAC_ISLANDER)
master$ASIAN <- as.integer(master$ASIAN)
master$NATIVE_AM <- as.integer(master$NATIVE_AM)
master$AFR_AM <- as.integer(master$AFR_AM)
master$WHITE <- as.integer(master$WHITE)

## master dataset with CntySt as factor
master$CntySt <- as.factor(master$CntySt)

## Unload unncessary objects
rm(list=setdiff(ls(), 'master'))

