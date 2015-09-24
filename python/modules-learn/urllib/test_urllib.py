#!/usr/bin/env python
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: test_urllib.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-09-23 14:25:36
############################

import urllib
import json

def push():
	req = urllib.urlopen("http://push.scloud.letv.com/api/v1/server")
	rs = req.read()
	result = json.loads(rs)
	print(result)

if __name__ == "__main__":
	push()
