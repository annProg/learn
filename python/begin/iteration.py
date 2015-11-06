#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: iteration.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-06 10:36:16
############################


from collections import Iterable

print(isinstance('abc', Iterable))
print(isinstance(["a","b","c"], Iterable))
print(isinstance(123, Iterable))

for i,value in enumerate(['a','b','c']):
	print(i,value)
