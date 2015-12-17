#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: db.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-10 12:08:37
############################

import item
import json

file_db = "db.json"

def init_DB():
	try:
		f = open(file_db, 'r')
	except:
		f = open(file_db, 'w')
	finally:
		if f:
			f.close()

	with open(file_db, 'r') as f:
		try:
			db = json.load(f)
		except:
			db = {}
	return(db)

def updateDB(hostid, applicationid, cmdbObj):
	db = init_DB()
	data = item.getItem(hostid, applicationid)
	for i in data:
		itemid = i['itemid']
		db[itemid] = {}
		db[itemid]['objid'] = cmdbObj['objid']
		db[itemid]['email'] = cmdbObj['alertemail']
		db[itemid]['phone'] = cmdbObj['alertphone']
		db[itemid]['httptestid'] = cmdbObj['httptestid']
		#print(itemid + ": " + str(db[itemid]))
	with open(file_db, 'w') as f:
		json.dump(db, f)

if __name__ == '__main__':
	print(init_DB())
	cmdbObj = {"objid":"12345", "alertemail":"hean@letv.com", "alertphone":"1311111111", "httptestid":"123"}
	updateDB("10120",cmdbObj)
	
