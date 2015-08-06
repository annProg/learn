#!/bin/bash

#-----------------------------------------------------------
# Usage: 找出子网中最长连续可用ip
# $Id: continuous-ip-baidu.sh  i@annhe.net  2015-08-04 12:06:11 $
#-----------------------------------------------------------

subnet="192.168.60.0/24"

used=(`nmap -sP -n $subnet |grep report |awk -F "." '{print $NF}'`)

echo "used: ${used[*]}"
num=${#used[*]}

let max=${used[1]}-${used[0]}
continuous="${used[0]} -> ${used[1]}"
for ((i=0; i<num-1; i++)); do
	let next=i+1
	let sum=${used[next]}-${used[i]}
	if [ $sum -gt $max ]; then
		max=$sum
		continuous="${used[$i]} -> ${used[$next]}"
	fi
done

echo -e "\n$continuous -- max:$max"
