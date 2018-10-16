#!/bin/bash

zabbix_server="10.1.1.1"
datadir="data_tengine_reqstat"
extdir=$(cd `dirname $0`;pwd)
basedir="$extdir/$datadir"
[ ! -d $basedir ] && mkdir $basedir
if [ $# -eq 2 ];then
	nginxlist="$basedir/$2"
else
	nginxlist="$basedir/nginx.list"
fi
reqstat=":8000/reqstat"

tmpdir="$basedir/tmp"
[ ! -d $tmpdir ] && mkdir $tmpdir

hostkey="ReqStat"

keymap=(
kv
bytes_in
bytes_out
conn_total
req_total
http_2xx
http_3xx
http_4xx
http_5xx
http_other_status
rt
ups_req
ups_rt
ups_tries
http_200
http_206
http_302
http_304
http_403
http_404
http_416
http_499
http_500
http_502
http_503
http_504
http_508
http_other_detail_status
http_ups_4xx
http_ups_5xx
)

function getData()
{
	while read line;do
	{
		tag=`echo $line | cut -f1 -d','`
		ip=`echo $line | cut -f2 -d','`
		log="$tmpdir/push.$ip.log"
		tmpfile="$tmpdir/join.$ip.tmp"
		file_start="$tmpdir/$ip.start"
		file_end="$tmpdir/$ip.end"
		file_push="$tmpdir/$ip.push"
		timedate=`date +%Y%m%d%H%M%S`
		logvar=$timedate
		
		host="${tag}_${hostkey}_${ip}"
		
		# 判断start file修改时间，如果大于90s，则认为监控不工作，需重新生成file_start
		modtime=`stat -c %Y $file_start`
		nowtime=`date +%s`
		value=`echo "$modtime $nowtime" |awk '{print $2-$1}'`
		[ $value -gt 90 ] && rm -f $file_start
		logvar="$logvar \"$value\""

		echo $ip | grep "10.120" &>/dev/null && proxy="-x http://10.135.28.97:8091" || proxy=""
		
		if [ ! -f $file_start ];then
			curl -s $proxy "http://$ip$reqstat" |sort -k1 -t',' >$file_start
			continue
		else
			curl -s $proxy "http://$ip$reqstat" |sort -k1 -t',' >$file_end
		fi
	
		# 根据文件修改时间计算平均值
		start_time=`stat -c %Y $file_start`
		end_time=`stat -c %Y $file_end`
		interval=`echo "$start_time $end_time" | awk '{print $2-$1}'`
		logvar="$logvar \"$interval\""
		[ $interval -eq 0 ] && continue
		
		# ($a-$(a-29)+interval-1)/interval  (A+B-1)/B 向上取整, (已废弃，使用浮点数)
		# 当错误数小于interval时，计算结果为0，故向上取整，使其值至少为1，以便于反映问题
		join -t',' $file_start $file_end 2>$tmpfile |\
		awk -F ',' -v cluster=$tag -v host=$host -v interval=$interval -v key="${keymap[*]}" -M '{split(key,arr,/ /)}{
			for(a=31;a<60;a++){
				if($1==""){
					app="UNDEFINED"
				}else{
					pre="^"cluster"-"
					post="-([1-9][0-9]+)$"
					app=gensub(pre,"","g",$1)
					app=gensub(post,".\\1","g",app)
				}
				if(arr[a-29]=="rt"){
					if($(a-6)-$(a-29-6)<=0){
						continue
					}
					print host" "arr[a-29]"["app"] "($a-$(a-29))/($(a-6)-$(a-29-6))
				}else if(arr[a-29]=="ups_rt"){
					if($(a-1)-$(a-29-1)<=0){
						continue
					}
					print host" "arr[a-29]"["app"] "($a-$(a-29))/($(a-1)-$(a-29-1))
				}else{
					if($a-$(a-29)<0){
						continue
					}
					print host" "arr[a-29]"["app"] "($a-$(a-29))/interval
				}}}' >$file_push
		joinlog=`cat $tmpfile`
		[ "$joinlog"x == ""x ] && joinlog="join SUCC"
		logvar="$logvar \"$joinlog\""

		if [ $(id -u) != 0 ];then
			echo "==========================================================" >>$log
			echo $logvar >>$log
			zabbix_sender -z $zabbix_server -i $file_push &>>$log
			cp -f $file_end $file_start
		else
			echo "$logvar"
		fi
		#mv $file_start $file_start.$timedate
		#mv $file_end $file_end.$timedate

	} done <$nginxlist
	wait
	echo '{"data":[]}'

}

function AppList()
{
	applist=""
	while read item;do
		ip=`echo $item |cut -f2 -d','`
		tag=`echo $item |cut -f1 -d','`
		echo $ip | grep "10.120" &>/dev/null && proxy="-x http://10.135.28.97:8091" || proxy=""
		applist="$applist `curl -s $proxy "http://$ip$reqstat" |grep -v "^<" |awk -v t=$tag -F ',' '{print t","$1}'`"
	done <$nginxlist

	str=""
	for id in `echo $applist |tr ' ' '\n' |sort -u`;do
		cluster=`echo $id |cut -f1 -d','`
		appname=`echo $id |cut -f2 -d','|awk -v cluster=$cluster '{result=gensub("^"cluster"-","","g",$0); app=gensub("-([1-9][0-9]+)$", ".\\\\1", "g", result); print app}'`
		[ "$appname"x == ""x ] && appname=UNDEFINED
		tag=`echo $id |cut -f1 -d','`
		str="$str{\"{#APP_NAME}\":\"$appname\",\"{#TAG}\":\"$tag\"},"
	done
	echo -n "{\"data\":[$str]}" |sed 's/\},\]\}/\}\]\}/g'
}

function NginxList()
{
	str=`awk -F ',' '{print "{\"{#TAG}\":\""$1"\",\"{#REQSTAT_IP}\":\""$2"\"},"}' $nginxlist |sort -u |sed '/^$/d' |tr -d '\n'`
	echo -n "{\"data\":[$str]}" |sed 's/,\]/\]/g'
}

case $1 in
	applist) AppList;;
	getstat) getData;;
	nginxlist) NginxList;;
	null) echo '{"data":[]}';;
	*) exit 1;;
esac
