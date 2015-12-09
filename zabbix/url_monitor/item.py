#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: item.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-09 15:42:58
############################

import zabbixApi
import json

def getItem(hostid):
	params = {"output":["hostid", "key_", "name"], "hostids": hostid, "webitems":1}
	data = zabbixApi.apiRun("item.get", params)
	return(data)

if __name__ == '__main__':
	print(json.dumps(getItem("10656"),indent=1))
