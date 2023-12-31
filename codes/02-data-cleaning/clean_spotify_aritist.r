library(tidyverse)
library(dplyr)

# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read the data
df_artist <- read_csv("../../data/00-raw-data/spotify_artists_feature.csv")

# Drop unnecessary columns
df_artist <- df_artist %>%
  select(-c("uri", "href", "images.height1","images.height2","images.height3","images.url1","images.url2","images.url3","images.width1","images.width2","images.width3","popularity","type","uri","images.height4","images.url4","images.width4", "external_urls.spotify", "genres3","genres4","genres5","genres6","genres7","genres8", "genres2", "...1"))

# Leave only the prority genre
df_artist$genre <- df_artist$genres
mask <- is.na(df_artist$genres)
df_artist$genre[mask] <- df_artist$genres1[mask]

# Drop unnecessary genre colmuns
df_artist <- df_artist %>%
  select(-c("genres", "genres1"))

# Rename the id to artist_id
df_artist <- df_artist %>%
  rename(artist_ids = id)

# Fill the missing value with Undefined
df_artist$genre[is.na(df_artist$genre)] <- "undefined"

# Reduce the number of genre
df_artist$broad_genre <- df_artist$genre
print(unique(df_artist$broad_genre))
# Basic reduce
# df_artist$broad_genre <- gsub("^(.*hip hop.*)$", "hip hop", df_artist$broad_genre)
# df_artist$broad_genre <- gsub("^(.*rap.*)$", "hip hop", df_artist$broad_genre)
# df_artist$broad_genre <- gsub("^(.*trap.*)$", "hip hop", df_artist$broad_genre)

# df_artist$broad_genre <- gsub("^(.*pop.*)$", "pop", df_artist$broad_genre)
# df_artist$broad_genre <- gsub("^(.*rock.*)$", "rock", df_artist$broad_genre)

# Specific reduce
genre_mapping <- list(
  pop = c("dance pop", "k-pop", "pop", "latin pop", "chill pop", "canadian pop", "baroque pop", "classic oklahoma country", "contemporary country", "modern country pop", "black americana",  "art pop", "puerto rican pop"),
  hip_hop_rap = c("alt z", "hip hop", "melodic drill", "bronx drill", "chicago drill", 'trap queen', "lgbtq+ hip hop", 'rap canario', "canadian hip hop", "atl hip hop", "uk hip hop", "desi hip hop", "houston rap", "hip pop", "conscious hip hop", "country rap", "rap", "dfw rap", "florida rap", "australian hip hop", "deep underground hip hop", "memphis hip hop", "chicago rap", "ohio hip hop"),
  rnb_soul = c("uk contemporary r&b", "alternative r&b", "neo soul", "british soul", "canadian contemporary r&b"),
  rock_alternative = c("garage rock", "alternative rock", "modern rock", "indie rock italiano", "modern blues rock", "modern alternative pop", "kentucky indie"),
  electronic_dance = c("brostep", "big room", "aussietronica"),
  latin = c("reggaeton", "trap latino", "urbano espanol", "colombian pop"),
  indie_folk = c("indie pop"),
  "others" = c("corridos tumbados", "gen z singer-songwriter", "j-division", "bubblegum dance", "escape room", "gauze pop", "boy band", "afrobeats", "corrido", "musica chihuahuense", "musica mexicana", "chopped and screwed", "texas latin rap", "pluggnb")
)

# Mapping the genre to broad genre
map_to_broad_genre <- function(genre) {
  for (category in names(genre_mapping)) {
    if (genre %in% genre_mapping[[category]]) {
      return(category)
    }
  }
  print(genre)
  return("others")
}

df_artist <- df_artist %>%
  mutate(broad_genre = sapply(broad_genre, map_to_broad_genre))



print(unique(df_artist$broad_genre))
# Write the cleaned data to csv file
write.csv(df_artist, "../../data/01-modified-data/spotify_artist.csv", row.names = FALSE)