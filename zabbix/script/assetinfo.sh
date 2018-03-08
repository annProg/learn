#!/bin/bash

############################
# Usage:
# File Name: assetinfo.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-09-29 15:11:36
############################

sn=`sudo dmidecode -s system-serial-number |grep -v "^#"`
uuid=`sudo dmidecode -s system-uuid |grep -v "^#"`
manufacturer=`sudo dmidecode -s system-manufacturer|grep -v "^#"`
product=`sudo dmidecode -s system-product-name|grep -v "^#" |sed 's/-\[.*\]-//g'`
os=`cat /etc/redhat-release |sed -r 's/\(.*\)|Linux|release//g'`

echo $sn |grep -E " |-" &>/dev/null && assettag=$uuid || assettag=$sn

case $1 in
	"sn") echo $assettag;;
"manufacturer") echo $manufacturer;;
"product") echo $product;;
"os") echo $os;;
*) exit;;
esac

