#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: graph.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-08 18:24:17
############################

import zabbixApi

def getGitem(graphid):
	params = {"output":"extend", "expandData":1, "graphids":graphid}
	data = zabbixApi.apiRun("graphitem.get", params)
	return(data)

def getGraph():
	pass

def createGraph():
	pass

def updateGraph():
	pass

if __name__ == '__main__':
	print(getGitem("31754"))
