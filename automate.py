#!/usr/bin/env python

import os
os.chdir("/home/ubuntu/NYCattends/xml")

from subprocess import call
call("curl --silent http://schools.nyc.gov/AboutUs/schools/data/attendancexml/ -o temp.xml", shell=True)

with open('temp.xml') as f:
    content = f.readline()

import re
then = re.search("[0-9]{8}", content).group(0)

from datetime import date
today = date.strftime(date.today(), format="%Y%m%d")
import time
day = time.strftime("%A")

import os.path
if not os.path.exists(then + '.xml'):
    first = True
    call("git pull", shell=True)
    call("mv temp.xml " + then + '.xml', shell=True)
    call("git add .", shell=True)
    call("git commit -am 'auto-update for " + today + "'", shell=True)
    call("git push", shell=True)

percent = re.search('<ATTN_PCT>([0-9]+\.[0-9]+)</ATTN_PCT><LOC_CODE></LOC_CODE><SCHOOL_NAME>CITYWIDE TOTAL', content).group(1)

from random import choice
tags = ['@NYCSchools',
        '#NYC',
        '@GothamSchools',
        '@innovateNYCedu',
        '#eddata',
        '#EdTechNYC',
        '@Ed4Excellence',
        '@usedgov',
        '@attendanceworks',
        '#edchat']
tag = choice(tags)

links = ['bit.ly/NYCattendsNow',
         'bit.ly/NYCattdarch']
link = choice(links)

claims = ['NYC public school attendance for today was ' + percent + '%.',
          percent + '% of NYC public school students were in school today.',
          'On this fine ' + day + ', ' + percent + '% of NYC public school students were in school.',
          day + "'s NYC public school attendance: " + percent + '%']
claim = choice(claims)

tweet_text = claim + ' ' + link + ' ' + tag

if float(percent) < 70:
    tweet_text = "The NYCDOE reported " + percent + "% attendance for " + day + ". " + link

import tweetpony
import cnfg
my = cnfg.load('.twitterapprc')
if today == then and first:
    api = tweetpony.API(consumer_key=my['consumer_key'],
                        consumer_secret=my['consumer_secret'],
                        access_token=my['access_token'],
                        access_token_secret=my['access_token_secret'])
    api.update_status(status=tweet_text)
