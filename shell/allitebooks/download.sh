#!/bin/bash

[ ! -d download ] && mkdir download

PROXY=""
if [ "$1"x != ""x ];then
	PROXY="--http-proxy=$1"
fi

[ ! -d finished ] && mkdir finished

cd download
for page in `ls ../pages/*.txt`;do
	echo "Downloading $page"
	aria2c.exe --conditional-get=true \
	--auto-file-renaming=false \
	--max-concurrent-downloads=20 \
	-c \
	$PROXY \
	--log-level=notice \
	--log=download.log \
	-i ../pages/$page

	mv ../pages/$page ../finished
	echo "Finish $page"
done