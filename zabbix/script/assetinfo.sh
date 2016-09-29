#!/bin/bash

############################
# Usage:
# File Name: assetinfo.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-09-29 15:11:36
############################

sn=`dmidecode -s system-serial-number`
uuid=`dmidecode -s system-uuid`
manufacturer=`dmidecode -s system-manufacturer`
product=`dmidecode -s system-product-name`

echo $sn |grep -E " |-" &>/dev/null && assettag=$uuid || assettag=$sn

str="{\n\t\"data\":["
for id in assettag manufacturer product;do
	cmd="echo \$$id"
	str="$str\n\t\t{\"{#TAG}\":\"$id\", \"{#VALUE}\":\"`eval $cmd`\"},"
done
str="$str]\n}"
str=`echo $str |sed 's/,]/\\\\n\\\\t]/g'`
echo -e $str
