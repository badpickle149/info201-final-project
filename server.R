source("processing.R")

## Returns name of school. Avoids error "Operation not allowed without an active reactive context."
get_school_name <- function(name) {
  name
}

## Returns a vector to be passed to "school_info" func.
## Avoids error "Operation not allowed without an active reactive context."
get_school_params <- function(options, type) {
  # split_options <- splitAt(input$SchoolOptions, 8)
  # score_options <- append(split_options[[1]],"INSTNM", after = 0)
  # treasury_options <- append(split_options[[2]],"INSTNM", after = 0)
  
  score_options <- c()
  treasury_options <- c()
  
  score_values <- c("GRAD_DEBT_MDN_SUPP", ##"GRAD_DEBTMDN10YR_SUPP", 
                    "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS", 
                    "INSTURL")
  
  treasury_values <- c("MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE")
  
  for (option in options) {
    if (is.element(option, score_values)) {
      score_options <- append(score_options, option, after = length(score_options))
    } else if (is.element(option, score_values)) {
      treasury_options <- append(treasury_options, option, after = length(score_options))
    }
  }
  
  if (type == "score") {
    return(append(score_options, "INSTNM", after = 0))
  } else if (type == "treasury") {
    return(append(treasury_options, "INSTNM", after = 0))
  }
  return(c("INSTNM")) ## this is not expected behavior
}

## split a vector in two at an index
splitAt <- function(x, pos) unname(split(x, cumsum(seq_along(x) %in% pos)))

server <- function(input, output, session) {
  
  output$school_title_1 <- renderText({
    name <- get_school_name(input$School1)
    return(name)
  }) ## Show School 1 name
  ## Show School 1 Data (nees work)

  output$school_summary_1 <-renderTable({
    df <- school_info(input$School1, 
                      get_school_params(input$SchoolOptions, "score"), 
                      get_school_params(input$SchoolOptions, "treasury")
                     )
    return(df)
  })
  ## Show school 2 name
  output$school_title_2 <- renderText({
      name <- get_school_name(input$School2)
      return(name)
    }) 
  ## Show School 2 Data (nees work)
  output$school_summary_2 <- renderTable({
    school_info(input$School2, 
                get_school_params(input$SchoolOptions, "score"), 
                get_school_params(input$SchoolOptions, "treasury")
                )
  })

}
