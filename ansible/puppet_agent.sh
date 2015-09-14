#!/bin/bash

############################
# Usage:
# File Name: puppet_agent.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-09-14 12:11:23
############################

SERVER="repo.annhe.net"
PORT="10051"
HOSTNAME=`hostname`
ZABBIX_REPO="http://repo.zabbix.com/zabbix/2.4/rhel/6/x86_64/zabbix-release-2.4-1.el6.noarch.rpm"
CONF="/etc/zabbix/zabbix_agentd.conf"
INCLUDE="/etc/zabbix/zabbix_agentd.d/"
SALT=`date +%s`

EPEL="http://mirrors.sohu.com/fedora-epel/epel-release-latest-6.noarch.rpm"


rpm -qa |grep epel-release || rpm -i "$EPEL"
rpm -qa |grep puppet || yum install puppet

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
