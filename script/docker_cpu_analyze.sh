#!/bin/bash

############################
# Usage: 列出容器cpu占用率
# File Name: docker_cpu_analyze.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-20 20:09:48
############################

function color()
{
    echo -e "\033[41m$1\033[0m"
}

echo "CONTAINER-ID   PORT  %CPU  MESOS_TASK_ID"
for id in `docker ps |awk 'NR!=1{print $1}'`;do 
    mesosid=`docker inspect $id | grep -w "MESOS_TASK_ID" |cut -f2 -d'=' |tr -d '",'`
    port=`docker inspect $id |grep -w "PORT0" |cut -f2 -d'=' |tr -d '",'`
    cpu=`docker top $id aux|awk 'NR!=1{sum+=$3}END{print sum}'`
    #echo "$id  $port  `color $cpu`  $mesosid"
    printf "%s  %s  %-15s%s\n" "$id" "$port" "`color $cpu`" "$mesosid"  
done

