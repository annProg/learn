#!/bin/bash

############################
# Usage:
# File Name: disk_discovery.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-09-22 11:09:18
############################
#written by Yiffy
#mail:ccyhaoran@live.cn

diskarray=(`cat /proc/diskstats |grep -E "\bsd[abcdefg]\b|\bxvd[abcdefg]\b"|grep -i "\b$1\b"|awk '{print $3}'|sort|uniq   2>/dev/null`)
length=${#diskarray[@]}
printf "{"
printf  "\"data\":["
for ((i=0;i<$length;i++))
do
        printf '{'
        printf "\"{#DISK_NAME}\":\"${diskarray[$i]}\"}"
        if [ $i -lt $[$length-1] ];then
                printf ','
        fi
done
printf  "]"
printf "}"
