#!/bin/bash

############################
# Usage:
# File Name: getvip.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-29 16:48:13
############################

for id in `cat vip.csv |cut -f1,2,3,4,5 -d';' |sort |uniq`;do ips=`grep "$id" vip.csv |cut -f6 -d';'|tr -s '\n' '#' |sed 's/ #/##/g' |sed 's/ /,/g'`;echo "$id;$ips;" |sed 's/##;/;/g' >>revip.csv;done 
