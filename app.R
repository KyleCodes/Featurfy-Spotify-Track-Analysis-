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
library(httr)


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
                inputId = "go_button",
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
            
            
            style = "background-color: #111111; margin: 4px"
        ),
        
        wellPanel(
            selectInput(
                inputId = "analysis_selector",
                label = "Click on the albums to analyze",
                choices = album_names,
                selected = album_names[3],
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

                HTML("<span><br><br>Description <br><br> This Web app accesses 
                     Spotify's API and pulls every album - then every single track by the
                     artist A$ap Rocky. Spotify provides a rich bounty of information
                     about its songs. For example, they provide features such as tempo,
                     danceability, valence (happiness), energy, etc. In total, there are 18
                     categories provided</span><br><br>Data Pipeline<br><br>
                     Search request of an artist -> API returns artist id -> request all albums
                     corresponding to artistID -> API returns list of album ids -> request all
                     tracks and their enhanced analysis features belonging to each album -> API
                     returns information for each track -> this web app performs aggregate data analysis
                     <br><br>Issues<br><br>This is currently hard coded to only retrieve the discography
                     of a single artist. I was not able to figure out reactive values to take
                     user input")
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
    
    # ntext <- eventReactive(input$goButton, {
    #     input$artist_input
    # })
    
    # q <- reactive(input$go_button$value)
    # 
    # artist_ress <- reactiveValues(retrieve_artists(q))
    # 
    
    # observe({
    #     ntext
    #     updateSelectInput(
    #         session,
    #         "artist_selector",
    #         artist_ress$results = retrieve_artists(ntext)
    #     )
    # })
    
    output$energy_hist <- renderPlot(plot_energy())
    output$dance_hist <- renderPlot(plot_dance())
    output$valence_hist <- renderPlot(plot_valence())
    output$tempo_hist <- renderPlot(plot_tempo())
    output$speech_hist <- renderPlot(plot_speech())
    output$instrumental_hist <- renderPlot(plot_instrum())
    
    output$radio_chart <- renderPlot(plot_dance_vs_energy())
        
}


# Run the application 
shinyApp(ui = ui, server = server)


