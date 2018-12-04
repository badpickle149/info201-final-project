source("processing.R")

## Returns a vector to be passed to "school_info" func.
## Avoids error "Operation not allowed without an active reactive context."
get_school_params <- function(options, type) {
  score_options <- c()
  treasury_options <- c()
  
  score_values <- c("GRAD_DEBT_MDN_SUPP", ##"GRAD_DEBTMDN10YR_SUPP",
                    "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS",
                    "INSTURL")
  treasury_values <- c("MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE")
  
  for (option in options) {
    if (is.element(option, score_values)) {
      score_options <- append(score_options, option, after = length(score_options))
    } else if (is.element(option, treasury_values)) {
      treasury_options <- append(treasury_options, option, after = length(score_options))
    }
  }
  
  if (type == "score") {
    ret_vect <- (append(score_options, "INSTNM", after = 0))
  } else if (type == "treasury") {
    ret_vect <- (append(treasury_options, "INSTNM", after = 0))
  }
  return(ret_vect) ## this is not expected behavior
}

## split a vector in two at an index
splitAt <- function(x, pos) unname(split(x, cumsum(seq_along(x) %in% pos)))

server <- function(input, output, session) {
  ## Show school 1 name
  output$school_title_1 <- renderText({
    input$School1
  }) 
  ## Show school 2 name
  school1_df <- reactive({
    df <- school_info(input$School1, 
                      get_school_params(input$SchoolOptions, "score"), 
                      get_school_params(input$SchoolOptions, "treasury")
    )
    names(df) <- name_key[names(df)]
    df_temp <- df[,-1]
    rownames(df_temp) <- df[,1]
    df <- t(df_temp)
    df <- cbind(Categories = rownames(df), df)
  })
  school2_df <- reactive({
    df <- school_info(input$School2, 
                      get_school_params(input$SchoolOptions, "score"), 
                      get_school_params(input$SchoolOptions, "treasury")
    )
    names(df) <- name_key[names(df)]
    df_temp <- df[,-1]
    rownames(df_temp) <- df[,1]
    df <- t(df_temp)
    df <- cbind(Categories = rownames(df), df)
  })
  output$school_comparison <- renderTable({
    school1 <- school1_df()
    school2 <- school2_df()
    df <- merge(school1, school2)
  }, striped = TRUE, bordered = TRUE, spacing = c("m"), colnames = TRUE)
  
  output$top_schools <- renderTable({
    df <- list_best_schools(input$states, input$num_rows)
    names(df) <- c("Colleges (Ranked by Return on Investment)", 
                   "Mean Earnings ($)", "Median Earnings ($)", 
                   "Median Graduation Debt ($)")
    return(df)
  }, striped = TRUE)

}
