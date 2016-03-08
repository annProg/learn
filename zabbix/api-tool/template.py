#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: template.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-23 11:15:33
############################

import zabbixApi
import json
import re
import copy
import sys

def getHostList(argv):
	templateid = argv[0]
	params = {"output":["templateid"], "selectHosts":["hostid"], "templateids": templateid}
	data = zabbixApi.apiRun("template.get", params)
	return(data)
	
if __name__ == '__main__':
	function = {
			"get": getHostList,
			}
	func = sys.argv[1]
	if func in function.keys():
		data = function[func](sys.argv[2:])
	else:
		data = "args error"
	print(json.dumps(data,indent=1))
