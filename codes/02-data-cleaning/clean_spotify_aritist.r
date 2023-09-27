library(tidyverse)

# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read the data
df_artist <- read_csv("../../data/00-raw-data/spotify_artists_feature.csv")

# Drop unnecessary columns
df_artist <- df_artist %>%
  select(-c("uri", "href", "images.height1","images.height2","images.height3","images.url1","images.url2","images.url3","images.width1","images.width2","images.width3","name","popularity","type","uri","images.height4","images.url4","images.width4", "external_urls.spotify", "genres3","genres4","genres5","genres6","genres7","genres8", "genres2"))

# Leave only the prority genre
df_artist$genre <- df_artist$genres
mask <- is.na(df_artist$genres)
df_artist$genre[mask] <- df_artist$genres1[mask]

# Drop unnecessary genre colmuns
df_artist <- df_artist %>%
  select(-c("genres", "genres1", "...1"))

# Rename the id to artist_id
df_artist <- df_artist %>%
  rename(artist_id = id)

# Fill the missing value with Undefined
df_artist$genre[is.na(df_artist$genre)] <- "undefined"

# Write the cleaned data to csv file
write.csv(df_artist, "../../data/01-modified-data/spotify_artist.csv", row.names = FALSE)