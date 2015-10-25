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
import copy
from rand import *

ini = "conf.ini"
config = configparser.ConfigParser()
config.read(ini)

token = config.get("auth", "token")
url = config.get("login", "url")

header = {"Content-Type": "application/json"}

# request data


def apiRun(method,params):
	id = GenDigit(4)
	data = json.dumps(
	{
		"jsonrpc":"2.0",
		"method": method,
		"params":params,
		"auth":token,
		"id":id,
	})

	print(data)
	#try:
	r = requests.get(url, data=data, headers=header)
	print(json.loads(r.text))
	return(json.loads(r.text)['result'])
	#except:
	#	print("run" + params + "Failed")

if __name__ == '__main__':
	params = {"output":"mediatypeid"}
	mediatypes = apiRun("mediatype.get", params)
	newmedia = {}
	for mediatype in mediatypes:
		newmedia[mediatype['mediatypeid']] = []

	params = {"output":["usrgrpid","name"]}
	data = apiRun("usergroup.get", params)
	
	for grpid in data:
		tmp = copy.deepcopy(newmedia)
		gid = grpid['usrgrpid']
		params = {"usrgrpids":gid,"output":["mediatypeid","sendto"]}
		medias = apiRun("usermedia.get", params)

		for media in medias:
			tmp[media['mediatypeid']].append(media['sendto'])
		grpid['media'] = tmp
#		for k,v in tmp.items():
#			tmpdict = {k,v}
#			grpid['media'].append(tmpdict)
		#print(json.dumps(grpid,indent=1))
		password = GenPassword(14)
		user_medias = []
		for k,v in tmp.items():
			sendto = ",".join(v)
			if k=="4":
				continue
			if k=="1":
				mediaitem = {"mediatypeid":"4", "sendto":sendto, "active": 0, "severity": 63,"period": "1-7,00:00-24:00"}
			if k=="3":
				mediaitem = {"mediatypeid":"3", "sendto":sendto, "active": 0, "severity": 63,"period": "1-7,00:00-24:00"}
			user_medias.append(mediaitem)
		params = {"alias":grpid['name'],"passwd":password,"usrgrps":[{"usrgrpid":"76"}],"user_medias":user_medias}
		apiRun("user.create", params)
		print(params)
'''

	usermedias = getUserMediaList()
	for usermedia in usermedias:
		print("MediaID:",usermedia['mediaid'],"UserID:",usermedia['userid'],"MediaType:",usermedia['mediatypeid'],"SendTo:",usermedia['sendto'])

		'''
