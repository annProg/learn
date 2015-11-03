#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage: 用于为一组主机的同一种graph创建screen 
# File Name: screen.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-02 14:46:03
############################

import zabbixApi
import json
import sys

def getGrpId(grpname):
	params = {"output":"groupid","filter":{"name":grpname}}
	grpid = zabbixApi.apiRun("hostgroup.get", params)
	return(grpid[0]['groupid'])

def getGraphlist(grpid, graphname):
	params = {"output":["graphid", "name"], "groupids":grpid, "filter":{"name":graphname}}
	graphlist = zabbixApi.apiRun("graph.get", params)
	return(graphlist)

def createScreen(graphids, name, hsize):
	screenitems = []
	vsize = int((len(graphids)+hsize-1)/hsize)
	
	x = 0
	y = 0
	for graphid in graphids:
		screenitem = {"resourcetype":0, "resourceid":graphid, "x":x, "y":y, "width":"500"}
		screenitems.append(screenitem)
		if x < hsize - 1:
			x += 1
		else:
			x = 0
			y += 1

	params = {"name":name, "hsize":hsize, "vsize": vsize, "screenitems":screenitems}
	data = zabbixApi.apiRun("screen.create", params)
	return(data)

def getScreen(screenid):
	params = {"output":"extend","selectScreenItems": "extend", "screenids":screenid}
	data = zabbixApi.apiRun("screen.get", params)
	return(data)

if __name__ == '__main__':
	grpname = sys.argv[1]
	graphname = sys.argv[2]
	hsize = int(sys.argv[3])

	grpid = getGrpId(grpname)
	graphs = getGraphlist(grpid, graphname)
	graphids = []

	for graph in graphs:
		graphids.append(graph['graphid'])
	
	screenName = grpname + "-" + graphname
	ret = createScreen(graphids, screenName, hsize)
	print(ret)


