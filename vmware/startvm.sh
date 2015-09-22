#!/bin/bash

############################
# Usage: 批量管理虚拟机电源，需要msys支持
# File Name: startvm.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-09-22 09:33:32
############################



dir="/e/VMs/"
[ $# -lt 1 ] && echo "args error" && exit 1
func=$1
echo $func;
function prompt() {
	read -p "are you sure?(y/n)" p
	case $p in
		y) return 0;;
		n) exit 1;;
		*) echo "accept y,n" && exit 1;;
	esac
}

case $func in
	start) prompt;;
	stop) prompt;;
	pause) prompt;;
	unpause) prompt;;
	suspend) prompt;;
	*) echo "accept start, stop, pause, unpause, suspend" && exit 1;;
esac

for id in `find ./ $dir -name "*.vmx"`;do
	vmrun $func $id &
	echo "$id $func..."
done
