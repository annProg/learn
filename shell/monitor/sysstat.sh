#!/bin/bash

#-----------------------------------------------------------
# Usage: 系统状况监控
# $Id: sysstat.sh  i@annhe.net  2015-07-11 13:12:55 $
#-----------------------------------------------------------

top -n 2 |grep "Cpu" >> /tmp/cpu.txt
free -m |grep "Mem" >> /tmp/mem.txt
df -k | grep "sda1" >> /tmp/sda1.txt
time=`date +%m"."%d" "%k":"%M`
connect=`netstat -na | grep "219.238.148.30:80" | wc -l`
echo "$time  $connect" >> /tmp/connect_count.txt
