#!/usr/bin/env python
#-*- coding:utf-8 -*-	

############################
# Usage:
# File Name: column_discovery.py
# Author: annhe	
# Mail: i@annhe.net
# Created Time: 2016-01-18 11:43:08
############################

import json
import sys
import os

path=os.getcwd()

def discovery(filename,macro):
	filepath=path + "/" + filename

	data = {'data':[]}
	with open(filepath,'r') as f:
		for i in f.readlines():
			data['data'].append({'{#' + macro + '}':i.strip()})

	print json.dumps(data)

if __name__ == '__main__':
	discovery(sys.argv[1], sys.argv[2])
