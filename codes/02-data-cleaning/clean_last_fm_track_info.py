import pandas as pd


# Read in the data
df_tracks = pd.read_json('../../data/00-raw-data/last.fm.data/sample_track_info.json', lines=True)

# Get columns name
print(df_tracks.columns)

# Check the missing values
print(df_tracks.isnull().sum())

# Drop uneccessary columns
df_tracks.drop(columns=["uri", "track_href", "analysis_url", "time_signature", "duration_ms", "type"], inplace=True)

# Write the data in a csv file

df_tracks.to_csv('../../data/01-modified-data/last.fm.data/last_fm_track_info.csv', index=False)

