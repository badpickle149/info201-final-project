## this is the file for getting the data from the API and data wrangling

## this function accepts a list "params" which is a list of the
## query parameters needed for a call to the college scorecard API
## returns a list of length 2 where the element "metadata" is a list
## describing the data and "results" is a dataframe of the results
get_dataset <- function(endpoint, params) {
  base <- "https://api.data.gov/ed/collegescorecard"
  uri <- paste(base, "v1/schools", endpoint, sep = "/")
  res <- httr::GET(uri, query=params)
  body <- content(res, "text")
  parsed_data <- fromJSON(body)
  return(parsed_data)
}
