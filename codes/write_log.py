import pandas as pd

# read in the data
df_events = pd.read_json('../data/00-raw-data/last.fm.data/sample_track_info.json', lines=True)


# Get columns name
print(df_events.columns)

with open('../data/log.txt', 'w') as f:
    f.write('\n'.join(df_events['id']))
    f.write('\n')