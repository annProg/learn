#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: function.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-07 23:44:41
############################

import web
import host
import application
import trigger
import cmdbApi
import db

def getHostName(productId):
	ob_product = cmdbApi.getObjectById(productId)
	if ob_product['errmsg'] == "failed":
		print(ob_product)
		return(False)
	product = ob_product['result']['product']
	businessId = ob_product['result']['business']
	ob_business = cmdbApi.getObjectById(businessId)
	if ob_business['errmsg'] == "failed":
		print(ob_business)
		return(False)
	business = ob_business['result']['code']
	hostname = business + "." + product
	return(hostname)

def getHostId(hostname):
	hostids = host.getHostByName(hostname)
	if not hostids:
		argv = [hostname, groupid, ""]
		data = host.addHost(argv)
		try:
			hostid = data['hostids'][0]
			return(hostid)
		except:
			print(data)
			return(False)
	hostid = hostids[0]['hostid']
	return(hostid)
	
def getApplicationId(hostid, name):
	appids = application.getApplicationByName(hostid, name)
	if not appids:
		appids = application.createApplication(hostid, name)
		try:
			appid = appids['applicationids'][0]
			return(appid)
		except:
			print(appids)
			return(False)

	appid = appids[0]['applicationid']
	print(appid)
	return(appid)
		
def createTrigger(hostid, hostname, scenario):
	desc_resp = "Response time too long: " + scenario
	exp_resp = "{" + hostname + ":web.test.time[" + scenario + ",api Check,resp].last(#10)}>8000"
	desc_fail = "API请求失败: " + scenario
	exp_fail = "{" + hostname + ":web.test.fail[" + scenario + "].last(#5)}<>0"
	desc_error = "Request Error: " + scenario
	exp_error = "{" + hostname + ":web.test.error[" + scenario + "].nodata(60)}=0"

	triggers = []
	triggers.append({"desc":desc_resp, "exp":exp_resp})
	triggers.append({"desc":desc_error, "exp":exp_error})

	for tri in triggers:
		old_trigger = trigger.getTriggerByName(hostid, tri['desc'])
		if old_trigger:
			triggerid = old_trigger[0]['triggerid']
			data = trigger.updateTrigger(triggerid, tri['desc'], tri['exp'])
			print(data)
		else:
			data = trigger.createTrigger(tri['desc'], tri['exp'])
			print(data)

