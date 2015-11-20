#!/bin/bash

############################
# Usage:
# File Name: ab.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-19 11:53:52
############################

[ $# -lt 1 ] && echo "args error" && exit 1
url=$1
logname=`echo $url |awk -F '/' '{print $NF}'`
[ "$logname"x == ""x ] && logname=`echo $url |awk -F '/' '{print $3}'`
[ ! -d $logname ] && mkdir $logname
n=5000

begin=`date +%m%d-%H:%M:%S`

#for c in {100,200,300,500,1000};do
for c in {1,10,50,100,200,300,500,1000};do
	tmplog="$logname/raw-ab-$logname-c$c-n$n.log"
	gpllog="$logname/gnuplot-ab-$logname-c$c-n$n.log"
	log="$logname/ab-$logname-c$c-n$n.log"

	echo > $tmplog
	startTime=`date +%m%d-%H:%M:%S`
	ab -k -c $c -n $n -g $gpllog "$url" > $tmplog
	endTime=`date +%m%d-%H:%M:%S`

	serversoft=`grep "Server Software" $tmplog |awk '{print $NF}'`
	hostname=`grep "Server Hostname" $tmplog |awk '{print $NF}'`
	path=`grep "Document Path" $tmplog |awk '{print $NF}'`
	request="http://"$hostname$path
	completeRequest=`grep "Complete requests" $tmplog |awk '{print $NF}'`
	failedRequest=`grep "Failed requests" $tmplog |awk '{print $NF}'`
	tpr=`grep "Time per request" $tmplog |grep -v "concurrent" |awk '{print $4}'`
	qps=`grep "Requests per second" $tmplog |awk '{print $4}'`
	less1s=`cat $gpllog | awk '{if($9<1000) sum++}END{print sum-1}'`
	echo "start end concurrency requests completeRequest failedRequest qps tpr less1s" >$log
	echo "$startTime $endTime $c $n $completeRequest $failedRequest $qps $tpr $less1s" >>$log
done

finish=`date +%m%d-%H:%M:%S`

function meanAnalyze()
{
	file="$logname/non2xx"
	cat $logname/ab-* |grep -v "concurrency" |sort -k3 -n >$file.dat
cat > $file.plt <<EOF
	set term png size 1366 768
	set output "$file.png"
	set title "total requests $n ($begin - $finish)"
	set grid
	set xlabel "concurrency"
	set ylabel "failed requests"
	plot "$file.dat" using 3:6 with linespoints pointtype 7 pointsize 2 title "non2xx", \
		"$file.dat" using 3:7 with linespoints pointtype 7 pointsize 2 title "qps(/s)", \
		"$file.dat" using 3:9 with linespoints pointtype 7 pointsize 2 title "less than 1s", \
		"$file.dat" using 3:8 with linespoints pointtype 7 pointsize 2 title "time per request(ms)"
EOF
	gnuplot $file.plt
}

function response()
{
	file="$logname/response"
}

meanAnalyze
