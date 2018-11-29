library(shiny)

## setwd("C:/Users/picklewoman/Documents/INFO201/assignments/info201-final-project")

source("ui-processing.R")

ui <- fluidPage(
  
  tabsetPanel(
    
    ## Compare Schools Tab
    tabPanel("compare_schools", 
             sidebarLayout(
               sidebarPanel(
                 
                 selectizeInput(
                   "Schools", label = NULL, choices = , multiple = TRUE, 
                    options = list(placeholder = 'select a school', maxItems = 2, maxOptions = 8)
                   )
               ),
               mainPanel(
                 
               )
             )

           )
  )
  
)
