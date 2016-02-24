#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: item.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-23 11:15:33
############################

import zabbixApi
import json
import re
import copy
import sys

def getItemList(argv):
	grpid = argv[0].split(",")
	key = argv[1]
	params = {"output":["hostid", "itemids", "key_", "lastvalue"], "groupids":grpid, "search": {"key_": key}}
	data = zabbixApi.apiRun("item.get", params)
	return(data)

if __name__ == '__main__':
	function = {
			"get": getItemList,
			}
	func = sys.argv[1]
	if func in function.keys():
		data = function[func](sys.argv[2:])
	else:
		data = "args error"
	print(json.dumps(data,indent=1))
