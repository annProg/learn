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
from mail.mail import *   #zabbix邮件脚本
from python.sms import *  #zabbix短信发送脚本
import logging
import json

url = "http://10.135.28.97:8000/contact.php"
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
	html = "<table><tr>	
	return(json.dumps(orig))

if __name__ == '__main__':
	try:
		with open("/tmp/err.log", 'a+') as f:
			f.write(sys.argv[3] + "  :   " + str(type(sys.argv[3])) + "\n")
		orig = sys.argv[3].replace('"', '#')
		orig = orig.replace('\'', '"')
		data = json.loads(orig)

		itemid = data['itemid']
		subject = sys.argv[2]
		contact = init(itemid)
		content = getContent(data)

		mail(contact, subject, content)
		sms(contact, subject)

	except:
		logging.exception("Exception Logged")

