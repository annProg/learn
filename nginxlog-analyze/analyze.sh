#!/bin/bash

############################
# Usage:
# File Name: status_code.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-27 10:46:46
############################

[ $# -lt 3 ] && echo "./status_code.sh func logfile comment" && exit 1
func=$1
logfile=$2
datadir=$3

logdate=`head -1 $logfile |awk '{print $2}' |awk -F 'T' '{print $1}' | tr -d '[' |sort |uniq -c |sort -nr |awk '{print $2}' |head -1`
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
	awk '{print $3}' $logfile | sort |uniq -c |sort -nr > $file_code
}

function timeSeries_200()
{
	awk '{print $2}' $logfile |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > $file_all
	grep "\]  200 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > $file_200
}

function timeSeries_error()
{
	for code in {400,404,499,500,502,504};do
		eval grep "\]  400 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > \$file_$code
	done
}

function updateplt()
{
	file=$datadir/timeSeries-$1
	plt=$file.plt
	img=$file.png
	imgtitle="timeSeries-$1 ( $logdate )"
	
	cp $plottpl $plt
	
	sed -i "s#OUTPUTPATH#$img#g" $plt
	sed -i "s#IMGTITLE#$imgtitle#g" $plt
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
	gnuplot $plt
	
	mv *.plt $pltdir
}

function responseTime()
{
	cut -f1,10 -d'"' $logfile |awk -F '[T|+|"]' '{print $2,$4}' >$file_time
}

case $func in
	getcode) getStatusCode;;
	200) timeSeries_200;;
	err) timeSeries_error;;
	response) responseTime;;
	plot) [ $# -lt 4 ] && echo "arg4 needed (all|time|code|200|404|499|500|502|504)" && exit 1; plot $4;;
	*) echo "nothing to do";;
esac
