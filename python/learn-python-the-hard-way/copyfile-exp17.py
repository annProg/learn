#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 文件拷贝
# $Id: copyfile-exp17.py  i@annhe.net  2015-07-27 01:10:07 $
#-----------------------------------------------------------

import sys
import os

script, from_file, to_file = sys.argv

print("Copying from %s to %s" % (from_file, to_file))

with open(from_file) as infile:
	indata = infile.read()

print("The input file is %d bytes long" % len(indata))

print("Does the output file exist? %r" % os.path.exists(to_file))
print("Ready, hit RETURN to continue, CTRL-C to abort.")

input("?")

with open(to_file, 'w') as outfile:
	outfile.write(indata)
print("Alright, all done.")

