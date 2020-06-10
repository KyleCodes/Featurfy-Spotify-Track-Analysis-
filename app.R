#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
source("header.R")

clientID <- "7d4e98d5926f47fd887b33c0db094c72"
clientSecret <- "5274969d76bb4006964b92076acc6194"

ui <- dashboardPage(
    skin = "green",
    header(),
    dashboardSidebar(
        
        wellPanel(
            textInput(
                inputId = "artist_input",
                label = "Search for an Artist",
                value = "",
                width = "100%",
                placeholder = "ex: The Beatles"
            ),
            
            actionButton(
                inputId = "search_artists",
                label = "Search",
                width = "40%"
            ),
            
            style = "background-color: #111111; margin: 4px"
        ),
        
        wellPanel(
            selectInput(
                inputId = "artist_selector",
                label = "Confirm the artist you are looking for",
                choices = c("---", "neuh1", "neuh2", "neuh3"),
                selected = "---",
                multiple = FALSE,
                width = "100%"
            ),
            
            style = "background-color: #111111; margin: 4px"
        ),
        
        wellPanel(
            selectInput(
                inputId = "analysis_selector",
                label = "Click on the albums to analyze",
                choices = c("all", "neuh1", "neuh2", "neuh3"),
                selected = "all",
                multiple = TRUE,
                width = "100%",
            ),
            
            style = "background-color: #111111; margin: 4px"
        ),
        
        wellPanel(
            actionButton(
                inputId = "submit_button",
                label = "Analyze!",
                width = "80%"
            ),
            style = "background-color: #111111; margin: 4px"
        ),
        
        wellPanel(

            
            tags$img(
                src = "rocky.jpg",
                width = 200,
                height = 200
            ),
            
            style = "background-color: #111111; margin: 4px"
        )
    ),
    dashboardBody(
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css"))
    ),
    title = "Featurefy"
)




# Define server logic required to draw a histogram
server <- function(input, output) {
    

    
}


# Run the application 
shinyApp(ui = ui, server = server)




# get a list of artist ids
#res = search_spotify(q = "asap", type = "artist", market = NULL, limit = 10, offset = 0, include_external = NULL, authorization = token, include_meta_info = FALSE)



