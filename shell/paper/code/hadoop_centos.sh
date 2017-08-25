#!/bin/bash

# Usage: Hadoop自动配置脚本
# History: 
#	20140425  annhe  基本功能

#Hadoop版本
HADOOP_VERSION=1.2.1
#Jdk版本，Oracle官方无直链下载，请自备rpm包并设定版本号
JDK_VESION=7u51
#Hadoop下载镜像，默认为北理(bit)
MIRRORS=mirror.bit.edu.cn
#操作系统版本
OS=`uname -a |awk '{print $13}'`

#软件包目录
SOFTDIR=soft
#用户主目录
HOMEDIR=/root

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

# 检查是否是Centos
cat /etc/issue|grep CentOS && r=0 || r=1
if [ $r -eq 1 ]; then
	echo "This script can only run on CentOS!"
	exit 1
fi

#同步时钟
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#yum install -y ntp
ntpdate -u pool.ntp.org &>/dev/null
echo -e "Time: `date` \n"
#开机自动同步时间
chkconfig --level 235 ntpdate on


#软件包
HADOOP_FILE=hadoop-$HADOOP_VERSION-1.$OS.rpm
if [ "$OS"x = "x86_64"x ]; then
	JDK_FILE=jdk-$JDK_VESION-linux-x64.rpm
else
	JDK_FILE=jdk-$JDK_VESION-linux-i586.rpm
fi


function Install ()
{
	#卸载已安装版本
	rpm -qa |grep hadoop
	rpm -e hadoop
	rpm -qa | grep jdk
	rpm -e jdk
	
	#恢复/etc/profile备份文件
	mv /etc/profile.bak /etc/profile

	#准备软件包
	cd $SOFTDIR
	if [ ! -f $HADOOP_FILE ]; then
		wget "http://$MIRRORS/apache/hadoop/common/stable1/$HADOOP_FILE" && r=0 || r=1
		[ $r -eq 1 ] && { echo "download error, please check your mirrors or check your network....exit"; exit 1; }
	fi
	[ ! -f $JDK_FILE ] && { echo "$JDK_FILE not found! Please download yourself....exit"; exit 1; }

	#开始安装
	rpm -ivh $JDK_FILE && r=0 || r=1
	if [ $r -eq 1 ]; then
		echo "$JDK_FILE install failed, please verify your rpm file....exit"
		exit 1
	fi
	rpm -ivh $HADOOP_FILE && r=0 || r=1
	if [ $r -eq 1 ]; then
		echo "$HADOOP_FILE install failed, please verify your rpm file....exit"
		exit 1
	fi
	
	#备份/etc/profile
	cp /etc/profile /etc/profile.bak
	
	#配置java环境变量
	cat >> /etc/profile <<eof
#set java enviroment
JAVA_HOME=/usr/java/default
CLASSPATH=.:\$JAVA_HOME/lib
PATH=\$JAVA_HOME/bin:\$PATH
export JAVA_HOME CLASSPATH PATH
eof

	bash /etc/profile
	
	#配置Hadoop脚本权限
	chmod u+x /usr/sbin/*.sh
	
	#重置HADOOP_CLIENT_OPTS值
	sed -i "s/export\ HADOOP_CLIENT_OPTS=\"-Xmx128m \$HADOOP_CLIENT_OPTS\"/export\ HADOOP_CLIENT_OPTS=\"-Xmx512m \$HADOOP_CLIENT_OPTS\"/g" /etc/hadoop/hadoop-env.sh
	
	#在/etc/hosts中添加主机名对应的ip地址
	grep "$HOSTNAME" /etc/hosts && r=0 || r=1
	[ $r -eq 1 ] && echo "127.0.0.1    $HOSTNAME" >>/etc/hosts
}

#配置ssh免密码登陆
function PassphraselessSSH ()
{
	#不重复生成私钥
	[ ! -f $HOMEDIR/.ssh/id_dsa ] && ssh-keygen -t dsa -P '' -f $HOMEDIR/.ssh/id_dsa
	cat $HOMEDIR/.ssh/authorized_keys |grep "`cat $HOMEDIR/.ssh/id_dsa.pub`" &>/dev/null && r=0 || r=1
	#没有公钥的时候才添加
	[ $r -eq 1 ] && cat $HOMEDIR/.ssh/id_dsa.pub >> $HOMEDIR/.ssh/authorized_keys
	chmod 644 $HOMEDIR/.ssh/authorized_keys
	#不检查公钥
	cat > $HOMEDIR/.ssh/config <<eof
StrictHostKeyChecking no
eof

}


Install 2>&1 | tee -a /tmp/hadoop_install.log
PassphraselessSSH 2>&1 | tee -a /tmp/hadoop_install.log

#修改HADOOP_CLIENT_OPTS后需要重启 
read -p "need reboot, reboot now? (y/n)" chioce
[ "$chioce"x = "y"x ] && shutdown -r now || echo -e "\033[31m[ERRO]: Please Reboot Before use \033[0m"


	