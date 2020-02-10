#!/bin/bash

# 处理下载失败的项目
# errorCode=3   404
# errorCode=22  403 或 500
# 403一般是文件链接未包含文件（只有目录），因此可以筛选出 errorCode=22 并且后缀未 epub|pdf的项目重新下载

LOG=download/download.log

[ "$1"x != ""x ] && LOG=$1

ERR=pages/error.txt
echo >$ERR

for uri in `grep "errorCode=22" $LOG |grep URI |awk -F'=' '{print $NF}' |grep -vE "\/$"`;do
	grep -A2 -h "$uri" finished/*.txt >> $ERR
done