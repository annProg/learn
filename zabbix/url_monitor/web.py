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
	params = {"output": ["httptestid", "name", "hostid"], "selectSteps": ["httpstepid"],"filter": filters}
	#params = {"output": ["httptestid", "name", "hostid"], "filter": filters}
	data = zabbixApi.apiRun("httptest.get", params)
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
	applicationid = argv['applicationid']

	steps = [{"name": "api Check", "url": url, "status_codes": status, "no": no, "required": required}]
	params = {"name": name, "hostid": hostid, "steps": steps, "delay": delay, "agent": agent, "applicationid":applicationid}

	data = zabbixApi.apiRun("httptest.create", params)
	return(data)

def updateScenario(argv):
	name = argv['name']
	hostid = argv['hostid']
	url = argv['url']
	status = argv['status']
	no = argv['no']
	required = argv['required']
	delay = argv['delay']
	agent = argv['agent']	
	applicationid = argv['applicationid']
	httptestid = argv['httptestid']
	httpstepid = argv['httpstepid']

	steps = [{"httpstepid":httpstepid, "name": "api Check", "url": url, "status_codes": status, "no": no, "required": required}]
	params = {"name": name, "hostid": hostid, "steps": steps, "delay": delay, "agent": agent, 
			"applicationid":applicationid, "httptestid": httptestid}

	data = zabbixApi.apiRun("httptest.update", params)
	return(data)

if __name__ == '__main__':
	func = sys.argv[1]
	if func == "get":
		print(json.dumps(getScenarioByName("10119", "base_ota__getUpgradeProfile"),indent=1))
	if func == "create":
		argv = {"name":"api_m_test", "hostid":"10653", "url": "http://10.181.117.47:8000/upstream", "status":"200", "no":1, "required":"br", "delay":30, "agent":"curl"}
		print(json.dumps(createScenario(argv)))
