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
import collections
a={"key":"hean"}
b={"key":"liuyuan"}

c = {}
for k,v in a.items():
	c[k]=a[k] +"," + b[k]
print(c)

