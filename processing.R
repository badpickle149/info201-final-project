## this script reads in and processes the csv files
## and handles the majority of all data manipulation

library(dplyr)
library(ggplot2)
library(scales)

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

# Input name of school, and two vectors with the name of criteria to view. 
# Vector 1 is criteria from the scorecard csv, 
# vector 2 from the treasuary csv. Returns a dataframe with relevant info
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

# Takes in parameters of a selected states and how many rows the user 
# wants to output and returns a dataframe representing the schools 
# in a selected state that have the greatest return on investment.
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
}

## Returns a vector to be passed to "school_info" func.
get_school_params <- function(options, type) {
  score_options <- c()
  treasury_options <- c()
  
  score_values <- c(
    "GRAD_DEBT_MDN_SUPP", ## "GRAD_DEBTMDN10YR_SUPP",
    "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS",
    "INSTURL"
  )
  treasury_values <- c("MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE")
  
  for (option in options) {
    if (is.element(option, score_values)) {
      score_options <- append(score_options, option, 
                              after = length(score_options))
    } else if (is.element(option, treasury_values)) {
      treasury_options <- append(treasury_options, option, 
                                 after = length(score_options))
    }
  }
  
  if (type == "score") {
    ret_vect <- (append(score_options, "INSTNM", after = 0))
  } else if (type == "treasury") {
    ret_vect <- (append(treasury_options, "INSTNM", after = 0))
  }
  return(ret_vect)
}

## returns a plot of either Earnings for each school or Debt for each school
## use "option" param to specify Earnings or Debt
graph_debt_vs_salary <- function(school1, school2, option) {
  ## get debt and earning info from each school
  school1_data <- school_info(school1, c("INSTNM", "GRAD_DEBT_MDN_SUPP"), 
                              c("INSTNM", "MN_EARN_WNE_P10"))
  school2_data <- school_info(school2, c("INSTNM", "GRAD_DEBT_MDN_SUPP"), 
                              c("INSTNM", "MN_EARN_WNE_P10"))
  ## make one data frame. Makes plotting easier
  df <- rbind(school1_data, school2_data)
  ## change debt and earnings columns to "numeric" type
  df$GRAD_DEBT_MDN_SUPP <- as.numeric(df$GRAD_DEBT_MDN_SUPP)
  df$MN_EARN_WNE_P10 <- as.numeric(df$MN_EARN_WNE_P10)
  ## rename columns to more accessible names
  names(df) <- c("School Name", "Total Debt After Graduation ($)", 
                 "Earning/yr After Graduation ($)")
  if (option == "Debt") { ## plots a Debt comparison bar graph
    plot <- ggplot(data = df, aes(x = `School Name`, 
                                  y = `Total Debt After Graduation ($)`)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      geom_text(aes(label = `Total Debt After Graduation ($)`), vjust = 1.6, 
                color = "white", size = 6.0) +
      theme_minimal() + scale_y_continuous(labels = comma)
  } else { ## plots an Earnings comparison bar graph
    plot <- ggplot(data = df, aes(x = `School Name`, 
                                  y = `Earning/yr After Graduation ($)`)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      geom_text(aes(label = `Earning/yr After Graduation ($)`), 
                vjust = 1.6, color = "white", size = 6.0) +
      theme_minimal() + scale_y_continuous(labels = comma)
  }
  return(plot)
}
