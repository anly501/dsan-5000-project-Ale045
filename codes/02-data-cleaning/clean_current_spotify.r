library(tidyverse)

# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read all the data from current trending Spotify music
df_global <- read_csv("../../data/00-raw-data/global_top_50.csv")
df_billboard <- read_csv("../../data/00-raw-data/billboard_features.csv")
df_billboard_2022 <- read_csv("../../data/00-raw-data/billboard_2022_features.csv")

# Combie all the data
df_all <- rbind(df_global, df_billboard, df_billboard_2022)
# Remove duplicate rows
df_all <- df_all %>%
  distinct(id, .keep_all = TRUE)

# Drop the index column which is not needed
df_all <- df_all[, -1]


# Drop unnecessary columns
df_all <- df_all %>%
  select(-c("uri", "track_href", "analysis_url", "time_signature", "duration_ms", "type", "danceability"))

# Change the id column name
df_all <- df_all %>%
  rename(track_id = id)


# Check if there is any missing value
print(colSums(is.na(df_all)))

# Only lfet the main aritst for a track
df_all$artist_ids <- sapply(df_all$artist_ids, function(x) strsplit(x, ",")[[1]][1])

# Write the cleaned data to csv file
write.csv(df_all, "../../data/01-modified-data/spotify_current_all.csv", row.names = FALSE)