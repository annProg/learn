#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: first
# $Id: first.py  me@annhe.net  2015-09-23 18:54:49 $
#-----------------------------------------------------------

import functools

def log(text):
	def decorator(func):
		@functools.wraps(func)
		def wrapper(*args, **kw):
			print('%s %s():' % (text, func.__name__))
			return func(*args, **kw)
		return wrapper
	return decorator

@log('执行')
def now():
	print("2015-9-23")


if __name__ == '__main__':
	now()
	print(now.__name__)
