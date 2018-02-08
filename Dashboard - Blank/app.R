# Shiny Dashboard Example

library(shiny)
library(shinydashboard)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)
library(DT)
library(purrr)

starwars <- starwars
starwarrs <- flatten(starwars)

pdf(NULL)

header <- dashboardHeader(title = "Star Wars Dashboard")

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