library(spotifyr)
library(plotly)
library(ggplot2)
library(knitr)
# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Get token
access_token <- get_spotify_access_token()

# Get artist info
global_top_50_id <- '37i9dQZEVXbMDoHDwVN2tF'
global_top_50 <- get_playlist_tracks(global_top_50_id)


# billboard.2022_id <- '37i9dQZF1DWWGeEU3DbvDJ'
# billboard.2022 <- get_playlist_tracks(billboard.2022_id)


# Get audio features
artist_info <- sapply(global_top_50$track.id, function(x) {
    get_track(x)$album$artists[[2]]
})

artist_ids_vector <- sapply(artist_info, function(x) paste(x, collapse = ","))




# print(artist_info)
# print(global_top_50_track_info)
# global_top_50_track_info_df <- as.data.frame(global_top_50_track_info)

global_top_50_audio_features <- get_track_audio_features(global_top_50$track.id)
gloabl_top_50_audio_features_df <- as.data.frame(global_top_50_audio_features)

gloabl_top_50_audio_features_df$artist_ids <- artist_ids_vector
gloabl_top_50_audio_features_df$track_name <- global_top_50$track.name

# global_top_50_audio_features_df <- rbind(gloabl_top_50_audio_features_df, artist_info)



write.csv(gloabl_top_50_audio_features_df, "./data/00-raw-data/global_top_50.csv")
# write.csv(global_top_50_track_info_df, "./data/00-raw-data/global_top_50_track_info.csv")