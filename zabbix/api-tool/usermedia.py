#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: getUserMedia.py
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


def SimpleGet(method,params):
	data = json.dumps(
	{
		"jsonrpc":"2.0",
		"method": method + ".get",
		"params":params,
		"auth":token,
		"id":1,
	})

	try:
		r = requests.get(url, data=data, headers=header)
		return(json.loads(r.text)['result'])
	except:
		print("get" + method + "Failed")

if __name__ == '__main__':
	params = {"output":["usrgrpid","name"]}
	data = SimpleGet("usergroup", params)
	
	result = {}
	for grpid in data:
		gid = grpid['usrgrpid']
		params = {"usrgrpids":gid,"output":["userid","alias"]}
		users = SimpleGet("user", params)
		grpid['user'] = users
		for user in users:
			uid = user['userid']
			params = {"userids":uid,"output":["mediatypeid","sendto"]}
			medias = SimpleGet("usermedia", params)
			grpid['media'] = medias
		print(json.dumps(grpid,indent=1))

	'''
	usermedias = getUserMediaList()
	for usermedia in usermedias:
		print("MediaID:",usermedia['mediaid'],"UserID:",usermedia['userid'],"MediaType:",usermedia['mediatypeid'],"SendTo:",usermedia['sendto'])

		'''
