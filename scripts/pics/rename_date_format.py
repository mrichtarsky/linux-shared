#!/usr/bin/env python3

import argparse
from datetime import datetime
import os
import re
import shutil

parser = argparse.ArgumentParser(description='Rename all files matching with the given case-insentive extension. New name is the creation time of the file.')
parser.add_argument('path')
parser.add_argument('--dryRun', action='store_true')
args = parser.parse_args()

def getTimeStr(timestamp):
    dt = datetime.fromtimestamp(timestamp)
    return dt.strftime("%Y-%m-%d_%H%M%S")

for root, _, files in os.walk(args.path):
    for name in files:
        if mo := re.match(r'^(\d\d\d\d)(\d\d)(\d\d)_(\d\d)(\d\d)(\d\d)([^\d].*)$', name):
            year, month, day, hour, min_, sec, suffix = mo.groups()
            dstFile = os.path.join(root, f"{year}-{month}-{day}_{hour}{min_}{sec}{suffix}")
            srcFile = os.path.join(root, name)
        elif mo := re.match(r'^(.*)(20[0-9][0-9])([0-1][0-9])([0-3][0-9])(.*)$', name):
            prefix, year, month, day, suffix = mo.groups(0)
            dstFile = os.path.join(root, f"{year}-{month}-{day}{suffix}")
            srcFile = os.path.join(root, name)
        else:
            continue
        print(srcFile, '->', dstFile)
        exists = os.path.exists(dstFile)
        if exists:
            print('Exists')
        if not args.dryRun and not exists:
            shutil.move(srcFile, dstFile)
