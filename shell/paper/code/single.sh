#!/bin/bash

# Usage: Hadoop���ڵ�ģʽ
# History:
#	20140427  annhe  ��������

function SingleMode ()
{
	#ֹͣHadoop�ػ�����
	stop-all.sh
	
	cd /etc/hadoop/
	#ʹ�������core-site.xml
	cat > core-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
eof

	#ʹ�������hdfs-site.xml
	cat > hdfs-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>	
eof
	
	#ʹ�������mapred-site.xml
	cat > mapred-site.xml <<eof
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
</configuration>
eof

}

SingleMode 2>&1 | tee -a single.log

