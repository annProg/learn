#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: cmdbApi.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-23 10:51:34
############################

import configparser
import requests

ini = "config.ini"
config = configparser.ConfigParser()
config.read(ini)

url = config.get("cmdb", "url")
user = config.get("cmdb", "user")
passwd = config.get("cmdb", "passwd")

def runRequest(request):
	data = {}
	try:
		r = requests.get(request, auth=requests.auth.HTTPBasicAuth(user, passwd))
		data['errmsg'] = "suc"
		data['result'] = r.json()
	except:
		data['errmsg'] = "failed"
		data['result'] = {}

	data['errno'] = r.status_code
	return(data)

def getObjectById(assetId):
	action = "objects"
	request = url + action + "/" + assetId
	data = runRequest(request)

	ret = {}
	ret['errno'] = data['errno']
	ret['errmsg'] = data['errmsg']
	ret['result'] = {}
	try:
		objectFields = data['result']['objectFields']
		for k,v in objectFields.items():
			for item in v:
				key = item['name']
				value = item['value']
				ret['result'][key] = value
	except:
		return(data)
	return(ret)

def getObjectList(objectType):
	action = "objectlist/by-objecttype"
	request = url + action + "/" + objectType
	data = runRequest(request)
	return(data)

if __name__ == '__main__':
	#print(getObjectById("1257"))
	print(getObjectList("API"))
