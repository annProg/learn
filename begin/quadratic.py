#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 求解一元二次方程
# $Id: quadratic.py  i@annhe.net  2015-06-13 21:42:58 $
#-----------------------------------------------------------

import math

def quadratic(a,b,c):
	x1 = (-b + math.sqrt(b**2 - 4*a*c))/2*a	
	x2 = (-b - math.sqrt(b**2 - 4*a*c))/2*a
	return x1,x2

x1,x2 = quadratic(2,7,1)
print("x1 = %f"%x1)
print("x2 = %f"%x2)
	
