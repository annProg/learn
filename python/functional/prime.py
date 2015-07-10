#!/usr/bin/env python3
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: prime.py  i@annhe.net  2015-07-02 18:11:38 $
#-----------------------------------------------------------
 
def _odd_iter():
	n = 1
	while True:
		n = n + 2
		yield n

def _not_divisible(n):
	return lambda x: x % n > 0

def primes():
	yield 2
	it = _odd_iter()
	while True:
		n = next(it)
		yield n
		it = filter(_not_divisible(n), it)

for n in primes():
	if n < 200:
		print(n)
	else:
		break
