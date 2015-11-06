#!/usr/bin/env python3
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: listComprehensions.py  me@annhe.net  2015-11-06 10:43:38 $
#-----------------------------------------------------------
import os

l = [x*x for x in range(1,11)]
l2 = [x*x for x in range(1,11) if x%2==0]
print(l)
print(l2)

l3 = [m+n for m in 'abc' for n in 'xyz']
print(l3)

l4 = [m+n+t for m in 'abc' for n in 'xyz' for t in '123']
print(l4)

l5 = [d for d in os.listdir('.')]
print(l5)
print(os.listdir('.'))

print([s.upper() for s in l5])


L = ['Hello', 'World', 18, 'Apple', None]
print([s.lower() for s in L if isinstance(s,str)])
