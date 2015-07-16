#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 
# $Id: fib.py  i@annhe.net  2015-07-16 12:42:40 $
#-----------------------------------------------------------


def fibs(x):
	result = [0,1]
	for index in range(x-2):
		result.append(result[-2]+result[-1])
	return result

def rec_fib(x):
	if x <= 0:
		return 
	if x == 1:
		return 0
	elif x == 2:
		return 1
	else:
		return rec_fib(x-1)+rec_fib(x-2)

if __name__ == '__main__':
	num = int(input('Enter on number: '))
	print(fibs(num))
	fib=[]
	for i in range(num):
		fib.append(rec_fib(i+1))
	print(fib)
