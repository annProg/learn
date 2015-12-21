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
import json
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
		data['errno'] = r.status_code
	except:
		data['errmsg'] = "failed"
		data['result'] = {}
		data['errno'] = "10001"

	return(data)

def getObjectById(assetId, orig=1):
	action = "objects"
	request = url + action + "/" + assetId
	data = runRequest(request)
	
	if orig != 1:
		return(data)

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

	ret['result']['objid'] = assetId
	return(ret)

def updateObject(argv):
	action = "objects"
	request = url + action + "/" + argv['objid']

	objtype = argv['objtype']
	objid = argv['objid']
	objfields = argv['objfields']

	param={"objectType":objtype,"objectId":objid,"status":"A","objectFields":objfields}
	data = requests.put(request, data=json.dumps(param), auth=requests.auth.HTTPBasicAuth(user, passwd))
	return(data)


def getObjectList(objectType):
	action = "objectlist/by-objecttype"
	request = url + action + "/" + objectType
	data = runRequest(request)
	return(data)

def getObjectListByValue(fieldvalue):
	action = "objectlist/by-fieldvalue"
	request = url + action + "/" + fieldvalue
	data = runRequest(request)
	return(data)

if __name__ == '__main__':
	print(getObjectById("1918"))
	#print(getObjectListByValue("GET"))
	#print(getObjectById("70"))
	#print(getObjectById("1254"))
	#argv = {"assetid":"1257", "objtype":"API"}
	#updateObject(argv)
	#print(getObjectList("API"))
