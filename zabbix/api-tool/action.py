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

#params = {"selectOperations": "extend"}
params = {"output":"extend"}
#params = {"output":"extend","selectOperations": "extend"}

data = apiRun("action.get", params)
#print(data)
for action in data:
	print(json.dumps(action, indent=1))

'''
def getOperations(type, esc_period, esc_step_from, esc_step_to, userid, default_msg, mediatypeid):
	operation = {
		"operationtype": type,
		"esc_period": esc_period,
		"esc_step_from": esc_step_from,
		"esc_step_to": esc_step_to,
		"evaltype": "0",
def updateAction(actionid, esc_period, userid, mediatypeid=0)
params = {
	"actionid":"68",
	"operations": [
		{
			"operationtype": "0",
			"esc_period": "100",
			"esc_step_from": "3",
			"esc_step_to": "4",
			"evaltype": "0",
			"opmessage_usr": [
			{
			 "userid": "183"
			}],
		    "opmessage": {
			 "default_msg": "1",
			 "mediatypeid": "0",
		    }
		},
		{
			"operationtype": "0",
			"esc_period": "100",
			"esc_step_from": "1",
			"esc_step_to": "2",
			"evaltype": "0",
			"opmessage_usr": [
			{
			 "userid": "183"
			}],
		    "opmessage": {
			 "default_msg": "1",
			 "mediatypeid": "0",
		    }
		}
	],
	"name": "测试动作API修改"
}

data = apiRun("action.update", params)
print(data)
'''
