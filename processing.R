library(dplyr)

scorecard <- read.csv("data/Most-Recent-Cohorts-Scorecard-Elements.csv", stringsAsFactors = FALSE, header=TRUE, sep=",")
treasury <- read.csv("data/Most-Recent-Cohorts-Treasury-Elements.csv", stringsAsFactors = FALSE, header=TRUE, sep="," )

# For scorecard data. Input school name and vector of criteria to view
school_info_scor <- function(name, vector) {
  df <- scorecard %>% filter(INSTNM == name) %>%
  select_(.dots=vector)
}

# For treasury data. Input school name and vector of criteria to view
school_info_treas <- function(name, vector) {
  df <- treasury %>% filter(INSTNM == name) %>%
    select_(.dots=vector)
}

# Example call of school_info
harvard_info_score <- school_info_scor("Harvard University", c("INSTNM", "GRAD_DEBT_MDN_SUPP", "MD_EARN_WNE_P10"))
harvard_info_treas <- school_info_treas("Harvard University", c("INSTNM", "MN_EARN_WNE_P10", "MD_EARN_WNE_P10"))

