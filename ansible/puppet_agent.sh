#!/bin/bash

############################
# Usage:
# File Name: puppet_agent.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-09-14 12:11:23
############################

SERVER="repo.annhe.net"
HOSTNAME=`hostname`
CONF="/etc/puppet/puppet.conf"
SALT=`date +%s`
EPEL="http://mirrors.sohu.com/fedora-epel/epel-release-latest-6.noarch.rpm"

rpm -qa |grep epel-release || rpm -i "$EPEL"
rpm -qa |grep puppet || yum install  puppet -y

mv -f $CONF $CONF.bak.$SALT
cat >>$CONF <<EOF
[main]
    logdir = /var/log/puppet
    rundir = /var/run/puppet
    ssldir = \$vardir/ssl
[agent]
    classfile = \$vardir/classes.txt
    localconfig = \$vardir/localconfig
    server = $SERVER
    certname = $HOSTNAME
EOF

/etc/init.d/puppet start
puppet agent --test
