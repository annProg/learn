#!/bin/bash

############################
# Usage:
# File Name: repo.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-07-21 14:20:04
############################

yumdir="/etc/yum.repos.d"
epel="$yumdir/epel.repo"
backup="$yumdir/backup"

[ ! -d $backup ] && mkdir $backup
mv -f $yumdir/*.repo $backup

rpm -qa |grep epel-release && rpm -e epel-release
rpm -Uvh http://mirrors.yun-idc.com/epel/6/x86_64/epel-release-6-8.noarch.rpm
#baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch
sed -i 's#download.fedoraproject.org/pub#mirrors.yun-idc.com#g' $epel
sed -i -E 's/^mirrorlist(.*)/#mirrorlist\1/g' $epel
sed -i -E 's/#baseurl(.*)/baseurl\1/g' $epel
curl -s http://mirrors.163.com/.help/CentOS6-Base-163.repo -o $yumdir/Base-163.repo
yum clean all
yum makecache

