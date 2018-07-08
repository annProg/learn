#!/bin/bash

############################
# Usage: 通过1/4圆面积计算PI近似值
# File Name: 11-approximation-pi.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-08 22:59:11
############################

N=$1

echo $N |awk '{r=2;n=$0;w=r/n;pi=0;for(i=0;i<n;i++) {x=w*i-w/2;h=sqrt(r*r-x*x);pi=pi+h*w}}END{print pi}'
