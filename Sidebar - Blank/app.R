# In Class Examples - Sidebar

library(shiny)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)

starwars <- starwars
starwars$films <- as.character(starwars$films)
starwars$vehicles <- as.character(starwars$vehicles)
starwars$starships <- as.character(starwars$starships)
starwars$name <- as.factor(starwars$name)

pdf(NULL)

# Define UI
ui <- fluidPage(
  # Application title
  titlePanel("Star Wars Sidebar"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      
    ),
    
    # Output plot
    mainPanel(
      
    )
  )
)

# Define server logic
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)