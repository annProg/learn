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
while read ip;do
	echo -n "$ip - "
	echo "show dbs" |mongo $ip --quiet &>/dev/null && echo "FAILED" || echo "OK"
done <$file
