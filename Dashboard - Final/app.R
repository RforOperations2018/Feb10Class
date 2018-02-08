# Shiny Dashboard Example with Reactive Functions

library(shiny)
library(shinydashboard)
library(reshape2)
library(dplyr)
library(plotly)
library(shinythemes)

starwars <- starwars
starwars$films <- as.character(starwars$films)
starwars$vehicles <- as.character(starwars$vehicles)
starwars$starships <- as.character(starwars$starships)
starwars$name <- as.factor(starwars$name)
starwars$bmi <- starwars$mass / ((starwars$height / 100)^2)

pdf(NULL)

header <- dashboardHeader(title = "Star Wars Dashboard",
                          dropdownMenu(type = "notifications",
                                       notificationItem(text = "5 escape pods deployed", 
                                                        icon = icon("space-shuttle"))
                          ),
                          dropdownMenu(type = "tasks", badgeStatus = "success",
                                       taskItem(value = 110, color = "green",
                                                "Midichlorians")
                          ),
                          dropdownMenu(type = "messages",
                                       messageItem(
                                         from = "Princess Leia",
                                         message = HTML("Help Me Obi-Wan Kenobi! <br> You're my only hope."),
                                         icon = icon("exclamation-circle"))
                          )
                        )

sidebar <- dashboardSidebar(
  sidebarMenu(
   id = "tabs",
   menuItem("Plot", icon = icon("bar-chart"), tabName = "plot"),
   menuItem("Table", icon = icon("table"), tabName = "table", badgeLabel = "new", badgeColor = "green"),
   selectInput("char_select",
               "Characters:",
               choices = levels(starwars$name),
               multiple = TRUE,
               selectize = TRUE,
               selected = c("Luke Skywalker", "Darth Vader", "Jabba Desilijic Tiure", "Obi-Wan Kenobi", "R2-D2", "Dexter Jettster")),
   HTML("<center>"), downloadButton("downloadData", label = "Download Characterts"), HTML("</center>")
  )
)

body <- dashboardBody(tabItems(
  tabItem("plot",
          fluidRow(
            infoBoxOutput("mass"),
            valueBoxOutput("height")
          ),
          fluidRow(
            tabBox(title = "Plots",
                   width = 12,
                   tabPanel("Mass", plotlyOutput("plot_mass")),
                   tabPanel("BMI", plotlyOutput("plot_bmi")))
            )
          ),
  tabItem("table",
          fluidPage(
            box(title = "Selected Character Stats", DT::dataTableOutput("table"), width = 12))
          )
))

ui <- dashboardPage(header, sidebar, body)

# Define server logic
server <- function(input, output) {
  # Star Wars Reactive Function
  swInput <- reactive({
    subset(starwars, name %in% input$char_select)
  })
  output$plot_mass <- renderPlotly({
    dat <- swInput()
    ggplotly(ggplot(data = dat, aes(x = name, y = mass, fill = name)) + geom_bar(stat = "identity"), tooltip = c("x", "y"))
  })
  output$plot_bmi <- renderPlotly({
    dat <- swInput()
    ggplot(data = dat, aes(x = mass, y = height, size = bmi, colour = name)) + geom_point()
  })
  output$table <- DT::renderDataTable({
    sw <- swInput()
    subset(sw, select = c(name, height, mass, birth_year, homeworld, species))
  })
  output$mass <- renderInfoBox({
    sw <- swInput()
    num <- round(mean(sw$mass, na.rm = T), 2)
    
    infoBox("Avg Mass", value = num, subtitle = paste(nrow(sw), "characters"), icon = icon("balance-scale"), color = "purple")
  })
  output$height <- renderValueBox({
    sw <- swInput()
    num <- round(mean(sw$height, na.rm = T), 2)
    
    valueBox(subtitle = "Avg Height", value = num, icon = icon("sort-numeric-asc"), color = "green")
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      paste('starwars-', Sys.Date(), '.csv', sep='')
    },
    content = function(name) {
      sw <- swInput()
      write.csv(sw, name)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)