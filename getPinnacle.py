#!/usr/bin/env python

from pyvirtualdisplay import Display

import requests
import bs4
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd
import time
import numpy as np
from datetime import date

def getPinnacleDF():
    
	display = Display(visible=0, size=(800, 600))
	display.start()

	url='https://www.pinnacle.com/fr/tennis/matchups'
	driver = webdriver.Chrome()
	driver.get(url)

	try:
		element = WebDriverWait(driver, 1000).until(
		    EC.presence_of_element_located((By.CLASS_NAME,'price'))
		)
		html=driver.page_source

	finally:
		driver.quit()	
		display.stop()


	soup = bs4.BeautifulSoup(html, 'html.parser')

	box_noms=soup.select('span[class*="style_participantName"]')

	df=pd.DataFrame(columns=['Joueur H', 'Joueur A', 'Odd H', 'Odd A','Heure','Jour'])
	for k in range(len(df.columns)):
		df[df.columns[k]]=np.zeros(int(len(box_noms)/2))

	for k in range(int(len(box_noms)/2)):
		df.loc[k,'Joueur H']=box_noms[2*k].text
	for k in range(int(len(box_noms)/2)):
		df.loc[k,'Joueur A']=box_noms[2*k+1].text

	box_odds=soup.find_all("a",{'data-test-gametype': 'matchup'})

	for k in range(int(len(box_noms)/2)):
		df.loc[k,'Odd H']=box_odds[2*k].text
	for k in range(int(len(box_noms)/2)):
		df.loc[k,'Odd A']=box_odds[2*k+1].text

	box_hours=soup.select('span[class*="style_time"]')

	for k in range(len(df)):
		df.loc[k,'Heure']=box_hours[k].text

	for k in range(len(df)):
		df.loc[k,'Jour']=date.today()

	df['Prenom H'],df['Nom H']=df['Joueur H'].str.split(' ',1).str
	df['Prenom A'],df['Nom A']=df['Joueur A'].str.split(' ',1).str

	df['Joueur H-']=df['Joueur H']
	df['Joueur A-']=df['Joueur A']
	df['Joueur H']=df['Nom H']+' '+df['Prenom H'].str[0]
	df['Joueur A']=df['Nom A']+' '+df['Prenom A'].str[0]
	df=df.drop(columns=['Prenom A','Nom A','Prenom H','Nom H'])
	# changement
	return df

pi=getPinnacleDF()
pi.to_csv('pi.csv',index=False,header=True)

