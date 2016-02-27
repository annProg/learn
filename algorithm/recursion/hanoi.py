#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: hanoi.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-02-27 11:26:03
############################

import sys

def move(n, l, m, r):
	if n == 1:
		print( l + "->" +  r)
	else:
		move(n-1, l, r, m)
		print( l + "->" + r)
		move(n-1, m, l, r)

n = int(sys.argv[1])
print("Hanoi: " + str(n))
move(n, "A", "B", "C")

