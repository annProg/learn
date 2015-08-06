#!/bin/bash

#-----------------------------------------------------------
# Usage: 同步时间
# $Id: ntp.sh  i@$group.net  2015-07-21 15:05:34 $
#-----------------------------------------------------------
[ $# -lt 1 ] && exit 1
group=$1
cmd="ntpdate -u time.windows.com"
cmd2="hwclock -w"
ansible $group -m command -a "$cmd"
ansible $group -m command -a "$cmd2"
ansible $group -m command -a "date"
