#!/bin/bash
file="信息科学与工程学院.txt"
sed -i "/^$/d" del.dat
while read id 
do
	search=`echo $id |awk '{print $1}'`
	replace=`echo $id |awk '{print $2}'`
	sed -i "s/.*$search.*/$replace/g" $file
done<del.dat

