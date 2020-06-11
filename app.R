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
source("data_pipeline.R")
source("global.R")


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
                choices = artist_names,
                selected = "---",
                multiple = FALSE,
                width = "100%"
            ),
            
            textOutput(
                outputId = "dummy"
            ),
            
            style = "background-color: #111111; margin: 4px"
        ),
        
        wellPanel(
            selectInput(
                inputId = "analysis_selector",
                label = "Click on the albums to analyze",
                choices = album_names,
                selected = "all",
                multiple = TRUE,
                width = "100%",
            ), 
            
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
        
        tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
        

    
        fluidRow(
            # energy histogram
            column(
                width = 2,

                plotOutput(
                    outputId = "energy_hist"
                )
            ),

            # dance histogram
            column(
                width = 2,

                plotOutput(
                    outputId = "dance_hist"
                )
            ),

            # valence histogram
            column(
                width = 2,

                plotOutput(
                    outputId = "valence_hist"
                )
            ),

            # tempo histogram
            column(
                width = 2,

                plotOutput(
                    outputId = "tempo_hist"
                )
            ),

            # speech histogram
            column(
                width = 2,

                plotOutput(
                    outputId = "speech_hist"
                )
            ),

            # instrumental histogram
            column(
                width = 2,

                plotOutput(
                    outputId = "instrumental_hist"
                )
            ),
        ),

        fluidRow(

            # word bubble text mining diagram
            column(
                width = 5,

                plotOutput(
                    outputId = "text_mine"
                )
            ),

            # radio chart
            column(
                width = 5,

                plotOutput(
                    outputId = "radio_chart"
                ),

                offset = 2
            )
        )
        
    ),
    title = "Featurefy"
)




# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    output$dummy <- renderText(input$artist_input)
    
    
    output$energy_hist <- renderPlot(plot_energy())
    output$dance_hist <- renderPlot(plot_dance())
    output$valence_hist <- renderPlot(plot_valence())
    output$tempo_hist <- renderPlot(plot_tempo())
    output$speech_hist <- renderPlot(plot_speech())
    output$instrumental_hist <- renderPlot(plot_instrum())
    
    # output$text_mine <- renderPlot(hist(rnorm(100)))
    output$radio_chart <- renderPlot(plot_dance_vs_energy())
        
}


# Run the application 
shinyApp(ui = ui, server = server)


