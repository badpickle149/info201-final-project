library(shiny)

##source("processing.R")

ui <- fluidPage(
  
  tabsetPanel(
    
    ## Compare Schools Tab
    tabPanel("compare_schools", 
             sidebarLayout(
               sidebarPanel(
                 selectizeInput(
                   "schools", label = NULL, choices = state.name, multiple = TRUE, 
                    options = list(placeholder = 'select a school', maxItems = 2, maxOptions = 8)
                   )
               ),
               mainPanel(
                 
               )
             )
             )
  )
)