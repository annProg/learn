#!/bin/bash

############################
# Usage: 求完全数(1-9999)
# File Name: 7-isperfect.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-06 17:05:31
############################

function isperfect() {
	n=$1
	sum=0
	for((i=1;i<n;i++));do
		t=$((n%i))
		[ $t -eq 0 ] && sum=$((sum+i))
	done
	[ $sum -eq $n ] && echo "$n"
}

for id in `seq 1 9999`;do
	isperfect $id
done
