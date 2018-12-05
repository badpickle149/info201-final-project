# Processing the csv files

## this function accepts a list "params" which is a list of the
## query parameters needed for a call to the college scorecard API
## returns a list of length 2 where the element "metadata" is a list
## describing the data and "results" is a dataframe of the results

library(dplyr)

scorecard <- read.csv("data/Most-Recent-Cohorts-Scorecard-Elements.csv",
                      stringsAsFactors = FALSE, header = TRUE, sep = ",")
treasury <- read.csv("data/Most-Recent-Cohorts-Treasury-Elements.csv",
                     stringsAsFactors = FALSE, header = TRUE, sep = "," )

checkbox_choice_values <- c("GRAD_DEBT_MDN_SUPP", ##"GRAD_DEBTMDN10YR_SUPP",
                            "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS",
                            "INSTURL", "MN_EARN_WNE_P10", "UNEMP_RATE",
                            "POVERTY_RATE")
name_key <- c(INSTNM = "College",
              GRAD_DEBT_MDN_SUPP = "Median Total Grad Debt",
              MD_EARN_WNE_P10 = "Median Earnings after Graduation",
              PCTFLOAN = "% Students Receiving Federal Loan",
              PCTPELL = "% Students Receiving Pell Grant",
              UGDS = "Number of Undergraduates",
              INSTURL = "School Website Link",
              MN_EARN_WNE_P10 = "Mean Earnings After College",
              UNEMP_RATE = "Unemployment Rate of Students After Graduation",
              POVERTY_RATE = "Poverty Rate of Students After Graduation")

# Input name of school, and two vectors with the name of criteria to view. Vector 1 is criteria from
# the scorecard csv , vector 2 from the treasuary csv. Returns a dataframe with relevant info
school_info <- function(name, vector1, vector2) {
  score <- scorecard %>% filter(INSTNM == name) %>%
    select_(.dots = vector1)
  treas <- treasury %>% filter(INSTNM == name) %>%
    select_(.dots = vector2)
  left_join(score, treas, by = "INSTNM")
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
harvard <- school_info("Harvard University", c("INSTNM", "GRAD_DEBT_MDN_SUPP",
                                               "MD_EARN_WNE_P10", "PCTFLOAN",
                                               "PCTPELL", "UGDS", "INSTURL"),
                                             c("INSTNM", "MN_EARN_WNE_P10",
                                               "UNEMP_RATE", "POVERTY_RATE"))

list_best_schools <- function(selected_state, num_rows)  {
  treasury_min <- treasury %>% select(INSTNM, MN_EARN_WNE_INC1_P10,
                                      MN_EARN_WNE_INC2_P10,
                                      MN_EARN_WNE_INC3_P10,
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
  combined_min <- combined_min %>% distinct(INSTNM, MN_EARN_WNE_INC1_P10,
                                            MN_EARN_WNE_INC2_P10,
                                            MN_EARN_WNE_INC3_P10,
                                            MD_EARN_WNE_P10, UNEMP_RATE,
                                            STABBR, GRAD_DEBT_MDN_SUPP)
  combined_min <- combined_min %>% filter(STABBR == selected_state)
  combined_min <- combined_min %>% mutate(mean_total =
                        ((as.numeric(as.character(MN_EARN_WNE_INC1_P10)) +
                        as.numeric(as.character(MN_EARN_WNE_INC2_P10)) +
                         as.numeric(as.character (MN_EARN_WNE_INC3_P10))) / 3))
  combined_min <- combined_min %>% mutate(roi =
                            ((as.numeric(as.character(mean_total)) +
                            as.numeric(as.character(MD_EARN_WNE_P10))) /
                            (2 * as.numeric(as.character(GRAD_DEBT_MDN_SUPP)))))
  best_schools <- combined_min %>% select(INSTNM, mean_total, MD_EARN_WNE_P10,
                                          GRAD_DEBT_MDN_SUPP, roi)
  best_schools <- best_schools %>% arrange(desc(roi)) %>% head(num_rows)
  best_schools <- best_schools %>% select(INSTNM, mean_total,
                                          MD_EARN_WNE_P10, GRAD_DEBT_MDN_SUPP)
  return(best_schools)
}
