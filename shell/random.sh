#!/bin/bash

#-----------------------------------------------------------
# Usage: 随机数
# $Id: random.sh  i@annhe.net  2015-07-27 02:21:14 $
#-----------------------------------------------------------

function TimestampRand()
{
	range=$1
	timestamp=`date +%s%N`
	let res=$timestamp%$range
	echo $res
}

function RandomRand()
{
	range=$1
	let res=$RANDOM%$range
	echo $res
}

function UrandomRand()
{
	range=$1
	rand=`head -200 /dev/urandom | cksum | cut -f1 -d" "`
	let res=$rand%$range
	echo $res
}

function UuidRand()
{
	range=$1
	rand=`cat /proc/sys/kernel/random/uuid| cksum | cut -f1 -d" "`
	let res=$rand%$range
	echo $res
}
echo "时间戳: `TimestampRand 10`"
echo "\$RANDOM: `RandomRand 10`"
echo "urandom: `UrandomRand 10`"
echo "uuid: `UuidRand 10`"

str=""
for i in `seq 1 6`;do
	str="$str`RandomRand 9`"
done

echo $str
echo "翻转:"
echo $str | rev

echo $str | awk '{for(i=1;i<=length;i++){line=substr($0,i,1)line}}END{print line}'
