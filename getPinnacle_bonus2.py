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

import gspread
import pandas as pd
from oauth2client.service_account import ServiceAccountCredentials
import numpy as np

import yagmail

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
	return df

def updateGSwithDF(df,nameSheet):

	scope=['https://www.googleapis.com/auth/spreadsheets',
	'https://www.googleapis.com/auth/drive.file',
	'https://www.googleapis.com/auth/drive']

	creds=ServiceAccountCredentials.from_json_keyfile_name('YourProject.json',scope)
	client=gspread.authorize(creds)
	sh=client.open_by_url('https://docs.google.com/spreadsheets/d/1Hz_DysSzKu_5f7Z7PngBtpK14Cpwm0cIq8w_O53bIkY/edit#gid=0')
	sh=sh.worksheet(nameSheet)

	a=sh.get_all_values()

	alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	target='A'+str(len(a)+1)+':'+alphabet[len(a[0])-1]+str(len(a)+1+len(df)-1)
	sh.update(target,df.values.tolist())

def SendEmail():
    user = 'yourmail@gmail.com'
    app_password = 'azdakzdpazdlaz'
    to = 'yourmail@gmail.com'

    subject = 'Scraping : Pinnacle'
    content = ['The site has been scrape sucessfully !']

    with yagmail.SMTP(user, app_password) as yag:
        yag.send(to, subject, content)
        print('Sent email successfully.')

pi=getPinnacleDF()
pi.to_csv('pi.csv',index=False,header=True)

#Bonus1
pi = pi.applymap(str)
updateGSwithDF(pi,'Feuille 1')

#Bonus2
SendEmail()
