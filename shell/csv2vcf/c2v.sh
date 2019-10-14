#!/bin/bash
# 结合parallel，并行执行提升效率
# cat list.csv | parallel -j 100 ./c2v.sh | tee -a list.vcf

[ $# -lt 1 ] && echo "args error" && exit 1
id=$1 
 
FIRSTNAME=`echo $id | awk -F "," '{print $1}'`
LASTNAME=`echo $id | awk -F "," '{print $2}'`
CORP=`echo $id | awk -F "," '{print $8}'`
DEPART=`echo $id | awk -F "," '{print $9}'`
TITLE=`echo $id | awk -F "," '{print $6}'`
TEL=`echo $id | awk -F "," '{print $4}'`
EMAIL=`echo $id | awk -F "," '{print $5}'`
IMADDRESS=`echo $id | awk -F "," '{print $3}'`
 
cat <<EOF
BEGIN:VCARD
VERSION:2.1
N;LANGUAGE=zh-cn;CHARSET=utf8:$FIRSTNAME;$LASTNAME
FN;CHARSET=utf8:$FIRSTNAME$LASTNAME
ORG;CHARSET=utf8:$CORP;$DEPART
TITLE;CHARSET=utf8:$TITLE
TEL;CELL;VOICE:$TEL
X-MS-OL-DEFAULT-POSTAL-ADDRESS:0
EMAIL;PREF;INTERNET:$EMAIL
X-QQ:$IMADDRESS
END:VCARD

EOF
