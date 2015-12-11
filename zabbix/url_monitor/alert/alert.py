#!/usr/bin/env python
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: alert.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-10 14:52:18
############################

import sys
import requests
import time
#from mail.mail import *   #zabbix邮件脚本
#from python.sms import *  #zabbix短信发送脚本
import logging
import json
import tpl

url = "http://10.135.28.97:8000/contact.php"
cmdb = "http://10.135.28.97:8000"
zabbix = "http://zabbix.scloud.letv.cn"
log = "/tmp/alert_phone.log"
logging.basicConfig(filename=log,level=logging.DEBUG)

def init(itemid):
	request = url + "?itemid=" + itemid
	r = requests.get(request)
	contact = r.json()
	return(contact)

def smslog(status, to, subject):
		curdate = time.strftime('%F %X')
		with open(log, 'a+') as f:
				f.write(curdate + " " + str(status) + " " + to + " " + subject + "\n")

def mail(contact, subject, content):
	to_list = contact['email']
	send_mail(to_list, subject, content)

def sms(contact, content):
	to_list = contact['phone'].split(',')
	for phone in to_list:
		x = Sender().done(content, str(phone))
		status = x['errno']
		smslog(status, phone, content)
def getContent(orig):
	argv = {}
	argv['name'] = orig['name']
	argv['items'] = []

	down = orig['downdate'] + " " + orig['downtime']
	argv['items'].append({"icon":"clock_red", "itemkey":"故障时间", "itemvalue":down})
	argv['items'].append({"icon":"clock", "itemkey":"告警时间", "itemvalue":orig['now']})
	
	if "update" in orig.keys():
		argv['status'] = "up"
		argv['items'].append({"icon":"clock_green", "itemkey":"恢复时间", "itemvalue":orig['update'] + orig['uptime']})
		up = orig['uptime'] + " " + orig['uptime']
		duration = time.mktime(time.strptime(up,'%Y.%m.%d %H:%M:%S')) - time.mktime(time.strptime(down, '%Y.%m.%d %H:%M:%S'))
		duration = str(duration/60) + " 分钟"
		argv['items'].append({"icon":"clock", "itemkey":"故障时长", "itemvalue":duration})
	else:
		argv['status'] = "down"

	argv['items'].append({"icon":"reason", "itemkey":"报警详情", "itemvalue":orig['itemvalue']})
	argv['items'].append({"icon":"switch", "itemkey":"报警级别", "itemvalue":orig['severity']})
	argv['items'].append({"icon":"switch", "itemkey":"主机名称", "itemvalue":orig['hostname']})
	argv['items'].append({"icon":"switch", "itemkey":"报警名称", "itemvalue":orig['itemname']})
	argv['items'].append({"icon":"switch", "itemkey":"报警项目", "itemvalue":orig['itemkey']})

	eventurl= zabbix + "/tr_events.php?triggerid=" + orig['triggerid'] + "&eventid=" + orig['eventid']
	eventid = "<a href=\"" + eventurl +"\">" + eventurl + "</a>"
	argv['items'].append({"icon":"link", "itemkey":"事件ID", "itemvalue":eventid})

	httptesturl = zabbix + "/httpdetails.php?httptestid=" + orig['httptestid']
	argv['items'].append({"icon":"link", "itemkey":"监控详情", "itemvalue":httptesturl})
	cmdburl = cmdb + "/object.php?action=show&id=" + orig['objid']
	argv['items'].append({"icon":"link", "itemkey":"CMDB详情", "itemvalue":cmdburl})
	argv['items'].append({"icon":"link", "itemkey":"负责人", "itemvalue":orig['admin']})

	return(tpl.mailTemplate(argv))

if __name__ == '__main__':
#	try:
#		with open("/tmp/err.log", 'a+') as f:
#			f.write(sys.argv[3] + "  :   " + str(type(sys.argv[3])) + "\n")
	orig = sys.argv[3].replace('"', '#')
	orig = orig.replace('\'', '"')
	data = json.loads(orig)

	itemid = data['itemid']
	subject = sys.argv[2]
	contact = init(itemid)
	print(contact)
	data['httptestid'] = contact['httptestid']
	data['objid'] = contact['objid']
	data['admin'] = contact['email'].split('@')[0] + "(" + contact['phone'] + ")"
	content = getContent(data)

	print("##############\n\n")
	print(content)
		#mail(contact, subject, content)
		#sms(contact, subject)

#	except:
#		logging.exception("Exception Logged")

