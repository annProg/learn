#!/bin/bash
FILE=$1
REPLACE="replace.dat"

thread=$2
if [ $# -lt 2 ]; then
	echo -e "args error! \n Usage: ./get.sh datafile thread key {show_num}"
	exit 1
fi

#判断届数
for id in 1071 1081 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014
do
	STU_SUM=`grep $id "$FILE" |wc -l`
	[ $id == 1071 ] && id=2003
	[ $id == 1072 ] && id=2004
	if [ $STU_SUM -gt 3000 ];then
		((YEAR=id+4))
		break
	else
		YEAR="Unkown"
		continue
	fi
done

echo $thread |grep -E "[0-9]" && r=0 || r=1
if [ $r -eq 0 ];then
	[ $thread -gt 10000 ] && echo thread too large! && exit 1
else
	echo -e "args error! \n Usage: ./get.sh datafile thread key {show_num}"
	exit 1
fi
if [ $# -eq 3 ];then
	if [ $3 -lt 500 ];then
		SHOW_NUM=$3
		KEY=""
	else
		KEY=$3
		SHOW_NUM=0
	fi
else
	KEY=$3
	SHOW_NUM=$4
	[ "$SHOW_NUM"x == ""x ] && SHOW_NUM=0
fi
OUT=$KEY.csv
[ "$KEY"x == ""x ] && OUT=all.csv

COMPANY=$KEY.txt
[ "$KEY"x == ""x ] && COMPANY=all.txt

PIC=$YEAR-$KEY
[ "$KEY"x == ""x ] && PIC=$YEAR-all


echo >$COMPANY
grep "$KEY" $FILE >$OUT

echo $KEY |grep -E "[0-9]" && ADD_KEY=`grep $KEY $FILE |awk -F "," '{print $4}' |sort |uniq -c |sort -n -r | awk 'NR==1{print $2}'`

TOTAL=`wc -l "$OUT" |awk '{print $1}'`

if [ $SHOW_NUM -gt 0 ];then
	TITLE="湖南大学 $KEY $ADD_KEY $YEAR 届 $TOTAL 名毕业生去向(取前 $SHOW_NUM 强)"
else
	TITLE="湖南大学 $KEY $ADD_KEY $YEAR 届 $TOTAL 名毕业生去向"
fi

FONTS="/usr/share/fonts/wqy-microhei/wqy-microhei.ttc"

echo "KEY=$KEY"
echo "SHOW_NUM=$SHOW_NUM"

function func()
{
	company=`echo $id | awk -F "," '{print $7}'`
	r_company=`echo $id | awk -F "," '{print $8}'`
		[ "$r_company"x != ""x -a "$r_company"x != "-"x ] && company=$r_company
	p_company=`echo $id | awk -F "," '{print $9}'`
		[ "$p_company"x != ""x -a "$p_company"x != "-"x ] && company=$p_company
	echo $company >>$COMPANY
	sleep 3
}

tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"
rm "$tmp_fifofile"

for ((i=0;i<$thread;i++));do
	echo 
done >&6

while read id;do
	read -u6
	{
		func
		echo >&6
	} &
done < $OUT


wait
exec 6>&-

wait

file=$COMPANY
#sed -i "/^$/d" $REPLACE
while read id 
do
	echo $id |grep -E "#|^$" && continue
	search=`echo $id |awk '{print $1}'`
	replace=`echo $id |awk '{print $2}'`
	if [ "$replace"x == ""x ];then
		sed -i "s/$search//g" $file
	else
		sed -i "s/.*$search.*/$replace/g" $file
	fi
done<$REPLACE

sed -i '/^$/d' $file
sed -i 's/\ //g' $file
sed -i "s/\(.*银行\).*行.*/\1/g" $file
sed -i "s/\(.*公司\).*公司/\1/g" $file
sed -i "s/\(.*公司\).*研究所/\1/g" $file
sed -i "s/\(.*银行\).*/\1/g" $file
sed -i "s/\(.*集团\).*/\1/g" $file
sed -i "s/\(.*局\).*/\1/g" $file
sed -i "s/\(.*大学\).*学院.*/\1/g" $file
sed -i "s/中国\(香港.*\).*/\1/g" $file
sed -i "s/.*香港\(香港.*\).*/\1/g" $file
sed -i "s/.*美国\(美国.*\).*/\1/g" $file
sed -i "s/.*英国\(英国.*\).*/\1/g" $file
sed -i "s/.*日本\(日本.*\).*/\1/g" $file
sed -i "s/.*澳大利亚\(澳大利亚.*\).*/\1/g" $file

cat $file |sort |uniq -c |sort -n -r >all.tmp
ALL_NUM=`wc -l all.tmp |awk '{print $1}'`
[ $SHOW_NUM -eq 0 ] && SHOW_NUM=$ALL_NUM
((SHOW_NUM=ALL_NUM-SHOW_NUM))
head -n -$SHOW_NUM all.tmp >tmp

echo >more
echo >single
function multiplot()
{
	while read id
	do
		num=`echo $id |awk '{print $1}'`
		if [ $num -gt 1 ];then
			echo $id >>more
		else
		echo $id >>single
	fi
done<tmp
}
#echo "`wc -l single|awk '{print $1}'` 仅一人单位" >>more
#sort -n -r more >tmp
#1pt约等于1.3px
SUM=`wc -l tmp |awk '{print $1}'`

FONTSIZE=12
PX=16
SPACE=2
WIDTH=`echo $PX $SPACE $SUM|awk '{print $1*$2*$3+$1*10}' `

HIGHT=1050
HIGHT_V=1280
[ $TOTAL -gt 4000 ] && HIGHT=2000
[ $TOTAL -lt 100 ] && HIGHT=900 && HIGTH_V=1000

echo $WIDTH

OFFSET=`echo $WIDTH |awk '{print 0.5-16*10/$WIDTH}'`
echo $OFFSET

MOST=`awk 'NR==1{print $1}' tmp`
((MOST=MOST/20))
[ $MOST -eq 0 ] && MOST=1
echo $MOST

gnuplot<<EOF
set term png size $WIDTH,$HIGHT font "$FONTS,$FONTSIZE px"
set output "./img/$PIC-h.png"
set style data histograms
set grid
set title "$TITLE" offset graph -$OFFSET
set style fill solid 2.00 border
set xtic rotate by 300
set ytics $MOST
plot "tmp" using 1:xtic(2)
EOF


gnuplot<<EOF
set term png size $WIDTH,$HIGHT_V font "$FONTS,$FONTSIZE px"
set output "./img/$PIC-v.png"
set boxwidth 2 absolute
set style data histograms
set grid
#set title "$TITLE" offset graph -$OFFSET
set style fill solid $MOST border -1
set xtic rotate by 90
set xtic offset 1,0
set ytic rotate by 90
set ytics $MOST
plot "tmp" using 1:xtic(2)
EOF

TITLE_OFFSET=160
((RESIZE_ORIGIN=$TITLE_OFFSET-20))
((R_WIDTH=$HIGHT_V-$RESIZE_ORIGIN))

convert -rotate 90 img/$PIC-v.png img/$PIC-v.png.tmp
convert -font $FONTS -pointsize 16 -draw "text $TITLE_OFFSET,26 '$TITLE'" img/$PIC-v.png.tmp img/$PIC-v.png && rm -f img/$PIC-v.png.tmp
convert -crop "$R_WIDTH x$WIDTH+$RESIZE_ORIGIN+0" img/$PIC-v.png img/$PIC-v.png.tmp && mv img/$PIC-v.png.tmp img/$PIC-v.png
