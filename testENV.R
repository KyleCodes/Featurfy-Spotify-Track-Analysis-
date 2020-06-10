library(shiny)
library(shinydashboard)
source("header.R")

ui <- dashboardPage(
  header(),
  dashboardSidebar(
    sidebarSearchForm(
      textId = "artist_input",
      buttonId = "artist_search",
      label = "Enter an Artist",
      icon = NULL
    ),
    
    textOutput(
      outputId = "artist_result"
    )
  ),
  dashboardBody(
    
  ),
  title = "Featurefy",
  skin = "green"
)




# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$artist_result <- renderText(input$artist_input)
  
}
