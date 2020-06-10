library(dplyr)
library(httr)
library(jsonlite)
library(stringr)

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


# Return a search query from spotify
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


# Get the artist corresponding to the given Artist ID
get_artist <- function(id, authorization = get_spotify_access_token()) {
  
  base_url <- 'https://api.spotify.com/v1/artists'
  
  params <- list(
    access_token = authorization
  )
  url <- str_glue('{base_url}/{id}')
  res <- GET(url, query = params, encode = 'json')
  stop_for_status(res)
  
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  return(res)
}



##########################################################################################

# Get the album's belonging to the specified artistID
get_artist_albums <- function(id, include_groups = c('album', 'single', 'appears_on', 'compilation'), market = NULL, limit = 20, offset = 0, authorization = get_spotify_access_token(), include_meta_info = FALSE) {
  
  base_url <- 'https://api.spotify.com/v1/artists'
  
  if (!is.null(market)) {
    if (!str_detect(market, '^[[:alpha:]]{2}$')) {
      stop('"market" must be an ISO 3166-1 alpha-2 country code')
    }
  }
  
  params <- list(
    include_groups = paste(include_groups, collapse = ','),
    market = market,
    limit = limit,
    offset = offset,
    access_token = authorization
  )
  url <- str_glue('{base_url}/{id}/albums')
  res <- GET(url, query = params, encode = 'json')
  stop_for_status(res)
  
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  if (!include_meta_info) {
    res <- res$items
  }
  return(res)
}


##########################################################################################

# Get all of the tracks belonging to an album
get_album_tracks <- function(id, limit = 20, offset = 0, market = NULL, authorization = get_spotify_access_token(), include_meta_info = FALSE) {
  
  base_url <- 'https://api.spotify.com/v1/albums'
  
  if (!is.null(market)) {
    if (str_detect(market, '^[[:alpha:]]{2}$')) {
      stop('"market" must be an ISO 3166-1 alpha-2 country code')
    }
  }
  
  params <- list(
    market = market,
    offset = offset,
    limit = limit,
    access_token = authorization
  )
  url <- str_glue('{base_url}/{id}/tracks')
  res <- RETRY('GET', url, query = params, encode = 'json')
  stop_for_status(res)
  
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  if (!include_meta_info) {
    res <- res$items
  }
  
  return(res)
}


##########################################################################################

# Return the specified artist's top songs
get_artist_top_tracks <- function(id, market = 'US', authorization = get_spotify_access_token(), include_meta_info = FALSE) {
  
  base_url <- 'https://api.spotify.com/v1/artists'
  
  if (!is.null(market)) {
    if (!str_detect(market, '^[[:alpha:]]{2}$')) {
      stop('"market" must be an ISO 3166-1 alpha-2 country code')
    }
  }
  
  params <- list(
    market = market,
    access_token = authorization
  )
  url <- str_glue('{base_url}/{id}/top-tracks')
  res <- GET(url, query = params, encode = 'json')
  stop_for_status(res)
  
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  if (!include_meta_info) {
    res <- res$tracks
  }
  
  return(res)
}

##########################################################################################

# Get recommended artists based on the specified artist's ID
get_related_artists <- function(id, authorization = get_spotify_access_token(), include_meta_info = FALSE) {
  
  base_url <- 'https://api.spotify.com/v1/artists'
  
  params <- list(
    access_token = authorization
  )
  url <- str_glue('{base_url}/{id}/related-artists')
  res <- GET(url, query = params, encode = 'json')
  stop_for_status(res)
  
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE)
  
  if (!include_meta_info) {
    res <- res$artists
  }
  
  return(res)
}

##########################################################################################

# (Bread and butter): Get the features for each track specified. Limit = 100
get_track_audio_features <- function(ids, authorization = get_spotify_access_token()) {
  stopifnot(length(ids) <= 100)
  base_url <- 'https://api.spotify.com/v1/audio-features'
  params <- list(
    access_token = authorization,
    ids = paste0(ids, collapse = ',')
  )
  res <- RETRY('GET', base_url, query = params, encode = 'json')
  stop_for_status(res)
  res <- fromJSON(content(res, as = 'text', encoding = 'UTF-8'), flatten = TRUE) %>%
    .$audio_features %>%
    as_tibble()
  return(res)
}

##########################################################################################