library(tidyverse)
library(dplyr)

# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read the data
df_event <- read_csv("../../data/01-modified-data/last.fm.data/tracks.csv")


# Check with the missing value
str(df_event)
print(colSums(is.na(df_event)))
print(nrow(df_event))

# Turn the track_name start with ! to NA
df_event$track <- gsub("^!.*", NA, df_event$track)

# Drop the rows with missing track
print(colSums(is.na(df_event)))
df_event <- df_event %>%
  filter(!is.na(track))

# Drop the rows with unprintable characters track name
df_event <- df_event %>%
  filter(!grepl("[^[:print:]]", track))

# Write to the csv file

write.csv(df_event, "../../data/01-modified-data/last.fm.data/tracks_cleaned.csv", row.names = FALSE)