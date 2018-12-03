# Processing the csv files

library(dplyr)

scorecard <- read.csv("data/Most-Recent-Cohorts-Scorecard-Elements.csv", stringsAsFactors = FALSE, header=TRUE, sep=",")
treasury <- read.csv("data/Most-Recent-Cohorts-Treasury-Elements.csv", stringsAsFactors = FALSE, header=TRUE, sep="," )

checkbox_choice_values <- c("GRAD_DEBT_MDN_SUPP", ##"GRAD_DEBTMDN10YR_SUPP", 
                            "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS", 
                            "INSTURL", "MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE")

# Input name of school, and two vectors with the name of criteria to view. Vector 1 is criteria from
# the scorecard csv , vector 2 from the treasuary csv. Returns a dataframe with relevant info
school_info <- function(name, vector1, vector2) {
  score <- scorecard %>% filter(INSTNM == name) %>%
    select_(.dots=vector1)
  treas <- treasury %>% filter(INSTNM == name) %>%
    select_(.dots=vector2)
  ret <- left_join(score, treas, by="INSTNM")
  return(ret)
}

replace_col_names <- function(df) {
  for (x in names(df)) {
    if (!is.na(match(x, checkbox_choice_values))) {
      index = match(x, checkbox_choice_values)
      if (length(fields) > 0) {
        append(checkbox_choice_values[[index]], fields, after = 0)
      } else {
        append(checkbox_choice_values[[index]], fields, after = 1)
      }
    }
  }
  names(df) <- fields
  return(df)
}

# Example call
harvard <- school_info("Harvard University", c("INSTNM", "GRAD_DEBT_MDN_SUPP", "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS", 
                                               "INSTURL"), 
                       c("INSTNM", "MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE"))


