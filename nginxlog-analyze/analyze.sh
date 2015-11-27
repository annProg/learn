#!/bin/bash

############################
# Usage:
# File Name: status_code.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-27 10:46:46
############################

[ $# -lt 1 ] && echo "./status_code.sh logfile" && exit 1

logfile=$1

function getStatusCode()
{
	awk '{print $2}' $logfile | sort |uniq -c |sort -nr > status_code.txt
}
