#!/bin/bash

############################
# Usage:
# File Name: ab.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-19 11:53:52
############################

[ $# -lt 3 ] && echo -e "Usage:\n\t./ab.sh url requests-number comment" && exit 1
url=$1
option=$4
n=$2
comment=$3

logname=`echo $url |awk -F '/' '{print $NF}'`
[ "$logname"x == ""x ] && logname=`echo $url |awk -F '/' '{print $3}'`
logname=$logname"_"$comment
[ ! -d $logname ] && mkdir $logname

begin=`date +%m%d-%H:%M:%S`

#for c in {100,300};do
for c in {1,10,50,100,200,300,500,1000};do
	tmplog="$logname/raw-ab-$logname-c$c-n$n.log"
	gpllog="$logname/gnuplot-ab-$logname-c$c-n$n.log"
	log="$logname/ab-$logname-c$c-n$n.log"

	echo > $tmplog
	startTime=`date +%M:%S`
	ab $option -c $c -n $n -g $gpllog "$url" > $tmplog
	endTime=`date +%M:%S`

	serversoft=`grep "Server Software" $tmplog |awk '{print $NF}'`
	hostname=`grep "Server Hostname" $tmplog |awk '{print $NF}'`
	path=`grep "Document Path" $tmplog |awk '{print $NF}'`
	request="http://"$hostname$path
	completeRequest=`grep "Complete requests" $tmplog |awk '{print $NF}'`
	failedRequest=`grep "Non-2xx responses" $tmplog |awk '{print $NF}'`
	[ "$failedRequest"x == ""x ] && failedRequest=0
	tpr=`grep "Time per request" $tmplog |grep -v "concurrent" |awk '{print $4}'`
	qps=`grep "Requests per second" $tmplog |awk '{print $4}'`
	less1s=`cat $gpllog | awk '{if($9<1000) sum++}END{print sum-1}'`
	less500ms=`cat $gpllog | awk '{if($9<500) sum++}END{print sum-1}'`
	less100ms=`cat $gpllog | awk '{if($9<100) sum++}END{print sum-1}'`
	echo "start end concurrency requests completeRequest failedRequest qps tpr less1s less500ms less100ms" >$log
	echo "$startTime $endTime $c $n $completeRequest $failedRequest $qps $tpr $less1s $less500ms $less100ms" >>$log
done

finish=`date +%m%d-%H:%M:%S`

function overview()
{
	file="$logname/overview"
	cat $logname/ab-* |grep -v "concurrency" |sort -k3 -n >$file.dat
	#comment=`awk '{print $1"-"$2":"$3}'`
cat > $file.plt <<EOF
	set term png size 1300,700
	set output "$file.png"
	set title "total requests $n ($begin - $finish)\n\n$comment"
	set grid
	set xlabel "concurrency"
	set ylabel "requests count"
	plot "$file.dat" using 3:(\$6*100) with linespoints pointtype 7 pointsize 2 title "non2xx*100", \
		"$file.dat" using 3:(\$7*10) with linespoints pointtype 7 pointsize 2 title "qps*10(/s)", \
		"$file.dat" using 3:9 with linespoints pointtype 7 pointsize 2 title "less than 1s", \
		"$file.dat" using 3:10 with linespoints pointtype 7 pointsize 2 title "less than 500ms", \
		"$file.dat" using 3:11 with linespoints pointtype 7 pointsize 2 title "less than 100ms", \
		"$file.dat" using 3:8 with linespoints pointtype 7 pointsize 2 title "time per request(ms)"
EOF
	gnuplot $file.plt
}

function timeSeries()
{
	datadir="$logname/timeSeries"
	[ ! -d "$datadir" ] && mkdir "$datadir"
	for id in `ls $logname/gnuplot-*`;do
		title=`echo $id |cut -f2 -d'/' |sed 's/\.log//g'`
		file=$datadir"/"$title
		cat >$file.plt <<EOF
		set term png size 500,500
		set size 1,1
		set output "$file.png"
		set title "timeSeries of $title"
		set grid
		set xdata time
		set timefmt "%s"
		set format x "%S"
		set xlabel 'seconds'
		set ylabel "response time (ms)"
		set datafile separator '\\t'
		plot "$id" every ::2 using 2:5 title 'response time' with points
EOF
		gnuplot $file.plt
	done
}

function throughput()
{
	datadir="$logname/throughput"
	[ ! -d $datadir ] && mkdir "$datadir"
	for id in `ls $logname/gnuplot-*`;do
		title=`echo $id |cut -f2 -d'/' |sed 's/\.log//g'`
		file=$datadir"/"$title
		awk '{print $6}' $id |grep -v wait |sort |uniq -c|awk '{print $2,$1}' >$file.dat
	done
	
	plt="$datadir/throughput.plt"

	cat >$plt <<EOF
	set term png size 1300,700
	set output "$datadir/throughput.png"
	set title "$logname ($begin - $finish)\n\n$comment"
	set grid
	set key invert reverse Left outside
	set xdata time
	set timefmt "%s"
	set format x "%S"
	set xlabel "seconds"
	set ylabel "responses per second"
EOF
	echo -n "plot " >>$plt
	for id in `ls $datadir/gnuplot-*`;do
		concurrency=`echo $id | awk -F '-' '{print $(NF-1)}'`
		echo "\"$id\" using 1:2 title \"concurrency $concurrency\" with linespoints pointtype 7 pointsize 2, \\" >> $plt
	done
	
	sed -i '$s/,.*//' $plt
	gnuplot $plt
}

overview
timeSeries
throughput
