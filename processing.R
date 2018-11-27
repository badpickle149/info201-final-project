## this is the file for getting the data from the API and data wrangling

## this function accepts a list "params" which is a list of the
## query parameters needed for a call to the college scorecard API
## returns a list of length 2 where the element "metadata" is a list
## describing the data and "results" is a dataframe of the results

library(httr)
library(jsonlite)

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
  get_dataset(params)
}

boston <- data_school("boston college")


