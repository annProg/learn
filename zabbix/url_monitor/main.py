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
import db
import sys

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
	return(appid)
		
def createTrigger(hostid, hostname, scenario, failcount=3, timeoutcount=10, timeout=8000):
	desc_resp = "Response time too long: " + scenario
	# 最后timeoutcount次的请求都大于timeout毫秒
	exp_resp = "{" + hostname + ":web.test.time[" + scenario + ",api Check,resp].last(#" + str(timeoutcount) + ")}>" + str(timeout)

	desc_error = "Request Error: " + scenario
	# 满足最后failcount次失败且60s内有error数据，使用web.test.error主要是为了获得具体报错信息
	exp_error = "{" + hostname + ":web.test.error[" + scenario + "].nodata(60)}=0" + " and " + "{" + hostname + ":web.test.fail[" + scenario + "].last(#" + str(failcount) + ")}<>0"

	triggers = []
	triggers.append({"desc":desc_resp, "exp":exp_resp})
	triggers.append({"desc":desc_error, "exp":exp_error})

	for tri in triggers:
		old_trigger = trigger.getTriggerByName(hostid, tri['desc'])
		if old_trigger:
			triggerid = old_trigger[0]['triggerid']
			data = trigger.updateTrigger(triggerid, tri['desc'], tri['exp'])
		else:
			data = trigger.createTrigger(tri['desc'], tri['exp'])

def getStatus(assetId):
	try:
		status = cmdbApi.getObjectById(assetId)['result']['code']
		if status == "offline":
			status = 1
		else:
			status = 0
	except:
		status = 0
	return(status)
	
def run(assetId):
	ret = {}
	cmdbObj = cmdbApi.getObjectById(str(assetId))['result']
	if not cmdbObj:
		return(False)
	
	argv = {}
	method = cmdbApi.getObjectById(cmdbObj['requestmethod'])['result']['method']
	if (method == "GET"):
		argv['url'] = cmdbObj['url'] + "?" + cmdbObj['param']
		argv['posts'] = ""
	else:
		argv['url'] = cmdbObj['url']
		argv['posts'] = cmdbObj['param']

	hostname= getHostName(cmdbObj['product'])
	argv['name'] = hostname + "-" + "/".join(cmdbObj['url'].split('/')[3:])
	argv['status_code'] = cmdbObj['responsecode']
	argv['no'] = 1
	argv['hostid'] = getHostId(hostname)
	argv['delay'] = cmdbObj['delay']
	if not argv['delay'].isdigit():
		argv['delay'] = 60
	argv['required'] = cmdbObj['responsedata']
	argv['agent'] = agent
	argv['applicationid'] = getApplicationId(argv['hostid'], argv['name'])
	argv['status'] = getStatus(cmdbObj['status'])
	
	# 如果某个cmdb项目已经在zabbix创建过，则不以web监控名称判断web monitor是否存在(存在cmdb中修改URL的情况)
	if cmdbObj['httptestid']:
		scenario = web.getScenarioById(argv['hostid'], cmdbObj['httptestid'])
		if not scenario:
			scenario =  web.getScenarioByName(argv['hostid'], argv['name'])
	else:
		scenario =  web.getScenarioByName(argv['hostid'], argv['name'])

	if scenario:
		argv['httptestid'] = scenario[0]['httptestid']
		argv['httpstepid'] = scenario[0]['steps'][0]['httpstepid']
		data = web.updateScenario(argv)
		#triggername = data
	else:
		data = web.createScenario(argv)
		argv['httptestid'] = data['httptestids'][0]
	ret[assetId] = data

	# trigger
	if not cmdbObj['timeout'].isdigit():
		cmdbObj['timeout'] = 8000
	if not cmdbObj['timeoutcount'].isdigit():
		cmdbObj['timeoutcount'] = 10
	if not cmdbObj['failcount'].isdigit():
		cmdbObj['failcount'] = 3
	createTrigger(argv['hostid'], hostname, argv['name'], cmdbObj['failcount'], cmdbObj['timeoutcount'], cmdbObj['timeout'])
	
	#update cmdb
	cmdb_argv = {}
	cmdb_argv['objtype'] = "API"
	cmdb_argv['objid'] = str(assetId)
	cmdb_argv['objfields'] = {'Zabbix Info': 
			[{'name': 'httptestid', 'type': 'text', 'value': argv['httptestid'], 'label': 'httptestid'}]
			}
	print(cmdbApi.updateObject(cmdb_argv))

	if not cmdbObj['httptestid']:
		cmdbObj['httptestid'] = argv['httptestid']
	db.updateDB(argv['hostid'], argv['applicationid'], cmdbObj)
	return(ret)

def allUpdate():
	apiList = cmdbApi.getObjectList("API")['result']
	if not apiList:
		print("no api")
		exit()

	for assetId in apiList:
		print(assetId,end="")
		print(run(assetId))

if __name__ == '__main__':
	func = sys.argv[1]
	if func == "up":
		data = run(sys.argv[2])
	elif func == "all":
		data = allUpdate()
	else:
		data = "args error"
	print(data)
