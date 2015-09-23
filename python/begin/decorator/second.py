#!/usr/bin/env python
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: second.py  me@annhe.net  2015-09-23 18:59:04 $
#-----------------------------------------------------------

from first import now

def log(func):
	def wrapper(*args, **kw):
		print('call %():' % func.__name__)
		return func(*args, **kw)
	return wrapper

now()
