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

ini = "cmdb_conf.ini"
config = configparser.ConfigParser()
config.read(ini)

url = config.get("login", "url")
user = config.get("login", "user")
passwd = config.get("login", "passwd")

def getObjectById(assetId):
	action = "objects"
	request = url + action + "/" + assetId

	data = {}
	try:
		r = requests.get(request, auth=requests.auth.HTTPBasicAuth(user, passwd))
		objectFields = r.json()['objectFields']
		data['errmsg'] = "suc"
		data['errno'] = r.status_code
		for k,v in objectFields.items():
			for item in v:
				key = item['name']
				value = item['value']
				data['result'][key] = value
	except:
		data['errmsg'] = "failed"
		data['errno'] = r.status_code
		data['result'] = {}

	return(data)


if __name__ == '__main__':
	print(getObjectById("1256"))
