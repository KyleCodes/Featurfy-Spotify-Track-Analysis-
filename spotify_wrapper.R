library(dplyr)
library(httr)
library(jsonlite)

##########################################################################################

# Retrieves app token for communicating with spotify's servers
get_spotify_access_token <- function() {
  
  client_id <- "7d4e98d5926f47fd887b33c0db094c72"
  client_secret <- "5274969d76bb4006964b92076acc6194"
  
  post <- RETRY('POST', 'https://accounts.spotify.com/api/token',
                accept_json(), authenticate(client_id, client_secret),
                body = list(grant_type = 'client_credentials'),
                encode = 'form', httr::config(http_version = 2)) %>% content
  
  if (!is.null(post$error)) {
    stop(str_glue('Could not authenticate with given Spotify credentials:\n\t{post$error_description}'))
  }
  
  access_token <- post$access_token
  
  return(access_token)
}

get_spotify_access_token()


##########################################################################################

# Get Artists from the entered keyword(s)
get_artists <- function(ids, authorization = get_spotify_access_token(), include_meta_info = TRUE) {
  
  base_url <- 'https://api.spotify.com/v1/artists'
  
  params <- list(
    ids = paste(ids, collapse = ','),
    access_token = authorization
  )
  res <- GET(base_url, query = params, encode = 'json')
  stop_for_status(res)
  
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  if (!include_meta_info) {
    res <- res$artists
  }
  
  return(res)
}


##########################################################################################

# Return a search query from 
search_spotify <- function(q, type = c('album', 'artist', 'playlist', 'track'), market = NULL, limit = 20, offset = 0, include_external = NULL, authorization = get_spotify_access_token(), include_meta_info = FALSE) {
  
  base_url <- 'https://api.spotify.com/v1/search'
  
  if (!is.character(q)) {
    stop('"q" must be a string')
  }
  
  if (!is.null(market)) {
    if (!str_detect(market, '^[[:alpha:]]{2}$')) {
      stop('"market" must be an ISO 3166-1 alpha-2 country code')
    }
  }
  
  if ((limit < 1 | limit > 50) | !is.numeric(limit)) {
    stop('"limit" must be an integer between 1 and 50')
  }
  
  if ((offset < 0 | offset > 10000) | !is.numeric(offset)) {
    stop('"offset" must be an integer between 1 and 10,000')
  }
  
  if (!is.null(include_external)) {
    if (include_external != 'audio') {
      stop('"include_external" must be "audio" or an empty string')
    }
  }
  
  params <- list(
    q = q,
    type = paste(type, collapse = ','),
    market = market,
    limit = limit,
    offset = offset,
    include_external = include_external,
    access_token = authorization
  )
  res <- RETRY('GET', base_url, query = params, encode = 'json')
  stop_for_status(res)
  
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  if (!include_meta_info && length(type) == 1) {
    res <- res[[str_glue('{type}s')]]$items %>% as_tibble
  }
  
  return(res)
}



##########################################################################################



##########################################################################################


##########################################################################################


##########################################################################################


##########################################################################################