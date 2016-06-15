#!/bin/bash

############################
# Usage:
# File Name: proc.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-06-15 14:37:56
############################

include="rcgroupchat_ser|codis-proxy|codis-server|codis-config"

str='{\n\t"data":['
for id in `ps -A |awk '{print $NF}' |sort -u |grep -Ew "$include"`;do
	str="$str\n\t\t{\"{#PROCNAME}\":\"$id\"},"
done
str="$str]\n}"
str=`echo $str |sed 's/,]/\\\\n\\\\t]/g'`
echo -e $str

