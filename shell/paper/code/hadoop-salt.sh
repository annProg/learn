#!/bin/bash

# Usage: 用salt同步Hadoop集群配置
# History:
#

#脚本工作目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#切换目录
cd $DIR && echo -e "\033[33m[INFO]: working dir is $(pwd) \033[0m"

SALTDIR=salt
MASTER=HADOOP-152
HOMEDIR=/root

[ ! -d $SALTDIR ] && mkdir $SALTDIR

cat > $SALTDIR/hosts <<eof
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
eof
#hosts文件
salt "HADOOP-*" cmd.run "ifconfig eth0 |grep inet\ addr" >tmp
cat tmp |grep inet |awk -F '[:]' '{print $2}' |awk '{print $1}' |awk -F '[.]' '{print $1"."$2"."$3"."$4" HADOOP-"$4}' >>$SALTDIR/hosts
rm -f tmp

#master密钥
salt $MASTER cmd.run "cat /root/.ssh/id_dsa.pub" >tmp
cat tmp |grep ssh-dss |awk '{print "ssh-dss "$2}' >$SALTDIR/authorized_keys

#集群配置文件
cat > $SALTDIR/core-site.xml <<core
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>fs.default.name</name>
		<value>hdfs://$MASTER:9000</value>
	</property>
</configuration>
core

cat > $SALTDIR/hdfs-site.xml <<hdfs
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>dfs.replication</name>
		<value>2</value>
	</property>
</configuration>	
hdfs
	
cat > $SALTDIR/mapred-site.xml <<mapred
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>mapred.job.tracker</name>
		<value>$MASTER:9001</value>
	</property>
</configuration>
mapred

#masters文件
echo $MASTER >$SALTDIR/masters
#slaves文件
cat $SALTDIR/hosts |grep HADOOP|sed "/$MASTER/d" |awk '{print $2}' >$SALTDIR/slaves

#状态文件
cat > $SALTDIR/hadoop.sls <<eof
hosts:
  file.managed:
    - name: /etc/hosts
    - source: salt://hosts
authorized_keys:
  file.managed:
    - name: $HOMEDIR/.ssh/authorized_keys
    - source: salt://authorized_keys
    - mode: 644
core-site.xml:
  file.managed:
    - name: /etc/hadoop/core-site.xml
    - source: salt://core-site.xml
hdfs-site.xml:
  file.managed:
    - name: /etc/hadoop/hdfs-site.xml
    - source: salt://hdfs-site.xml
mapred-site.xml:
  file.managed:
    - name: /etc/hadoop/mapred-site.xml
    - source: salt://mapred-site.xml
masters:
  file.managed:
    - name: /etc/hadoop/masters
    - source: salt://masters
slaves:
  file.managed:
    - name: /etc/hadoop/slaves
    - source: salt://slaves
eof

    