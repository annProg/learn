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

def getScenarioByName(hostid, name):
	filters = {"hostid": hostid, "name": name}
	params = {"output": ["httptestid", "name", "hostid"], "filter": filters}
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

def createScenario(argv):
	name = argv['name']
	hostid = argv['hostid']
	url = argv['url']
	status = argv['status']
	no = argv['no']
	required = argv['required']
	delay = argv['delay']
	agent = argv['agent']	

	steps = [{"name": "api Check", "url": url, "status_codes": status, "no": no, "required": required}]
	params = {"name": name, "hostid": hostid, "steps": steps, "delay": delay, "agent": agent}

	data = zabbixApi.apiRun("httptest.create", params))
	return(data)

	apis = cmdbApi.getObjectList("API")
	msg = apis['errmsg']
	if (msg == "failed"):
		exit()
	apiList = apis['result']

	for assetId in apiList:
		data = cmdbApi.getObjectById(str(assetId))
		msg = data['errmsg']
		if (msg == "failed"):
			exit()
		api = data['result']
		location = "http://" + api['domain'] + "/" + api['location']
		if (api['requestmethod'] == "GET"):
			url = location + "?" + api['getparam']
		else:
			url = location

		name = api['domain'] + "/" + api['location']
		status = api['responsecode']
		no = 1
		hostid = "10597"

		agent = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.8 (KHTML, like Gecko) Chrome/17.0.940.0 Safari/535.8"
		delay = 30
		required = api['responsedata']


if __name__ == '__main__':
	func = sys.argv[1]
	if func == "get":
		print(json.dumps(getScenarioByName("10653", "ota_tv_getUpgradeProfile"),indent=1))
	if func == "create":
		print(json.dumps(createScenario()))
