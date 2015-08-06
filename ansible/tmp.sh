#!/bin/bash

############################
# Usage:
# File Name: tmp.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-07-21 15:28:39
############################

#echo "*/1 * * * * root ntpdate -u time.windows.com &>>/var/log/ntpdate.log && hwclock -w" >> /etc/crontab

network="192.168.60."
lab=(133 134 135 136)
num=${#lab[*]}

for ((i=0;i<num;i++)); do
	ip=`ifconfig |grep "inet " |grep -v "127.0" |awk '{print $2}' |cut -f4 -d'.'`
	if [ $ip -eq ${lab[$i]} ]; then
		let count=i+1
		hostname="lab$count"
		sed -i "s/HOSTNAME=.*/HOSTNAME=$hostname/g" /etc/sysconfig/network
		ip="$network${lab[$i]}"	
		grep "^$ip" /etc/hosts &>/dev/null && r=0 || r=1
		if [ $r -eq 1 ]; then
			echo "$network${lab[$i]} $hostname" >> /etc/hosts
		else
			sed -i "s/$ip.*/$ip\ $hostname/g" /etc/hosts
		fi
	fi
done


