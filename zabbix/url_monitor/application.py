#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: application.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-07 22:31:48
############################

import zabbixApi
import json

def getApplicationByName(hostid, name):
	filters = {"name": name}
	params = {"output": ["name", "hostid"], "hostids":hostid, "filter":filters}
	data = zabbixApi.apiRun("application.get", params)
	return(data)

def getApplicationById(applicationid):
	params = {"output": ["name","hostid"], "applicationids":applicationid}
	data = zabbixApi.apiRun("application.get", params)
	return(data)

def createApplication(hostid, name):
	params = {"name": name, "hostid": hostid}
	data = zabbixApi.apiRun("application.create", params)
	return(data)

def updateApplication(name, applicationid):
	params = {"name": name, "applicationid": applicationid}
	data = zabbixApi.apiRun("application.update", params)
	return(data)

def deleteApplication(applicationid):
	params = []
	params.append(applicationid)
	data = zabbixApi.apiRun("application.delete", params)
	return(data)

if __name__ == '__main__':
	#print(getApplicationByName("10654", "tv_desktop"))
	#print(deleteApplicatioin("595"))
	print(getApplicationById("596"))
