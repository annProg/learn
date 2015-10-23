#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: getHost.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-23 11:15:33
############################

import requests
import json
import configparser

ini = "conf.ini"
config = configparser.ConfigParser()
config.read(ini)

token = config.get("auth", "token")
url = config.get("login", "url")

header = {"Content-Type": "application/json"}

# request data

data = json.dumps(
{
	"jsonrpc":"2.0",
	"method":"host.get",
	"params":{
		"output":["hostid","name"],
		"filter":{"host":""}
		},
	"auth":token,
	"id":1,
})

def getHostList():
	try:
		r = requests.get(url, data=data, headers=header)
		return(json.loads(r.text)['result'])
	except:
		print("get HostList Failed")

if __name__ == '__main__':
	hosts = getHostList()
	for host in hosts:
		print("HostID:",host['hostid'],"HostName:",host['name'])
