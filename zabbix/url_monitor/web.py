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

def getScenarioById(hostid, httptestid):
	filters = {"hostid": hostid, "httptestid": httptestid}
	params = {"output": ["httptestid", "name", "hostid"], "selectSteps": ["httpstepid"],"filter": filters}
	data = zabbixApi.apiRun("httptest.get", params)
	return(data)

def createScenario(argv):
	name = argv['name']
	hostid = argv['hostid']
	url = argv['url']
	status_code = argv['status_code']
	no = argv['no']
	required = argv['required']
	delay = argv['delay']
	agent = argv['agent']	
	applicationid = argv['applicationid']
	posts = argv['posts']
	status = argv['status']

	steps = [{"name": "api Check", "url": url, "posts": posts, "status_codes": status_code, "no": no, "required": required}]
	params = {"name": name, "hostid": hostid, "steps": steps, "delay": delay, "agent": agent, 
			"applicationid":applicationid, "status": status}

	data = zabbixApi.apiRun("httptest.create", params)
	return(data)

def updateScenario(argv):
	name = argv['name']
	hostid = argv['hostid']
	url = argv['url']
	status_code = argv['status_code']
	no = argv['no']
	required = argv['required']
	delay = argv['delay']
	agent = argv['agent']	
	applicationid = argv['applicationid']
	httptestid = argv['httptestid']
	httpstepid = argv['httpstepid']
	posts = argv['posts']

	steps = [{"httpstepid":httpstepid, "name": "api Check", "url": url, "posts": posts, 
		"status_codes": status_code, "no": no, "required": required}]
	params = {"name": name, "hostid": hostid, "steps": steps, "delay": delay, "agent": agent, 
			"applicationid":applicationid, "httptestid": httptestid, "status": argv['status']}

	data = zabbixApi.apiRun("httptest.update", params)
	return(data)

if __name__ == '__main__':
	func = sys.argv[1]
	if func == "get":
		print(json.dumps(getScenarioById(sys.argv[2], sys.argv[3]),indent=1))
	if func == "create":
		argv = {"name":"api_m_test", "hostid":"10653", "url": "http://10.181.117.47:8000/upstream", "status":"200", "no":1, "required":"br", "delay":30, "agent":"curl"}
		print(json.dumps(createScenario(argv)))
