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
import hashlib
import json

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
	
def getScenarioName(hostname, url):
	md5 = hashlib.md5()
	md5.update(url.encode('utf-8'))
	urlhash = md5.hexdigest()[0:9]

	domain = "/".join(url.split('/')[2:3])
	domain =".".join(domain.split('.')[0:2])
	location = "/".join(url.split('/')[3:])
	location = "/".join(location.split('/')[-2:])
	scenario = domain + "-" + location + "-" + urlhash
	return(scenario)

def getCurlCmd(url,method,header,params):
	if header:
		headers = header.split('\r\n')
	else:
		headers = []
	curl_cmd = "curl -s "
	header_str = ""
	if headers:
		for item in headers:
			item_str = "-H \"" + item + "\" "
			header_str += item_str
	curl_cmd += header_str

	if method == "GET":
		curl_data = "\"" + url + "?" + params + "\""
		curl_cmd += curl_data
	else:
		curl_data = url + " --data \"" + params + "\""
		curl_cmd += curl_data
	return(curl_cmd)

def getApplicationId(hostid, name, applicationid=None):
	if not applicationid:
		try:
			old_appids = application.getApplicationByName(hostid, name)
			appids = application.updateApplication(name, old_appids[0]['applicationid'])
			return(appids['applicationids'][0])
		except:	
			appids = application.createApplication(hostid, name)
			return(appids['applicationids'][0])
	else:
		try:
			appids = application.getApplicationById(applicationid)
			appids = application.updateApplication(name ,applicationid)
			return(appids['applicationids'][0])
		except:
			appids = application.getApplicationByName(hostid, name)
			if not appids:
				appids = application.createApplication(hostid, name)
				return(appids['applicationids'][0])
			else:
				return(appids[0]['applicationid'])

def getTriggerExps(hostname, scenario, nodatatime, failcount=3, timeoutcount=10, timeout=8):
	nodata = str(int(nodatatime)*2)
	desc_resp = "Response time too long: " + scenario
	# 最后timeoutcount次的请求都大于timeout秒
	exp_resp = "{" + hostname + ":web.test.time[" + scenario + ",api Check,resp].count(#" + str(timeoutcount) + "," + str(timeout) + ",\"gt\")}=" + str(timeoutcount)

	desc_error = "Request Error: " + scenario
	# 满足最后failcount次失败且60s内有error数据，使用web.test.error主要是为了获得具体报错信息
	exp_error = "{" + hostname + ":web.test.error[" + scenario + "].nodata(" + nodata + ")}=0" + " and " + "{" + hostname + ":web.test.fail[" + scenario + "].count(#" + str(failcount) + ",1" + ")}=" + str(failcount)

	triggers = []
	triggers.append({"desc":desc_resp, "exp":exp_resp})
	triggers.append({"desc":desc_error, "exp":exp_error})
	return(triggers)

def getTriggerId(triggers, triggerids=None):
	ret_triggerids = {}

	for tri in triggers:
		try:
			old_trigger = trigger.getTriggerById(triggerids[tri['desc']])
			data = trigger.updateTrigger(old_trigger[0]['triggerid'], tri['desc'], tri['exp'])
			#print("i am here")
		except:
			try:
				old_trigger = trigger.getTriggerByName(tri['desc'])
				data = trigger.updateTrigger(old_trigger[0]['triggerid'], tri['desc'], tri['exp'])
			except:
				data = trigger.createTrigger(tri['desc'], tri['exp'])
		#print(str(tri) + ": " + str(data))
		ret_triggerids[tri['desc']] = data['triggerids'][0]
	return(ret_triggerids)

