#!/usr/bin/env python2.6
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: check.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-28 14:57:28
############################

import ansible.runner
import json
import re
import copy
import sys
import requests

def gatherFacts(func, iplist):
	runner = ansible.runner.Runner(
			host_list=iplist,
			module_name="script",
			module_args=func,
			pattern="",
			forks=51,
			become="True",
			timeout=10
			)
	data = runner.run()
	return(data)

if __name__ == '__main__':
	func = sys.argv[1]
	iplist = sys.argv[2]
	data = gatherFacts(func, iplist)
	#print(data)
	ret = {}
	for k,v in data['contacted'].items():
		ret[k] = v['stdout'].split(',')

	
	with open("gather.log", "w") as f:
		f.write(json.dumps(ret,indent=1))
	if sys.argv[3] == "a":
		print(ret)
	else:
		print(json.dumps(ret,indent=1).replace("\\r\\n", "\n").replace("\\t", "\t"))
