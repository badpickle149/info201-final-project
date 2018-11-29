## this is the file for getting the data from the API and data wrangling

## this function accepts a list "params" which is a list of the
## query parameters needed for a call to the college scorecard API
## returns a list of length 2 where the element "metadata" is a list
## describing the data and "results" is a dataframe of the results

library(httr)
library(jsonlite)
library(dplyr)

key = "WxdDlU0dc1U3VPeVJ0Ke2G7QSTPENsSMAfnFKVHV"

get_dataset <- function(params) {
  base <- "https://api.data.gov/ed/collegescorecard"
  uri <- paste(base, "v1/schools", sep = "/")
  res <- httr::GET(uri, query=params)
  body <- content(res, "text")
  parsed_data <- fromJSON(body)
  return(parsed_data)
}

# returns the data for a specific school
data_school <- function(school){
  params <- list(school.name = school, api_key = key)
  data <- get_dataset(params)
  data <- data$results
}

compare_schools <- function(school1, school2) {
  school1_data <- data_school(school1)
  school2_data <- data_school(school2)
  school1_avg_price <- school1_data$latest$cost$avg_net_price.overall
  school2_avg_price <- school2_data$latest$cost$avg_net_price.overall
  
  combined_data <- inner_join(school1_avg_price, school2_avg_price, by = avg_net_price.overall)
}

boston <- data_school("boston college")
boston_admission_details <- head(boston$latest$admissions, 100)
boston_cost_details <- boston$`2012`$cost
boston_financial_aid <- boston$latest$aid
school_sum <- summary(boston_cost_details %>% head(1))

compare <- compare_schools("boston college", "harvard university")
