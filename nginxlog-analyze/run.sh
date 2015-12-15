#!/bin/bash

############################
# Usage:
# File Name: run.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-11-29 01:04:46
############################

function gethelp()
{
	echo "./run.sh (app|code)" 
}
[ $# -lt 1 ] && gethelp && exit 1

func=$1
applogdir=applog
codelogdir=codelog
applogbak=applog_bak

[ ! -d $applogbak ] && mkdir $applogbak

function runAppAnalyze()
{
	[ ! -d $applogdir ] && echo "applogdir not exist...exit" && exit 1
	
	for id in `find $applogdir -name "*.app.log"`;do
	{
		datadir="data/"`echo $id |awk -F '/' '{print $NF}'`
		echo $datadir
		[ ! -d $datadir ] && mkdir -p $datadir
		
		./analyze.sh getcode $id $datadir
		./analyze.sh 200 $id $datadir
		./analyze.sh err $id $datadir
		./analyze.sh response $id $datadir
		./analyze.sh plot $id $datadir all,200
		./analyze.sh plot $id $datadir 500,502,504
		./analyze.sh plot $id $datadir 400,404,499,500,502,504
		./analyze.sh plot $id $datadir 500
		./analyze.sh plot $id $datadir 502
		./analyze.sh plot $id $datadir 504
		./analyze.sh plot $id $datadir 499
		./analyze.sh plot $id $datadir 404
		./analyze.sh plot $id $datadir 400,404,499
		./analyze.sh plot $id $datadir time
		
		mv $id $applogbak
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

case $func in
	app) runAppAnalyze;;
	*) echo "nothing to do";;
esac
