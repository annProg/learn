#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: test.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-23 14:50:26
############################

import json

data = json.dumps(
		{
			"id":"1",
			"value":"监控",

		}		
)

print(data)
print(json.loads(data))
print(json.loads(data)['value'])
