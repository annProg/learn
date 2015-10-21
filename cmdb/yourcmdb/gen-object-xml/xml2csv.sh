#!/bin/bash
# -*- coding:utf-8 -*-
 
#-----------------------------------------------------------
# Usage: 
# $Id: xml2csv.sh  me@annhe.net  2015-10-21 11:15:00 $
#-----------------------------------------------------------
 
[ $# -lt 1 ] && echo "args error" && exit 1

inputDir=$1
outputDir="cmdb_object_csv"

function run()
{
	groupNameAll=`grep "<group name" $xmlFile | cut -f2 -d'"'`
	groupName=`grep "<group name" $xmlFile |head -n 1 | cut -f2 -d'"'`
	objectName=`grep "<object-type name" $xmlFile | head -n 1 |cut -f2 -d'"'`
	fieldGroup=`grep "<fieldgroup name" $xmlFile | head -n 1 |cut -f2 -d'"'`

	for id in $groupNameAll;do
		rm -fr $outputDir/$id
	done
	tmpfile="tmp.file"

	while read line;do
		newGroupName=`echo $line |grep "<group name" | cut -f2 -d'"'`
		newObjectName=`echo $line |grep "<object-type name" | cut -f2 -d'"'`
		newFieldGroup=`echo $line |grep "<fieldgroup name" | cut -f2 -d'"'`

		[ "$newGroupName"x != ""x ] && groupName=$newGroupName
		[ "$newObjectName"x != ""x ] && objectName=$newObjectName
		[ "$newFieldGroup"x != ""x ] && fieldGroup=$newFieldGroup

		objectFile="$outputDir/$groupName/$objectName".csv
		objectDir="$outputDir/$groupName"

		[ ! -d $objectDir ] && mkdir -p $objectDir
		[ ! -f $objectFile ] && echo "name,label,type,uniq,summaryfield,fieldgroup" > $objectFile

		field=`echo $line |grep "<field name"`
		if [ "$field"x != ""x ]; then
			echo >$tmpfile
			for id in `echo $field`;do
				echo $id >> $tmpfile
			done
			name=`grep "name=" $tmpfile |cut -f2 -d'"'`
			label=`grep "label=" $tmpfile |cut -f2 -d'"'`
			ftype=`grep "type=" $tmpfile |cut -f2 -d'"'`
			funiq=`grep "uniq=" $tmpfile |cut -f2 -d'"'`
			summaryfield=`grep "summaryfield=" $tmpfile |cut -f2 -d'"'`

			echo "$name,$label,$ftype,$funiq,$summaryfield,$fieldGroup" >> $objectFile
		fi
	done <$xmlFile
}

for xmlFile in `find $inputDir -name "*.xml"`;do
	run
done

for id in `find $outputDir -name "*.csv"`;do
	enca $id |grep "UTF-8" && iconv -f utf-8 -t gbk $id >$id.gbk
	mv -f $id.gbk $id
	#enca $id |grep "UTF-8" && enconv -x gbk $id
done

rm -f $tmpfile
