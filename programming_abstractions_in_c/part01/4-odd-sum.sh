#!/bin/bash

############################
# Usage: 计算前N个奇数的和
# File Name: 4-odd-sum.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-06 16:27:08
############################

n=$1
m=$((2*n))
sum=0

for((i=1;i<m;i=i+2));do
	sum=$((sum+i))
done

echo $sum
