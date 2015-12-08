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

def getTriggerByName(hostid, description):
	filters = {"description": description}
	params = {"output": "extend", "hostids":hostid, "filter":filters}
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

if __name__ == '__main__':
	#print(getApplicationByName("10654", "tv_desktop"))
	print(getTriggerByName("10120", "Scenario test Failed: base_ota_upgrade.hdtv.letv.com_getUpgradeProfile"))
