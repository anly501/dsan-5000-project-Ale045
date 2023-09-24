import pandas as pd
import numpy as np
import lyricsgenius as lg

df_billboard = pd.read_csv('../../data/00-raw-data/billboard_features.csv')
df_billboard_2022 = pd.read_csv('../../data/00-raw-data/billboard_2022_features.csv')
df_global = pd.read_csv('../../data/00-raw-data/global_top_50.csv')


# Get the lyrics for each song

names = df_billboard['track_name'].values

names_2022 = df_billboard_2022['track_name'].values
names_global = df_global['track_name'].values
# track_id = df_billboard['id'].values

genius = lg.Genius("-oIUp9eDL9VOXcgW-H7Npt071eCMCjf3jb_fUm_3k5_UzEVf0S-gAL5uKHwgVIK6")


def get_lyrics(songList):
	lyrics = []
	for name in songList:
		print(name)
		song = genius.search_song(name)
		if song:
			lyrics.append(song.lyrics)
		else:
			lyrics.append(np.nan)
	
	return lyrics

lyrics_billboard = get_lyrics(names)
lyrics_2022 = get_lyrics(names_2022)
lyrics_global = get_lyrics(names_global)

# print(len(lyrics_global))
# print(len(df_billboard['id']))
# print(len(names))

df_lyrics = pd.DataFrame({'track_id': df_billboard['id'], 'name': names,'lyrics': lyrics_billboard})
df_lyrics_2022 = pd.DataFrame({'track_id': df_billboard_2022['id'], 'name':names_2022, 'lyrics': lyrics_2022})
df_lyrics_global = pd.DataFrame({'track_id': df_global['id'],'name': names_global, 'lyrics': lyrics_global})


df_lyrics.to_csv('../../data/00-raw-data/genius_lyrics.csv', index=False)
df_lyrics_2022.to_csv('../../data/00-raw-data/genius_lyrics_2022.csv', index=False)
df_lyrics_global.to_csv('../../data/00-raw-data/genius_lyrics_global.csv', index=False)