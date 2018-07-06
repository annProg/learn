#!/bin/bash

############################
# Usage: 质数分解
# File Name: 8-prime-decompose.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-06 17:24:44
############################

num=$1

function isPrime() {
	n=$1
	sqrtn=`echo $n |awk '{print int(sqrt($0))}'`
	for i in `seq 2 $sqrtn`;do 
		t=$((n%i))
		[ $t -eq 0 ] && echo 0 && return
	done
	echo 1
}

function decompose() {
	nn=$1
	exp=""
	for id in `seq 2 $nn`;do
		p=`isPrime $id`
		s=1
		if [ $p -eq 1 ];then
			s=$((nn%id))
		fi
		if [ $s -eq 0 ];then
			t=$((nn/id))
			exp=`decompose $t`"*$id"
		fi
	done
	echo $exp
}

decompose $num |sed 's/^\*//g'
