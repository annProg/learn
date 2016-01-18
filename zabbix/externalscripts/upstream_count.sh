#!/bin/bash

############################
# Usage:
# File Name: upstream_count.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-01-18 18:22:48
############################

#!/bin/bash

basedir=$(cd `dirname $0`;pwd)
nginxlist="$basedir/tv_nginx.list"

function pull_data()
{
	ip=$1
	curl -s "http://$ip:8000/upstream?format=csv" |awk -v ip=$ip -F ',' '
	{
		upstream[$2]+=1;
		if($4=="up")
			up[$2]+=1
		else
			down[$2]+=1
	}END{
		for(k in upstream){
			if(down[k] == "")
				down[k]=0
			print k","(1-up[k]/upstream[k])*100","upstream[k]","down[k]
		}
	}'

}

timedata=`date +%H%M%S`
echo $timedata >$basedir/upstream_count.log

while read ip;do
	for id in `pull_data $ip`;do
		upstream=`echo $id |cut -f1 -d','`
		down_percentage=`echo $id |cut -f2 -d','`
		total=`echo $id |cut -f3 -d','`
		down=`echo $id |cut -f4 -d','`
		zabbix_sender -z 10.0.0.11 -s "TV_Nginx-$ip" -k "upstream_count[$upstream]" -o "$down_percentage" &>>$basedir/upstream_count.log
		zabbix_sender -z 10.0.0.11 -s "TV_Nginx-$ip" -k "upstream_total[$upstream]" -o "$total" &>>$basedir/upstream_count.log
		zabbix_sender -z 10.0.0.11 -s "TV_Nginx-$ip" -k "upstream_down[$upstream]" -o "$down" &>>$basedir/upstream_count.log
	done
done <$nginxlist

echo '{"data":[]}'
