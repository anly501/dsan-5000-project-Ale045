library(spotifyr)
library(plotly)
library(ggplot2)
library(knitr)
library(dplyr)

data_global <- read.csv("./data/00-raw-data/global_top_50.csv")
data_billbord <- read.csv("./data/00-raw-data/billboard_features.csv")
data_billbord_2022 <- read.csv("./data/00-raw-data/billboard_2022_features.csv")

total_artist <- c(data_global$artist_ids, data_billbord$artist_ids, data_billbord_2022$artist_ids)
total_artist <- unlist(strsplit(total_artist, split = ","))
total_artist <- unique(total_artist)

access_token <- get_spotify_access_token()

artist_info_list <- lapply(total_artist, get_artist)
df_list <- lapply(artist_info_list, function(x) as.data.frame(t(unlist(x))))
artist_df <- bind_rows(df_list)

write.csv(artist_df, "./data/00-raw-data/spotify_artists_feature.csv")




