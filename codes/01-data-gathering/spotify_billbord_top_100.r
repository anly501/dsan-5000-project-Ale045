library(spotifyr)
library(plotly)
library(ggplot2)
library(knitr)



# Get token
access_token <- get_spotify_access_token()


billboard.id <- '6UeSakyzhiEt4NB3UAd6NQ'
billboard <- get_playlist_tracks(billboard.id)
print(billboard$track.name)


artist_info <- sapply(billboard$track.id, function(x) {
    get_track(x)$album$artists[[2]]
})

artist_ids_vector <- sapply(artist_info, function(x) paste(x, collapse = ","))




# print(artist_info)
# print(global_top_50_track_info)
# global_top_50_track_info_df <- as.data.frame(global_top_50_track_info)

billboard.features <- get_track_audio_features(billboard$track.id)
billboard.features.df <- as.data.frame(billboard.features)


billboard.features.df$artist_ids <- artist_ids_vector
billboard.features.df$track_name <- billboard$track.name

# global_top_50_audio_features_df <- rbind(gloabl_top_50_audio_features_df, artist_info)



write.csv(billboard.features.df, "./data/00-raw-data/billboard_features.csv")
# write.csv(global_top_50_track_info_df, "./data/00-raw-data/global_top_50_track_info.csv")