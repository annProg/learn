#!/usr/bin/env python3
# -*- coding:utf-8 -*-

#-----------------------------------------------------------
# Usage: lambda test
# $Id: lambda.py  i@annhe.net  2015-07-16 15:33:24 $
#-----------------------------------------------------------

#函数使用:  
#1. 代码块重复，这时候必须考虑到函数，降低程序的冗余度  
#2. 代码块复杂，这时候必须考虑到函数，降低程序的复杂度  
#Python有两种函数,一种是def定义，一种是lambda函数()  
#当程序代码很短，且该函数只使用一次，为了程序的简洁，及节省变量内存占用空间，引入了匿名函数这个概念  
nums = range(2,20)  
for i in nums:  
	nums = filter(lambda x:x%2,nums)  
print(list(nums))
