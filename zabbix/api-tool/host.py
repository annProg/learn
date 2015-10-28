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

def getHostIpList():
	params = {"output":["hostid", "ip"], "filter":{"type":"1"}}
	data = zabbixApi.apiRun("hostinterface.get", params)
	return(data)

if __name__ == '__main__':
	data = getHostIpList()
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
