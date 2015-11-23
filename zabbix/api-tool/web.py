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
import cmdbApi

def getScenario():
	params = {"output": "extend","selectSteps": "extend"}
	data = zabbixApi.apiRun("httptest.get", params)
	return(data)

def init():
	data = cmdbApi.getObjectById('1256')
	ret = {}
	if(data['errmsg'] == "suc"):
		ret['hostname'] = data['']
	else:
		print("cmdb return " + str(data))
		return(data)

def createHost():
	pass

def createScenario(name):
	url = "http://upgrade.hdtv.letv.com/tvosup/api/upgrade/getUpgradeProfile?mac=c80e77633221&model=S250F&uid=3.0&version=V640R360C022B00000S&defFlag=0"
	steps = [{"name": "api Check", "url": url, "status_codes": 200, "no": 1}]
	params = {"name": name, "hostid": "10597", "steps": steps}
	data = zabbixApi.apiRun("httptest.create", params)
	return(data)

if __name__ == '__main__':
	func = sys.argv[1]
	if func == "get":
		print(json.dumps(getScenario(),indent=1))
	if func == "create":
		print(json.dumps(createScenario("demo_ota_tv_getUpgradeProfile")))
	init()
