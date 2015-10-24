#!/bin/bash

############################
# Usage:
# File Name: send.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2015-10-24 20:06:06
############################

thread=$1	#设置线程数，在这里所谓的线程，其实就是几乎同时放入后台（使用&）执行的进程。
if [ "$1"x == ""x ]; then
	thread=1
fi
 
tmp_fifofile=/tmp/$$.fifo		#脚本运行的当前进程ID号作为文件名
mkfifo $tmp_fifofile			#新建一个随机fifo管道文件
exec 6<>$tmp_fifofile			#定义文件描述符6指向这个fifo管道文件
rm $tmp_fifofile			#清空管道内容
 
#定义一个函数做为线程（子进程），该函数功能是ping测试
function func()
{
	python2 ./mail.py
	sleep 5
}
 
# for循环 往 fifo管道文件中写入$thread个空行
for ((i=0;i<$thread;i++));do
	echo 
done >&6
 
for id in `seq 1 10`;do
	read -u6		#从文件描述符6中读取行（实际指向fifo管道)
	{
		func		
		echo >&6	#再次往fifo管道文件中写入一个空行
	} &
done
 
wait			#等到后台的进程都执行完毕
exec 6>&-		##删除文件描述符6
exit 0
