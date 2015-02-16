#!/usr/bin/env python

import glob
from lxml import etree
import sys
import csv

fields = ['ATTN_DATE_YMD', 'DBN', 'ATTN_PCT',
          'SCHOOL_NAME', 'Borough', 'DistrictCode', 'LOC_CODE']
rows = [fields]

for filename in sorted(glob.glob('../xml/*.xml')):
  with open(filename) as file:
    # All data is on one long line.
    line = file.readline()
    # Remove ASCII decimal 26, "synchronous "
    line = line.replace(chr(26), '')
    root = etree.fromstring(line)
    for item in root:
      contents = dict()
      for element in item:
        if element.text: contents[element.tag] = element.text
      rows.append([contents.get(field,'').encode('utf-8') for field in fields])

writer = csv.writer(sys.stdout)
for line in rows:
  writer.writerow(line)
