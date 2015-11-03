#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: test.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-23 14:50:26
############################

import zabbixApi
import json
import argparse

parser = argparse.ArgumentParser(description='Create Zabbix screen from all of a host Items or Graphs.')
parser.add_argument('--host', dest='hostname', type=str, help='Zabbix Host to create screen from')
parser.add_argument('--group', dest='hostgroup', type=str, help='Zabbix Host to create screen from')
parser.add_argument('-s', type=str, 
					help='Screen name in Zabbix.  Put quotes around it if you want spaces in the name.')
parser.add_argument('-c', dest='columns', type=int, default=3,
					help='number of columns in the screen (default: 3)')
parser.add_argument('-d', dest='dynamic', action='store_true',
					help='enable for dynamic screen items (default: disabled)')
parser.add_argument('-t', dest='screentype', action='store_true',
					help='set to 1 if you want item simple graphs created (default: 0, regular graphs)')

args = parser.parse_args()
print(args)
'''
hostname = args.hostname
screen_name = args.screenname
columns = args.columns
dynamic = (1 if args.dynamic else 0)
screentype = (1 if args.screentype else 0)
'''
