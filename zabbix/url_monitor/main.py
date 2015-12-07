#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: main.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-07 23:44:41
############################


def init():
	data = cmdbApi.getObjectById('1256')
	ret = {}
	if(data['errmsg'] == "suc"):
		ret['hostname'] = data['']
	else:
		print("cmdb return " + str(data))
		return(data)

apis = cmdbApi.getObjectList("API")
	msg = apis['errmsg']
	if (msg == "failed"):
		exit()
	apiList = apis['result']

	for assetId in apiList:
		data = cmdbApi.getObjectById(str(assetId))
		msg = data['errmsg']
		if (msg == "failed"):
			exit()
		api = data['result']
		location = "http://" + api['domain'] + "/" + api['location']
		if (api['requestmethod'] == "GET"):
			url = location + "?" + api['getparam']
		else:
			url = location

		name = api['domain'] + "/" + api['location']
		status = api['responsecode']
		no = 1
		hostid = "10597"

		agent = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.8 (KHTML, like Gecko) Chrome/17.0.940.0 Safari/535.8"
		delay = 30
		required = api['responsedata']

