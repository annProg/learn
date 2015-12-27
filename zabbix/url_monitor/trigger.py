#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: trigger.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-07 22:31:48
############################

import zabbixApi
import json

def getTriggerByName(description):
	filters = {"description": description}
	params = {"output": "extend", "filter":filters}
	data = zabbixApi.apiRun("trigger.get", params)
	return(data)

def getTriggerById(triggerid):
	filters = {"triggerid": triggerid}
	params = {"output": "extend", "filter":filters}
	data = zabbixApi.apiRun("trigger.get", params)
	return(data)

def createTrigger(description, expression):
	params = {"description": description, "expression": expression, "priority": 3}
	data = zabbixApi.apiRun("trigger.create", params)
	return(data)

def updateTrigger(triggerid, description, expression):
	params = {"triggerid":triggerid, "description": description, "expression": expression, "priority": 3}
	data = zabbixApi.apiRun("trigger.update", params)
	return(data)

def deleteTrigger(triggerids):
	param = triggerids
	data = zabbixApi.apiRun("trigger.delete", params)
	return(data)

if __name__ == '__main__':
	#print(getApplicationByName("10654", "tv_desktop"))
	#print(getTriggerById("10122", "13805"))
	print(getTriggerByName("Request Error: a-interact.scloud.letv.com/api/v1/InteractProgram/currentProgram"))
