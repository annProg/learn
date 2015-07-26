#!/bin/bash

#-----------------------------------------------------------
# Usage: ssh-copy-id自动化
# $Id: copy-key.sh  i@annhe.net  2015-07-21 14:26:27 $
#-----------------------------------------------------------

while read id;do
	ip=`echo $id | awk '{print $1}'`
	user=`echo $id | awk '{print $2}'`
	passwd=`echo $id | awk '{print $3}'`
	./copy-key.exp $ip $user $passwd
done <host.list
