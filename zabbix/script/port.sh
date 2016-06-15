#!/bin/bash

############################
# Usage:
# File Name: port.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-06-15 14:37:40
############################

exclude="zabbix_agentd|monit|snmpd"

str='{\n\t"data":['
for id in `sudo ss -lpn |awk '{print $4,$6}' |perl -pe 's/.*?:(\d)/\1/' |sed 's/users:((\"//g'|sed 's/\".*$//' |grep -vE "127.0.0.1|172.17.|Local" |sort -u |tr ' ' ':' |grep -vEw "$exclude"`;do
	proc=`echo $id | cut -f2 -d':'`
	port=`echo $id | cut -f1 -d':'`
	str="$str\n\t\t{\"{#PROCNAME}\":\"$proc\", \"{#PORT}\":\"$port\"},"
done
str="$str]\n}"
str=`echo $str |sed 's/,]/\\\\n\\\\t]/g'`
echo -e $str

