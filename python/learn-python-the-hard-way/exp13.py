#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: argv
# $Id: exp13.py  i@annhe.net  2015-07-27 00:12:43 $
#-----------------------------------------------------------

from sys import argv

print("argc: " ,len(argv))
if(len(argv)<4):
	print("args error")
	exit(False)
script, first, second, third = argv
print("script:",script)
print("first:",first)
print("second:",second)
print("third:",third)
