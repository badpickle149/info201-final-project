## this is the file for getting the data from the API and data wrangling

## this function accepts a list "params" which is a list of the
## query parameters needed for a call to the college scorecard API
## returns a list of length 2 where the element "metadata" is a list
## describing the data and "results" is a dataframe of the results

library(dplyr)

scorecard <- read.csv("./data/Most-Recent-Cohorts-Scorecard-Elements.csv")
treasury <- read.csv("./data/Most-Recent-Cohorts-Treasury-Elements.csv")

find_school <- function(name)   {
  scorecard %>% filter(name)
}

list_best_schools <- function(selected_state)  {
  treasury_min <- treasury %>% select(INSTNM, MN_EARN_WNE_INC1_P10, 
                                      MN_EARN_WNE_INC2_P10, MN_EARN_WNE_INC3_P10,
                                      UNEMP_RATE, MD_EARN_WNE_P10)
  scorecard_min <- scorecard %>% select(INSTNM, STABBR, GRAD_DEBT_MDN_SUPP)
  combined_min <- full_join(treasury_min, scorecard_min, by = "INSTNM")
  combined_min <- combined_min %>%  filter(MN_EARN_WNE_INC1_P10 != "NULL" & 
                                             MN_EARN_WNE_INC1_P10 != "PrivacySuppressed" &
                                             MN_EARN_WNE_INC2_P10 != "NULL" &
                                             MN_EARN_WNE_INC2_P10 != "PrivacySuppressed" &
                                             MN_EARN_WNE_INC3_P10 != "NULL" &
                                             MN_EARN_WNE_INC3_P10 != "PrivacySuppressed" &
                                             UNEMP_RATE != "NULL" &
                                             UNEMP_RATE != "PrivacySuppressed" &
                                             MD_EARN_WNE_P10 != "NULL" &
                                             MD_EARN_WNE_P10 != "PrivacySuppressed" &
                                             GRAD_DEBT_MDN_SUPP != "NULL" &
                                             GRAD_DEBT_MDN_SUPP != "PrivacySuppressed")
  combined_min <- combined_min %>% distinct(INSTNM, MN_EARN_WNE_INC1_P10, MN_EARN_WNE_INC2_P10,
                                            MN_EARN_WNE_INC3_P10, MD_EARN_WNE_P10, UNEMP_RATE,
                                            STABBR, GRAD_DEBT_MDN_SUPP)
  combined_min <- combined_min %>% filter(STABBR == selected_state)
  combined_min <- combined_min %>% mutate(mean_total = ((as.numeric(as.character(MN_EARN_WNE_INC1_P10)) +
                                                        as.numeric(as.character(MN_EARN_WNE_INC2_P10)) +
                                                        as.numeric(as.character(MN_EARN_WNE_INC3_P10))) / 3))
  combined_min <- combined_min %>% mutate(roi = ((as.numeric(as.character(mean_total)) + 
                                                 as.numeric(as.character(MD_EARN_WNE_P10))) / 
                                                 (2 * as.numeric(as.character(GRAD_DEBT_MDN_SUPP)))))
  best_schools <- combined_min %>% select(INSTNM, mean_total, MD_EARN_WNE_P10, GRAD_DEBT_MDN_SUPP, roi)
  best_schools <- best_schools %>% arrange(desc(roi)) %>% head(8)
  return(best_schools)
}
