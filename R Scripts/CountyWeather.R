# if you have not installed the 'countyweather' package, please run the following line:
# install.packages('countyweather')
using ('countyweather')
using ('ggplot2')

# Check if .Renviron file is present with NOAA Token
any(grepl("^\\.Renviron", list.files("~", all.files = TRUE)))

# Import FIPS file to parse out all county level FIPS codes