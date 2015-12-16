#!/bin/bash

############################
# Usage:
# File Name: addTvNode.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-23 16:47:26
############################

##################################
# list file format sample
# 192.168.1.101 tv.ct.node.101
###################################

[ $# -lt 2 ] && echo "args error" && exit 1

list=$1
core=$2

#TV-Nginx
templateids="10610,10127,10109"
#templateids="10596,10124,10192,10237,10109"
[ "$core"x == "8"x ] && templateids="10109,10177"
groupids="44,9"

while read id;do
	ip=`echo $id |awk '{print $1}'`
	name=`echo $id |awk '{print $2}'`
	isp=`echo $name |cut -f2 -d'.'`
	[ "$isp"x == "ct"x ] && groupids="44,9"
	./host.py add $ip $name $groupids $templateids
	#echo "./host.py add $ip $name $groupids $templateids"
done <$list
