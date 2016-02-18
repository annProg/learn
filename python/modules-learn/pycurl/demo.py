#!/usr/bin/env python3
#-*- coding:utf-8 -*-  

############################
# Usage:
# File Name: demo.py
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-02-17 19:14:03
############################
#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os,sys
import time
import sys
import pycurl

class joincontents:
    def __init__(self):
        self.contents = ''
    def callback(self,curl):
        self.contents = self.contents + curl.decode('utf-8')

def curlurl(url):
    t = joincontents()
    c = pycurl.Curl()
    c.setopt(pycurl.WRITEFUNCTION,t.callback)
    c.setopt(pycurl.ENCODING, 'gzip')
    c.setopt(pycurl.URL,url)
    c.perform()
    NAMELOOKUP_TIME =  c.getinfo(c.NAMELOOKUP_TIME)
    CONNECT_TIME =  c.getinfo(c.CONNECT_TIME)
    PRETRANSFER_TIME =   c.getinfo(c.PRETRANSFER_TIME)
    STARTTRANSFER_TIME = c.getinfo(c.STARTTRANSFER_TIME)
    TOTAL_TIME = c.getinfo(c.TOTAL_TIME)
    HTTP_CODE =  c.getinfo(c.HTTP_CODE)
    SIZE_DOWNLOAD =  c.getinfo(c.SIZE_DOWNLOAD)
    HEADER_SIZE = c.getinfo(c.HEADER_SIZE)
    SPEED_DOWNLOAD=c.getinfo(c.SPEED_DOWNLOAD)
    print("HTTP状态码：%s" %(HTTP_CODE))
    print("DNS解析时间：%.2f ms"%(NAMELOOKUP_TIME*1000))
    print("建立连接时间：%.2f ms" %(CONNECT_TIME*1000))
    print("准备传输时间：%.2f ms" %(PRETRANSFER_TIME*1000))
    print("传输开始时间：%.2f ms" %(STARTTRANSFER_TIME*1000))
    print("传输结束总时间：%.2f ms" %(TOTAL_TIME*1000))
    print("下载数据包大小：%d bytes/s" %(SIZE_DOWNLOAD))
    print("HTTP头部大小：%d byte" %(HEADER_SIZE))
    print("平均下载速度：%d bytes/s" %(SPEED_DOWNLOAD))

if __name__ == '__main__':
    url = sys.argv[1]
    curlurl(url)
