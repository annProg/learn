#!/bin/bash

############################
# Usage:
# File Name: deploy.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-12-17 11:08:02
############################

alertscripts="/usr/local/zabbix/share/zabbix/alertscripts"
cp -f alert/alert.py $alertscripts
cp -f alert/tpl.py $alertscripts
cp -f alert/contact.php /home/wwwroot/default
