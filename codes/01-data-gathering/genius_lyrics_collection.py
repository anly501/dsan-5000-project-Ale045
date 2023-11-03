import pandas as pd
import numpy as np
import lyricsgenius as lg

# df_billboard = pd.read_csv('../../data/00-raw-data/billboard_features.csv')
# df_billboard_2022 = pd.read_csv('../../data/00-raw-data/billboard_2022_features.csv')
# df_global = pd.read_csv('../../data/00-raw-data/global_top_50.csv')

# df_total = pd.read_csv('../../data/01-modified-data/spotify_current_all.csv')
df_history = pd.read_csv('../../data/01-modified-data/top50MusicFrom2010-2019_cleaned.csv')

# Get the lyrics for each song

# names = df_billboard['track_name'].values

# names_2022 = df_billboard_2022['track_name'].values
# names_global = df_global['track_name'].values

track_names = df_history['title'].values
artist_names  = df_history['artist'].values
# track_id = df_billboard['id'].values

access_token = 'n5wn3NAVztaMX5jiWznZ-961NiWz2YejM6rUItONwoSsFlFxVils8ANHEVOp1BuV'
genius = lg.Genius(access_token)


def get_lyrics(songList, artistList):
	lyrics = []
	for i in range(0, len(songList)):
		try:
			song = genius.search_song(songList[i], artistList[i])
		
		except:
			print(f'No lyrics for {songList[i]}')
			lyrics.append(np.nan)
			continue

		if song:
			lyrics.append(song.lyrics)
		else:
			lyrics.append(np.nan)
	
	return lyrics

# lyrics_billboard = get_lyrics(names)
# lyrics_2022 = get_lyrics(names_2022)
# lyrics_global = get_lyrics(names_global)

lyrics_total = get_lyrics(track_names, artist_names)


# print(len(lyrics_global))
# print(len(df_billboard['id']))
# print(len(names))

# df_lyrics = pd.DataFrame({'track_id': df_billboard['id'], 'name': names,'lyrics': lyrics_billboard})
# df_lyrics_2022 = pd.DataFrame({'track_id': df_billboard_2022['id'], 'name':names_2022, 'lyrics': lyrics_2022})
# df_lyrics_global = pd.DataFrame({'track_id': df_global['id'],'name': names_global, 'lyrics': lyrics_global})

df_lyrics_total = pd.DataFrame({'track_name': track_names, 'artist_name': artist_names, 'lyrics': lyrics_total})

df_lyrics_total.to_csv('../../data/00-raw-data/spotify_history_all_lyrics.csv', index=False)

# df_lyrics.to_csv('../../data/00-raw-data/genius_lyrics.csv', index=False)
# df_lyrics_2022.to_csv('../../data/00-raw-data/genius_lyrics_2022.csv', index=False)
# df_lyrics_global.to_csv('../../data/00-raw-data/genius_lyrics_global.csv', index=False)