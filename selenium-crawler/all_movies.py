#%%
from selenium import webdriver
import time
import pandas as pd
#%%

driver = webdriver.Chrome('./src/chromedriver.exe')
def tem_item(xpath, drive = driver):
    try: 
        drive.find_element_by_xpath(xpath)
        return True
    except:
        return False
time.sleep(2)
driver.implicitly_wait(1)
driver.get('https://pt.wikipedia.org/wiki/Nicolas_Cage')
#%% 

tb_filmes = '//*[@id="mw-content-text"]/div[1]/table[2]'

i = 0
while not tem_item(tb_filmes):
    i+=1
    if i >50:
        break

tabela = driver.find_element_by_xpath(tb_filmes)
df = pd.read_html('<table>' + tabela.get_attribute('innerHTML') + '</table>')[0]

#%%
with open('print.png', 'wb') as f:
    f.write(driver.find_element_by_xpath(
        '//*[@id="mw-content-text"]/div[1]/table[1]/tbody/tr[2]/td/div/div/div/a/img').screenshot_as_png)
# %%
driver.close()

# %%

df[df['Ano']==1984]

# %%
df.to_csv('filmes_Nicolas_cage.csv', sep=';',index=False)
# %%
