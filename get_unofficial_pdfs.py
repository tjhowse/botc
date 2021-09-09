#!/usr/bin/python3
URL = 'http://bignose.whitetree.org/projects/botc/diy/'

import httplib2
from bs4 import BeautifulSoup, SoupStrainer

http = httplib2.Http()
status, response = http.request(URL)

for link in BeautifulSoup(response, parse_only=SoupStrainer('a'), features="html.parser"):
    if link.has_attr('href') and link['href'].endswith(".pdf"):
        print(URL+link['href'])
