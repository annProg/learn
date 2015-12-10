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
from email.mime.multipart import MIMEMultipart
import time
import ConfigParser
import re

#解析配置文件
config = ConfigParser.ConfigParser()
config.read("conf.ini")   # 注意这里必须是绝对路径

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
	address=mail_user+"<"+mail_user+"@"+mail_postfix+">"
	#msg = MIMEText(content, 'plain', 'utf-8')
	msg = MIMEMultipart('alternative')
	msg['Subject'] = sub
	msg['From'] = address

	part = MIMEText(content, 'html', 'utf-8')
	msg.attach(part)

	to_list = to_list.split(",")
	msg['To'] =";".join(to_list)
	msg['Cc'] =";".join(mailcc_list)
	toaddrs = to_list + mailcc_list #抄送人也要加入到sendmail函数的收件人参数中，否则无法收到
	try:
		s = smtplib.SMTP()
		s.connect(mail_host)
		#s.login(mail_user,mail_pass)
		s.sendmail(address, toaddrs, msg.as_string())
		s.close()
		
		maillog("success", toaddrs, sub)
		return True
	except Exception, e:
		print str(e)
		maillog(str(e), toaddrs, sub)
		return False

if __name__ == '__main__':
	sub = sys.argv[2].replace("\n", "")
	sub = sub.replace("\r\n", "")
	regex = re.compile(r'DETAIL:.*$')
	sub = regex.sub("DETAIL:", sub)

	to_list = sys.argv[1]
	to_list = to_list.split(",")
	new_list = []
	for to in to_list:
		if "@" in to:
			new_list.append(to)
		else:
			to = to + "@letv.com"
			new_list.append(to)
	new_list = ",".join(new_list)
	send_mail(new_list, sub, sys.argv[3])

	#send_mail(mailto_list, "test", "this is a test message")
