import pandas as pd

# read in the data
df_tik = pd.read_csv('../../data/00-raw-data/TikTok_songs_2022.csv')

# Check for missing values
print(df_tik.isnull().sum())

# Check for duplicates

print(df_tik.duplicated().sum())