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
                     )
                   ),
               
               mainPanel(
                 fluidRow(
                   column(1,
                     textOutput("school_title_1")
                   ),
                   column(2,
                     textOutput("school_title_2")
                   )
                 )
               )
             )
             
             ## Old layout
             # sidebarLayout(
             #   sidebarPanel(
             # 
             #     selectizeInput(
             #       "Schools", label = NULL, choices = schools, multiple = TRUE,
             #        options = list(placeholder = 'select a school', maxItems = 2, maxOptions = 8)
             #       )
             #   ),
             #   mainPanel(
             # 
             #   )
             # )

           )
  )
  
)
