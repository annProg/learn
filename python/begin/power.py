#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 
# $Id: power.py  i@annhe.net  2015-06-13 22:19:27 $
#-----------------------------------------------------------

def power(x,n=2):
	s = 1
	while n>0:
		n = n -1
		s = s*x
	return s

print("power(5) = %d"%power(5))
print("power(2,4) = %d"%power(2,4))
