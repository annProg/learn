#!/bin/bash

############################
# Usage:
# File Name: checkMongo.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2017-01-18 13:03:45
############################
[ $# -lt 1 ] && echo -e "Usage:\n\t$0 iplist_file" && exit 1
file=$1
checkfile=/tmp/mg.check

while read ip;do
	echo -n "$ip - "
	echo "show dbs" |mongo $ip --quiet &>$checkfile && r=0 || r=1
	if [ $r -eq 0 ];then
		grep "not authorized" $checkfile &>/dev/null && echo "OK" || echo "Problem"
	else
		echo "OK"
	fi
done <$file
