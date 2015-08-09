#!/bin/bash

#-----------------------------------------------------------
# Usage: 处理数据量很大的白名单
# $Id: lakh-whitelist-sm.sh  i@annhe.net  2015-08-04 16:44:45 $
#-----------------------------------------------------------


[ $# -lt 2 ] && echo "file thread need" && exit 1

file=$1
thread=$2
line=500000

#log="/home/wwwlogs/access.log"

#echo "time getip:"
#time awk '{print $1}' $log |sort |uniq >ip.txt

rm -f average-*
echo "time split:"
time split -l $line $file "average-"

function search()
{
	for id in `ls average-*`;do
		{
			grep -w "$1" $id &>/dev/null && echo "$ip ok" && break && return 0
		}&
		sleep 2
		wait
	done
	echo "$ip failed"
}

tmp_fifo=/tmp/$$.fifo
mkfifo $tmp_fifo
exec 6<>$tmp_fifo
rm $tmp_fifo

for ((i=0;i<$thread;i++));do
	echo >&6
done

while read ip;do
	read -u6
	{
		search $ip
		echo >&6
		sleep 2
	}&
done <ip.txt

wait
exec 6>&-

rm -f average-*
exit 0
