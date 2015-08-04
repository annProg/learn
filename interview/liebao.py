#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: 
# $Id: liebao.py  i@annhe.net  2015-07-17 17:00:25 $
#-----------------------------------------------------------

#输出如下形式的数字
# 0
# 0 1
# 0 1 2
# ...
def func(x):
	for i in range(x):
		for j in range(i+1):
			print(j, '', end="")
		print("")


def func2(x):
	list=[]
	for i in range(x):
		list.append(str(i))
		print(' '.join(list))


n = int(input("Input a num: "))
print("Func(%s): " % n)
func(n)
print("\n\nFunc2(%s): " % n)
func2(n)
