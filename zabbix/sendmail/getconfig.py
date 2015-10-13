#!/usr/bin/env python
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: config.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-13 18:47:40
############################

import ConfigParser

config = ConfigParser.ConfigParser()
config.read("conf.ini")

sections = config.sections()
server = config.options("mailserver")

server = config.items("mailserver")

server = config.get("send", "mailto_list")
print server
