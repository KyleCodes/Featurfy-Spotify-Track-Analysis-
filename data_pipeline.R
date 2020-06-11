source("spotify_wrapper.R")

# Enter an artist in a string to get a list of possible results
#     Returns a list of artist objects
retrieve_artists <- function(artist_query) {
  
  token <- get_spotify_access_token()
  query <- artist_query
  artist_results <- search_spotify(query, type = "artist", authorization = token, limit = 10)
  return(artist_results)
}

# Enter an artist ID to get a list of possible results
#     Returns a list of album objects
retrieve_albums_by_artist <- function(artist_id) {
  
  token <- get_spotify_access_token()
  albums <- get_artist_albums(id = artist_id, include_groups = "album", authorization = token)
  return (albums)
}

# Enter a list of album IDs and get all of their songs + features
#     Returns a data frame of feature objects representing all songs by an artist
retrieve_songs_and_features <- function(album_IDs) {
  token <- get_spotify_access_token()
  df = tibble()
  
  for (alb in album_IDs) {
    albs_tracks <- get_album_tracks(id = alb, authorization = token)
    track_ids <- albs_tracks$id
    albs_track_features <- get_track_audio_features(track_ids)
    df <- df %>% bind_rows(albs_track_features)
  }
  
  return (df)
}










