#!/bin/bash

############################
# Usage:
# File Name: docker_mon.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-24 13:49:55
############################

[ $# -lt 1 ] && echo "args error" && exit 1
dockerid=$1
t=`date +%m%d-%H:%M:%S`
php=`docker top $dockerid -aux |grep php-fpm |awk '{sum+=$4}END{print sum}'`
nginx=`docker top $dockerid -aux |grep nginx |awk '{sum+=$4}END{print sum}'`
total=`docker top $dockerid -aux |grep -v CMD |awk '{sum+=$4}END{print sum}'`

echo "$t  $php  $nginx  $total" |tee -a dockertop-$dockerid.log

