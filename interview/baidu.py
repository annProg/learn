#!/usr/bin/env python2.6
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: use python2
# $Id: baidu.py  i@annhe.net  2015-08-03 17:56:10 $
#-----------------------------------------------------------

#输出如下形式的数字
# 0
# 0 1
# 0 1 2
# ...
# 现场使用Python2


def func1(x):
	for i in range(x):
		for j in range(i+1):
			print j,
		print ''

def func2(x):
	list = []
	for i in range(x):
		list.append(str(i))
		print ' '.join(list)

n = input("input a number: ")
print "Func1 %s" % n
func1(n)

print "\n\nFunc2 %s" % n
func2(n)
