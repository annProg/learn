#!/bin/bash

#-----------------------------------------------------------
# Usage: 
# $Id: pts-kill.sh  i@annhe.net  2015-08-07 19:29:34 $
#-----------------------------------------------------------

me=`who am i |awk '{print $2}'`

for id in `w |grep "pts/" |grep -v "$me" |awk '{print $2}'`;do
	pkill -kill -t $id
	echo "kill -- $id"
done
