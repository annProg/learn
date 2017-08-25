#!/bin/bash

# Usage: 重置Cloudstack环境
# History:
#


MYSQLROOTPWD=root
NFSSERVER=192.168.60.111
SYSTEMVM=systemvm64template-2014-04-15-master-kvm.qcow2.bz2

mysql -uroot -p$MYSQLROOTPWD -e "drop database cloud; drop database cloud_usage; drop database cloudbridge;"

cloudstack-setup-databases cloud:cloud@localhost --deploy-as=root:root
mount -t nfs $NFSSERVER:/secondary /mnt/secondary

rsync 192.168.60.10::hadoop/soft/$SYSTEMVM .
/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /mnt/secondary/ -f $SYSTEMVM -h kvm -F

service cloudstack-management restart

echo -e "\033[31m[ERRO]: 请在agent上执行 service libvirtd restart \033[0m"