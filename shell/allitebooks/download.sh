#!/bin/bash

[ ! -d download ] && mkdir download

cd download
cat ../pages/*.txt | \
	aria2c.exe --conditional-get=true \
	--auto-file-renaming=false \
	-c \
	--log-level=notice \
	--log=download.log \
	-i -