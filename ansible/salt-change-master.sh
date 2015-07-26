#!/bin/bash

#-----------------------------------------------------------
# Usage: change salt master
# $Id: salt-change-master.sh  i@annhe.net  2015-07-21 15:11:57 $
#-----------------------------------------------------------

[ $# -lt 2 ] && echo "args error" && exit 1
oldmaster="192.168.60.100"
newmaster="192.168.60.129"
group=$1
saltgroup=$2
salt-key -d "$saltgroup"

ansible $group -m command -a "cp /etc/salt/minion /etc/salt/minion.bak"
ansible $group -m command -a "sed -i 's/$oldmaster/$newmaster/g' /etc/salt/minion"
ansible $group -m command -a "rm -f /etc/salt/pki/minion/minion_master.pub"
ansible $group -m command -a "/etc/init.d/salt-minion restart"
ansible $group -m command -a "/etc/init.d/salt-minion status"
ansible $group -m command -a "tail /var/log/salt/minion"
