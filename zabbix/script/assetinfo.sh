#!/bin/bash

############################
# Usage:
# File Name: assetinfo.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-09-29 15:11:36
############################

function all_ip() {
	ips=""
	for item in `ip add |grep "inet " |grep -E "host lo|global eth" |grep -v "127.0.0.1" |awk '{print $2}'`;do
		ip=`echo $item |cut -f1 -d'/'`
		mask=`echo $item |cut -f2 -d'/'`
		first=`echo $ip |cut -f1 -d'.'`
		if [ $mask -eq 32 ];then
			ips="$ips,vip-$ip"
		elif [ $first -eq 10 ];then
			ips="$ips,int-$ip"
		else
			ips="$ips,ext-$ip"
		fi
	done
	oob=`sudo ipmitool lan print 2>/dev/null |grep "^IP Address" |grep -v "Source" |awk '{print $NF}'`
	if [ "$oob"x != ""x ];then
		ips="$ips,oob-$oob"
	fi
	echo $ips |sed 's/^,//g'
}

function hp_raid() {
	sudo /opt/hp/hpssacli/bld/hpssacli ctrl all show config 2>/dev/null|grep "RAID" |cut -f2 -d',' |awk '{print $2}' |grep -v "^$" |uniq -c |awk '{print $2"*"$1}' |tr '\n' '+' |sed 's/+$//g'
}

function dell_raid() {
	raid=`sudo /opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -Lall -aALL 2>/dev/null|grep "RAID Level"|awk  -F": " '{print $2}'|tr ' ' '#'|tr -d ','`
	r=""
	for id in $raid;do 
		case "$id" in
		"Primary-1#Secondary-0#RAID#Level#Qualifier-0") r="$r+1";;
		"Primary-0#Secondary-0#RAID#Level#Qualifier-0") r="$r+0";;
		"Primary-5#Secondary-0#RAID#Level#Qualifier-3") r="$r+5";;
		"Primary-1#Secondary-3#RAID#Level#Qualifier-0") r="$r+10";;
		"*") r="$r+N";;
		esac	
	done
	[ "$r"x == ""x ] && r="N"
	echo $r |tr '+' '\n' |grep -v "^$" |uniq -c |awk '{print $2"*"$1}' | tr '\n' '+' |sed 's/+$//g'
}

sn=`sudo dmidecode -s system-serial-number |grep -v "^#"`
uuid=`sudo dmidecode -s system-uuid |grep -v "^#"`
manufacturer=`sudo dmidecode -s system-manufacturer|grep -v "^#"`
product=`sudo dmidecode -s system-product-name|grep -v "^#" |sed 's/-\[.*\]-//g'`
os=`cat /etc/redhat-release |sed -r 's/\(.*\)|Linux|release//g'`
kernel=`uname -r |sed 's/-.*//g'`

echo $sn |grep -E " |-" &>/dev/null && assettag=$uuid || assettag=$sn

diskspace=`df 2>/dev/null|grep -E " /letv| /data" |awk '{all+=$(NF-4);avail+=$(NF-2)}END{print all*1024,avail*1024}'`

if [ "$manufacturer"x == "HP"x ];then
	pd=`sudo /opt/hp/hpssacli/bld/hpssacli ctrl all show config 2>/dev/null|grep "physicaldrive" |cut -f3 -d',' |awk '{sum+=$1}END{print NR,int(sum/1024)}'`
	raid=`hp_raid`
else
	pd=`sudo /opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL 2>/dev/null|grep "Raw Size:" |awk '{if($4=="GB") sum+=$3/1024; else sum+=$3}END{print NR,int(sum)}'`
	raid=`dell_raid`
fi

case $1 in
	"sn") echo $assettag;;
"manufacturer") echo $manufacturer;;
"product") echo $product;;
"os") echo $os;;
"all") echo "$diskspace" |awk '{print $1}';;
"avail") echo "$diskspace" |awk '{print $2}';;
"pdnum") echo "$pd" |awk '{print $1}';;
"pdsize") echo "$pd" |awk '{print $2}';;
"raid") echo $raid |sed 's/*1+/+/g' |sed 's/*1$//g';;
"kernel") echo $kernel;;
"ip") all_ip;;
*) exit;;
esac

