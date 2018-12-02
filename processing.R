# Processing the csv files

library(dplyr)

scorecard <- read.csv("data/Most-Recent-Cohorts-Scorecard-Elements.csv", stringsAsFactors = FALSE, header=TRUE, sep=",")
treasury <- read.csv("data/Most-Recent-Cohorts-Treasury-Elements.csv", stringsAsFactors = FALSE, header=TRUE, sep="," )

# Input name of school, and two vectors with the name of criteria to view. Vector 1 is criteria from
# the scorecard csv , vector 2 from the treasuary csv. Returns a dataframe with relevant info
school_info <- function(name, vector1, vector2) {
  score <- scorecard %>% filter(INSTNM == name) %>%
    select_(.dots=vector1)
  treas <- treasury %>% filter(INSTNM == name) %>%
    select_(.dots=vector2)
  left_join(score, treas, by="INSTNM")
}

# Example call
harvard <- school_info("Harvard University", c("INSTNM", "GRAD_DEBT_MDN_SUPP", "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS", 
                                                           "INSTURL"), 
                       c("INSTNM", "MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE"))

