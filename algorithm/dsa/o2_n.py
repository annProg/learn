#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage: O(2^n)算法
# File Name: o2_n.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-12-19 16:57:23
############################

def power2bf_i(n):
	pow = 1
	while n > 0:
		pow = pow << 1
		n = n - 1
	return(pow)

if __name__ == '__main__':
	print(power2bf_i(100000))
