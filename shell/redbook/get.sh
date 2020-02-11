#!/bin/bash
[ $# -lt 3 ] && echo "$0 type(redp|sg24|gg24) start end" && exit 1

tp=$1
case $tp in
	redp) directory="redpapers";;
	*) directory="redbooks";;
esac

pdf="http://www.redbooks.ibm.com/$directory/pdfs/$tp"
lenovo_pdf="https://lenovopress.com/$tp"
redpieces="http://www.redbooks.ibm.com/redpieces/pdfs/$tp"
abstract="http://www.redbooks.ibm.com/abstracts/$tp"
lenovo_abstract="https://lenovopress.com/$tp"

start=$2
end=$3

for id in `seq $start $end`;do
	len=`echo ${#id}`
	case $len in
		1) id="000$id";;
		2) id="00$id";;
		3) id="0$id";;
		*) id="$id";;
	esac
	
	tmp_html=$tp$id.html
	
	pdflink=$pdf
	abstractlink=$abstract
	curl -L -s "$abstractlink$id.html" -o $tmp_html
	
	title=`sed -n '/ibm-navigation-trail/{n;p}' $tmp_html |awk -F '>|<' '{print $3}' |tr '/' '-'`
	page=`sed -n "/Number of pages/{n;p}" $tmp_html | cut -f2 -d'>'`

	publish=`grep "Publish Date" $tmp_html | awk -F '>|<' '{print $9}'`
	
	if [ "$publish"x == ""x ];then
		pdflink=$lenovo_pdf
		abstractlink=$lenovo_abstract
		curl -L -s "$abstractlink$id" -o $tmp_html
		
		publish=`sed -n "/First Published/{n;p}" $tmp_html`
		page=`sed -n "/PDF size/{n;p}" $tmp_html |awk '{print $1}'`
	fi
	
	year_publish=`echo $publish |awk '{print $NF}'`
	update=`sed -n "/Last Update/{n;p}" $tmp_html | awk '{print $NF}' |cut -f1 -d'<'`
	[ "$update"x == ""x ] && update="no update"
	grep "Other Language Versions" $tmp_html &>/dev/null && language="other language" || language="only english"
	rate=`grep "Rating" $tmp_html | awk -F '>|<' '{print $9}' |tr -d '()' |sed 's/based on //g'`
	[ "$rate"x == ""x ] && rate="no reviews"
	
	bookdir="$tp/$year_publish"
	[ ! -d $bookdir ] && mkdir -p $bookdir
	
	bookpath="$bookdir/$tp$id-[$year_publish][$update][$rate][$page][$language]-$title.pdf"
	
	rm -f $tmp_html
	echo -n "处理 $tp$id  --  $title ..."
	if [ "$title"x = "Our apologies"x ];then
		echo "  未找到!"
		continue
	else
		echo -n "  下载中..."
	fi
	http_code=`curl -L -s "$pdflink$id.pdf" -o "$bookpath" -w "%{http_code}"`
	[ "$http_code" == "404" ] && http_code=`curl -L -s "$redpieces$id.pdf" -o "$bookpath" -w "%{http_code}"`
	echo "   $http_code"
done