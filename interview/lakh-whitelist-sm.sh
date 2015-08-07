#!/bin/bash

#-----------------------------------------------------------
# Usage: 处理数据量很大的白名单
# $Id: lakh-whitelist-sm.sh  i@annhe.net  2015-08-04 16:44:45 $
#-----------------------------------------------------------


for i in `seq 10 192`; do
	for j in `seq 0 250`; do
		for k in `seq 0 250`; do
			for h in `seq 1 253`; do
				echo "$i.$j.$k.$h" >> whitelist.txt
			done
		done
	done
done
