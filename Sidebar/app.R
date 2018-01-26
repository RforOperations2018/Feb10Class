# Class 1
# In Class Examples - Sidebar

library(shiny)
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

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css"),
   # Application title
   titlePanel("Star Wars Sidebar"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      
      sidebarPanel(
         selectInput("char_select",
                     "Characters:",
                     choices = levels(meltwars$name),
                     multiple = TRUE,
                     selectize = TRUE,
                     selected = c("Luke Skywalker", "Darth Vader", "Jabba Desilijic Tiure", "Obi-Wan Kenobi", "R2-D2", "Dexter Jettster"))
      ),
      
      # Output plot
      mainPanel(
         plotlyOutput("plot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$plot <- renderPlotly({
    dat <- subset(meltwars, name %in% input$char_select)
    ggplot(data = dat, aes(x = name, y = as.numeric(value), fill = name)) + geom_bar(stat = "identity")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)