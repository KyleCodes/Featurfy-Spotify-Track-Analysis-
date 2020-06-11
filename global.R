source("data_pipeline.R")
library(ggplot2)
library(ggradar)
library(scales)
library(dplyr)

artists <- retrieve_artists("asap")
artist_names <- artists$name

albums <- retrieve_albums_by_artist(artists$id[1])
album_names <- albums$name

songs_and_features <- retrieve_songs_and_features(albums$id)

genres <- artists$genres[1]
genres <- genres[[1]]


###########################################################

plot_energy <- function() {
  ggplot(data = songs_and_features, aes(x=energy)) +
    geom_density(fill="#1DB954", color="#1DB954", alpha=0.7)
}

plot_dance <- function() {
  ggplot(data = songs_and_features, aes(x=danceability)) +
    geom_density(fill="#1DB954", color="#1DB954", alpha=0.7)
}

plot_tempo <- function() {
  ggplot(data = songs_and_features, aes(x=tempo)) +
    geom_density(fill="#1DB954", color="#1DB954", alpha=0.7)
}

plot_valence <- function() {
  ggplot(data = songs_and_features, aes(x=valence)) +
    geom_density(fill="#1DB954", color="#1DB954", alpha=0.7)
}

plot_speech <- function() {
  ggplot(data = songs_and_features, aes(x=speechiness)) +
    geom_density(fill="#1DB954", color="#1DB954", alpha=0.7)
}

plot_instrum <- function() {
  ggplot(data = songs_and_features, aes(x=instrumentalness)) +
    geom_density(fill="#1DB954", color="#1DB954", alpha=0.7)
}

###########################################################

plot_dance_vs_energy <- function() {
  ggplot(songs_and_features, aes(x=energy, y=danceability, color=valence)) +
    geom_point(size = 5) + 
    theme_dark() +
    scale_color_gradient(low="darkorchid1", high="#1DB954")
}




