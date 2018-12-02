source("processing.R")

## Returns name of school. Avoids error "Operation not allowed without an active reactive context."
get_school_name <- function(name) {
  name
}

## Returns a vector to be passed to "school_info" func.
## Avoids error "Operation not allowed without an active reactive context."
get_school_params <- function(input, type) {
  # split_options <- splitAt(input$SchoolOptions, 8)
  # score_options <- append(split_options[[1]],"INSTNM", after = 0)
  # treasury_options <- append(split_options[[2]],"INSTNM", after = 0)
  
  score_options <- c()
  treasury_options <- c()
  
  score_values <- c("GRAD_DEBT_MDN_SUPP", ##"GRAD_DEBTMDN10YR_SUPP", 
                      "MD_EARN_WNE_P10", "PCTFLOAN", "PCTPELL", "UGDS", 
                      "INSTURL")
  
  treasury_values <- c("MN_EARN_WNE_P10", "UNEMP_RATE", "POVERTY_RATE")
  
  lapply(input$SchoolOptions, function(x) {
    if (x %in% score_values) {
      score_options <- append(score_options, x, after = 1)
    } else if (x %in% treasury_values) {
      treasury_options <- append(treasury_options, x, after = 1)
    }
  })
  
  if (type == "score") {
    return(append(score_options, "INSTNM", after = 0))
  } else if (type == "treasury") {
    return(append(treasury_options, "INSTNM", after = 0))
  }
}

## split a vector in two at an index
splitAt <- function(x, pos) unname(split(x, cumsum(seq_along(x) %in% pos)))

function(input, output, session) {
  
  output$school_title_1 <- renderText(get_school_name(input$School1)) ## Show School 1 name
  ## Show School 1 Data (nees work)
  output$school_summary_1 <-renderTable(school_info(input$School1, 
                                                        get_school_params(input, "score"), 
                                                    get_school_params(input, "treasury")))
  
  output$school_title_2 <- renderText(get_school_name(input$School2)) ## Show school 2 name
  ## Show School 2 Data (nees work)
  output$school_summary_2 <- renderTable(school_info(input$School2, 
                                                     get_school_params(input, "score"), 
                                                     get_school_params(input, "treasury")))
}
