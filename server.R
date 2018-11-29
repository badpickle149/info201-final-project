

get_school_name <- function(name) {
  name
}

function(input, output, session) {
  output$school_title_1 <- renderText(get_school_name(input$School1))
  output$school_title_2 <- renderText(get_school_name(input$School2))
}
