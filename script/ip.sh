#!/bin/bash

############################
# Usage:
# File Name: ip.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2017-08-17 10:59:27
############################

ip=$1
network=$2

net=`echo $network |cut -f1 -d'/'`
mask=`echo $network |cut -f2 -d'/'`
zero=$((32-mask))

M=""
for i in `seq 1 $mask`;do
	M="${M}1"
done
for k in `seq 1 $zero`;do
	M="${M}0"
done

M1=$((2#${M:0:8}))
M2=$((2#${M:8:8}))
M3=$((2#${M:16:8}))
M4=$((2#${M:24:8}))

ip1=`echo $ip |cut -f1 -d'.'`
ip2=`echo $ip |cut -f2 -d'.'`
ip3=`echo $ip |cut -f3 -d'.'`
ip4=`echo $ip |cut -f4 -d'.'`

n1=$((ip1&M1))
n2=$((ip2&M2))
n3=$((ip3&M3))
n4=$((ip4&M4))

n="$n1.$n2.$n3.$n4"

if [ "$n"x == "$net"x ];then
	echo "True: $ip in $network"
else
	echo "False: $ip not in $network"
fi

echo -e "\n====================="
echo "ip's NetWork: $n"
