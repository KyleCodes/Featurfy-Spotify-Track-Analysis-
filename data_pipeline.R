source("spotify_wrapper.R")


retrieve_artists <- function(artist_query) {
  
  token <- get_spotify_access_token()
  query <- artist_query
  artist_results <- search_spotify(query, type = "artist", authorization = token)
  return(artist_results)
}



retrieve_albums_by_artist <- function(artist_id) {
  
  token <- get_spotify_access_token()
  albums <- get_artist_albums(id = artist_id, include_groups = "album", authorization = token)
  return (albums)
}

retieve_songs_and_features <- function(album_IDs) {
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










