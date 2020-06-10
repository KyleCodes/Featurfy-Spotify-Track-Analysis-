header <- function() {
  header <- dashboardHeader()
  anchor <- tags$a(
    href='http://www.spotify.com',
    tags$img(src='https://broadwaydollamusic.files.wordpress.com/2012/09/6274-spotify-logo-horizontal-white-rgb.png', height='40'),
    ''
  )
  
  header$children[[2]]$children <- tags$div(
    tags$head(tags$style(HTML(".spotify_logo { background-color: transparent}"))),
    anchor,
    class = 'spotify_logo')
  
  header$children[[3]]$children[[1]] <- tags$div(style = "padding-left: 40px",
                                                 actionButton('XvY', 'X Versus Y', style = "height: 50px; font-family: Fixedsys; background-color: #121212; border: 0; color: #ddd; border-bottom: 3px solid; border-color:#ddd"),
                                                 actionButton('XvZ', 'X Versus Z', style = "height: 50px; font-family: Fixedsys; background-color: #121212; border: 0; color: #ddd; border-bottom: 3px solid; border-color:#ddd"),
                                                 actionButton('XvA', 'X Versus A', style = "height: 50px; font-family: Fixedsys; background-color: #121212; border: 0; color: #ddd; border-bottom: 3px solid; border-color:#ddd"),
                                                 actionButton('XvB', 'X Versus B', style = "height: 50px; font-family: Fixedsys; background-color: #121212; border: 0; color: #ddd; border-bottom: 3px solid; border-color:#ddd")
  )
  header$children[[3]]$children[[2]] <- NULL
  return(header)
}