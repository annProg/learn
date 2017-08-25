#!/bin/bash

# Usage: Hadoop单节点模式
# History:
#	20140427  annhe  基本功能

function SingleMode ()
{
	#停止Hadoop守护进程
	stop-all.sh
	
	cd /etc/hadoop/
	#使用下面的core-site.xml
	cat > core-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
eof

	#使用下面的hdfs-site.xml
	cat > hdfs-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>	
eof
	
	#使用下面的mapred-site.xml
	cat > mapred-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
eof

}

SingleMode 2>&1 | tee -a single.log

