#!/bin/bash

exclude="zabbix_agentd|monit|snmpd|sendmail|moxi"
conf="/etc/lld_port.conf"

hostname | grep "mpaas_node" &>/dev/null && r=0 || r=1
[ $r -eq 0 ] && include="mesos-slave|sshd|dnsmasq|agentd_zx"

hostname | grep ".kafka." &>/dev/null && r=0 || r=1
[ $r -eq 0 ] && include="9092:java|sshd|dnsmasq|agentd_zx"

if [ -f $conf ];then
    source $conf
fi

str='{\n\t"data":['

if [ "$include"x != ""x ];then
	for id in `sudo ss -lpn |awk '{print $4,$6}' |perl -pe 's/.*?:(\d)/\1/' |sed 's/users:((\"//g'|sed 's/\".*$//' |grep -vE "127.0.0.1|172.17.|Local" |sort -u |grep -v ":" |tr ' ' ':' | grep -v ":$" | grep -Ew "$include"`;do
	    proc=`echo $id | cut -f2 -d':'`
	    port=`echo $id | cut -f1 -d':'`
	    str="$str\n\t\t{\"{#PROCNAME}\":\"$proc\", \"{#PORT}\":\"$port\"},"
	done
else
	for id in `sudo ss -lpn |awk '{print $4,$6}' |perl -pe 's/.*?:(\d)/\1/' |sed 's/users:((\"//g'|sed 's/\".*$//' |grep -vE "127.0.0.1|172.17.|Local" |sort -u |grep -v ":" |tr ' ' ':' |grep -v ":$" |grep -vEw "$exclude"`;do
	    proc=`echo $id | cut -f2 -d':'`
	    port=`echo $id | cut -f1 -d':'`
	    str="$str\n\t\t{\"{#PROCNAME}\":\"$proc\", \"{#PORT}\":\"$port\"},"
	done
fi
str="$str]\n}"
str=`echo $str |sed 's/,]/\\\\n\\\\t]/g'`
echo -e $str
