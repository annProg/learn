#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: getUserMedia.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-23 11:15:33
############################

import zabbixApi
import json
import copy
from rand import *

mediatype = [{"id":"1", "type":"Email"}, {"id":"3", "type":"SMS"}, {"id":"4", "type":"emailScript"}]
readgroup = ["76"]
readmedia = ["4"]

def getMediaTypes():
	params = {"output":"mediatypeid"}
	mediatypes = zabbixApi.apiRun("mediatype.get", params)
	return mediatypes

def getUserGrps():
	params = {"output":["usrgrpid","name"]}
	data = zabbixApi.apiRun("usergroup.get", params)
	return(data)

def getUserId(username):
	params = {"output":["userid", "alias"],"filter":{"alias":username}}
	data = zabbixApi.apiRun("user.get", params)
	#print(data)
	try:
		return(data[0]['userid'])
	except:
		return(False)

def getGrpMedias(grpid):
	mediatypes = getMediaTypes()
	newmedias = {}
	for mediatype in mediatypes:
		newmedias[mediatype['mediatypeid']] = []
	
	params = {"usrgrpids":grpid, "output":["mediatypeid", "sendto"]}
	medias = zabbixApi.apiRun("usermedia.get", params)
	try:
		for media in medias:
			newmedias[media['mediatypeid']].append(media['sendto'])
		return(newmedias)
	except:
		return(False)
	

def updateMedias(userid, medias):
	params = {"users":[{"userid":userid}],"medias":medias}
	#print(params)
	data = zabbixApi.apiRun("user.updatemedia", params)
	return(data)

def resetMedia():
	for grpid in data:
		tmp = copy.deepcopy(newmedia)
		gid = grpid['usrgrpid']
		params = {"usrgrpids":gid,"output":["mediatypeid","sendto"]}
		medias = apiRun("usermedia.get", params)

		for media in medias:
			tmp[media['mediatypeid']].append(media['sendto'])
		grpid['media'] = tmp

		password = GenPassword(14)
		user_medias = []
		for k,v in tmp.items():
			print(v)
			sendto = ",".join(v)
			sendto = sendto.replace("@letv.com", "")
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

def doUpdateMedia():
	grps = getUserGrps()
	for grp in grps:
		medias = []
		grpname = grp['name']
		grpid = grp['usrgrpid']
		if grpid in readgroup:
			continue
		grpmedia = getGrpMedias(grpid)
		#print(grpmedia)
		for k,v in grpmedia.items():
			sendto = ",".join(v)
			sendto = sendto.replace("@letv.com", "")
			if k in readmedia:
				continue
			elif k=="1":
				mediaitem = {"mediatypeid": "4", "sendto": sendto, "active": 0, "severity": 63, "period": "1-7,00:00-24:00"}
			elif k=="3":
				mediaitem = {"mediatypeid": "3", "sendto": sendto, "active": 0, "severity": 63, "period": "1-7,00:00-24:00"}
			else:
				continue
			medias.append(mediaitem)

		userid = getUserId(grpname)
		data = updateMedias(userid, medias)
		print(data)
		#print(medias)

if __name__ == '__main__':
	doUpdateMedia()
