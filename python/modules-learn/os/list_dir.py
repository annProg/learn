#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: list_dir.py  me@annhe.net  2015-09-24 11:29:33 $
#-----------------------------------------------------------

import os, re

dir_path = os.path.join(os.getcwd(), "rule/")
reg_match = "(.*\.)rule"
ruleFiles = []

def list_dir(match, path):
	global ruleFiles
	if os.path.isfile(path):
		if re.match(match,path):
			ruleFiles.append(path)
	else:
		for f in os.listdir(path):
			if f[0] == '.':
				continue
			abs_f = os.path.join(path,f)
			if os.path.isfile(abs_f):
				if re.match(match,f):
					ruleFiles.append(abs_f)
			elif os.path.isdir(abs_f):
				list_dir(match,abs_f)

if __name__ == '__main__':
	list_dir(reg_match, dir_path)
	print(ruleFiles) 

