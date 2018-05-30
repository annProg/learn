#!/bin/bash
exclude="zabbix_agentd|monit|snmpd|sendmail|moxi|[0-9]{5}:java"
conf="/etc/lld_port.conf"

hostname | grep "mpaas_node" &>/dev/null && r=0 || r=1
[ $r -eq 0 ] && include="mesos-slave|sshd|dnsmasq|agentd_zx"

hostname | grep ".kafka." &>/dev/null && r=0 || r=1
[ $r -eq 0 ] && include="9092:java|sshd|dnsmasq|agentd_zx"

hostname | grep -E "ad.*.(log-collection|bigdata)" &>/dev/null && r=0 || r=1
[ $r -eq 0 ] && exclude=$exclude"|java"

if [ -f $conf ];then
    source $conf
fi

str='{\n\t"data":['

function ntlp()
{
	netstat -ntlp |awk 'NR>2{print $4"#"$7}' |sed -r 's/.*?:([0-9]+)#/\1#/g' |sed -r 's/#[0-9]+?\/(.*)/:\1/g' |grep -v "#"
}

if [ "$include"x != ""x ];then
	for id in `ntlp | grep -Ew "$include"`;do
	    proc=`echo $id | cut -f2 -d':'`
	    port=`echo $id | cut -f1 -d':'`
	    str="$str\n\t\t{\"{#PROCNAME}\":\"$proc\", \"{#PORT}\":\"$port\"},"
	done
else
	for id in `ntlp |grep -vEw "$exclude"`;do
	    proc=`echo $id | cut -f2 -d':'`
	    port=`echo $id | cut -f1 -d':'`
	    str="$str\n\t\t{\"{#PROCNAME}\":\"$proc\", \"{#PORT}\":\"$port\"},"
	done
fi
str="$str]\n}"
str=`echo $str |sed 's/,]/\\\\n\\\\t]/g'`
echo -e $str
