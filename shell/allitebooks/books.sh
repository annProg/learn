#!/bin/bash

[ $# -lt 2 ] && echo "$0 startpage endpage" && exit 1
LOG=books.log
URI="http://www.allitebooks.org/page"
START=$1
END=$2

[ ! -d pages ] && mkdir pages
[ ! -d tmp ] && mkdir tmp
echo > $LOG

function _info() {
	echo -e "\033[32m[INFO] $1\033[0m"
}

function _warn() {
	echo -e "\033[31m[ERRO] $1\033[0m"
}

function errorhandle() {
	if [ "$1"x != "200"x ];then
	 	msg="$2"
		echo "$msg" >> $LOG
		_warn "$msg"
	else
		_info "$3"
	fi
}

for page in `seq $START $END`;do
	filename=$page
	[ $page -lt 1000 ] && filename="0$page"
	[ $page -lt 100 ] && filename="00$page"
	[ $page -lt 10 ] && filename="000$page"

	result=`curl -L -s --connect-timeout 5 "$URI/$page/" -o tmp/$page.html -w "%{http_code}"`
	errorhandle "$result" "page $page failed. httpcode: $result" "page $page succ"

	echo > pages/$filename.txt
	for book in `grep bookmark tmp/$page.html |grep -v entry |awk -F'"' '{print $2}'`;do
		TITLE=`echo $book |awk -F'/' '{print $4}'`
		bookname="tmp/$TITLE.html"
		result=`curl -s --connect-timeout 5 "$book" -o $bookname -w "%{http_code}"`
		errorhandle "$result" "book $book on page $page failed. httpcode: $result" "book $book  on page $page succ"
		CATEGORY=`grep "Category:" $bookname | awk '{print $3}' |awk -F'/' '{print $4}'`
		YEAR=`grep "Year:" $bookname | awk '{print $2}' |awk -F'<' '{print $1}'`
		FORMAT=`grep "File format:" $bookname |awk '{print $3}' |awk -F'<' '{print $1}' |awk -F',' '{print $1}' |tr '[A-Z]' '[a-z]'`
		PDF=`grep -i "Download $FORMAT" $bookname | awk -F'"' '{print $2}' |sed 's/ /%20/g'`

		if [ "$CATEGORY"x == ""x ];then
			CATEGORY="unknown"
		fi

		if [ "$PDF"x != ""x ];then
			echo -e "$PDF \n  dir=$CATEGORY/$YEAR\n  out=$TITLE.$FORMAT" >> pages/$filename.txt
		else
			errorhandle "404" "book $book on page $page no download link. ignore" "succ"
		fi
	done
done


