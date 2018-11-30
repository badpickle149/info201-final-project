source("processing.R")

## Returns name of school. Avoids error "Operation not allowed without an active reactive context."
get_school_name <- function(name) {
  name
}

## Returns a vector to be passed to "school_info" func.
## Avoids error "Operation not allowed without an active reactive context."
get_school_params <- function(input) {
  append(input$SchoolOptions, "INSTNM", after = 0)
}

function(input, output, session) {
  
  output$school_title_1 <- renderText(get_school_name(input$School1)) ## Show School 1 name
  ## Show School 1 Data (nees work)
  output$school_summary_1 <-renderDataTable(school_info(input$School1, 
                                                        get_school_params(input), c("placeholder")))
  
  output$school_title_2 <- renderText(get_school_name(input$School2)) ## Show school 2 name
  ## Show School 2 Data (nees work)
  output$school_summary_2 <- renderDataTable(school_info(input$School2, 
                                                         get_school_params(input), c("placeholder")))
}
