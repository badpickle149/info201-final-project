library(shiny)

## setwd("C:/Users/picklewoman/Documents/INFO201/assignments/info201-final-project")

source("ui-processing.R")

ui <- fluidPage(
  
  titlePanel("Which School is Right For You?"),
  tabsetPanel(
    
    ## Compare Schools Tab
    tabPanel("Compare Schools", 
             
             titlePanel("Compare Two Schools"),
             sidebarLayout(
               sidebarPanel(
                    
                     selectizeInput(
                       "School1", label = NULL, choices = schools, multiple = TRUE,
                        options = list(placeholder = 'select a school', maxItems = 1, maxOptions = 8)
                       ),
                     
                     selectizeInput(
                       "School2", label = NULL, choices = schools, multiple = TRUE,
                       options = list(placeholder = 'select a school', maxItems = 1, maxOptions = 8)
                     ),
                     
                     checkboxGroupInput("SchoolOptions", label = "Options", 
                                        choices = c("Median Total Grad Debt" -> "GRAD_DEBT_MDN_SUPP", 
                                                    "Median Monthly Payment" -> "GRAD_DEBTMDN10YR_SUPP",
                                                    "Median Earnings after Graduation" -> "MD_EARN_WNE_P10",
                                                    "% Students Receiving Federal Loan" -> "PCTFLOAN",
                                                    "% Students Receiving Pell Grant" -> "PCTPELL",
                                                    "Number of Undergraduates" -> "UGDS",
                                                    "School Website Link" -> "INSTURL")
              
                     )
                   ),
               
               mainPanel(
                 fluidRow(
                   
                   ## Output for School 1
                   column(1,
                     textOutput("school_title_1"),
                     tableOutput("school_summary_1")
                   ),
                   
                   ## Output for School 2
                   column(3,
                     textOutput("school_title_2"),
                     tableOutput("school_summary_2")
                   )
                 )
               )
             )

           )
    
    # tabsetPanel("Compare by State",
    #   titlePanel("Compare Schools by States"),
    #   sidebarLayout(
    #     
    #     sidebarPanel(
    #       
    #     ),
    #     
    #     mainPanel(
    #       
    #     )
    #   )
    # )
  )
  
)
