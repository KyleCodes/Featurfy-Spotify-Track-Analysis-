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
  
  header$children[[3]]$children[[1]] <- NULL
  
  header$children[[3]]$children[[2]] <- NULL
  return(header)
}