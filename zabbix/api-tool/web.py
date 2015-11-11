#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: web.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-11 14:59:33
############################

import zabbixApi
import sys
import json

def getScenario():
	params = {"output": "extend","selectSteps": "extend"}
	data = zabbixApi.apiRun("httptest.get", params)
	return(data)

if __name__ == '__main__':
	func = sys.argv[1]
	if func == "get":
		print(json.dumps(getScenario(),indent=1))
