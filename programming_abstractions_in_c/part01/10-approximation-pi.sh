#!/bin/bash

############################
# Usage: 求PI的近似值
# File Name: 10-approximation-pi.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-06-10 07:55:41
############################

N=$1
m=$((2*N))
echo $m |awk '{q=0;co=1;for(i=1;i<$0;i=i+2) {q=q+(co*1)/i;co=-1*co}}END{print 4*q}'
