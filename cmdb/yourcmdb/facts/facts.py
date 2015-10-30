#!/usr/bin/env python2.6
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
import copy


internal = re.compile(r'^10\..*|^192.168.60\..*')
docker = re.compile(r'^172\..*|^192.168.1\..*')

def gatherFacts():
	runner = ansible.runner.Runner(
			host_list="./ip.ini",
			module_name="setup",
			module_args="",
			pattern="",
			forks=60,
			become="True",
			timeout=5
			)
	data = runner.run()
	return(data)
def isVip(ip, facts):
	INTERFACES="ansible_interfaces"
	delifs=["eth0", "eth1", "eth2", "eth3", "eth4", "docker0"]
	ifs = facts[INTERFACES]

	regex = re.compile(r'eth.*|docker.*|veth.*|bond.*')
	tmp = copy.deepcopy(ifs)
	for i in ifs:
		if re.search(regex, i):
			tmp.remove(i)
	vips = []
	for i in tmp:
		IFDETAIL="ansible_" + i
		if i=="lo":
			try:
				viplist = facts[IFDETAIL]["ipv4_secondaries"]
				for vip in viplist:
					vips.append(vip["address"])
			except:
				continue
		else:
			try:
				vip = facts[IFDETAIL]["ipv4"]["address"]
				vips.append(vip)
			except:
				continue
	if ip in vips:
		return(True)
	else:
		return(False)

def dealFacts(ip, data):
	try:
		facts = data['contacted'][ip]['ansible_facts']
	except:
		with open("failed.log", "a+") as f:
			f.write(ip + " failed\n")
		return(False)

	ret = {}

	#SN="ansible_product_serial"
	UUID="ansible_product_uuid"
	IPV4="ansible_all_ipv4_addresses"
	PROCESSOR_COUNT="ansible_processor_count"
	PROCESSOR_MODEL="ansible_processor"
	MEM="ansible_memtotal_mb"
	MODEL="ansible_product_name"
	VENDOR="ansible_system_vendor"
	HOSTNAME="ansible_nodename"
	SYSTEM="ansible_distribution"
	VERSION="ansible_distribution_version"
	ARCHITECTURE="ansible_architecture"
	KERNEL="ansible_kernel"
	VCPUS="ansible_processor_vcpus"
	CORES="ansible_processor_cores"
	THREADS="ansible_processor_threads_per_core"
	DEVICES="ansible_devices"


	ret['uuid'] = facts[UUID]
	ret['ip'] = []
	ret['vip'] = []
	ret['system'] = facts[SYSTEM] + "-" + facts[VERSION] + "-" + facts[ARCHITECTURE]
	ret['kernel'] = facts[KERNEL]
	
	tmpIp = facts[IPV4]
	for i in tmpIp:
		if isVip(i, facts):
			if re.search(internal, i):
				ret['vip'].append({"ip":i, "type":"int", "isp":""})
			else:
				ret['vip'].append({"ip":i, "type":"ext", "isp":""})
			continue
		if re.search(internal, i):
			ret['ip'].append({"ip":i,"type":"int", "uuid":ret['uuid']})
		elif re.search(docker, i):
			continue
		else:
			ret['ip'].append({"ip":i,"type":"ext", "uuid":ret['uuid']})
	ret['cpu'] = str(facts[PROCESSOR_COUNT]) + "x" +str(facts[CORES]) + "x" + str(facts[THREADS]) + " "  + facts[PROCESSOR_MODEL][1]
	ret['mem'] = str(int((facts[MEM]+1024-1)/1024)) + " GB"
	ret['model'] = facts[MODEL]
	ret['vendor'] = facts[VENDOR]
	ret['hostname'] = facts[HOSTNAME]

	ret['devices'] =""
	for k,v in facts[DEVICES].items():
		item = k + ":" + v['size'] + "#"
		ret['devices'] += item
	
	ipshows=""
	with open("ip.csv", "a+") as f:
		for ipaddr in ret['ip']:
			f.write(";;" + ipaddr['ip'] + ";" + ipaddr['type'] + ";" + ipaddr['uuid'] + "\n")
			ipshow = ipaddr['type'] + "-" + ipaddr['ip'] + " "
			ipshows += ipshow

	with open("vip.csv", "a+") as f:
		for vip in ret['vip']:
			f.write(";;" + vip['ip'] + ";" + vip['type'] + ";" + vip['isp'] + ";" + ipshows + ";\n")

	with open("server.csv", "a+") as f:
		f.write(";;" + ret['hostname'] + ";" + ipshows + ";;" + ret['uuid'] + ";" + ret['vendor'] + ";" + ret['model'] + ";" + ret['system'] + ";" + ret['kernel'] + ";" + ret['mem'] + ";" + ret['cpu'] + ";" + ret['devices'] + ";" + ";;;;;;\n")  

	print(ret)
	print("\n")

if __name__ == '__main__':
	data = gatherFacts()
	with open("gather.log", "w") as f:
		f.write(json.dumps(data,indent=1))
	with open("ip.ini", "r") as f:
		iplist = f.read().split("\n")
		for ip in iplist:
			dealFacts(ip,data)
