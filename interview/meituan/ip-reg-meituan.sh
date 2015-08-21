#!/bin/bash

#-----------------------------------------------------------
# Usage: 正则匹配ip
# $Id: ip-reg.sh  i@annhe.net  2015-08-22 03:17:35 $
#-----------------------------------------------------------

reg=(
"^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$"
#"^(([1]?\d{1,2}|2[0-4]\d|25[0-5])\.){3}([1]?\d{1,2}|2[0-4]\d|25[0-5])$"
"^(([1-9]?\d|1\d{2}|2[0-4]\d|25[0-5])\.){3}([1-9]?\d|1\d{2}|2[0-4]\d|25[0-5])$"
)

function match_ip() {
	ip=$1
	for id in ${reg[*]};do
		echo $ip | grep --color -P  "$id"  &>/dev/null && echo "ok      $ip" || echo "failed  $ip"
	done
	echo ""
}

function gen_test_data() {
	sum=$1
	arr=()
	for ((i=0;i<$sum;i++));do
		let arr[0]=$RANDOM%300
		let arr[1]=$RANDOM%200
		let arr[2]=$RANDOM%100
		let arr[3]=$RANDOM%10
		let arr[4]=$RANDOM%1
		let arr[5]=$RANDOM%5
		let arr[6]=$RANDOM%500
		let arr[7]=$RANDOM%350
		let arr[8]=$RANDOM%150
		let arr[9]=$RANDOM%1000
		
		ip=()
		for ((j=0;j<4;j++));do
			let index=$RANDOM%9
			ip[$j]=${arr[$index]}
		done

		ip="${ip[0]}.${ip[1]}.${ip[2]}.${ip[3]}"

		match_ip $ip
	done
}

gen_test_data 20

list=(
0.0.0.0
255.255.255.255
001.02.5.3
124.0.0.0
299.9.1.2
)

for id in ${list[@]};do
	match_ip $id
done

