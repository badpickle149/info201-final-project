## this script handles the serve output for the shiny app
## as well as some very minor dataframe reformatting

source("processing.R")

## this is the server function, which handles all of the app's output
server <- function(input, output) {
  error_msg_schools <- paste0(
    "Please select two schools to compare. ",
    "If you don't need a second school, ",
    "you can choose the same school again."
  )
  error_msg_options <- "Please select at least two options to compare."

  school1_df <- reactive({
    validate(
      need(input$School1, error_msg_schools),
      need(length(input$SchoolOptions) >= 2, error_msg_options)
    )
    df <- school_info(
      input$School1,
      get_school_params(input$SchoolOptions, "score"),
      get_school_params(input$SchoolOptions, "treasury")
    )
    names(df) <- name_key[names(df)]
    df_temp <- df[, -1]
    rownames(df_temp) <- df[, 1]
    df <- t(df_temp)
    df <- cbind(Categories = rownames(df), df)
  })
  school2_df <- reactive({
    validate(
      need(input$School2, error_msg_schools),
      need(length(input$SchoolOptions) >= 2, error_msg_options)
    )
    df <- school_info(
      input$School2,
      get_school_params(input$SchoolOptions, "score"),
      get_school_params(input$SchoolOptions, "treasury")
    )
    names(df) <- name_key[names(df)]
    df_temp <- df[, -1]
    rownames(df_temp) <- df[, 1]
    df <- t(df_temp)
    df <- cbind(Categories = rownames(df), df)
  })
  output$school_comparison <- renderTable({
    validate(
      need(school1_df(), error_msg_schools),
      need(school2_df(), error_msg_schools)
    )
    school1 <- school1_df()
    school2 <- school2_df()
    df <- merge(school1, school2)
  }, striped = TRUE, bordered = TRUE, spacing = c("m"), colnames = TRUE)

  output$top_schools <- renderTable({
    df <- list_best_schools(input$states, input$num_rows)
    names(df) <- c(
      "Colleges (Ranked by Return on Investment)",
      "Mean Earnings ($)", "Median Earnings ($)",
      "Median Graduation Debt ($)"
    )
    return(df)
  }, striped = TRUE)

  ## plot to compare earnings after graduating from each school
  output$plot_earnings <- renderPlot({
    validate(
      need(input$School1, error_msg_schools),
      need(input$School2, error_msg_schools)
    )
    graph_debt_vs_salary(input$School1, input$School2, "Earnings")
  })

  ## plot to compare debt after graduating from each school
  output$plot_debt <- renderPlot({
    validate(
      need(input$School1, error_msg_schools),
      need(input$School2, error_msg_schools)
    )
    graph_debt_vs_salary(input$School1, input$School2, "Debt")
  })
}
