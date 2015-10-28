#!/usr/bin/env python2
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: facts.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-28 14:57:28
############################

import ansible.runner
import json
import re


internal = re.compile(r'^10\..*|^192.168\..*')
docker = re.compile(r'^172\..*')

def gatherFacts():
	runner = ansible.runner.Runner(
			host_list="./ip.ini",
			module_name="setup",
			module_args="",
			pattern="",
			forks=10,
			become="True",
			timeout=5
			)
	data = runner.run()
	return(data)

def dealFacts(ip, data):
	try:
		facts = data['contacted'][ip]['ansible_facts']
	except:
		with open("failed.log", "a+") as f:
			f.write(ip + " failed\n")
		return(False)

	ret = {}

	#SN="ansible_product_serial"
	SN="ansible_product_uuid"
	IPV4="ansible_all_ipv4_addresses"
	PROCESSOR_COUNT="ansible_processor_count"
	PROCESSOR_MODEL="ansible_processor"
	MEM="ansible_memtotal_mb"
	MODEL="ansible_product_name"
	VENDOR="ansible_system_vendor"
	HOSTNAME="ansible_fqdn"

	ret['sn'] = facts[SN]
	ret['ip'] = []
	tmpIp = facts[IPV4]
	for i in tmpIp:
		if re.search(internal, i):
			ret['ip'].append({"ip":i,"type":"int", "sn":ret['sn']})
		elif re.search(docker, i):
			continue
		else:
			ret['ip'].append({"ip":i,"type":"ext", "sn":ret['sn']})
	ret['cpu'] = str(facts[PROCESSOR_COUNT]) + "x " + facts[PROCESSOR_MODEL][1]
	ret['mem'] = str(facts[MEM]) + " MB"
	ret['model'] = facts[MODEL]
	ret['hostname'] = facts[HOSTNAME]

	with open("ip.csv", "a+") as f:
		for ipaddr in ret['ip']:
			f.write(";;" + ipaddr['ip'] + ";" + ipaddr['type'] + ";" + ipaddr['sn'] + "\n")

	with open("server.csv", "a+") as f:
		f.write(";;" + ret['hostname'] + ";;;" + ret['sn'] + ";" + ret['model'] + ";" + ret['mem'] + ";" + ret['cpu'] + ";;;;;;\n")  

	print(ret)

if __name__ == '__main__':
	data = gatherFacts()
	with open("ip.ini", "r") as f:
		iplist = f.read().split("\n")
		for ip in iplist:
			dealFacts(ip,data)
