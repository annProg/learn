#!/usr/bin/env python3
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: recursion
# $Id: recursion.py  i@annhe.net  2015-07-01 16:06:57 $
#-----------------------------------------------------------
 
def fact(n):
	if n==1:
		return 1
	return n * fact(n - 1)

n=int(input('input n: '))
print(type(n))
sum = fact(n)
print(sum)
