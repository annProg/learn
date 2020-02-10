#!/bin/bash

[ ! -d download ] && mkdir download

PROXY=""
if [ "$1"x != ""x ];then
	PROXY="--http-proxy=$1"
fi

cd download
cat ../pages/*.txt | \
	aria2c.exe --conditional-get=true \
	--auto-file-renaming=false \
	-c \
	$PROXY \
	--log-level=notice \
	--log=download.log \
	-i -

[ ! -d finished ] && mkdir finished
mv pages/*.txt finished