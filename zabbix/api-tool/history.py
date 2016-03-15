#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: history.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-03-15 13:49:05
############################

import zabbixApi
import json
import re
import copy
import sys

def getHistory(argv):
	itemid = argv[0].split(",")
	time_from = argv[1]
	time_till = argv[2]
	params = {"output":"extend", "itemids":itemid, "history": 0, "time_from": time_from, "time_till": time_till,
			"sortfield": "clock"}
	data = zabbixApi.apiRun("history.get", params)
	return(data)

if __name__ == '__main__':
	function = {
			"get": getHistory,
			}
	func = sys.argv[1]
	if func in function.keys():
		data = function[func](sys.argv[2:])
	else:
		data = "args error"
	print(json.dumps(data,indent=1))

