#!/bin/bash

############################
# Usage:
# File Name: assetinfo.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-09-29 15:11:36
############################

function hp_raid() {
	/opt/hp/hpssacli/bld/hpssacli ctrl all show config 2>/dev/null|grep "RAID" |cut -f2 -d',' |awk '{print $2}' |tr '\n' '+' |sed 's/+$//g'
}

function dell_raid() {
	raid=`/opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -Lall -aALL 2>/dev/null|grep "RAID Level"|awk  -F": " '{print $2}'|tr ' ' '#'|tr -d ','`
	r=""
	for id in $raid;do 
		case "$id" in
		"Primary-1#Secondary-0#RAID#Level#Qualifier-0") r="1+$r";;
		"Primary-0#Secondary-0#RAID#Level#Qualifier-0") r="0+$r";;
		"Primary-5#Secondary-0#RAID#Level#Qualifier-3") r="5+$r";;
		"Primary-1#Secondary-3#RAID#Level#Qualifier-0") r="10+$r";;
		"*") r="N+$r";;
		esac	
	done
	[ "$r"x == ""x ] && r="N"
	echo $r |sed 's/+$//g'
}


sn=`sudo dmidecode -s system-serial-number |grep -v "^#"`
uuid=`sudo dmidecode -s system-uuid |grep -v "^#"`
manufacturer=`sudo dmidecode -s system-manufacturer|grep -v "^#"`
product=`sudo dmidecode -s system-product-name|grep -v "^#" |sed 's/-\[.*\]-//g'`
os=`cat /etc/redhat-release |sed -r 's/\(.*\)|Linux|release//g'`

echo $sn |grep -E " |-" &>/dev/null && assettag=$uuid || assettag=$sn

diskspace=`df 2>/dev/null|grep -E " /letv| /data" |awk '{all+=$(NF-4);avail+=$(NF-2)}END{print all*1024,avail*1024}'`

if [ "$manufacturer"x == "HP"x ];then
	pd=`/opt/hp/hpssacli/bld/hpssacli ctrl all show config 2>/dev/null|grep "physicaldrive" |cut -f3 -d',' |awk '{sum+=$1}END{print NR,int(sum/1024)}'`
	raid=`hp_raid`
else
	pd=`/opt/MegaRAID/MegaCli/MegaCli64 -PDList -aALL 2>/dev/null|grep "Raw Size:" |awk '{sum+=$3}END{print NR,int(sum/1024)}'`
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
"raid") echo "$raid";;
*) exit;;
esac

