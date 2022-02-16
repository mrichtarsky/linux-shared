#!/usr/bin/env python3

import argparse
from datetime import datetime
import os
import shutil
import stat

parser = argparse.ArgumentParser(description='Rename all files matching with the given case-insentive extension. New name is the creation time of the file.')
parser.add_argument('path')
parser.add_argument('extension')
parser.add_argument('--dryRun', action='store_true')
args = parser.parse_args()

def getTimeStr(timestamp):
    dt = datetime.fromtimestamp(timestamp)
    return dt.strftime("%Y-%m-%d_%H%M%S")

for root, _, files in os.walk(args.path):
    for name in files:
        srcFile = os.path.join(root, name)
        _, extOrig = os.path.splitext(srcFile)
        ext = extOrig.lstrip('.')
        if ext.lower() != args.extension.lower():
            continue
        info = os.stat(srcFile)
        dstFileName = getTimeStr(info[stat.ST_MTIME])
        dstFile = os.path.join(root, dstFileName + extOrig.lower())
        print(f"{srcFile} -> {dstFile}")
        if not args.dryRun:
            shutil.move(srcFile, dstFile)
