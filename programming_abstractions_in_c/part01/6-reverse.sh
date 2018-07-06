#!/bin/bash

############################
# Usage: 整数翻转
# File Name: 6-reverse.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-06 16:58:15
############################

n=$1
echo $n |awk '{n=$0;m=0;while(n>0) {m=m*10+n%10;n=int(n/10);}}END{print m}'
echo $n |awk '{for(i=1;i<=length;i++){line=substr($0,i,1)line}}END{print line}'
echo $n |rev
