# In Class Examples - Grid

library(shiny)
library(reshape2)
library(dplyr)
library(plotly)
library(DT)

starwars <- starwars
starwars$films <- as.character(starwars$films)
starwars$vehicles <- as.character(starwars$vehicles)
starwars$starships <- as.character(starwars$starships)
starwars$name <- as.factor(starwars$name)

pdf(NULL)

# Define UI for application
ui <- fluidPage(
  titlePanel("Star Wars Grid"),
  fluidRow(
    column(4,
           wellPanel(
             selectInput("char_select",
                         "Characters:",
                         choices = levels(starwars$name),
                         multiple = TRUE,
                         selectize = TRUE,
                         selected = c("Luke Skywalker", "Darth Vader", "Jabba Desilijic Tiure", "Obi-Wan Kenobi", "R2-D2", "Dexter Jettster"))
           )       
    ),
    column(8,
           plotlyOutput("plot")
    )
  ),
  fluidRow(
    DT::dataTableOutput("table")
  )
)

# Define server logic
server <- function(input, output) {
  output$plot <- renderPlotly({
    dat <- subset(starwars, name %in% input$char_select)
    ggplot(data = dat, aes(x = name, y = mass, fill = name)) + geom_bar(stat = "identity")
  })
  output$table <- DT::renderDataTable({
    subset(starwars, name %in% input$char_select, select = c(name, height, mass, birth_year, homeworld, species))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)