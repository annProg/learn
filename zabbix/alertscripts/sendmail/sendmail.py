#!/usr/bin/env python
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: sendmail.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-13 14:52:16
############################

from scloud_mail import *
import sys
import time

log = "/tmp/sendmail.log"
if len(sys.argv) < 3:
	exit()

mailto_list = sys.argv[1].split(",")
subject = sys.argv[2]
content = sys.argv[3].replace("\n", "<br>")
content = HtmlContent(content)
if send_mail(mailto_list, subject, content):
	status = "success"
else:
    status = "failed"

times = time.strftime('%F %X')
with open(log,'a+') as f:
  f.write(times + " " + status + " " + ",".join(mailto_list) + " " + subject + "\n")
