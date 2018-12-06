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
      
      h3("Our Data"),
      p("Up to date information is accessed from the United
         States Department of Education’s
         College Scorecard, a public resource which includes
         financial data for all undergraduate
         degree-granting institutions of higher education.
         We display and break down this data using
         our return on investment formula to rank the
         value of schools by state and make it easier
         for you to make the right choice."),
      
      h3("Questions Addressed"),
      p("Our target audience is all prospective US college students.
        Our app provides an easy way to compare the financial
        cost and benefit of different colleges in the US. 
        The following are questions you may have that are answered
        in our app:"),
      strong("What percent of students at [name] college receive federal loans,
             and how does this compare to other colleges I'm interested in?"),
      p("If you navigate to our first tab, you can choose the 
        % students receiving federal loans option and choose two colleges
        to compare. You may also be interested in the percentage of 
        students who receive the Pell Grant."),
      strong("How do two colleges I am considering compare to each other
             in terms of average earnings and debt after graduation?"),
      p("You can check this directly in our first tab by selecting
        the corresponding categories in the sidebar and the schools
        you are interested in, or even if you just choose two schools
        you are interested in, there are two bar graphs comparing
        the mean earnings 10 years after enrollment for the two schools
        and the mean debt after graduation for the two schoolsrespectively."),
      strong("What colleges in my state have the best return on investment?"),
      p("On our second tab, you can choose any US state and see a table
        of colleges in that state (that have chosen to release the relevant
        information) ranked by their return on investment. You can
        also compare average earnings and debt after graduation directly.
        See that tab for more details on how the ranking is calculated."),
      h3("Our Team"),
      p("Ann Shan, Ryan Tucker, Kevin Weng, Thomas Kakatsakis")
      
      
  
    )
  )
)
