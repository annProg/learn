#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 写文件
# $Id: wfile-exp16.py  i@annhe.net  2015-07-27 00:59:48 $
#-----------------------------------------------------------

import sys

script, filename = sys.argv

print("We're going to erase %r." % filename)
print("If you don't want that, hit CTRL-C (^C).")
print("If you do want that, hit RETURN.")

input("?")

print("Opening the file...")

with open(filename, 'w') as target:
	print("Truncation the file.  Goodbye!")
	target.truncate()

print("Now I'm going to ask you for three lines.")

line1 = input("line 1: ")
line2 = input("line 2: ")
line3 = input("line 3: ")

print("I'm going to write these to the file.")

with open(filename, 'w') as target:
	target.write(line1)
	target.write("\n")
	target.write(line2)
	target.write("\n")
	target.write(line3)
	target.write("\n")
target.close()
print("And finally, the stuff of %r is: \n" % filename)
with open(filename) as newfile:
	newfile.read()
