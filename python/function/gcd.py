#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 最大公约数
# $Id: gcd.py  i@annhe.net  2015-08-18 22:24:14 $
#-----------------------------------------------------------

def gcd(x,y):
	if (y == 0):
		exit(1)
	mod = x % y
	if (mod == 0):
		return y
	else:
		return gcd(y,mod)

a = int(input("input a: "))
b = int(input("input b: "))

res = gcd(a,b)
print(res)
