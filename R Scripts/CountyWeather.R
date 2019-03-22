# if you have not installed the 'countyweather' package, please run the following line:
# install.packages('countyweather')
library('countyweather')
library('ggplot2')

# Check if .Renviron file is present with NOAA Token
#any(grepl("^\\.Renviron", list.files("~", all.files = TRUE)))

options("noaakey" = Sys.getenv("noaakey"))

# Import FIPS file to parse out all county level FIPS codes
FIPS <- as.data.frame(read.csv('../Data/FIPS.csv', header = FALSE, sep = ','))
vineet <- daily_fips(fips = "12086", date_min = "2018-08-01", 
                            date_max = "2019-01-31", var=c('name', 'prcp'))
