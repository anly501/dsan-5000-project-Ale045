library(spotifyr)
library(plotly)
library(ggplot2)
library(knitr)



# Get token
access_token <- get_spotify_access_token()


billboard.2022_id <- '37i9dQZF1DWWGeEU3DbvDJ'
billboard.2022 <- get_playlist_tracks(billboard.2022_id)


# Get audio features
artist_info <- sapply(billboard.2022$track.id, function(x) {
    get_track(x)$album$artists[[2]]
})

artist_ids_vector <- sapply(artist_info, function(x) paste(x, collapse = ","))




# print(artist_info)
# print(global_top_50_track_info)
# global_top_50_track_info_df <- as.data.frame(global_top_50_track_info)

billboard.2022.features <- get_track_audio_features(billboard.2022$track.id)
billboard.2022.features.df <- as.data.frame(billboard.2022.features)

billboard.2022.features.df$artist_ids <- artist_ids_vector

# global_top_50_audio_features_df <- rbind(gloabl_top_50_audio_features_df, artist_info)



write.csv(billboard.2022.features.df, "./data/00-raw-data/billboard_2022_features.csv")
# write.csv(global_top_50_track_info_df, "./data/00-raw-data/global_top_50_track_info.csv")