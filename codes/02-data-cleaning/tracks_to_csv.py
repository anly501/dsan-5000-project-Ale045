import pandas as pd
import re

# read in the data
cleaned = []
with open('../../data/00-raw-data/last.fm.data/tracks.tsv', 'r') as f:
    for line in f.readlines():
        cleaned_line = re.sub(r'\t+|\s{2,}', ',', line.strip())
        cleaned.append(cleaned_line)

    

with open('../../data/01-modified-data/last.fm.data/tracks.csv', 'w') as f:
    for line in cleaned:
        f.write(line + '\n')
