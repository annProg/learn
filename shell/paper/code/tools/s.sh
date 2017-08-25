#!/bin/bash

# Usage: 命令简化脚本
# History:
#



if [ $# -eq 0 ]; then
	echo "m        cloudstack-management status"
	echo "ip       iptables status"
	echo "cl       cloudstack-management restart"
	echo "setup    cloudstack-setup-management"
	echo "stop     cloudstack-management stop"
fi
[ "$1"x = "m"x ] && service cloudstack-management status
[ "$1"x = "ip"x ] && service iptables status
[ "$1"x = "cl"x ] && /etc/init.d/cloudstack-management restart
[ "$1"x = "setup"x ] && cloudstack-setup-management
[ "$1"x = "stop"x ] && /etc/init.d/cloudstack-management stop
