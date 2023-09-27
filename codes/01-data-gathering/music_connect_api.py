import pandas as pd
import numpy as np
import requests



def get_top_tracks_for_user(username, api_key, limit=50):
    base_url = "http://ws.audioscrobbler.com/2.0/"
    params = {
        "method": "user.getTopTracks",
        "user": username,
        "api_key": api_key,
        "format": "json",
        "limit": limit
    }
    
    response = requests.get(base_url, params=params)
    data = response.json()
    
    if 'toptracks' in data and 'track' in data['toptracks']:
        return [track['name'] for track in data['toptracks']['track']]
    else:
        return []

# Replace 'YOUR_API_KEY', 'TRACK_NAME', and 'ARTIST_NAME' with appropriate values
api_key = "c0da2f4f35b20dcbbfa51fa3c42f9c76"
track_name = "Vampire"
artist_name = "Olivia Rodrigo"

result = get_top_tracks_for_user("3856459", api_key)
print(result)

# df_username = pd.read_csv('../../data/00-raw-data/Last.fm_data.csv')   
# print(df_username['Username'].unique())
# top_listeners = get_top_listeners(track_name, artist_name, api_key)
# for listener in top_listeners:
#     top_tracks = get_top_tracks_for_user(listener, api_key)
#     print(f"Top tracks for {listener}: {top_tracks}")


