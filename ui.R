library(shiny)

## setwd("C:/Users/picklewoman/Documents/INFO201/assignments/info201-final-project")

source("ui-processing.R")
ui <- fluidPage(
  titlePanel("Which School is Right For You?"),
  tabsetPanel(
    ## Compare Two Schools Tab
    tabPanel(
      "Compare Schools",
      titlePanel("Compare Two Schools"),
      sidebarLayout(
        sidebarPanel(
          ## widget to select first school
          selectizeInput(
            "School1", label = NULL, choices = schools, selected = "Harvard University",multiple = TRUE,
            options = list(placeholder = 'select a school', maxItems = 1, maxOptions = 8)
          ),
          ## widget to select second school
          selectizeInput(
            "School2", label = NULL, choices = schools, selected = "Boston College",multiple = TRUE,
            options = list(placeholder = 'select a school', maxItems = 1, maxOptions = 8)
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
            ## shows plots for earnings and debt after college respectfully
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
          ## slider widget let's users choose how many results to display
          sliderInput(
            "num_rows",
            "Number of Schools to Display",
            min = 1,
            max = 30,
            value = 10
          )
        ),

        mainPanel(
          ## outputs table using above widgets
          tableOutput("top_schools")
        )
      )
    ),
    tabPanel(
      "Our App",
      titlePanel("Our App"),
      p("Which School is Right For You is created for prospective university students who want
      to choose their future college or university with financial information in mind. We 
      provide relevant facts and figures about the financial aid, earnings, and debt for 
      over 7000 undergraduate schools in the United States."),
      
      strong("Our Data"),
      p("Up to date information is accessed from the United States Department of Education’s 
        College Scorecard, a public resource which includes financial data for all undergraduate 
        degree-granting institutions of higher education. We display and break down this data using
        our return on investment formula to rank the value of schools by state and make it easier 
        for you to make the right choice.")
      
    )
  )
)
