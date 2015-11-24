#!/bin/bash

############################
# Usage:
# File Name: timeout.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-24 12:13:42
############################

t=`date +%m%d-%H:%M:%S`
tw=`netstat -at |grep "TIME_WAIT" |awk '/^tcp/{a[$6]++}END{for(i in a){printf("%s\t%d\n",i,a[i])}}'`
echo "$t $tw"
