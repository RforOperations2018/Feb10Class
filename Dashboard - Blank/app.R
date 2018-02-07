# Class 2
# Shiny Dashboard Example

library(shiny)
library(shinydashboard)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)

starwars <- starwars
starwars$films <- NULL
starwars$vehicles <- NULL
starwars$starships <- NULL
meltwars <- melt(starwars, id = "name")
meltwars$name <- as.factor(meltwars$name)

pdf(NULL)

header <- dashboardHeader(title = "Star Wars Dashboard",

                        )

sidebar <- dashboardSidebar(
  sidebarMenu(
   id = "tabs",

  )
)

body <- dashboardBody(
  tabItems(
    
  )
)

ui <- dashboardPage(header, sidebar, body)

# Define server logic
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)