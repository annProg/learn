#!/bin/bash

# Usage:
# History:
#

URL=mirrors.ustc.edu.cn

cd conf/
[ ! -d rpm ] && mkdir rpm
cat cloudstack.txt |grep 'Dependency' |awk -F '[:]' '{print $3}' | while read id
do
	wget "http://$URL/centos/6/os/x86_64/Packages/$id.rpm" &>/dev/null && echo -e "\033[36m[SUCC]: $id OK! \033[0m" || echo -e "\033[31m[ERRO]: $id failed.... \033[0m"
	
done
mv *.rpm rpm

