#!/bin/bash

############################
# Usage:
# File Name: awk.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-01-15 14:18:11
############################

cat data | awk '
{
	a[$3,$2,$1]=$4
}
END{
	for(k in a){
		split(k,idx,SUBSEP);
		print idx[1],idx[2],a[idx[1],idx[2],"sendmsg"],a[idx[1],idx[2],"ackmsg"],a[idx[1],idx[2],"procmsg"]
	}
}' |sort |uniq

