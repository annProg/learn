#!/bin/bash

# Usage: 重置虚拟机磁盘
# History:
#

[ $# -eq 0 ] && { echo "need args"; exit 1; }
#空格以 "-" 代替
if [ "$1"x = "h"x ]; then
DIR=(
/d/Virtual-Machines/Master/
/d/Virtual-Machines/Slave1/
/d/Virtual-Machines/Slave2/
)
elif [ "$1"x = "c"x ]; then
DIR=(
/s/Virtual-Machines/Management/
/s/Virtual-Machines/agent1/
/d/Virtual-Machines/Storage/
)
fi

read -p "Dangerous! Are you sure? (y/n) " choice
if [ "$choice"x = "y"x ]; then
	for id in ${DIR[*]}
	do
		DISKDIR=`echo $id | tr -s "-" "\ "`
		cd "$DISKDIR"
		rm -f *.vmdk
		DISKFILE=`cat *.vmx |grep vmdk | awk -F '["]' '{print $2}'`
		if [ $DISKFILE = Storage.vmdk ]; then
			SIZE=60GB
		else
			SIZE=20GB
		fi
		/s/programs/VMware/Workstation/vmware-vdiskmanager.exe -c -t 1 -s $SIZE -a lsilogic $DISKFILE &>/dev/null && echo -e "\033[36m[SUCC]:  $id$DISKFILE OK! SIZE=$SIZE \033[0m"
	done
	echo -e "\033[36m[SUCC]: All OK!, exit... \033[0m"
else
	echo -e "\033[36m[SUCC]: exit... \033[0m" && exit 0
fi