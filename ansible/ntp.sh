#!/bin/bash

#-----------------------------------------------------------
# Usage: 同步时间
# $Id: ntp.sh  i@annhe.net  2015-07-21 15:05:34 $
#-----------------------------------------------------------

cmd="ntpdate -u time.windows.com"
cmd2="hwclock -w"
ansible annhe -m command -a "$cmd"
ansible annhe -m command -a "$cmd2"
ansible annhe -m command -a "date"
