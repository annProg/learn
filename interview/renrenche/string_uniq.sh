#!/bin/bash

#-----------------------------------------------------------
# Usage: 字符串去重
# $Id: string_uniq.sh  i@annhe.net  2015-08-27 16:40:45 $
#-----------------------------------------------------------

[ $# -lt 1 ] && exit 1

str=$1
len=${#str}

arr=()
for ((i=0;i<len;i++));do
	char=${str:$i:1}
	for ch in ${arr[*]};do
		[ "$char"x == "$ch"x ] && continue 2
	done
	arr[$i]=`echo ${str:$i:1}`
done

echo ${arr[*]} |tr -d ' '
