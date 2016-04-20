#!/bin/bash

############################
# Usage: 列出容器cpu占用率
# File Name: docker_cpu_analyze.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-04-20 20:09:48
############################

#!/bin/bash
for id in `docker ps |awk 'NR!=1{print $1}'`;do 
    app=`docker inspect $id |grep -w Hostname |cut -f4 -d'"'`
    echo -n "$id - $app - ";docker top $id aux|awk 'NR!=1{sum+=$3}END{print sum}'
done

