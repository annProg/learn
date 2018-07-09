#!/bin/bash

############################
# Usage: 将数字转为汉字  还有一些bug
# File Name: 12-num-tostring.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-08 23:28:53
############################

n=$1

array_n=("零" "一" "二" "三" "四" "五" "六" "七" "八" "九")
array_unit=("" "" "十" "百" "千" "万" "十" "百" "千" "亿" "十" "百" "千")

s=()
function run() {
	l=${#n}
	ll=$((l-1))
	[ $l -gt 12 ] && echo "超出计算范围(12位)" && exit 1
	iscontinuity=0
	for i in `seq 1 $l`;do
		m=$((n%10))
		n=$((n/10))

		islast=$((l-ll))
		if [ $m -gt 0 ];then
			s[$((l-i))]=${array_n[$m]}${array_unit[$i]}
			iscontinuity=0
		elif [ $m -eq 0 ];then
			if [ $i -eq 5 ] || [ $i -eq 9 ];then
				s[$((l-i))]=${array_unit[$i]}
			elif [ $i -gt $islast ] && [ $iscontinuity -eq 0 ];then
				s[$((l-i))]=${array_n[$m]}
				iscontinuity=1
			else
				ll=$((ll-1))
			fi
		fi
	done
}

run
echo ${s[@]}
