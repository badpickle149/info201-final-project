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
          selectizeInput(
            "School1", label = NULL, choices = schools, selected = "Harvard University",multiple = TRUE,
            options = list(placeholder = 'select a school', maxItems = 1, maxOptions = 8)
          ),
          
          selectizeInput(
            "School2", label = NULL, choices = schools, selected = "Boston College",multiple = TRUE,
            options = list(placeholder = 'select a school', maxItems = 1, maxOptions = 8)
          ),
          
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
            textOutput("school_title_1"),
            tableOutput("school_summary_1"),
            textOutput("school_title_2"),
            tableOutput("school_summary_2")
            #plotOutput("plot_earnings"),
            #plotOutput("plot_debt")
          )
        )
      )
    ),

    ## Compare by state tab
    tabPanel(
      "Compare by State",
      titlePanel("Compare Schools by States"),
      sidebarLayout(

        sidebarPanel(
          selectInput(
            "states",
            "Select a State of Interest",
            choices = state.abb
          ),
          sliderInput(
            "num_rows",
            "Number of Schools to Display",
            min = 1,
            max = 30,
            value = 10
          )
        ),

        mainPanel(
          tableOutput("top_schools")
        )
      )
    )
  )
)
