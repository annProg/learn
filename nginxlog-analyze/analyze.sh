#!/bin/bash

############################
# Usage:
# File Name: analyze.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-27 10:46:46
############################

function gethelp()
{
	echo -e "./analyze.sh func logfile datadir\n
	func   \tgetcode,200,err,response,plot
	logfile\tthe path of log you want to analyze
	datadir\tdirectory of analyze data
		"
}
[ $# -lt 3 ] && gethelp && exit 1
func=$1
logfile=$2
datadir=$3
datadir=`echo $datadir |sed 's#/$##g'`

logdate=`tail -n 1000 $logfile |awk '{print $2}' |awk -F 'T' '{print $1}' | tr -d '[' |sort |uniq -c |sort -nr |awk '{print $2}' |head -1`
plottpl="plot.tpl"
datetime=`date +%m%d%H%M%S`
pltdir="$datadir/plt"

[ ! -d $datadir ] && mkdir $datadir
[ ! -d $pltdir ] && mkdir $pltdir

for id in {all,code,time,200,400,404,499,500,502,504};do
	eval file_$id="$datadir/$id.txt"
done

function getStatusCode()
{
	exist $file_code && awk '{print $3}' $logfile | sort |uniq -c |sort -nr > $file_code
}

function exist()
{
	if [ ! -f $1 ];then
		return 0
	else
		echo "$1 exist..."
		return 1
	fi
}

function timeSeries_200()
{
	exist $file_all && awk '{print $2}' $logfile |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > $file_all
	exist $file_200 && grep "\]  200 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > $file_200
}

function timeSeries_error()
{
	for code in {400,404,499,500,502,504};do
		eval filevar=\$file_$code
		exist $filevar && grep "\]  $code " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > $filevar
	done
}

function updateplt()
{
	[ -f $file_code ] && totalrequest=`awk '{sum+=$1}END{print sum}' $file_code` || totalrequest="unkown"
	tag=`echo $datadir | awk -F '/' '{print $NF}'`
	file=$datadir/$tag-timeSeries-$1
	plt=$file.plt
	img=$file.png
	imgtitle="timeSeries-$1 ( $logdate )\\\n$tag - total request $totalrequest"
	
	cp $plottpl $plt
	
	sed -i "s#OUTPUTPATH#$img#g" $plt
	sed -i "s#IMGTITLE#$imgtitle#g" $plt
	echo $plt |grep "time.plt" &>/dev/null && sed -i "s#count#response time (s)#g" $plt
}

function plot()
{
	updateplt $1
	echo -n "plot " >> $plt
	for id in `echo $1 | tr -s ',' ' '`;do
		eval datafile=\$file_$id
		echo -n "\"$datafile\" using 1:2 title \"$id\"," >>$plt
	done
	
	sed -i 's/,$//g' $plt
	gnuplot $plt &>/dev/null && r=0 || r=1
	if [ $r -eq 0 ];then
		echo "$plt plot SUC!"
	elif [ $r -eq 1 ];then
		echo $plt |grep "time.plt" &>/dev/null && r=0 || r=1
		
		if [ $r -eq 0 ];then
			cp $plt $plt.bak
			for k in {2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};do
				sed -i "s/using/every $k using/g" $plt
				sed -i -E "s/(total request.*)/interval every $k - \1/g" $plt
				gnuplot $plt &>/dev/null && echo "$plt plot SUC! (with $k)" && rm -f $plt.bak && break || cp -f $plt.bak $plt
			done
		fi
		
	else
		echo "$plt plot FAILED!"
	fi
	
	mv $plt $pltdir
}

function responseTime()
{
	exist $file_time && cut -f1,10 -d'"' $logfile |awk -F '[T|+|"]' '{print $2,$4}' >$file_time
}

case $func in
	getcode) getStatusCode;;
	200) timeSeries_200;;
	err) timeSeries_error;;
	response) responseTime;;
	plot) [ $# -lt 4 ] && echo "arg4 needed (all|time|code|200|404|499|500|502|504)" && exit 1; plot $4;;
	*) echo "nothing to do";;
esac
