#!/usr/bin/env python3

import argparse
import os
import shutil
import sys

parser = argparse.ArgumentParser(description='Flatten all files recursively from srcPath to destPath ')
parser.add_argument('srcPath')
parser.add_argument('destPath')
parser.add_argument('--dryRun', action='store_true')
parser.add_argument('--deleteSrcPath', action='store_true')
args = parser.parse_args()

for root, _, files in os.walk(args.srcPath):
    for name in files:
        srcFile = os.path.join(root, name)
        destFile = os.path.join(args.destPath, name)
        if os.path.exists(destFile):
            data1 = open(srcFile, 'rb').read()
            data2 = open(destFile, 'rb').read()
            if data1 == data2:
                print('Duplicate, ignoring')
                if not args.dryRun and args.deleteSrcPath:
                    os.unlink(srcFile)
                continue
            prefix, ext = os.path.splitext(destFile)
            counter = 0
            while os.path.exists(destFile):
                destFile = "%s_%s%s" % (prefix, counter, ext)
                counter += 1
            print('Existing different file, alternate name', destFile)

        if not args.dryRun:
            if args.deleteSrcPath:
                shutil.move(srcFile, destFile)
            else:
                shutil.copy2(srcFile, destFile)

if args.deleteSrcPath:
    removeSrcPath = True
    for root, _, files in os.walk(args.srcPath):
        if len(files) > 0:
            removeSrcPath = False
            break

    if removeSrcPath:
        print('All files gone, cleaning directory')
        if not args.dryRun:
            shutil.rmtree(args.srcPath)
