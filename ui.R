## this script handles the user interface of our shiny app

library(shiny)

source("ui-processing.R")

state_ranking_descr <- paste0("This table shows the schools of your selected ",
                             "state ranked by average return on investment. ",
                             "In this case return on investment is calculated",
                             " by taking the average earnings of a graduate ",
                             "after 10 years and dividing that by the ",
                             "average debt at graduation.")

ui <- fluidPage(
  titlePanel("Which School is Right For You?"),
  tabsetPanel(
    ## Compare Two Schools Tab
    tabPanel(
      "Compare Schools",
      titlePanel("Compare Two Schools"),
      sidebarLayout(
        sidebarPanel(
          ## widget to select school 1
          selectizeInput(
            "School1", label = NULL, choices = schools, selected =
              "Harvard University", multiple = TRUE,
            options = list(placeholder = 'select a school',
                           maxItems = 1, maxOptions = 8)
          ),
          ## widget to select school 2
          selectizeInput(
            "School2", label = NULL, choices = schools, selected =
              "Boston College", multiple = TRUE,
            options = list(placeholder = 'select a school',
                           maxItems = 1, maxOptions = 8)
          ),
          ## widget to select categories to be shown
          checkboxGroupInput(
            "SchoolOptions",
            label = "Options",
            choiceNames = checkbox_choice_keys,
            choiceValues = checkbox_choice_values,
            selected = checkbox_choice_values
          )
        ),
        mainPanel(
          fluidRow(
            ## outputs comparison table using information from above widgets
            tableOutput("school_comparison"),
            ## shows plots for earnings and debt after college respectively
            ## uses two school selector widgets to show plots
            plotOutput("plot_earnings"),
            plotOutput("plot_debt")
          )
        )
      )
    ),

    ## Compare by state tab
    tabPanel(
      "Return on Investment by State",
      titlePanel("Compare Schools by States"),
      sidebarLayout(

        sidebarPanel(
          ## select a state widget
          selectInput(
            "states",
            "Select a State of Interest",
            choices = state.abb
          ),
          ## slider widget lets users choose how many results to display
          sliderInput(
            "num_rows",
            "Number of Schools to Display",
            min = 1,
            max = 30,
            value = 10
          ),
          ## short description of how table is ranked for users
          helpText(state_ranking_descr)
        ),

        mainPanel(
          tableOutput("top_schools")
        )
      )
    ),
    tabPanel(
      "Our App",
      titlePanel("Our App"),
      p("Which School is Right For You is created for prospective
         university students who want to choose their future
         college or university with financial information in mind. We
         provide relevant facts and figures about the financial aid,
         earnings, and debt for over 7000 undergraduate schools
         in the United States."),
      
      strong("Our Data"),
      p("Up to date information is accessed from the United
         States Department of Education’s
         College Scorecard, a public resource which includes
         financial data for all undergraduate
         degree-granting institutions of higher education.
         We display and break down this data using
         our return on investment formula to rank the
         value of schools by state and make it easier
         for you to make the right choice.")
  
    )
  )
)
