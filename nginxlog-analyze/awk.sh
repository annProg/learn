#!/bin/bash

############################
# Usage:
# File Name: awk.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-16 17:54:52
############################

logfile=$1
# 日志格式
# '$remote_addr [$time_iso8601]  $status $body_bytes_sent '
# '"$request_method $scheme://$server_name$request_uri" '
# '"$http_referer" "$http_user_agent" "$http_x_forwarded_for" '
# '"$request_time" "$upstream_addr" "$upstream_status" "$upstream_response_time"';
awk '{print $}
