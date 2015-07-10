#!/bin/bash

#Name: ethcfg.sh
#Usage: reconfigure your ethernet. 
#History: 
#	release20140305 annhe

#任意键继续
get_char()
{
	#保存原来的终端设置
	SAVEDSTTY=`stty -g`
	#按键不打印到屏幕
	stty -echo
	#将终端设置成未加工模式，也可用stty raw
	stty cbreak
	#read and output only one character
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
}

#centos版本
function ReConfigureEth4Centos()
{
	cd /etc/sysconfig/network-scripts/
	
	#虚拟机uuid设置
	#UUID=`grep "UUID" ifcfg-eth0`
	
	#删除bond配置
	sed -i "/^alias bond.*/d" /etc/modprobe.d/dist.conf
	sed -i "/^options bond.*/d" /etc/modprobe.d/dist.conf
	
	#删除70-persistent-net.rules
	rm -f /etc/udev/rules.d/70-persistent-net.rules
	
	rm -f ifcfg-eth* ifcfg-bond*
	rm -rf backup
	ETH_TOTAL=`ip add |grep "^[0-9]" |grep "eth" |wc -l`
	
	if [ "$IPADDR" != "" ]; then
		NETWORK=`echo $IPADDR |awk -F '[.]' '{print $1"."$2"."$3"."}'`
		HOST=`echo $IPADDR |awk -F '[.]' '{print $4}'`
	else
		NETWORK=""
		HOST=""
	fi
	
	echo -e "TOTAL: $ETH_TOTAL\n"
	
	MAC=`ip add |grep "link/ether" |awk '{print $2}'`
	ID=0
	for HWADDR in $MAC
	do
		cat > ifcfg-eth$ID<<eof
DEVICE="eth$ID"
BOOTPROTO="$BOOTPROTO"
HWADDR="$HWADDR"
$NETWORK$HOST
$NETMASK
$GATEWAY
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE="Ethernet"		
eof
		((ID+=1))
		if [ "$HOST" != "" ]; then
			((HOST+=1))
	fi

	done	
	
	echo "ReConfigure Finished!"
	echo "Press any key to continue..."
	char=`get_char`
	/etc/init.d/network restart
	exit 0
	
}

#debain版本
#function ReConfigureEth4Debian()
#{}

echo -e "1. BOOTPROTO=dhcp\n2. BOOTPROTO=static\n3. BOOTPROTO=none\nPls restart after operation!"
read -p "Please input your choice: " Choice
if [ $Choice -eq 1 ]; then
	BOOTPROTO="dhcp"
	IPADDR=""
	NETMASK=""
	GATEWAY=""
elif [ $Choice -eq 2 ]; then
	BOOTPROTO="static"
	read -p "Please input IPADDR: " IPADDR
	read -p "Please input NETMASK: " NETMASK
	read -p "Please input GATEWAY: " GATEWAY
	IPADDR="IPADDR="$IPADDR
	NETMASK="NETMASK="$NETMASK
	GATEWAY="GATEWAY="$GATEWAY
elif [ $Choice -eq 3 ]; then
	BOOTPROTO="none"
	IPADDR=""
	NETMASK=""
	GATEWAY=""
else
	echo "Error input!"
	exit 0
fi

#开始执行
ReConfigureEth4Centos