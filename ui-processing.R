## read in data
data <- read.csv("data/Most-Recent-Cohorts-Scorecard-Elements.csv", stringsAsFactors = FALSE)

## list of all schools 
schools <- data$INSTNM

checkbox_choice_keys <- c("Median Total Grad Debt", "Median Monthly Payment", "Median Earnings after Graduation", 
                          "% Students Receiving Federal Loan", "% Students Receiving Pell Grant", 
                          "Number of Undergraduates", "School Website Link", ## split between scorecard and treasury 
                          "Mean Earnings After College", "Unemployment Rate of Students After Graduation", 
                          "Poverty Rate of Students After Graduation")

checkbox_choice_values <- c("GRAD_DEBT_MDN_SUPP", "GRAD_DEBTMDN10YR_SUPP", "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS", 
                            "INSTURL", "MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE")

names(checkbox_choice_values) <- checkbox_choice_keys
