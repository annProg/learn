#!/bin/bash

# Usage: Hadoop伪分布式配置
# History:
#	20140426  annhe  完成基本功能

# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

#同步时钟
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#yum install -y ntp
ntpdate -u pool.ntp.org &>/dev/null
echo -e "Time: `date` \n"

#默认为单网卡结构，多网卡的暂不考虑
IP=`ifconfig eth0 |grep "inet\ addr" |awk '{print $2}' |cut -d ":" -f2`


#伪分布式
function PseudoDistributed ()
{
	cd /etc/hadoop/
	#恢复备份
	mv core-site.xml.bak core-site.xml
	mv hdfs-site.xml.bak hdfs-site.xml
	mv mapred-site.xml.bak mapred-site.xml
	
	#备份
	mv core-site.xml core-site.xml.bak
	mv hdfs-site.xml hdfs-site.xml.bak
	mv mapred-site.xml mapred-site.xml.bak
	
	#使用下面的core-site.xml
	cat > core-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>fs.default.name</name>
		<value>hdfs://$IP:9000</value>
	</property>
</configuration>
eof

	#使用下面的hdfs-site.xml
	cat > hdfs-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>dfs.replication</name>
		<value>1</value>
	</property>
</configuration>	
eof
	
	#使用下面的mapred-site.xml
	cat > mapred-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>mapred.job.tracker</name>
		<value>$IP:9001</value>
	</property>
</configuration>
eof
}

#配置ssh免密码登陆
function PassphraselessSSH ()
{
	#不重复生成私钥
	[ ! -f ~/.ssh/id_dsa ] && ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
	cat ~/.ssh/authorized_keys |grep "`cat ~/.ssh/id_dsa.pub`" &>/dev/null && r=0 || r=1
	#没有公钥的时候才添加
	[ $r -eq 1 ] && cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
	chmod 644 ~/.ssh/authorized_keys
	#不检查公钥
	cat > $HOMEDIR/.ssh/config <<eof
StrictHostKeyChecking no
eof
}

#执行
function Execute ()
{
	#格式化一个新的分布式文件系统
	hadoop namenode -format
	#启动Hadoop守护进程
	start-all.sh
	echo -e "\n========================================================================"
	echo "hadoop log dir : $HADOOP_LOG_DIR"
		
	echo "NameNode - http://$IP:50070/"
	echo "JobTracker - http://$IP:50030/"
	echo -e "\n========================================================================="
}

PseudoDistributed 2>&1 | tee -a pseudo.log
PassphraselessSSH 2>&1 | tee -a pseudo.log
Execute 2>&1 | tee -a pseudo.log