'''
	for tri in triggers:
		if not triggerids:
			try:
				old_trigger = trigger.getTriggerByName(tri['desc'])
				data = trigger.updateTrigger(old_trigger[0]['triggerid'], tri['desc'], tri['exp'])
				ret_triggerids.append(data['triggerids'][0])
				continue
			except:
				data = trigger.createTrigger(tri['desc'], tri['exp'])
				try:
					ret_triggerids.append(data['triggerids'][0])
				except:
					print(data)
		else:
			for triggerid in triggerids:
				if trigger.getTriggerById(triggerid):
					#try:
					data = trigger.updateTrigger(triggerid, tri['desc'], tri['exp'])
					ret_triggerids.append(data['triggerids'][0])
					break
					#except:
					#	continue
				else:
					#try:
					data = trigger.createTrigger(tri['desc'], tri['exp'])
					ret_triggerids.append(data['triggerids'][0])
					#except:
					#	continue
	print("ret_tri:" + str(ret_triggerids))
	return(ret_triggerids)
'''

def deleteTriggers(triggerids):
	try:
		triggers = json.loads(triggerids)
	except:
		return("triggerids not dict string")
	ids = []
	for key in triggers.keys():
		ids.append(triggers[key])
	ret = trigger.deleteTrigger(ids)
	print("delete trigger: " + str(ret))

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
	argv['name'] = getScenarioName(hostname, cmdbObj['url'])
	argv['name'] = argv['name'][-64:]
	argv['status_code'] = cmdbObj['responsecode']
	argv['no'] = 1
	argv['hostid'] = getHostId(hostname)
	argv['delay'] = cmdbObj['delay']
	if not argv['delay'].isdigit():
		argv['delay'] = 60
	argv['required'] = cmdbObj['responsedata']
	argv['agent'] = agent
	argv['applicationid'] = getApplicationId(argv['hostid'], argv['name'], cmdbObj['applicationid'])
	argv['status'] = getStatus(cmdbObj['status'])
	argv['header'] = cmdbObj['header']
	cmdbObj['curl'] = getCurlCmd(cmdbObj['url'], method, cmdbObj['header'], cmdbObj['param'])

	# 如果某个cmdb项目已经在zabbix创建过，则不以web监控名称判断web monitor是否存在(存在cmdb中修改URL的情况)
	if cmdbObj['httptestid']:
		scenario = web.getScenarioById(cmdbObj['httptestid'])
		if not scenario:
			scenario =  web.getScenarioByName(argv['hostid'], argv['name'])
		#如果web scenario名称变更，删除过期的触发器
		elif not scenario[0]['name'] == argv['name']:
			deleteTriggers(cmdbObj['triggerid'])
	else:
		scenario =  web.getScenarioByName(argv['hostid'], argv['name'])

	if scenario:
		# 如果接口产品线变更（对应zabbix主机名变更）需要重新获得applicationid
		if not scenario[0]['hostid'] == argv['hostid']:
			application.deleteApplication(argv['applicationid'])
			web.deleteScenario(scenario[0]['httptestid'])
			argv['applicationid'] = getApplicationId(argv['hostid'], argv['name'])
			data = web.createScenario(argv)
			argv['httptestid'] = data['httptestids'][0]
		else:
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
		cmdbObj['timeout'] = 8
	if not cmdbObj['timeoutcount'].isdigit():
		cmdbObj['timeoutcount'] = 10
	if not cmdbObj['failcount'].isdigit():
		cmdbObj['failcount'] = 3
	triggers = getTriggerExps(hostname, argv['name'], argv['delay'], cmdbObj['failcount'], cmdbObj['timeoutcount'], cmdbObj['timeout'])
	try:
		triggerids = json.loads(cmdbObj['triggerid'])
	except:
		triggerids = None
	argv['triggerid'] = json.dumps(getTriggerId(triggers,triggerids), sort_keys=True)
	
	#update cmdb
	cmdb_argv = {}
	cmdb_argv['objtype'] = "API"
	cmdb_argv['objid'] = str(assetId)
	cmdb_argv['objfields'] = {
		'Zabbix Info': [
			{'name': 'httptestid', 'value': argv['httptestid']},
			{'name': 'applicationid', 'value': argv['applicationid']},
			{'name': 'triggerid', 'value': argv['triggerid']}
		],
		"Basic":[
			{"name":"url","label":"URL","type":"text","value":cmdbObj['url']}
		],
		"Extend":[
			{"name":"curl", "value":cmdbObj['curl']}	
		]
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
