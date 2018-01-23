#!/bin/bash

# 检查mpaas 前端机配置
declare -A gt
declare -A lt
declare -A eq

gt=(
[net.core.somaxconn]=65535
[net.core.rmem_default]=262144
[net.core.wmem_default]=262144
[net.core.rmem_max]=16777216
[net.core.wmem_max]=16777216
[net.ipv4.tcp_max_syn_backlog]=16384
[net.core.netdev_max_backlog]=20000
[net.ipv4.tcp_max_syn_backlog]=16384
[net.ipv4.tcp_max_orphans]=131072
)

lt=(
[net.ipv4.tcp_fin_timeout]=15
)

eq=(
[net.ipv4.tcp_tw_reuse]=1
[net.ipv4.tcp_tw_recycle]=1
[net.ipv4.tcp_syncookies]=0
)

function warning() {
	echo -e "\033[31m $1 \033[0m"
}

function ok() {
	echo -e "\033[32m $1 \033[0m"
}

function title() {
	echo -e "\033[33m ======== $1 ============== \033[0m"
}

title gt
for id in ${!gt[*]};do
	o=`sysctl -a |grep -w "$id"`
	v=`echo $o |awk '{print $NF}'`
	expect=${gt["$id"]}
	if [ $v -ge $expect ];then
		ok "$o - $expect"
	else
		warning "$o - $expect"
	fi
done

title lt
for id in ${!lt[*]};do
	o=`sysctl -a |grep -w "$id"`
	v=`echo $o |awk '{print $NF}'`
	expect=${lt["$id"]}
	if [ $v -le $expect ];then
		ok "$o - $expect"
	else
		warning "$o - $expect"
	fi
done

title eq
for id in ${!eq[*]};do
	o=`sysctl -a |grep -w "$id"`
	v=`echo $o |awk '{print $NF}'`
	expect=${eq["$id"]}
	if [ $v -eq $expect ];then
		ok "$o - $expect"
	else
		warning "$o - $expect"
	fi
done

sendq=`ss -lnt |grep ":80 " |awk '{print $3}'`
expect=10000
if [ $sendq -lt $expect ];then
	warning "port 80 sendq: $sendq  -  $expect"
else
	ok "port 80 sendq: $sendq  -  $expect"
fi
