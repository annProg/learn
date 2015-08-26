#!/bin/bash

#-----------------------------------------------------------
# Usage: 多文件ul统计
# $Id: count_url_sogou.sh  i@annhe.net  2015-08-27 02:40:30 $
#-----------------------------------------------------------
argc=$#
[ $argc -lt 1 ] && exit 1

argv=()
for ((i=0;i<$argc;i++));do
	argv[$i]=$1
	shift
done


echo > tmp
for ((i=0;i<$argc;i++));do
	filename=${argv[$i]}
	[ ! -f $filename ] && exit 1
	cat $filename | sed '/^$/d' | awk '{print $1" ""'$filename'"}' >> tmp
done

cat tmp |awk '{print $1}' |sort |uniq |sed '/^$/d'> tmp2 
for url in `cat tmp2`;do
	location=`grep -w $url tmp |awk '{print $2}'`
	location=`echo $location | tr -s ' ' ','`
	cat ${argv[*]} | grep -w $url |awk '{sum+=$2}END{print $1" "sum" ""'$location'"}'
done


rm -f tmp tmp2
