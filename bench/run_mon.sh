#!/bin/bash

############################
# Usage:
# File Name: run_mon.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-24 12:14:41
############################

[ $# -lt 1 ] && echo "args error" && exit 1
dockerid=$1
nohup watch -n 30 './timeout.sh >>timeout.log' &>/dev/null &
nohup watch -n 2 './docker_mon.sh $1' &>/dev/null &
