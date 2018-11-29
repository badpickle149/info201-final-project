## this is the file for getting the data from the API and data wrangling

## this function accepts a list "params" which is a list of the
## query parameters needed for a call to the college scorecard API
## returns a list of length 2 where the element "metadata" is a list
## describing the data and "results" is a dataframe of the results

library(dplyr)

scorecard <- read.csv("data/Most-Recent-Cohorts-Scorecard-Elements.csv", stringsAsFactors = FALSE, header=TRUE, sep=",")

# Input school name and vector of criteria to view
school_info <- function(name, vector) {
  scorecard %>% filter(INSTNM == name) %>%
  select_(.dots=vector)
}

# Example call of school_info
harvard_info <- school_info("Harvard University", c("INSTNM", "GRAD_DEBT_MDN_SUPP", "MD_EARN_WNE_P10"))

