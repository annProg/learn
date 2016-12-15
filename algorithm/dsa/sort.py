#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: bubblesort1a.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-12-15 14:33:21
############################

import time 
import random
import copy
import sys

def time_me(fn):
	def _wrapper(*args, **kwargs):
		start = time.time()
		ret = fn(*args, **kwargs)
		return(ret,fn.__name__,time.time() - start)
	return _wrapper

@time_me
def bubblesort1a(l):
	n=len(l)
	t=0
	for j in range(1,n):
		for i in range(1,n):
			if l[i-1]>l[i]:
				l[i-1],l[i] = l[i],l[i-1]
		t=j
		print("第" + str(t) + "趟: ", end="")
		print(l)
	return(n,j)

# 提前退出
@time_me
def bubblesort2a(l):
	n=len(l)
	o=n
	t=0
	sorted = False
	while not sorted:
		t+=1
		sorted=True
		for i in range(1,n):
			if l[i-1]>l[i]:
				l[i-1],l[i] = l[i],l[i-1]
				sorted=False
		print("第" + str(t) + "趟: ", end="")
		print(l)
		n-=1
	return(o,t)
	#return(l,o,t)

def genList(n):
	l = []
	for i in range(n):
		item = random.randint(1,n)
		l.append(item)
	return(l)

if __name__ == '__main__':
	l=genList(int(sys.argv[1]))
	l2=copy.deepcopy(l)
	#print(l)
	print(bubblesort1a(l))
	#print(l2)
	print(bubblesort2a(l2))

