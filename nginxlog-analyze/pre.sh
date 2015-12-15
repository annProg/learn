#!/bin/bash

############################
# Usage:
# File Name: pre.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-29 01:04:46
############################

function gethelp()
{
	echo "./pre.sh (app|code) logfile [more3sfile]" 
}
[ $# -lt 2 ] && gethelp && exit 1

func=$1
logfile=$2

function getAppLog()
{
	applogdir=applog
	[ ! -d $applogdir ] && mkdir $applogdir
	
	more3s=$1

	for id in `awk '{print $2}' $more3s |sed 's/\[.*\]//g'`;do
	{
		newlog=$applogdir/`echo $id |sed 's#/iptv/##g' |tr -s '/' '-'`".app.log"
		cat $logfile |gunzip | grep "$id" >$newlog
		echo "$id done"; sleep 2
	}
	done
	wait
}

function getHttpCode()
{
	codelogdir=codelog
	[ ! -d $codelogdir ] && mkdir $codelogdir
	
	for code in {400,404,499,500,502,504};do
	{
		echo $codelogdir/code_$code.log
		grep "\]  $code" $logfile >$codelogdir/code_$code.log;sleep 2
	}
	done
	wait
}

function errCodeAppRank()
{
	cut -f2 -d'"' $logfile |awk '{print $2}' |sed 's/\?.*//g' |sort |uniq -c |sort -nr >$logfile.apprank.txt
}

case $func in
	app) [ $# -lt 3 ] && echo "need arg3: more3sfile" && exit 1;getAppLog "$3";;
	code) getHttpCode;;
	rank) errCodeAppRank;;
	*) echo "nothing to do";;
esac
