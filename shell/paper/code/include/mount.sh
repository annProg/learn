#!/bin/bash

# Usage: ¹ÒÔØCentOS DVD
# History:
#

MOUNTDIR=/var/www/html/dvd

df |grep sr0|awk '{print $1}'|while read dev
do
	umount $dev
done

rpm -qa |grep httpd &>/dev/null && r=0 || r=1
[ $ -eq 1] && yum install -y httpd &>/dev/null && echo -e "\033[36m[SUCC]: install httpd \033[0m" || echo -e "\033[31m[ERRO]: install httpd failed \033[0m"
[ ! -d $MOUNTDIR ] && mkdir $MOUNTDIR
mount /dev/cdrom $MOUNTDIR && echo -e "\033[36m[SUCC]: mount on $MOUNTDIR ok! \033[0m" || echo -e "\033[31m[ERRO]: mount error ,please check! \033[0m"



