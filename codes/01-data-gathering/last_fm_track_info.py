import pandas as pd
import requests
from tqdm import tqdm as tq
import json
import time
import base64


# read in the data
df_events = pd.read_csv('../../data/01-modified-data/last.fm.data/listening_events_sample.csv')
df_music = pd.read_csv('../../data/01-modified-data/last.fm.data/tracks_cleaned.csv')
# Get unique tracks

# tracks = df_events['track_id'].unique()

track_counts = df_events['track_id'].value_counts()

# Sort the track counts in descending order
sorted_track_counts = track_counts.sort_values(ascending=False)

# Get the top 10000 track_ids
tracks = sorted_track_counts.index[:10000]

done = []
done_1 = []
with open('../../data/log.txt', 'r') as f:
    done = [line.strip() for line in f.readlines()]



# Replace 'your_access_token' with the token you get from Spotify API
access_token = 'BQCH-VQ4gUNx8cM9cnQK44PNNKECmcfoG7p55ngsbaWcnoipuwV-9TeAn5NIYQGF75GDJrzMt6AjC-_D9pKE_gtyXuIwQnhOYMps3d-TF28eAa7QyeQ'

def get_track_info(track_name, artist_name, access_token):
    headers = {
    'Authorization': f'Bearer {access_token}',
}

    # Replace with the artist and track name you're interested in
    artist_name = artist_name.replace(' ', '+')
    track_name = track_name.replace(' ', '+')

    # Step 1: Search for the track_id using artist name and track name
    search_url = 'https://api.spotify.com/v1/search'
    search_params = {
        'q': f'track%3A%22{track_name}%22+artist%3A{artist_name}&offset=0&limit=20',
        'type': 'track',
        'limit': 1  # we only want one result
    }

    response = requests.get(search_url, headers=headers, params=search_params)

    if response.status_code == 200:
        results = response.json()
        if results['tracks']['total'] == 0:
            print(f"No track found for {artist_name} - {track_name}")
            return None
        track_id = results['tracks']['items'][0]['id']
    else:
        print(f"Search failed: {response.status_code}, {response.reason}")
        track_id = None

    # Step 2: Get detailed information about the track using track_id
    if track_id:
        track_url = f'https://api.spotify.com/v1/audio-features/{track_id}'
        response = requests.get(track_url, headers=headers)
        
        if response.status_code == 200:
            track_info = response.json()

            return track_info
        else:
            print(f"Track info failed: {response.status_code}, {response.reason}, {response.headers}")
            return None
    else:
        return None



def get_access_token():
    # Replace with your client ID and client secret

    # Encode the client ID and client secret as base64
    client_creds = f'{"565fb42c460240d0a6e183c3ffa7f24b"}:{"325bf82223ae45b9af49f6c3d1843741"}'
    client_creds_b64 = base64.b64encode(client_creds.encode())

    # Define the headers and data for the POST request
    token_url = 'https://accounts.spotify.com/api/token'
    token_headers = {
        'Authorization': f'Basic {client_creds_b64.decode()}'
    }
    token_data = {
        'grant_type': 'client_credentials'
    }

    # Send the POST request to get the access token
    response = requests.post(token_url, headers=token_headers, data=token_data)

    # Extract the access token from the response
    access_token = response.json()['access_token']

    return access_token

    # get_track_info('Eternity Above Clouds', 'RADWIMPS')


def write_log(done_list):
    if done_list:
        with open('../../data/log.txt', 'a') as f:
            f.write('\n'.join(done_list))
            f.write('\n')


# Get the audio feature for each track
with open('../../data/00-raw-data/last.fm.data/sample_track_info.json', 'a') as f:
    buffer = []
    n = 0
    for track in tq(tracks):
        if str(track) in done:
            continue
        row  = df_music[df_music['track_id'] == track]
        if row.empty:
            print(f'No track info for track {track}')
            continue
        track_name, artist_name = row[['track', 'artist']].values[0]

        response = get_track_info(track_name, artist_name, access_token)
        time.sleep(0.2)

        if response:
            response['track_id'] = str(track)
            buffer.append(json.dumps(response))
            done_1.append(str(track))
        else:
            done_1.append(str(track))
            write_log(done_1)
            done_1 = []
            continue
        
        if len(buffer) == 100:
            f.write('\n'.join(buffer))
            f.write('\n')
            buffer = []
        
        n  = n + 1
        if n % 500 == 0:
            access_token = get_access_token()
            print(n)
        

        if len(done_1) % 100 == 0:
            write_log(done_1)
            done_1 = []

        if n == 10000:
            write_log(done_1)
            break




    if buffer:
        print('Writing last buffer')
        f.write('\n'.join(buffer))
        f.write('\n')
        buffer = []


