#!/usr/bin/env python3
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: generator.py  me@annhe.net  2015-11-06 11:08:33 $
#-----------------------------------------------------------

g = (x*x for x in range(100))
for n in g:
	print(n)

def fib(max):
	n,a,b = 0,0,1
	while n < max:
		print(b)
		a,b = b, a+b
		n = n+1
	return 'done'

fib(5)
