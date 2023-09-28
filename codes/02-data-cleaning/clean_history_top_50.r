library(tidyverse)
library(dplyr)

# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read the data
df_track <- read_csv("../../data/00-raw-data/top50MusicFrom2010-2019.csv")

# Change the column name
df_track <- df_track %>%
  rename(genre = `the genre of the track`, beat = `Beats.Per.Minute -The tempo of the song`, energy = `Energy- The energy of a song - the higher the value, the more energtic`, danceability = `Danceability - The higher the value, the easier it is to dance to this song`, loudness = `Loudness/dB - The higher the value, the louder the song`, liveness = `Liveness - The higher the value, the more likely the song is a live recording`, valence = `Valence - The higher the value, the more positive mood for the song`, duration = `Length - The duration of the song`, acousticness = `Acousticness - The higher the value the more acoustic the song is`, speechiness = `Speechiness - The higher the value the more spoken word the song contains`, popularity = `Popularity- The higher the value the more popular the song is`)


# Check for missing value
print(colSums(is.na(df_track)))
str(df_track)

# Drop the unnecessary columns
df_track <- df_track %>%
  select(-c("liveness", "acousticness"))

# Reduce the number of genres
df_track$genre <- gsub("^(.*hip hop.*)$", "hip_hop", df_track$genre)
df_track$genre <- gsub("^(.*rap.*)$", "hip_hop", df_track$genre)
df_track$genre <- gsub("^(.*trap.*)$", "hip_hop", df_track$genre)

df_track$genre <- gsub("^(.*pop.*)$", "pop", df_track$genre)
df_track$genre <- gsub("^(.*rock.*)$", "rock", df_track$genre)

print(unique(df_track$genre))


genre_mapping <- list(
  pop = c("dance pop", "k-pop", "pop", "british soul"),
  hip_hop = c("alt z", "hip hop"),
  r_and_b = c("canadian contemporary r&b", "r&b"),
  rock = c("neo mellow", "rock"),
  indie = c("indie pop", "pov: indie", "alaska indie"),
  electron = c("big room", "electro", "complextro", "house", "australian dance", "tropical house", "belgian edm", "edm", "electro house", "downtempo", "brostep"),
  latin = c("reggaeton", "trap latino", "urbano espanol", "colombian pop", "latin", "canadian latin"),
  country = c("classic oklahoma country", "contemporary country",
              "modern country pop", "black americana"),
  drill = c("melodic drill", "bronx drill", "chicago drill"),
  mixed = c("permanent wave", "boy band", "hollywood", "escape room", "alternative r&b")
)

map_to_broad_genre <- function(genre) {
  for (category in names(genre_mapping)) {
    if (genre %in% genre_mapping[[category]]) {
      return(category)
    }
  }
  return("other")
}

df_track <- df_track %>%
  mutate(genre = sapply(genre, map_to_broad_genre))

# Count the number of each genre
df_count <- df_track %>%
  group_by(genre) %>%
  summarise(count = n())
print(df_count)
# Write the cleaned data to csv file
write.csv(df_track, "../../data/01-modified-data/top50MusicFrom2010-2019_cleaned.csv", row.names = FALSE)