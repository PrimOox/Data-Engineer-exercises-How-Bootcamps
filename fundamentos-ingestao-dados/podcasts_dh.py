#%%
import requests
from bs4 import BeautifulSoup as bs
import logging
import pandas as pd

# %%
url_ini = 'https://datahackers.com.br/podcast/'
ret = requests.get(url_ini)
ret.text
# %%
soup = bs(ret.text)
# %%
soup
# %%
soup.find('h3')
# %%
soup.find('h3').text
# %%
soup.find('h3').a['href']
# %%
lst_podcast = soup.find_all('h3')
# %%
for item in lst_podcast:
    print(f"EP: {item.text}")

# %%
def get_podcasts(url):
    ret = requests.get(url)
    soup = bs(ret.text)
    return soup.find_all('h3')

# %%
url = 'https://datahackers.com.br/podcast/pagina-{}'
#%%
url.format(5)
#%%
get_podcasts(url.format(5))
# %%
log = logging.getLogger()
log.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
ch = logging.StreamHandler()
ch.setFormatter(formatter)
log.addHandler(ch)
# %%
#Pegando do site
i = 2
lst_podcast = []
lst_get = get_podcasts(url.format(i))
log.debug(f"Coletado {len(lst_get)} episódios do link: {url.format(i)}")

lst_podcast = get_podcasts(url_ini)
log.debug(f"Coletado {len(lst_get)} episódios do link: {url.format(i)}")

while len(lst_get) > 0:
    lst_podcast = lst_podcast + lst_get
    i += 1
    lst_get = get_podcasts(url.format(i))
    log.debug(f"Coletado {len(lst_get)} episódios do link: {url.format(i)}")

# %%
len(lst_podcast)
# %%
lst_podcast
# %%
df = pd.DataFrame(columns=['nome'])
# %%
for item in lst_podcast:
    df.loc[df.shape[0]] = [item.text]
# %%
df.shape
# %%
df
# %%
df.to_csv('banco_de_podcasts_DH.csv', sep=';', index=False)
#%%
## Pegando do Spotify

def get_podcasts_spotify(url):
    ret = requests.get(url)
    soup = bs(ret.text)
    return soup.find_all('h4')

url = 'https://open.spotify.com/show/1oMIHOXsrLFENAeM743g93'
#%%

log.debug(f"Coletado episódios")
lst_podcast = get_podcasts_spotify(url)

# %%
len(lst_podcast)
lst_podcast[15].text
lst_podcast[15].parent['href']
# %%
df = pd.DataFrame(columns=['nome', 'link'])
# %%
for item in lst_podcast:
    df.loc[df.shape[0]] = [item.text, 'https://open.spotify.com'+item.parent['href']]
# %%
df.shape
# %%
df
# %%
df.to_csv('datahackers_spotify.csv', sep=';', index=False)
# %%
