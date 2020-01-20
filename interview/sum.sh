#!/bin/bash

############################
# Usage: 大数相加
# File Name: sum.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2019-11-18 10:51:42
############################

[ $# -lt 2 ] && echo "$0 number1 number2" && exit 1

function max() {
	if [ $1 -gt $2 ];then
		echo $1
	else
		echo $2
	fi
}

function sum() {
	A=`echo $1 |rev`
	B=`echo $2 |rev`
	C=""

	len=`max ${#A} ${#B}`

	carry=0
	for ((i=0;i<$len;i++));do
		a=${A:$i:1}
		b=${B:$i:1}

		((c=a+b+carry))

		if [ $c -gt 9 ];then
			carry=1
			((c=c-10))
		else
			carry=0
		fi
		C="`echo $c`"${C}
	done

	echo $carry$C |sed 's/^0//g'
}

sum $1 $2
