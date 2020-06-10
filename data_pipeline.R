source("spotify_wrapper.R")

data_pipeline <- function() {
  token <- get_spotify_access_token()
  
  query <- "asap"
  
  artist_results <- search_spotify(query, type = "artist", authorization = token)
  
  artist_id <- artist_results$id[1]
  
  albums <- get_artist_albums(id = artist_id, include_groups = "album", authorization = token)
  
  album_IDs <- albums$id
  
  
  df = tibble()
  
  for (alb in album_IDs) {
    
    albs_tracks <- get_album_tracks(id = alb, authorization = token)
    
    track_ids <- albs_tracks$id
    
    albs_track_features <- get_track_audio_features(track_ids)
    
    df <- df %>% bind_rows(albs_track_features)
    
    
  }
  
  return (df)
}

token <- get_spotify_access_token()

query <- "asap"

artist_results <- search_spotify(query, type = "artist", authorization = token)

artist_id <- artist_results$id[1]

albums <- get_artist_albums(id = artist_id, include_groups = "album", authorization = token)

album_IDs <- albums$id


df = tibble()

for (alb in album_IDs) {
  
  albs_tracks <- get_album_tracks(id = alb, authorization = token)
  
  track_ids <- albs_tracks$id
  
  albs_track_features <- get_track_audio_features(track_ids)
  
  df <- df %>% bind_rows(albs_track_features)
  
  
}




