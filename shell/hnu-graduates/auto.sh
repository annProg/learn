#!/bin/bash
while read id
do
	key=`echo $id |awk '{print $2}'`
	bash -x ./get.sh 1000 "$key"
done<college.txt
