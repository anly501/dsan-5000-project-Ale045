import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer

# read in the data
df_lyrics = pd.read_csv('../../data/00-raw-data/genius_lyrics.csv')
df_lyrics_global = pd.read_csv('../../data/00-raw-data/genius_lyrics_global.csv')
df_lyrics_2022 = pd.read_csv('../../data/00-raw-data/genius_lyrics_2022.csv')


# union all the lyrcis dataframes into one
df_lyrics_all = pd.concat([df_lyrics, df_lyrics_global, df_lyrics_2022], ignore_index=True)

print(len(df_lyrics_all))
# drop duplicates
df_lyrics_all.drop_duplicates(subset=['track_id'], keep='first', inplace=True)

print(len(df_lyrics_all))

# Check for missing values
print(df_lyrics_all.isnull().sum())

# Drop rows with missing values
df_lyrics_all.dropna(inplace=True)

# Remove indication words
df_lyrics_all['lyrics'] = df_lyrics_all['lyrics'].str.replace(r'\[.*\]', ',', regex=True)
# Leave only printable characters
df_lyrics_all['lyrics'] = df_lyrics_all['lyrics'].str.replace(r'[^\x20-\x7E]+', '', regex=True)

# Turn the lyrcis into a bag of words and remove the stop words
vectorizer = CountVectorizer(stop_words='english', min_df=3, token_pattern=r'\b[^\d\W]+\b')
X = vectorizer.fit_transform(df_lyrics_all['lyrics'])
df_bag = pd.DataFrame(X.toarray(), columns=vectorizer.get_feature_names_out())

df_lyrics_all = df_lyrics_all.reset_index(drop=True)
df_bag.reset_index(drop=True)
df_lyrics_all = pd.concat([df_lyrics_all, df_bag], axis=1)


# Drop the lyrics column
df_lyrics_all.drop(columns=['lyrics'], inplace=True)


# Write the data in a csv file
df_lyrics_all.to_csv('../../data/01-modified-data/genius_lyrics_cleaned.csv', index=False)
