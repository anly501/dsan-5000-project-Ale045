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



# Show the distribution of age
# use a mask to remove -1 ages
mask <- df_user$age != -1
hist(df_user$age[mask], main = "Distribution of Age", xlab = "Age", col = "lightblue")


# Replace the -1 age with median
# df_user$age[!mask] <- median(df_user$age[mask])



# remove the age over 80
df_user <- df_user %>%
  filter(age <= 80)

# bining the age into 5-years interval
df_user$age_group <- cut(df_user$age, breaks = seq(0, 80, 5), labels = c("0-5", "5-10", "10-15", "15-20", "20-25", "25-30", "30-35", "35-40", "40-45", "45-50", "50-55", "55-60", "60-65", "65-70", "70-75", "75-80"))


# Write the cleaned data to csv file
write.csv(df_user, "../../data/01-modified-data/last.fm.data/users_cleaned.csv", row.names = FALSE)