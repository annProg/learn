#!/bin/bash

############################
# Usage:
# File Name: ntp.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-09-23 23:38:57
############################

active=`ntpq -pn |grep "^*"`

if [ $? -eq 0 ];then
	echo "$active" |awk '{print $(NF-1)}' |tr -d '-'
else
	echo "1000"
fi
