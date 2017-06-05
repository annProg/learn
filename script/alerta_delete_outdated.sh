#!/bin/bash

############################
# Usage: 删除alerta无效的报警
# File Name: alerta_delete_outdated.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2017-06-05 13:55:57
############################

KEY="Fnp7aLBfegVPqcpnKs_RGa-XcsgoNU0Cx2E-IggJ"
API="http://monitor.xxx.com/api"
DATE=`date -d @$(date +%s |awk '{print $1-87200}') +%Y-%m-%dT%H:%M:%S.000Z`
DT=`date -d @$(date +%s |awk '{print $1-87200}') +%Y-%m-%dT%H:00:00`
for id in `curl -s -H "Authorization: $KEY" "$API/alerts?status=open&to-date=$DATE" |jq .alerts[].id |tr -d '"'`;do
	curl -s -XDELETE -H "Authorization: $KEY" "$API/alert/$id"
done
