#!/bin/bash

# Usage: 设置软件源
# History:
#

HOSTNAME=controller

[ $# -eq 0 ] && { echo "need args"; exit 1; }

cd /etc/yum.repos.d/

[ ! -d backup ] && mkdir backup
if [ $1 = "l" ]; then
	mv *.repo backup
	cat >local.repo <<eof
[local]
name=local
baseurl=http://$HOSTNAME/centos65
gpgcheck=0
enabled=1

[cloudstack]
name=cloudstack
baseurl=http://$HOSTNAME/soft/cloudstack
enabled=1
gpgcheck=0
	
eof

elif [ $1 = "d"; then
	rm -f local.repo
	mv backup/* .
fi
