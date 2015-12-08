#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: main.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-07 23:44:41
############################

import web
import host
import application
import trigger
import cmdbApi
import configparser

ini = "config.ini"
config = configparser.ConfigParser()
config.read(ini)

groupid = config.get("monitor", "hostgroupid")
agent = config.get("monitor", "agent")

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
	hostname = business + "_" + product
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
	desc_fail = "Scenario test Failed: " + scenario
	exp_fail = "{" + hostname + ":web.test.fail[" + scenario + "].last(#5)}<>0"

	triggers = []
	triggers.append({"desc":desc_resp, "exp":exp_resp})
	triggers.append({"desc":desc_fail, "exp":exp_fail})

	for tri in triggers:
		old_trigger = trigger.getTriggerByName(hostid, tri['desc'])
		if old_trigger:
			triggerid = old_trigger[0]['triggerid']
			data = trigger.updateTrigger(triggerid, tri['desc'], tri['exp'])
			print(data)
		else:
			data = trigger.createTrigger(tri['desc'], tri['exp'])
			print(data)

def main():
	apiList = cmdbApi.getObjectList("API")['result']
	if not apiList:
		print("no api")
		exit()

	ret = {}
	for assetId in apiList:
		api = cmdbApi.getObjectById(str(assetId))['result']
		if not api:
			continue
		
		argv = {}
		location = "http://" + api['domain'] + "/" + api['location']
		if (api['requestmethod'] == "GET"):
			argv['url'] = location + "?" + api['getparam']
		else:
			argv['url'] = location
		hostname= getHostName(api['product'])
		argv['name'] = hostname + "_" + api['domain'] + "_" + api['location'].split('/')[-1]
		#argv['name'] = api['domain'] + "/" + api['location']
		argv['status'] = api['responsecode']
		argv['no'] = 1
		argv['hostid'] = getHostId(hostname)
		argv['delay'] = 30
		argv['required'] = api['responsedata']
		argv['agent'] = agent
		argv['applicationid'] = getApplicationId(argv['hostid'], argv['name'])
		
		scenario =  web.getScenarioByName(argv['hostid'], argv['name'])

		if scenario:
			argv['httptestid'] = scenario[0]['httptestid']
			argv['httpstepid'] = scenario[0]['steps'][0]['httpstepid']
			data = web.updateScenario(argv)
		else:
			data = web.createScenario(argv)
			argv['httptestid'] = data['httptestids'][0]
		ret[assetId] = data
		createTrigger(argv['hostid'], hostname, argv['name'])
		
		#update cmdb
		cmdb_argv = {}
		cmdb_argv['objtype'] = "API"
		cmdb_argv['objid'] = str(assetId)
		cmdb_argv['objfields'] = {'Zabbix Info': 
				[{'name': 'httptestid', 'type': 'text', 'value': argv['httptestid'], 'label': 'httptestid'}]
				}
		cmdbApi.updateObject(cmdb_argv)

	return(ret)

if __name__ == '__main__':
	print(main())
	#print(getHostId("base_ota"))
