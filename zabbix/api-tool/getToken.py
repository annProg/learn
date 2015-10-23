#!/usr/bin/env python3
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: getToken.py  me@annhe.net  2015-10-22 17:16:07 $
#-----------------------------------------------------------
 
import requests
import json
import configparser

ini = "conf.ini"
config = configparser.ConfigParser()
config.read(ini)

url = config.get("login", "url")
user = config.get("login", "user")
passwd = config.get("login", "passwd")
headers = {'content-type': 'application/json'}

data = json.dumps(
{
	"jsonrpc": "2.0",
    "method": "user.login",
    "params": {
		"user": user,
		"password": passwd
		},
	"id": 0	
}		
)

def getToken():
	global config
	try:
		r = requests.post(url, data=data, headers=headers)
		auth = json.loads(r.text)['result']
		config.set("auth", "token", auth)
		config.write(open(ini, "w"))
		return(auth)
	except:
		return("Login Failed")

if __name__ == '__main__':
	print(getToken())
