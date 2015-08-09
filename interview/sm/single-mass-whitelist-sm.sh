#!/bin/bash

#-----------------------------------------------------------
# Usage: 处理数据量很大的白名单
# $Id: lakh-whitelist-sm.sh  i@annhe.net  2015-08-04 16:44:45 $
#-----------------------------------------------------------


[ $# -lt 1 ] && echo "file thread need" && exit 1

file=$1

#log="/home/wwwlogs/access.log"

#echo "time getip:"
#time awk '{print $1}' $log |sort |uniq >ip.txt

function search()
{
	grep -w "$1" $file &>/dev/null && echo "$ip ok" && return 0
	echo "$ip failed"
}

while read ip;do
	search $ip
done <ip.txt
