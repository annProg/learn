#!/bin/bash
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: xml2csv.sh  me@annhe.net  2015-10-21 11:15:00 $
#-----------------------------------------------------------
 
[ $# -lt 1 ] && echo "args error" && exit 1

inputDir=$1
outputDir="object_xml_cmdb"
tmpfile=csv.file.tmp

[ ! -d $outputDir ] && mkdir $outputDir
function run()
{
	objectGroup=$id
	echo "<group name=\"$objectGroup\">"
	for csv in `ls $inputDir/$objectGroup |grep ".csv"`;do
		objectName=`echo $csv |cut -f1 -d'.'`
	echo -e "\t<object-type name=\"$objectName\">"
		cat $inputDir/$objectGroup/$csv |iconv -f gbk -t utf-8 |sed '1d' > $tmpfile
		# 排序之后会导致xml中的fields顺序和csv不一致，前端按照xml展示时顺序不符合常规认知
		# 又: 实测同一fieldgroup中的field可以不写在一起，及可以有多个同名的fieldgroup段
		# 因此 取消排序
		#cat $inputDir/$objectGroup/$csv |iconv -f gbk -t utf-8 |sed '1d' |sort -k6 -t',' > $tmpfile
		fieldGroup=`cat $tmpfile | cut -f6 -d',' |head -n 1`
		echo -e "\t\t<fields>"
		echo -e "\t\t\t<fieldgroup name=\"$fieldGroup\">"
		while read line;do
			newFieldGroup=`echo $line | cut -f6 -d','`
			if [ $newFieldGroup != $fieldGroup ];then
				fieldGroup=$newFieldGroup
				echo -e "\t\t\t</fieldgroup>"
				echo -e "\t\t\t<fieldgroup name=\"$fieldGroup\">"
			fi
			name=`echo $line | cut -f1 -d','`
			label=`echo $line | cut -f2 -d','`
			ftype=`echo $line | cut -f3 -d','`
			funiq=`echo $line | cut -f4 -d',' |tr -s '[A-Z]' '[a-z]'`
			summaryfield=`echo $line | cut -f5 -d',' | tr -s '[A-Z]' '[a-z]'`
			echo -e "\t\t\t\t<field name=\"$name\" label=\"$label\" type=\"$ftype\" uniq=\"$funiq\" summaryfield=\"$summaryfield\" />"
			
		done <$tmpfile
		echo -e "\t\t\t</fieldgroup>"
		echo -e "\t\t</fields>"
		echo -e "\t</object-type>"
	done
	echo "</group>"
}

for id in `ls $inputDir`;do
	run > $outputDir/$id.xml
done


rm -f $tmpfile
