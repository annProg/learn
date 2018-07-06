#!/bin/bash

############################
# Usage: 输入一系列整数直道遇到0，打印最大值
# File Name: 5-max-num.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-06 16:29:40
############################

n=1
max=0

while [ $n -ne 0 ];do
	read -p '? ' n
	if [ $n -gt $max ];then
		max=$n
	fi
done

echo "Max number: $max"
