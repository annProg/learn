#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: getHost.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-23 11:15:33
############################

import zabbixApi
import json
import re
import copy
import sys

def getHostByName(argv):
	hostname = argv[0]
	params = {"output": ["hostid", "host", "name"], "selectInterfaces":"extend", "selectGroups": ["groupid","name"], "selectParentTemplates": ["templateid", "name"], "filter": {"name":hostname}}
	data = zabbixApi.apiRun("host.get", params)
	return(data)

def getHostList(argv):
	#grpid = argv[0]
	grpid = argv[0].split(",")
	params = {"output":["hostid", "host", "name"],"groupids":grpid, "selectInterfaces":["ip", "port", "type"]}
	#print(params)
	data = zabbixApi.apiRun("host.get", params)
	return(data)

def getHostById(argv):
	hostids = argv[0].split(",")
	params = {"output":["hostid", "host", "name"], "selectInterfaces":["ip", "port", "type"], "hostids":hostids, "filter":{"type":"1"}}
	data = zabbixApi.apiRun("host.get", params)
	return(data)
	

def getHostInterface(argv):
	params = {"output":["hostid", "ip"], "filter":{"type":"1"}}
	data = zabbixApi.apiRun("hostinterface.get", params)
	return(data)

def getHostIpList(argv):
	data = getHostInterface(argv)
	iplist = {}
	
	for i in data:
		hostid = i['hostid']
		iplist[hostid] = []

	for i in data:
		hostid = i['hostid']
		ip = i['ip']
		iplist[hostid].append(ip)
	regex = re.compile(r'^10\..*')
	for k,v  in iplist.items():
		if len(v) == 1:
			continue
		for index in range(len(v)):
			ip = v[index]
			if not re.search(regex, ip):
				iplist[k].remove(ip)
				break
		iplist[k] = list(set(iplist[k]))
	for k,v in iplist.items():
		print(v[0])
		#if i['ip'] != "127.0.0.1":
		#	print(i['ip'])

def addHost(argv):
	ip = argv[0]
	name = argv[1]
	grpids = argv[2]
	templateids = argv[3]
	host = name + ".scloud.letv.com"
	interfaces = [
			{"type":1, "main":1, "useip":1, "ip":ip, "dns":"", "port":"10040"},
			{"type":2, "main":1, "useip":1, "ip":ip, "dns":"", "port":"161", "bulk":1},
			{"type":4, "main":1, "useip":1, "ip":ip, "dns":"", "port":"9988"}
			]

	groups = []
	for grpid in  grpids.split(","):
		group = {"groupid": grpid}
		groups.append(group)

	templates = []
	for templateid in templateids.split(","):
		template = {"templateid": templateid}
		templates.append(template)

	params = {"host": host, "name": name, "interfaces":interfaces, "groups": groups, "templates": templates}
	data = zabbixApi.apiRun("host.create", params)
	return(data)

def template_clear(argv):
	hostid = argv[0]
	templateid = argv[1]
	params = {"hostid": hostid, "templates_clear": [{"templateid": templateid}]}
	data = zabbixApi.apiRun("host.update", params)
	return(data)

def getAllHostId(argv):
	params = {"output":["hostid"]}
	data = zabbixApi.apiRun("host.get", params)
	return(data)
	
if __name__ == '__main__':
	function = {
			"get": getHostById,
			#"get": getHostByName,
			"add": addHost,
			"ips": getHostIpList,
			"list": getHostList,
			"ids": getAllHostId,
			"unlink": template_clear
			}
	func = sys.argv[1]
	if func in function.keys():
		data = function[func](sys.argv[2:])
	else:
		data = "args error"
	print(json.dumps(data,indent=1))
