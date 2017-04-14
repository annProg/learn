#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:计算服务器权值，统计服务器状态分布，并发送数据到zabbix
#       zabbix模板见 ../templates/zabbix_tpl_capacity.xml
# File Name: upstream_weight.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-02-25 03:20:27
############################

import item
import host
import re
import json
import time
import math
import numpy as np
import sys
import os

regex = re.compile(r'^10\.')

zabbixIp = "10.1.1.1"
cluster_conf = {"tv":{"grp": ["50","51"], "hostname": "capacity.clusters.newtv"},
		   "online":{"grp": ["30", "34"], "hostname": "capacity.clusters.online"}
}

def getHostList(grpid):
	argv = []
	argv.append(",".join(grpid))
	data = host.getHostList(argv)
	ret = []
	for element in data:
		tmp = {}
		for interface in element["interfaces"]:
			if interface["type"] == "1" and re.match(regex, interface["ip"]):
				tmp["hostid"] = element["hostid"]
				tmp["ip"] = interface["ip"]
		ret.append(tmp)
	return(ret)

def getItemValue(grpid):
	argv = []
	argv.append(",".join(grpid))
	argv.append("system.cpu.")
	data = item.getItemList(argv)
	hostlist = getHostList(grpid)

	ret = {}
	for host in hostlist:
		#print(host)
		ret[host["hostid"]] = {}
		ret[host["hostid"]]["ip"] = host["ip"]

	for element in data:
		ret[element["hostid"]][element["key_"]] = element["lastvalue"]
	return(ret)

def calcuWeight(grpid):
	data = getItemValue(grpid)
	ret = {}
	response = {}
	response["time"] = time.strftime("%Y-%m-%d %H:%M:%S",time.localtime(time.time()))
	response["data"] = ret
	response["status"] = {}
	weightlist = []

	for w in range(1,11):
		response["status"][str(w)] = 0


	for k in data.keys():
		v = data[k]
		ip = v["ip"]
		ret[ip] = {}

		# 权值计算法方法
		#ret[ip]["weight_calculate"] = "(100-avg5*100)*0.3 + (100-avg1*100)*0.4 + (100-steal)*0.1 + idle*0.1 + (100-iowait)*0.1"

		for key in v.keys():
			ret[ip][key] = v[key]
		
		# 权值计算
		# 防止因某个ip中断
		try:
			avg5 = (1 - float(ret[ip]["system.cpu.load[percpu,avg5]"]))*30
			avg1 = (1 - float(ret[ip]["system.cpu.load[percpu,avg1]"]))*40
			steal = (100 - float(ret[ip]["system.cpu.util[,steal,avg5]"]))*0.1
			iowait = (100 - float(ret[ip]["system.cpu.util[,iowait,avg5]"]))*0.1
			idle = float(ret[ip]["system.cpu.util[,idle,avg5]"])*0.1
		except:
			continue

		ret[ip]["weight_orig"] = avg5 + avg1 + steal + iowait + idle
		# 向上取整
		ret[ip]["weight"] = math.ceil(ret[ip]["weight_orig"]/10)
		# 权值不小于 1
		if ret[ip]["weight"] < 1:
			ret[ip]["weight"] = 1

		response["status"][str(ret[ip]["weight"])] += 1

		# 权值列表
		weightlist.append(ret[ip]["weight_orig"])
	response["statistics"] = statistics(weightlist)
	return(response)
	
def statistics(data):
	ret = {}
	ret["median"] = np.median(data)
	ret["max"] = np.max(data)
	ret["min"] = np.min(data)
	ret["std"] = np.std(data)
	ret["mean"] = np.mean(data)

	length = len(data)
	ret["fine"] = float(sum([x>79 for x in data])/length)*100
	ret["bad"] = float(sum([x<20 for x in data])/length)*100
	return(ret)

def sendZabbix(hostname, data):
	status = data["status"]
	statistics = data["statistics"]
	cmd_pre = "zabbix_sender -z " + zabbixIp + " -s " + hostname + " -k"

	for k in status.keys():
		cmd = cmd_pre + ' "capacity.weight[' + k + ']" -o "' + str(status[k]) + '" &>/dev/null'
		#print(cmd)
		os.system(cmd)
	for k in statistics.keys():
		cmd = cmd_pre + ' "capacity.' + k + '" -o "' + str(statistics[k]) + '" &>/dev/null'
		#print(cmd)
		os.system(cmd)

if __name__ == '__main__':
	#print(getHostList(tv))
	#calcuWeight(tv)
	cluster = sys.argv[1]
	grpid = cluster_conf[cluster]["grp"]
	hostname = cluster_conf[cluster]["hostname"]

	data = calcuWeight(grpid)
	sendZabbix(hostname, data)
	print(json.dumps(data))
