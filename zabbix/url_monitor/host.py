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
import sys

def getHostByName(argv):
	hostname = argv[0]
	params = {"output": ["hostid", "host", "name"], "selectInterfaces":"extend", "selectGroups": ["groupid","name"], "selectParentTemplates": ["templateid", "name"], "filter": {"name":hostname}}
	data = zabbixApi.apiRun("host.get", params)
	return(data)

def addHost(argv):
	hostname = argv[0]
	grpids = argv[1]
	name = argv[2]
	templateids = argv[3]

	groups = []
	for grpid in  grpids.split(","):
		group = {"groupid": grpid}
		groups.append(group)

	interfaces = [
			{"type":1, "main":1, "useip":1, "ip":"127.0.0.1", "dns":"", "port":"10050"}
			]

	params = {"host": hostname, "name": name, "interfaces":interfaces, "groups": groups}
	data = zabbixApi.apiRun("host.create", params)
	return(data)

if __name__ == '__main__':
	function = {
			"get": getHostByName,
			"add": addHost
			}
	func = sys.argv[1]
	if func in function.keys():
		data = function[func](sys.argv[2:])
	else:
		data = "args error"
	print(data)
