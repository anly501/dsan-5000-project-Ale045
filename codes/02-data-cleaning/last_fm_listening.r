library(tidyverse)
library(dplyr)

# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read the data
df_event <- read_csv("../../data/00-raw-data/last.fm.data/listening_events.tsv")

# Sample 100000 rows from the dataset
set.seed(1003)
df_event <- df_event %>%
  sample_n(100000)

# Check with the missing value
str(df_event)
print(colSums(is.na(df_event)))
print(nrow(df_event))
print(head(df_event))

# Split the tab separated column
df_event <- df_event %>%
  separate(`user_id\ttrack_id\talbum_id\ttimestamp`, into = c("user_id", "track_id", "album_id", "timestamp"), sep = "\t")

print(head(df_event))
# Write to the csv file
write.csv(df_event, "../../data/01-modified-data/last.fm.data/listening_events_sample.csv", row.names = FALSE)