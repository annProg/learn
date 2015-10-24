#!/usr/bin/env python
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: mail.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-19 16:58:05
############################

import sys
import smtplib
from email.mime.text import MIMEText
import time
import ConfigParser

#解析配置文件
config = ConfigParser.ConfigParser()
config.read("conf.ini")

mail_host=config.get("mailserver", "server")
mail_user=config.get("mailserver", "user")
mail_pass=config.get("mailserver", "passwd")
mail_postfix=config.get("mailserver", "postfix")
mailto_list=config.get("send", "mailto_list").split(",")
mailcc_list=config.get("send", "mailcc_list").split(",")


log="/tmp/sendmail.log"

def maillog(status, mailto_list, subject):
	curdate = time.strftime('%F %X')
	with open(log, 'a+') as f:
		f.write(curdate + " " + status + " " + ",".join(mailto_list) + " " + subject + "\n")

#定义send_mail函数
def send_mail(to_list,sub,content):
	'''
	to_list:发送列表，逗号分隔
	sub:主题
	content:内容
	send_mail("admin@qq.com","sub","content")
	'''
	global cc_list
	address=mail_user+"<"+mail_user+"@"+mail_postfix+">"
	msg = MIMEText(content, 'plain', 'utf-8')
	msg['Subject'] = sub
	msg['From'] = address
	msg['To'] =";".join(to_list)
	msg['Cc'] =";".join(mailcc_list)
	try:
		s = smtplib.SMTP()
		s.connect(mail_host)
		s.login(mail_user,mail_pass)
		s.sendmail(address, to_list, msg.as_string())
		s.close()
		
		maillog("success", to_list, sub)
		return True
	except Exception, e:
		print str(e)
		maillog(str(e), to_list, sub)
		return False
if __name__ == '__main__':
		send_mail(mailto_list, "test", "this is a test message")
