#!/bin/bash

############################
# Usage:
# File Name: zabbix_agent.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-09-08 17:22:23
############################

SERVER="repo.annhe.net"
PORT="10051"
HOSTNAME=`hostname`
ZABBIX_REPO="http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm"
CONF="/etc/zabbix/zabbix_agentd.conf"
INCLUDE="/etc/zabbix/zabbix_agentd.d/"
SALT=`date +%s`

rpm -qa |grep zabbix-release || rpm -ivh "$ZABBIX_REPO"
rpm -qa |grep zabbix-agent || yum install -y zabbix-agent

mv -f $CONF $CONF.bak.$SALT
cat >>$CONF <<EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=$SERVER
ServerActive=$SERVER:$PORT
Hostname=$HOSTNAME
Include=$INCLUDE
EOF

/etc/init.d/zabbix-agent restart
