import pandas as pd

# read in the data
df_tik = pd.read_csv('../../data/00-raw-data/TikTok_songs_2022.csv')

# Check for missing values
print(df_tik.isnull().sum())

# Check for duplicates
duplicates = df_tik[df_tik.duplicated()]
print(duplicates)

print(df_tik.columns)
# Drop unnecessary columns
df_tik.drop(columns=['artist_pop', 'album'], inplace=True)

print(df_tik.columns)

# Change the column names
df_tik.rename(columns={'trakc_name': 'track', 'artist_name': 'artist', 'popularity': 'track_pop'}, inplace=True)

print(df_tik.columns)


# Write the data in a csv file
df_tik.to_csv('../../data/01-modified-data/tik_tok_cleaned.csv', index=False)