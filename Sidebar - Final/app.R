# Examples - Sidebar Final

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
  tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css"),
   # Application title
   titlePanel("Star Wars Sidebar"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      
      sidebarPanel(
         selectInput("char_select",
                     "Characters:",
                     choices = levels(starwars$name),
                     multiple = TRUE,
                     selectize = TRUE,
                     selected = c("Luke Skywalker", "Darth Vader", "Jabba Desilijic Tiure", "Obi-Wan Kenobi", "R2-D2", "Dexter Jettster")),
         downloadButton("downloadData", label = "Download Characterts")
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
    dat <- subset(starwars, name %in% input$char_select)
    ggplot(data = dat, aes(x = name, y = mass, fill = name)) + geom_bar(stat = "identity")
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('starwars-', Sys.Date(), '.csv', sep='')
    },
    content = function(name) {
      dat <- subset(starwars, name %in% input$char_select)
      write.csv(dat, name)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)