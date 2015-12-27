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
import sys

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
	params = triggerids
	data = zabbixApi.apiRun("trigger.delete", params)
	return(data)

if __name__ == '__main__':
	if sys.argv[1] == "id":
		print(getTriggerById(sys.argv[2]))
	if sys.argv[1] == "name":
		print(getTriggerByName(sys.argv[2]))
