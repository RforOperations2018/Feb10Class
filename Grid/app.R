# Class 1
# In Class Examples - Grid

library(shiny)
library(reshape2)
library(dplyr)
library(plotly)
library(DT)

starwars <- starwars
starwars$films <- NULL
starwars$vehicles <- NULL
starwars$starships <- NULL
meltwars <- melt(starwars, id = "name")
meltwars$name <- as.factor(meltwars$name)

pdf(NULL)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Star Wars Grid"),
  fluidRow(
    column(4,
           wellPanel(
             selectInput("char_select",
                         "Characters:",
                         choices = levels(meltwars$name),
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
    dat <- subset(meltwars, name %in% input$char_select)
    ggplot(data = dat, aes(x = name, y = as.numeric(value), fill = name)) + geom_bar(stat = "identity")
  })
  output$table <- DT::renderDataTable({
    subset(starwars, name %in% input$char_select, select = c(name, height, mass, birth_year, homeworld, species))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)