library(tidyverse)

# use the current working directory of the active document
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read the data
df_user <- read_tsv("../../data/00-raw-data/last.fm.data/users.tsv")

# Check with the missing value
str(df_user)
print(colSums(is.na(df_user)))
print(nrow(df_user))

# Deal with the missinig value
# Drop the rows with missing gender
df_user <- df_user %>%
  filter(!is.na(gender))

# Fill the missing country with unknown
df_user$country[is.na(df_user$country)] <- "unknown"

# Turn gender to factor
df_user$gender <- as.factor(df_user$gender)

# Turn age to numeric
df_user$age <- as.numeric(df_user$age)

print(colSums(is.na(df_user)))

# Write the cleaned data to csv file
write.csv(df_user, "../../data/01-modified-data/last.fm.data/users_cleaned.csv", row.names = FALSE)