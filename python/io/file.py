#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 文件读写
# $Id: file.py  i@annhe.net  2015-07-16 23:40:07 $
#-----------------------------------------------------------

filename = "file.py"
f = open(filename)
while True:
	line = f.readline()
	if not line:
		break
	print(line)
f.close()
