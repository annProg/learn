#!/bin/bash

############################
# Usage:
# File Name: ssh.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2018-06-05 12:46:14
############################

[ $# -lt 2 ] && echo "$0 iplistfile func" && exit 1
PASS="passwordstring"
SSH="ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no"

thread=20	#设置线程数，在这里所谓的线程，其实就是几乎同时放入后台（使用&）执行的进程。
tmp_fifofile=/tmp/$$.fifo		#脚本运行的当前进程ID号作为文件名
mkfifo $tmp_fifofile			#新建一个随机fifo管道文件
exec 6<>$tmp_fifofile			#定义文件描述符6指向这个fifo管道文件
rm $tmp_fifofile			#清空管道内容

function parallel() {
	# for循环 往 fifo管道文件中写入$thread个空行
	for ((i=0;i<$thread;i++));do
		echo 
	done >&6
	 
	# 从ip.txt中读取ip
	while read id;do
		read -u6		#从文件描述符6中读取行（实际指向fifo管道)
		{
			$2 $id          # 执行的功能		
			echo >&6	#再次往fifo管道文件中写入一个空行
		} &
	# {} 这部分语句被放入后台作为一个子进程执行，所以不必每次等待3秒后执行
	#下一个,这部分的func几乎是同时完成的，当fifo中thread个空行读完后 while循环
	# 继续等待 read 中读取fifo数据，当后台的thread个子进程等待3秒后，按次序
	# 排队往fifo输入空行，这样fifo中又有了数据，while循环继续执行
	 
	done < $1		#从ip.txt中读取数据
	 
	 
	wait			#等到后台的进程都执行完毕
	exec 6>&-		##删除文件描述符6
	return 0
}

function name() {
	[ "$1"x == ""x ] && echo "ip error" && exit
	n=`sshpass -p $PASS $SSH $1 'hostname' 2>/dev/null`
	[ $? -gt 0 ] && n="failed"
	echo "$1 $n"
}

