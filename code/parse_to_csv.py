#!/usr/bin/env python

import sys
import csv
from xml.etree import ElementTree as ET

fields = ['ATTN_DATE_YMD', 'DBN', 'ATTN_PCT',
          'SCHOOL_NAME', 'Borough', 'DistrictCode', 'LOC_CODE']

writer = csv.writer(sys.stdout)
writer.writerow(fields)

for filename in sys.argv[1:]:
    with open(filename) as f:
        # All data is on one long line.
        line = f.readline()
    # Remove ASCII decimal 26, "synchronous "
    line = line.replace(chr(26), '')
    root = ET.fromstring(line)
    for item in root:
        row = [item.find(field).text or '' for field in fields]
        writer.writerow([val.encode('utf-8') for val in row])
