
## returns school name. Avoids "Operation not allowed without an active reactive context" error
get_school_name <- function(name) {
  name
}

function(input, output, session) {
  output$school_title_1 <- renderText(get_school_name(input$School1))
  ##output$school_summary_1 <- renderTable(## fill this part in with function to make a table)
  
  output$school_title_2 <- renderText(get_school_name(input$School2))
  ##output$school_summary_2 <- renderTable(## fill this part in with function to make a table)
}
