#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
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

regex = re.compile(r'^10\.')
tv = ["50","51"]

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

	for k in data.keys():
		v = data[k]
		ip = v["ip"]
		ret[ip] = {}

		# 权值计算法方法
		#ret[ip]["weight_calculate"] = "(100-avg5*100)*0.3 + (100-avg1*100)*0.4 + (100-steal)*0.1 + idle*0.1 + (100-iowait)*0.1"

		for key in v.keys():
			ret[ip][key] = v[key]
		
		# 权值计算
		avg5 = (1 - float(ret[ip]["system.cpu.load[percpu,avg5]"]))*30
		avg1 = (1 - float(ret[ip]["system.cpu.load[percpu,avg1]"]))*40
		steal = (100 - float(ret[ip]["system.cpu.util[,steal]"]))*0.1
		iowait = (100 - float(ret[ip]["system.cpu.util[,iowait]"]))*0.1
		idle = float(ret[ip]["system.cpu.util[,idle]"])*0.1

		ret[ip]["weight_orig"] = avg5 + avg1 + steal + iowait + idle
		# 向上取整
		ret[ip]["weight"] = int((avg5 + avg1 + steal + iowait + idle + 10 - 1)/10)
		# 权值不小于 1
		if ret[ip]["weight"] < 1:
			ret[ip]["weight"] = 1
	return(response)
	

if __name__ == '__main__':
	#print(getHostList(tv))
	print(json.dumps(calcuWeight(tv), indent=1))
