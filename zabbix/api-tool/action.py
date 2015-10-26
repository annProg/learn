#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: action.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-25 00:43:55
############################

import json
from zabbixApi import *
import sys

#params = {"output":"extend","selectOperations": "extend"}

def getOperations(type, esc_period, esc_step_from, esc_step_to, userids, default_msg=1, mediatypeid=0):
	operation = {
		"operationtype": type,
		"esc_period": esc_period,
		"esc_step_from": esc_step_from,
		"esc_step_to": esc_step_to,
		"evaltype": "0",
		"opmessage_usr": userids,
		"opmessage": {"default_msg": default_msg, "mediatypeid": mediatypeid},
		"opconditions": [{"conditiontype": "14","value": "0","operator": "0"}]
	}
	return(operation)

def getParams(actionid, operations, name):
	params = { "actionid": actionid, "operations": operations, "name": name}
	return(params)

def getUserID(username):
	params = {"output":"userid","filter":{"alias":username}}
	uid = apiRun("user.get", params)
	return(uid)

def getGrpName(grpid):
	params = {"output":["name"], "usrgrpids":grpid}
	grpnames = apiRun("usergroup.get", params)
	if "name" in grpnames[0].keys():
		return(grpnames[0]['name'])
	else:
		return(False)

def rollBack():
	f = open('action_indent.bak', 'r')
	params = json.load(f)
	#print(params)
	data = apiRun("action.update", params)
	print(data)

def getBackup():
	params = {"selectOperations": "extend"}
	data = apiRun("action.get", params)
	with open("action_indent.bak", "a+") as f:
		f.write(json.dumps(data, indent=1))

if __name__ == '__main__':
	#params = {"output":"extend"}
	params = {"selectOperations": "extend"}
	data = apiRun("action.get", params)
	for action in data:
		actionid = action['actionid']
		print("")
		if "opmessage_grp" in action['operations'][0].keys():
			grpids = action['operations'][0]["opmessage_grp"]
		else:
			continue

		userids = []
		for grpid in grpids:
			grpname = getGrpName(grpid['usrgrpid'])
			userid = getUserID(grpname)[0]
			userids.append(userid)
		name = action['name']
		operations = []
		op1 = getOperations("0", "300", "1", "1", userids)
		op2 = getOperations("0", "600", "2", "6", userids)
		op3 = getOperations("0", "1800", "7", "0", userids)
		operations.append(op1)
		operations.append(op2)
		operations.append(op3)

		params = getParams(actionid, operations, name)
		print("")
		
		done = []
		#done = ["3", "4", "5", "6", "9", "11", "13"]
		if actionid in done:
			continue
		data = apiRun("action.update", params)
		print(data)
		#print(params)
		#print(action)
		#print(json.dumps(action, indent=1))
