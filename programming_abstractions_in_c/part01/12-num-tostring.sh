#!/bin/bash

############################
# Usage: 将数字转为汉字
# File Name: 12-num-tostring.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-07-08 23:28:53
############################

n=$1

function N2S() {
	case $1 in
		1) echo -n "一";;
		2) echo -n "二";;
		3) echo -n "三";;
		4) echo -n "四";;
		5) echo -n "四";;
		6) echo -n "四";;
		7) echo -n "四";;
		8) echo -n "四";;
		9) echo -n "九";;
		0) echo -n "零";;
		*) return;;
	esac
}

function Unit() {
	case $1 in
		2) echo -n "十";;
		3) echo -n "百";;
		4) echo -n "千";;
		5) echo -n "万";;
		6) echo -n "十万";;
		7) echo -n "百万";;
		8) echo -n "千万";;
		9) echo -n "亿";;
		10) echo -n "十亿";;
		11) echo -n "百亿";;
		12) echo -n "千亿";;
		*) return;;
	esac
}


function run() {
	l=${#n}
	for i in `seq 1 $l`;do
		m=$((n%10))
		n=$((n/10))
		Unit $i
		N2S $m
	done
}

run |rev
