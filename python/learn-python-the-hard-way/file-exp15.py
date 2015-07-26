#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 文件读写
# $Id: file-exp15.py  i@annhe.net  2015-07-27 00:47:57 $
#-----------------------------------------------------------

import sys

script, filename = sys.argv


print("Here's your file %s:" % filename)
with open(filename) as txt:
	print(txt.read())

print("I'll also ask you to type it again:")
file_again = input("> ")
with open(file_again) as txt_again:
	print(txt_again.read())
