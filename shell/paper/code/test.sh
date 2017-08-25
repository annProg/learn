#!/bin/bash
rm -f tree
for id in $(seq 1 4)
do
	./init_pxeserver.sh -h conf/network.conf
	tree /var/www/html/centos65/repodata/ >>tree
done
