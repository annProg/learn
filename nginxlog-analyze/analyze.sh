#!/bin/bash

############################
# Usage:
# File Name: status_code.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-27 10:46:46
############################

[ $# -lt 2 ] && echo "./status_code.sh func logfile" && exit 1
func=$1
logfile=$2
logdate=`head -1 $logfile |awk '{print $2}' |awk -F 'T' '{print $1}' | tr -d '[' |sort |uniq -c |sort -nr |awk '{print $2}' |head -1`
plottpl="plot.tpl"
pltdir="plt"

[ ! -d $pltdir ] && mkdir $pltdir

function getStatusCode()
{
	awk '{print $3}' $logfile | sort |uniq -c |sort -nr > status_code.txt
}

function timeSeries_200()
{
	awk '{print $2}' $logfile |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > all.txt
	grep "\]  200 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > 200.txt
}

function timeSeries_error()
{
	grep "\]  400 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > 400.txt
	grep "\]  404 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > 404.txt
	grep "\]  504 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > 504.txt
	grep "\]  502 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > 502.txt
	grep "\]  500 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > 500.txt
	grep "\]  499 " $logfile | awk '{print $2}' |sort |uniq -c |awk '{print $2,$1}' |sed -r 's/\[.*?T|\+.*?\]//g' > 499.txt
}

function updateplt()
{
	sed -i "s/OUTPUTPATH/$img/g" $plt
	sed -i "s/IMGTITLE/$imgtitle/g" $plt
}

function plot()
{
	# 200 and all
	file=timeSeries-200
	plt=$file.plt
	img=$file.png
	imgtitle="timeSeries-200 ( $logdate )"
	
	cp $plottpl $plt
	updateplt
	
	cat >> $plt <<EOF
	plot "all.txt" using 1:2 title "all", \
	     "200.txt" using 1:2 title "200"
EOF
	gnuplot $plt

	# single code
	for code in {400,404,504,502,499,500};do
		file=timeSeries-$code
		plt=$file.plt
		img=$file.png
		imgtitle="timeSeries-$code ( $logdate )"
		cp $plottpl $plt
		updateplt
		
		cat >> $plt <<EOF
		plot "$code.txt" using 1:2 title "$code"
EOF
		gnuplot $plt
	done
	
	# all error code
	file=timeSeries-error
	plt=$file.plt
	img=$file.png
	imgtitle="timeSeries-error ( $logdate )"
	cp $plottpl $plt
	updateplt
	
	cat >> $plt <<EOF
	plot "400.txt" using 1:2 title "400", \
	     "404.txt" using 1:2 title "404", \
		 "504.txt" using 1:2 title "504", \
		 "502.txt" using 1:2 title "502", \
		 "499.txt" using 1:2 title "499", \
		 "500.txt" using 1:2 title "500"
EOF
	gnuplot $plt
	
	
	# error code without 499
	file=timeSeries-err-without499
	plt=$file.plt
	img=$file.png
	imgtitle="timeSeries-err-without499 ( $logdate )"
	cp $plottpl $plt
	updateplt
	
	cat >> $plt <<EOF
	plot "400.txt" using 1:2 title "400", \
	     "404.txt" using 1:2 title "404", \
		 "504.txt" using 1:2 title "504", \
		 "502.txt" using 1:2 title "502", \
		 "500.txt" using 1:2 title "500"

EOF
	gnuplot $plt
	
	# responseTime
	file=timeSeries-responseTime
	plt=$file.plt
	img=$file.png
	imgtitle="timeSeries-responseTime ( $logdate )"
	cp $plottpl $plt
	updateplt
	
	cat >> $plt <<EOF
	plot "responseTime.txt" using 1:2 title "response time"
EOF
	gnuplot $plt
	
	mv *.plt $pltdir
	
}

function responseTime()
{
	cut -f1,10 -d'"' $logfile |awk -F '[T|\+|"]' '{print $2,$4}' >responseTime.txt
}

case $func in
	getcode) getStatusCode;;
	200) timeSeries_200;;
	err) timeSeries_error;;
	response) responseTime;;
	plot) plot;;
	*) echo "nothing to do";;
esac
