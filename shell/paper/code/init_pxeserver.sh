#!/bin/bash

# Usage: PXE服务器自动配置脚本
# History:
#	20140428  annhe  完成基本功能

#脚本工作目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#切换目录
cd $DIR && echo -e "\033[33m[INFO]: working dir is $(pwd) \033[0m"

VERSION=6.5	#Centos版本
SOFTDIR=soft	#软件包目录
CONFDIR=conf	#配置文件目录
HADOOPFILE=hadoop-1.2.1-1.x86_64.rpm	#Hadoop rpm包
JDKFILE=jdk-7u51-linux-x64.rpm		#jdk rpm包
HOMEDIR=/root				#用户主目录
RESOURCEFILE=$2				#资源分配文件路径
MIRROR=CentOS-$VERSION-x86_64-minimal.iso	#CentOS镜像版本 已废弃
WEBDIR=/var/www/html				#http服务器主目录
KSDIR=ks.cfg					#ks文件名
IMAGEDIR=centos65				#安装镜像复制目录
TOTALPACKAGES=32 				#base里的rpm包总数+1 的值	
MIRRORURL=http://mirrors.ustc.edu.cn		#定制镜像使用软件源
CLOUDSTACKURL=http://cloudstack.apt-get.eu/rhel/4.3/	#cloudstack yum源地址
MYSQLROOTPWD=$3					#mysql root 密码
NFSPRIMARYDIR=/primary				#nfs primary dir
NFSSECONDARYDIR=/secondary			#nfs secondary dir
SYSTEMVM=systemvm64template-2014-04-15-master-kvm.qcow2.bz2	#系统模板文件，需自备，并置于soft目录下

#默认单网卡结构
IPADDR=`ifconfig eth0 |grep "inet\ addr" |awk '{print $2}' |cut -d ":" -f2`
NETWORK=`ip route show |grep src |awk -F '[/]' '{print $1}'`
NETMASK=`ifconfig eth0 |grep "inet\ addr" |awk -F '[:]' '{print $4}'`
#IMAGEURL=http://$IPADDR/$IMAGEDIR

#安装常用软件包,注意依赖关系,ntp依赖ntpdate,所以ntpdate应该在前面
RPM=(
wget
ntpdate
ntp
dos2unix
lsof
ntsysv
sysstat
time
unzip
vim
which
zip
)

#安装准备工作
function Initialize ()
{
	#关闭selinux和iptables
	sed -i "s/SELINUX=.*/SELINUX=disabled/g" /etc/sysconfig/selinux && echo -e "\033[36m[SUCC]: disable selinux \033[0m" || echo -e "\033[31m[ERRO]: disable selinux failed! \033[0m"
	service iptables stop &>/dev/null && echo -e "\033[36m[SUCC]: Stop iptables \033[0m" || echo -e "\033[31m[ERRO]: Stop iptables failed! \033[0m"
	chkconfig iptables off &>/dev/null && echo -e "\033[36m[SUCC]: Chkconfig iptables off \033[0m" || echo -e "\033[31m[ERRO]: disable iptables failed! \033[0m"
	
	#准备引导程序
	rpm -qa |grep syslinux &>/dev/null && r=0 || r=1
	if [ $r -eq 1 ]; then
		yum install -y syslinux &>/dev/null && echo -e "\033[33m[SUCC]: Install syslinux \033[0m" || echo -e "\033[31m[ERRO]: Install syslinux failed! \033[0m"
	else
		echo -e "\033[33m[INFO]: syslinux installed, ignore \033[0m"
	fi	
}



#安装并配置DHCP服务器
function ConfigDHCPD ()
{
	#安装dhcp服务器
	rpm -qa |grep dhcp-[0-9] &>/dev/null && r=0 || r=1
	if [ $r -eq 1 ]; then
		yum install -y dhcp &>/dev/null && echo -e "\033[36m[SUCC]: install dchp \033[0m" || echo -e "\033[31m[ERRO]: install dhcpd failed! \033[0m"
	else
		[ $r -eq 0 ] && echo -e "\033[33m[INFO]: dchp installed,ignore \033[0m"
	fi
	chkconfig --level 2345 dhcpd on && echo -e "\033[36m[SUCC]: enable dhcpd when boot \033[0m"
	
	#使用安装服务器的网关
	GATEWAY=` ip route show |grep default |awk '{print $3}'`
	BROADCAST=`ifconfig eth0 |grep Bcast |awk -F '[:]' '{print $3}' |awk '{print $1}'`
	DNS=`cat /etc/resolv.conf |grep nameserver |awk 'NR==1 {print $2}'`
	RANGE_FROM=`echo $NETWORK |awk -F '[.]' '{print $1"."$2"."$3"."(($4+2))}'`
	RANGE_TO=`echo $BROADCAST |awk -F '[.]' '{print $1"."$2"."$3"."(($4-3))}'`
	
	echo -e "\033[33m[INFO]: configure dhcpd.conf... \033[0m"
	cat > /etc/dhcp/dhcpd.conf <<eof
#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp*/dhcpd.conf.sample
#   see 'man 5 dhcpd.conf'
#
#


ddns-update-style interim;
ignore client-updates;
allow booting;
allow bootp;
subnet $NETWORK netmask $NETMASK {
        option routers                  $GATEWAY;
        option subnet-mask              $NETMASK;
        option domain-name-servers      $DNS;
        option time-offset              -18000; # Eastern Standard Time
        range dynamic-bootp $RANGE_FROM $RANGE_TO;
        default-lease-time 21600;
        max-lease-time 43200;
        next-server $IPADDR;
        filename "pxelinux.0";
}
	
eof
	#上面配置中指定了引导程序的名字(pxelinux.0)及TFTP服务器地址，以便从TFTP服务器获取必要文件
}

#配置HTTP服务器
function ConfigHTTPD ()
{
	#安装http服务器
	rpm -qa |grep httpd-[0-9] &>/dev/null && r=0 || r=1
	if [ $r -eq 1 ]; then
		yum install -y httpd &>/dev/null && echo -e "\033[36m[SUCC]: install httpd \033[0m" || echo -e "\033[31m[ERRO]: install httpd failed! \033[0m"
	else
		[ $r -eq 0 ] && echo -e "\033[33m[INFO]: httpd installed, ignore \033[0m"
	fi
	
	sed -i "s/#ServerName.*/ServerName localhost:80/g" /etc/httpd/conf/httpd.conf && echo -e "\033[36m[SUCC]: configure httpd.conf... \033[0m"
	chkconfig --level 2345 httpd on && echo -e "\033[36m[SUCC]: enable httpd when boot \033[0m"
		
	#挂载iso，需自行准备CentOS DVD ISO镜像文件，并设置虚拟机CD设备使用CentOS iso镜像文件
	df |grep sr|awk '{print $1}'| while read dev
	do
		umount $dev
	done

	[ ! -d $WEBDIR/$IMAGEDIR ] && mkdir $WEBDIR/$IMAGEDIR
	mount /dev/cdrom $WEBDIR/$IMAGEDIR &>/dev/null 
	FLAGS=$?
	if [ $FLAGS -eq 0 ]; then
		echo -e "\033[36m[SUCC]: mount on $WEBDIR/$IMAGEDIR ok! \033[0m"
	elif [ $FLAGS -eq 32 ]; then
		echo -e "\033[33m[INFO]: already mounted, ignore... \033[0m"
	else	
		echo -e "\033[31m[ERRO]: mount error ,please check! (May mounted or no device found!) \033[0m"
		exit 1
	fi

	
	#准备KS文件
	cp conf/ks.cfg $WEBDIR/$KSDIR && echo -e "\033[36m[SUCC]: copy ks.cfg to $WEBDIR/$KSDIR \033[0m"
	sed -i "s#^url.*#url\ --url=http://$IPADDR/$IMAGEDIR#g"  $WEBDIR/$KSDIR && echo -e "\033[36m[SUCC]: modify url for ks.cfg \033[0m"
	sed -i "s#repo.*#repo --name=\"CentOS\"  --baseurl=http://$IPADDR/$IMAGEDIR --cost=100#g" $WEBDIR/$KSDIR && echo -e "\033[36m[SUCC]: modify repo for ks.cfg \033[0m"
	
	#准备资源配置文件
	[ ! -d $WEBDIR/$CONFDIR ] && mkdir $WEBDIR/$CONFDIR && echo -e "\033[36m[SUCC]: mkdir $WEBDIR/$CONFDIR  \033[0m"
	cp $RESOURCEFILE $WEBDIR/$CONFDIR/network.conf && echo -e "\033[36m[SUCC]: cp resourcefile to $WEBDIR/$CONFDIR/network.conf \033[0m"
	
	#准备软件
	[ ! -d $WEBDIR/$SOFTDIR ] && mkdir $WEBDIR/$SOFTDIR && echo -e "\033[36m[SUCC]: create soft dir $WEBDIR/$SOFTDIR \033[0m"
	cp -ru soft/* $WEBDIR/$SOFTDIR && echo -e "\033[36m[SUCC]: copy soft to $WEBDIR/$SOFTDIR \033[0m"

	
	#准备hadoop安装脚本
	cp hadoop_centos.sh $WEBDIR/$CONFDIR && echo -e "\033[36m[SUCC]: copy hadoop install script to $WEBDIR/$CONFDIR \033[0m"
	
	#复制常用工具
	cp -ru tools $WEBDIR/


	
}

#安装并配置TFTP服务器
function ConfigTFTPD ()
{
	#安装tftp服务器
	rpm -qa |grep tftp-server &>/dev/null && r=0 || r=1
	if [ $r -eq 1 ]; then
		yum install -y tftp-server* &>/dev/null && echo -e "\033[36m[SUCC]: install tftp-server \033[0m" || echo -e "\033[31m[ERRO]: install tftp-server failed! \033[0m"
	else
		[ $r -eq 0 ] && echo -e "\033[33m[INFO]: tftp-server installed, ignore \033[0m"
	fi
	rpm -qa |grep xinetd &>/dev/null && rr=0 || rr=1
	if [ $r -eq 1 ]; then
		yum install -y xinetd* &>/dev/null && echo -e "\033[36m[SUCC]: install xinetd \033[0m" || echo -e "\033[31m[ERRO]: install xinetd failed! \033[0m"
	else
		[ $r -eq 0 ] && echo -e "\033[33m[INFO]: xinetd installed, ignore \033[0m"
	fi
	
	chkconfig --level 2345 xinetd on && echo -e "\033[36m[SUCC]: enable xinetd when boot \033[0m"
	echo -e "\033[33m[INFO]: write tftp configure file.... \033[0m"
	cat > /etc/xinetd.d/tftp <<eof
	
# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -s /tftpboot
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}
eof
	# 上面要修改 disable 值为 no 
	#server_args指定tftpboot文件夹，建立该文件夹
	[ ! -d /tftpboot ] && mkdir /tftpboot && echo -e "\033[36m[SUCC]: create tftpboot dir \033[0m"
	
	#tftp服务器用于分发启动文件，包括 initrd.img  pxelinux.0  pxelinux.cfg/default  vmlinuz等文件
	cp -u /usr/share/syslinux/pxelinux.0 /tftpboot	&& echo -e "\033[36m[SUCC]: copy pxelinux.0 to tftpboot \033[0m" #复制引导程序到tftpboot目录
	cp -u $WEBDIR/$IMAGEDIR/images/pxeboot/vmlinuz /tftpboot && echo -e "\033[36m[SUCC]: copy vmlinuz to tftpboot \033[0m"	#复制Linux内核到tftpboot目录
	cp -u $WEBDIR/$IMAGEDIR/images/pxeboot/initrd.img /tftpboot && echo -e "\033[36m[SUCC]: copy initrd.img to tftpboot \033[0m"		#复制ramdisk的映像文件到tftpboot目录
	[ ! -d /tftpboot/pxelinux.cfg ] && mkdir /tftpboot/pxelinux.cfg && echo -e "\033[36m[SUCC]: create pxelinux.cfg dir \033[0m"
	#cp /mnt/isoforpxe/isolinux/isolinux.cfg /tftpboot/pxelinux.cfg/default	#复制启动配置文件
	
	#编辑启动配置文件
	echo -e "\033[33m[INFO]: configure pxelinux.cfg/default... \033[0m"
	cat > /tftpboot/pxelinux.cfg/default <<eof
default linux
#prompt 1
timeout 600

display boot.msg

menu background splash.jpg
menu title Welcome to CentOS 6.5!
menu color border 0 #ffffffff #00000000
menu color sel 7 #ffffffff #ff000000
menu color title 0 #ffffffff #00000000
menu color tabmsg 0 #ffffffff #00000000
menu color unsel 0 #ffffffff #00000000
menu color hotsel 0 #ff000000 #ffffffff
menu color hotkey 7 #ffffffff #ff000000
menu color scrollbar 0 #ffffffff #00000000

label linux
  menu label ^Install or upgrade an existing system
  menu default
  kernel vmlinuz
  append initrd=initrd.img text ks=http://$IPADDR/$KSDIR

eof

	#ks=url指定了ks文件的访问路径
}

#配置CentOS要安装的软件包
function ConfigRepo ()
{
	rpm -qa |grep wget &>/dev/null && r=0 || r=1
	if [ $r -eq 1 ]; then
		yum install -y wget &>/dev/null && echo -e "\033[36m[SUCC]: install wget \033[0m" || echo -e "\033[31m[ERRO]: install wget failed! \033[0m"
	else
		[ $r -eq 0 ] && echo -e "\033[33m[INFO]: wget installed, ignore \033[0m"
	fi
	
	#准备CentOS Base软件包
	echo -e "\033[33m\n[INFO]: download from $MIRRORURL \033[0m"
	if [ ! -f conf/list.txt ]; then
		wget "$MIRRORURL/centos/6/os/x86_64/Packages/" -O conf/list.txt &>/dev/null && r=0 || r=1  #软件包链接
		[ $r -eq 0 ] && echo "[INFO]: list.txt download successfull!"
		[ $r -eq 1 ] && echo -e "\033[31m[ERRO]: list.txt download failed! \033[0m"
	fi
	
	[ ! -d soft/package ] && mkdir soft/package && echo -e "\033[36m[SUCC]: create dir soft/package \033[0m"
	cd soft/package && echo -e "\033[36m[SUCC]: enter dir soft/package \033[0m"
	cat ../../conf/base.xml |grep -A $TOTALPACKAGES "<packagelist" |sed "1d" |awk -F '[>]' '{print $2}'|awk -F '[<]' '{print $1}' |while read package
	do
		url=`awk -F '["]' '{print $2}' ../../conf/list.txt | grep "^$package-"`
		for id in $url
		do
			if [ ! -f $id ]; then
				wget "$MIRRORURL/centos/6/os/x86_64/Packages/$id" &>/dev/null && r=0 || r=1
				[ $r -eq 0 ] && echo -e "\033[36m[SUCC]: $id download successfull! \033[0m"
				[ $r -eq 1 ] && echo -e "\033[31m[ERRO]: $id download failed! \033[0m"
			else
				echo -e "\033[33m[INFO]: $id exist...ignore \033[0m"
			fi
		done
	done
	
	[ ! -d $WEBDIR/$IMAGEDIR ] && mkdir $WEBDIR/$IMAGEDIR
	cp -u * $WEBDIR/$IMAGEDIR/Packages/  && echo -e "\033[33m[INFO]: copy package to $WEBDIR/$IMAGEDIR/Packages.... \033[0m"
	cp ../../conf/base.xml $WEBDIR/$IMAGEDIR/repodata/ && echo -e "\033[36m[SUCC]: copy base.xml to web dir \033[0m"
	cd $WEBDIR/$IMAGEDIR/repodata/ && echo -e "\033[36m[SUCC]: enter $WEBDIR/$IMAGEDIR/repodata/ \033[0m"
	
	#备份
	if [ ! -d backup ]; then
		mkdir backup && echo -e "\033[36m[SUCC]: create repofile backup dir \033[0m"
		echo -e "\033[33m[INFO]: backup repofile... \033[0m"
		cp *minimal-x86_64.xml* backup
		cp repomd.xml backup
	fi
	
	#操作前先恢复
	rm -f *minimal-x86_64.xml* repomd.xml
	cp backup/* .
	
	REPOFILE=`cat repomd.xml |grep -A 3 "group\""|grep location |awk -F '["]' '{print $2}' |awk -F '[/]' '{print $2}'`
	REPOGZFILE=`cat repomd.xml |grep -A 3 "group_gz\""|grep location |awk -F '["]' '{print $2}' |awk -F '[/]' '{print $2}'`
	OLDREPOSHA256=`sha256sum $REPOFILE |awk '{print $1}'` && echo -e "\033[36m[SUCC]: old repofile sha256sum \033[0m"
	OLDREPOGZSHA256=`sha256sum $REPOGZFILE |awk '{print $1}'` && echo -e "\033[36m[SUCC]: old gzip repofile sha256sum  \033[0m"
	
	chmod 777 $REPOFILE
	
	echo -e "\033[33m[INFO]: configure repofile...add base package \033[0m"
	sed -i '/<category/,$d' $REPOFILE
	cat base.xml | tr -s "[\015]" "[\n]" >> $REPOFILE && rm -f base.xml
	chmod 444 $REPOFILE	
	
	cat >> $REPOFILE <<eof


<category>
    <id>core</id>
    <name>Core</name>
    <description>Minimal server packages set</description>
    <display_order>60</display_order>
    <grouplist>
      <groupid>core</groupid>
    </grouplist>
  </category>
  <category>
    <id>base</id>
    <name>Base</name>
    <description>Basic server packages set</description>
    <display_order>61</display_order>
    <grouplist>
      <groupid>base</groupid>
    </grouplist>
  </category>
</comps>	
eof

	VER=`echo $REPOFILE |awk -F '[-]' '{print $2}'`
	NEWFIELSHA256=`sha256sum $REPOFILE |awk '{print $1}'` && echo -e "\033[36m[SUCC]: get new repofile sha256sum \033[0m"
	NEWREOPFILE=$NEWFIELSHA256-$VER-minimal-x86_64.xml
	mv $REPOFILE $NEWREOPFILE &>/dev/null && echo -e "\033[36m[SUCC]: rename new repofile \033[0m"
	
	cp $NEWREOPFILE tmp.xml
	gzip tmp.xml && echo -e "\033[36m[SUCC]: gzip new repofile \033[0m"
	NEWGZFILESHA256=`sha256sum tmp.xml.gz |awk '{print $1}'` && echo -e "\033[36m[SUCC]: get new gzip repofile sha256sum \033[0m"
	
	NEWREPOGZFILE=$NEWGZFILESHA256-$VER-minimal-x86_64.xml.gz
	mv tmp.xml.gz $NEWREPOGZFILE && echo -e "\033[36m[SUCC]: rename new gzip repofile \033[0m"
	
	echo -e "\033[33m[INFO]: modify repomd.xml... \033[0m"
	chmod 777 repomd.xml
	sed -i "s/$OLDREPOSHA256/$NEWFIELSHA256/g" repomd.xml
	sed -i "s/$OLDREPOGZSHA256/$NEWGZFILESHA256/g" repomd.xml
	chmod 444 repomd.xml
	rm -f tmp.xml
}

#配置rsync服务器
function ConfigRsync ()
{
	rpm -qa |grep rsync &>/dev/null && r=0 || r=1
	if [ $r -eq 1 ]; then
		yum install -y rsync &>/dev/null && echo -e "\033[36m[SUCC]: install rsync \033[0m" || echo -e "\033[31m[ERRO]: install rsync failed! \033[0m"
	else
		echo -e "\033[33m[INFO]: rsync installed, ignore \033[0m"
	fi
	
	rpm -qa |grep xinetd &>/dev/null && rr=0 || rr=1
	if [ $r -eq 1 ]; then
		yum install -y xinetd* &>/dev/null && echo -e "\033[36m[SUCC]: install xinetd \033[0m" || echo -e "\033[31m[ERRO]: install xinetd failed! \033[0m"
	else
		[ $r -eq 0 ] && echo -e "\033[33m[INFO]: xinetd installed, ignore \033[0m"
	fi
	
	echo -e "\033[33m[INFO]: configure rsyncd server... \033[0m"
	sed -i "s/disable.*/disable \= no/g" /etc/xinetd.d/rsync
	cat > /etc/rsyncd.conf <<eof
max connections=40
use chroot=no
log file=/var/log/rsyncd.log
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
secrets file=/etc/rsyncd.pwd

[hadoop]
uid=nobody
gid=nobody
path=/var/www/html/
comment = hadoop
read only = no
list = no
ignore errors = no
hosts allow=192.168.60.0/24
eof

	cat > /etc/rsyncd.pwd <<eof
eof

}

#配置安装Hadoop的ks文件
function HadoopKS ()
{
	echo -e "[INFO]: configure ks.cfg for hadoop installation... "
	cat >> $WEBDIR/$KSDIR <<eof
%post --log=/tmp/post-install.log

#关闭iptables开机启动 ks里的--disable选项只是不配置iptables规则
service iptables stop &>/dev/null && echo -e "[SUCC]: Stop iptables " || echo -e "[ERRO]: Stop iptables failed! "
chkconfig iptables off &>/dev/null && echo -e "[SUCC]: Chkconfig iptables off " || echo -e "[ERRO]: disable iptables failed! "

#设置本地yum源
cd /etc/yum.repos.d/
mkdir backup && mv *.repo backup
cat > local.repo <<repo
[local]
name=local
baseurl=http://$IPADDR/$IMAGEDIR/
enabled=1
gpgcheck=0

[cloudstack]
name=cloudstack
baseurl=http://$IPADDR/$SOFTDIR/cloudstack/
enabled=1
gpgcheck=0

[saltstack]
name=saltstack
baseurl=http://$IPADDR/$SOFTDIR/saltstack/
enabled=1
gpgcheck=0
repo


cd /tmp
pwd
curl -o network.conf http://$IPADDR/$CONFDIR/network.conf &>/dev/null && echo -e "[SUCC]: resourcefile download ok! "
MAC=\`ifconfig eth0 |grep HWaddr |awk '{print \$5}'\`
IP=\`grep "\$MAC" network.conf |grep HADOOP |awk '{print \$3}'\`
HOST=\`grep "\$MAC" network.conf |grep HADOOP |awk '{print \$1}'\`
NETMASK=\`grep "\$MAC" network.conf |grep HADOOP |awk '{print \$4}'\`
GATEWAY=\`grep "\$MAC" network.conf |grep HADOOP |awk '{print \$5}'\`

#set static ip addr
IFCFG=/etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "s/BOOTPROTO.*/BOOTPROTO=static/g" \$IFCFG
echo "IPADDR=\$IP" >>\$IFCFG
echo "NETMASK=\$NETMASK" >>\$IFCFG
echo "GATEWAY=\$GATEWAY" >>\$IFCFG

# add hostname to /etc/hosts
cat network.conf |grep HADOOP |awk '{print \$3" "\$1}' >>/etc/hosts
# reset hostname
sed -i "s/HOSTNAME.*/HOSTNAME=\$HOST/g" /etc/sysconfig/network

mkdir soft && cd soft
curl -o $HADOOPFILE http://$IPADDR/$SOFTDIR/$HADOOPFILE &>/dev/null && echo -e "[SUCC]: hadoop download ok! "
curl -o $JDKFILE http://$IPADDR/$SOFTDIR/$JDKFILE &>/dev/null && echo -e "[SUCC]: jdk download ok! "

cd ../
curl -o hadoop_centos.sh http://$IPADDR/$CONFDIR/hadoop_centos.sh &>/dev/null && echo -e "[SUCC]: hadoop_centos.sh download ok! "
sed -i '/read\ -p/,$'d hadoop_centos.sh
bash hadoop_centos.sh &>/dev/null && echo -e "[SUCC]: run hadoop_centos.sh ok! "

#curl -o xinetd-2.3.14-39.el6_4.x86_64.rpm http://$IPADDR/$SOFTDIR/package/xinetd-2.3.14-39.el6_4.x86_64.rpm &>/dev/null && echo -e "[SUCC]: xinetd down ok! "
#curl -o rsync-3.0.6-9.el6_4.1.x86_64.rpm http://$IPADDR/$SOFTDIR/package/rsync-3.0.6-9.el6_4.1.x86_64.rpm &>/dev/null && echo -e "[SUCC]: rsync down ok! "
#rpm -ivh xinetd-2.3.14-39.el6_4.x86_64.rpm &>/dev/null && echo -e "[SUCC]: xinetd install ok! "
#rpm -ivh rsync-3.0.6-9.el6_4.1.x86_64.rpm &>/dev/null && echo -e "[SUCC]: rsync install ok! "

sed -i "s/disable.*/disable = no/g" /etc/xinetd.d/rsync
cat > /etc/rsyncd.conf <<key
max connections=40
use chroot=no
log file=/var/log/rsyncd.log
pid file=/var/run/rsyncd.pid
lock file=/var/run/rsyncd.lock
secrets file=/etc/rsyncd.pwd

[pubkey]
uid=nobody
gid=nobody
path=/tmp/
read only = no
list = no
ignore errors = no
hosts allow=$NETWORK/$NETMASK
key
cat > /etc/rsyncd.pwd <<pas
pas

#开启必要服务
chkconfig ntpd on && /etc/init.d/ntpd start
chkconfig ntpdate on && ntpdate -u pool.ntp.org &>/dev/null
chkconfig xinetd on
chkconfig rsync on

/etc/init.d/xinetd restart
/etc/init.d/network restart

# slave pull d_dsa.pub from master
MASTER=\`cat network.conf |grep master |awk '{print \$1}'\`   # hostname of master
SLAVE=\`cat network.conf |grep slave |awk '{print \$1}'\`     # hostname of slave

if [ "\$HOST" = "\$MASTER" ]; then
	cp $HOMEDIR/.ssh/id_dsa.pub /tmp/id_dsa.pub
	cd /tmp
	chmod 777 id_dsa.pub
else
	i=0
	while [ \$i -lt 100 ]
	do
		#pull from master
		rsync Master::pubkey/id_dsa.pub . &>/dev/null && r=0 || r=1

		#check if rsync successfull and retry
		if [ \$r -eq 0 ]; then
			break;
		else
			sleep 5		#sleep 5 second then retry
			((i+=1))	#retry 100 times
			echo "retry  \$i ..."
		fi
	done
	cat $HOMEDIR/.ssh/authorized_keys | grep \`cat id_dsa.pub\`  &>/dev/null && r=0 || r=1
	[ \$r -eq 1 ] && cat id_dsa.pub >> $HOMEDIR/.ssh/authorized_keys
fi

# add id_dsa.pub of Controller
cat $HOMEDIR/.ssh/authorized_keys | grep "$KEY"  &>/dev/null && r=0 || r=1
[ \$r -eq 1 ] && echo "$KEY" >> $HOMEDIR/.ssh/authorized_keys


#install userfull rpm
#rsync $IPADDR::hadoop/soft/package/* .
#for id in ${RPM[*]}
#do
	#一个个的安装，主要解决某些因依赖问题中断安装的问题
#	for soft in \`ls |grep \$id-[0-9]\`
#	do
#		rpm -qa |grep \`echo \$soft|awk -F '[.]' '{print \$1}'\` &>/dev/null  && r=0 || r=1
#		if [ \$r -eq 1 ]; then
#			 rpm -i \$soft &>/dev/null && echo "[SUCC]: \$soft install ok!" || echo "[ERRO]: \$soft install failed "
#		else
#			echo "[INFO]: \$soft already installed , ignore..."
#		fi
#
#	done
#	
#done


#配置集群
cd /etc/hadoop

#使用下面的core-site.xml
cat > core-site.xml <<core
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>fs.default.name</name>
		<value>hdfs://\$MASTER:9000</value>
	</property>
</configuration>
core

#使用下面的hdfs-site.xml
cat > hdfs-site.xml <<hdfs
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
	
#使用下面的mapred-site.xml
cat > mapred-site.xml <<mapred
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Put site-specific property overrides in this file. -->

<configuration>
	<property>
		<name>mapred.job.tracker</name>
		<value>\$MASTER:9001</value>
	</property>
</configuration>
mapred

#添加master和slave主机名
cat > masters <<masters
\$MASTER
masters

cat > slaves << slaves
\$SLAVE
slaves

#安装salt-minion
yum install -y python-babel
rpm -ivh http://$IPADDR/$SOFTDIR/python-jinja2-2.2.1-1.el6.x86_64.rpm
yum install -y salt-minion

#修改master主机
sed -i "s/#master:.*/master: $IPADDR/g" /etc/salt/minion


eof


}

#配置安装Cloudstack的ks文件
function CloudStackKS ()
{
	echo -e "[INFO]: configure ks.cfg for CloudStack installation... "
	
	#添加cloudstack yum源
	sed -i "/repo.*/a\repo --name=\"CloudStack\"  --baseurl=http://$IPADDR/$SOFTDIR/cloudstack --cost=100" $WEBDIR/$KSDIR
	
	#准备Cloudstack rpm包
	[ ! -d $WEBDIR/$SOFTDIR/cloudstack ] && mkdir $WEBDIR/$SOFTDIR/cloudstack
	curl -s $CLOUDSTACKURL |grep rpm | awk -F '["]' '{print $8}' |while read pkg
	do
		[ ! -f $WEBDIR/$SOFTDIR/cloudstack/$pkg ] && curl -s -o $WEBDIR/$SOFTDIR/cloudstack/$pkg $CLOUDSTACKURL/$pkg
	done
	
	#准备Cloudstack rpm repodata文件
	[ ! -d $WEBDIR/$SOFTDIR/cloudstack/repodata/ ] && mkdir $WEBDIR/$SOFTDIR/cloudstack/repodata/
	curl -s $CLOUDSTACKURL/repodata/ |grep xml | awk -F '["]' '{print $8}' | while read xml
	do
		[ ! -f $WEBDIR/$SOFTDIR/cloudstack/repodata/$xml ] && curl -s -o $WEBDIR/$SOFTDIR/cloudstack/repodata/$xml $CLOUDSTACKURL/repodata/$xml
	done
	
	
	cat >> $WEBDIR/$KSDIR <<eof
%post --log=/tmp/post-install.log

#关闭iptables开机启动 ks里的--disable选项只是不配置iptables规则
service iptables stop &>/dev/null && echo -e "[SUCC]: Stop iptables " || echo -e "[ERRO]: Stop iptables failed! "
chkconfig iptables off &>/dev/null && echo -e "[SUCC]: Chkconfig iptables off " || echo -e "[ERRO]: disable iptables failed! "
chkconfig ntpd on
chkconfig ntpdate on

cd /tmp
curl -s -O http://$IPADDR/$CONFDIR/network.conf
	
MAC=\`ifconfig eth0 |grep HWaddr |awk '{print \$5}'\`
IP=\`grep "\$MAC" network.conf |grep CLOUDSTACK |awk '{print \$3}'\`
HOST=\`grep "\$MAC" network.conf |grep CLOUDSTACK |awk '{print \$1}'\`
NETMASK=\`grep "\$MAC" network.conf |grep CLOUDSTACK |awk '{print \$4}'\`
GATEWAY=\`grep "\$MAC" network.conf |grep CLOUDSTACK |awk '{print \$5}'\`

#集群角色的MAC地址,AGENT没有列出，作为这些角色之外的角色
MANAGEMENTMAC=\`grep management network.conf | grep CLOUDSTACK | awk '{print \$2}'\` && echo "\$MANAGEMENTMAC"
STORAGEMAC=\`grep storage network.conf | grep CLOUDSTACK | awk '{print \$2}'\` && echo "\$STORAGEMAC"
DBMAC=\`grep mysqlDB network.conf | grep CLOUDSTACK | awk '{print \$2}'\` && echo "\$DBMAC"

#set static ip addr
IFCFG=/etc/sysconfig/network-scripts/ifcfg-eth0
sed -i "s/BOOTPROTO.*/BOOTPROTO=static/g" \$IFCFG
echo "IPADDR=\$IP" >>\$IFCFG
echo "NETMASK=\$NETMASK" >>\$IFCFG
echo "GATEWAY=\$GATEWAY" >>\$IFCFG

# add hostname to /etc/hosts
cat network.conf |grep CLOUDSTACK |awk '{print \$3" "\$1}' >>/etc/hosts
hostname -f
# reset hostname
sed -i "s/HOSTNAME.*/HOSTNAME=\$HOST/g" /etc/sysconfig/network
hostname -f
/etc/init.d/network restart
hostname -f

#设置本地yum源
cd /etc/yum.repos.d/
mkdir backup && mv *.repo backup
cat > local.repo <<repo
[local]
name=local
baseurl=http://$IPADDR/$IMAGEDIR/
enabled=1
gpgcheck=0

[cloudstack]
name=cloudstack
baseurl=http://$IPADDR/$SOFTDIR/cloudstack/
enabled=1
gpgcheck=0

[saltstack]
name=saltstack
baseurl=http://$IPADDR/$SOFTDIR/saltstack/
enabled=1
gpgcheck=0
repo

cd /tmp/

#配置管理节点
if [ "\$MANAGEMENTMAC"x = "\$MAC"x ]; then
	#安装管理节点
	yum install -y cloud-client
	#http://download.cloud.com.s3.amazonaws.com/tools/vhd-util
	#mv vhd-util /usr/share/cloudstack-common/scripts/vm/hypervisor/xenserver/
	#cloudstack-setup-management
	#service iptables stop
	#/etc/init.d/cloudstack-management restart
fi

#配置数据库节点
if [ "\$DBMAC"x = "\$MAC"x ]; then
	#配置数据库
	yum install -y mysql-server
	cat >> /etc/my.cnf <<mysql
innodb_rollback_on_timeout=1
innodb_lock_wait_timeout=600
max_connections=350
log-bin=mysql-bin
binlog-format='ROW'
mysql

	#开机启动MySQL
	chkconfig mysqld on
	#启动MySQL才能进行下面的操作
	/etc/init.d/mysqld restart

	mysqladmin -u root password '$MYSQLROOTPWD'
	#导入Cloudstack基础数据
	cloudstack-setup-databases cloud:cloud@localhost --deploy-as=root:$MYSQLROOTPWD
fi

#配置存储节点
if [ "\$STORAGEMAC"x = "\$MAC"x ]; then
	rpm -qa | grep nfs-utils &>/dev/null && r=0 || r=1
	[ \$r -eq 1 ] && yum install -y nfs-utils
	cat > /etc/exports <<nfs
$NFSPRIMARYDIR *(rw,async,no_root_squash)
$NFSSECONDARYDIR *(rw,async,no_root_squash)
nfs

	mkdir $NFSPRIMARYDIR
	mkdir $NFSSECONDARYDIR

	sed -i "s/#Domain.*/Domain = \$HOST/g" /etc/idmapd.conf

	cat >> /etc/sysconfig/nfs <<nfs
LOCKD_TCPPORT=32803
LOCKD_UDPPORT=32769
MOUNTD_PORT=892
RQUOTAD_PORT=875
STATD_PORT=662
STATD_OUTGOING_PORT=2020
nfs

	service rpcbind start
	service nfs start
	chkconfig rpcbind on
	chkconfig nfs on
	exportfs -a
fi

#agent节点
if [ \$MAC != \$MANAGEMENTMAC -a \$MAC != \$DBMAC -a \$MAC != \$STORAGEMAC ]; then
	#配置agent计算节点
	yum install -y java-gcj-compat  #jakarta-commons-daemon-jsvc依赖java-gcj-compat
	rpm -ivh http://$IPADDR/$SOFTDIR/jakarta-commons-daemon-jsvc-1.0.1-8.9.el6.x86_64.rpm #这个包Centos DVD1没有,ztmdt, java-gcj-compat is needed by jakarta-commons-daemon-jsvc-1:1.0.1-8.9.el6.x86_64
	yum install -y cloud-agent
	
	#桥接,Cloudstack默认使用cloudbr0,cloudbr1..作为网桥名称，修改后可能出错
	#update: Cloudstack貌似可以自动配置桥接网络，这里可以省去（多网卡bond时可能仍需手动桥接）
	#cat > /etc/sysconfig/network-scripts/ifcfg-cloudbr0 <<br
#DEVICE="cloudbr0"
#TYPE="Bridge"
#ONBOOT="yes"
#BOOTPROTO=static
#IPADDR=\$IP
#NETMASK=\$NETMASK
#GATEWAY=\$GATEWAY
#br

#	sed -i "/IPADDR/d" /etc/sysconfig/network-scripts/ifcfg-eth0
#	sed -i "/NETMASK/d" /etc/sysconfig/network-scripts/ifcfg-eth0
#	sed -i "/GATEWAY/d" /etc/sysconfig/network-scripts/ifcfg-eth0
#	echo "BRIDGE=cloudbr0" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	
	#配置qemu
	echo "vnc_listen=0.0.0.0" >> /etc/libvirt/qemu.conf
	
	#配置libvirtd。为了让在线迁移正常工作，libvirt须使用非加密的TCP连接。
	#并关闭组播DNS广播
	cat >> /etc/libvirt/libvirtd.conf <<virtd
listen_tls = 0
listen_tcp = 1
tcp_port = "16059"
auth_tcp = "none"
mdns_adv = 0
virtd

	#仅在libvirtd.conf中打开listen_tcp是不够的，还需要以下更改
	sed -i "s/#LIBVIRTD_ARGS.*/LIBVIRTD_ARGS=\"--listen\"/g" /etc/sysconfig/libvirtd
	#echo "LIBVIRTD_ARGS=\"--listen\"" >> /etc/sysconfig/libvirtd
	
	#重启服务
	service libvirtd restart
	#service cloudstack-agent restart
	service iptables stop
	
fi

#设置日志目录权限
chown cloud -R /var/log/cloudstack

if [ "\$MANAGEMENTMAC"x = "\$MAC"x ]; then
	NFSIP=\`grep storage network.conf |grep CLOUDSTACK | awk '{print \$3}'\`
	#创建挂载点
	mkdir -p /mnt/secondary
	mount -t nfs \$NFSIP:$NFSSECONDARYDIR /mnt/secondary/
	
	#挂载系统模板
	rsync $IPADDR::hadoop/$SOFTDIR/$SYSTEMVM .
	/usr/share/cloudstack-common/scripts/storage/secondary/cloud-install-sys-tmplt -m /mnt/secondary/ -f $SYSTEMVM -h kvm -F
	
	cloudstack-setup-management
	service iptables stop
	#/etc/init.d/cloudstack-management restart
fi

#安装salt-minion
yum install -y python-babel
rpm -ivh http://$IPADDR/$SOFTDIR/python-jinja2-2.2.1-1.el6.x86_64.rpm
yum install -y salt-minion

#修改master主机
sed -i "s/#master:.*/master: $IPADDR/g" /etc/salt/minion

eof


}

#在控制机上安装saltstack master
function SaltStack ()
{
	#安装依赖包
	rpm -qa |grep python-babel &>/dev/null && r=0 || r=1
	[ $r -eq 1 ] && yum install -y python-babel &>/dev/null && echo -e "\033[33m[INFO]: install python-babel... \033[0m"
	rpm -qa |grep python-jinja2 &>/dev/null && r=0 || r=1
	[ $r -eq 1 ] && rpm -ivh soft/python-jinja2-2.2.1-1.el6.x86_64.rpm &>/dev/null && echo -e "\033[33m[INFO]: install python-jinja2... \033[0m"
	#安装master
	rpm -qa |grep salt-master &>/dev/null && r=0 || r=1
	[ $r -eq 1 ] && yum install -y salt-master &>/dev/null && echo -e "\033[33m[INFO]: install salt-master... \033[0m"
	
}

#启动PXE服务器
function StartAll ()
{
	echo -e "\n======================================================================="
	/etc/init.d/xinetd restart &>/dev/null && echo -e "\033[33m[INFO]: Restart xinetd... \033[0m" || echo -e "\033[31m[ERRO]: Restart xinetd failed! \033[0m"
	/etc/init.d/dhcpd restart &>/dev/null && echo -e "\033[33m[INFO]: Restart dhcpd... \033[0m" || echo -e "\033[31m[ERRO]: Restart dhcpd failed! \033[0m"
	/etc/init.d/httpd restart &>/dev/null && echo -e "\033[33m[INFO]: Restart httpd... \033[0m" || echo -e "\033[31m[ERRO]: Restart httpd failed! \033[0m"
	/etc/init.d/salt-master restart &>/dev/null && echo -e "\033[33m[INFO]: Restart salt-master... \033[0m" || echo -e "\033[31m[ERRO]: Restart salt-master failed!	\033[0m"
	if [ "$MYSQLROOTPWD"x != ""x ]; then
		echo -e "\033[36m[SUCC]: mysql root password : $MYSQLROOTPWD \033[0m"
		echo -e "\033[36m[SUCC]: cloudstack database=cloud and password=cloud \033[0m"
		echo -e "[INFO]: nfs Primary path: $NFSPRIMARYDIR,   nfs secondary path: $NFSSECONDARYDIR"
	fi
	echo -e "\n======================================================================="
}

#安装常用软件包
function InstallRPM ()
{
	for id in ${RPM[*]}
	do
		rpm -qa |grep $id-[0-9] &>/dev/null && r=0 || r=1
		if [ $r -eq 1 ]; then
			yum install -y $id &>/dev/null && echo -e "\033[33m[INFO]: install $id successfull \033[0m" || echo -e "\033[31m[ERRO]: install $id failed! \033[0m"
		else
			echo -e "\033[33m[INFO]: $id installed, ignore \033[0m"
		fi
	done

}

#打印帮助信息
function PrintHelp ()
{
	echo "This script is used to automatically configure PXE Installer"
	
	echo -e "\nUsage:"
	echo -e "\tinit_pxeserver.sh [OPTION]"
	echo -e "\nOptions"
	echo -e "-d  resourcefile                     2 args, default configuration,only install CentOS"
	echo -e "-h  resourcefile                     2 args, install CentOS and hadoop"
	echo -e "-c  resourcefile mysqlrootpwd        3 args, install Centos and CloudStack"
	echo -e "--help                    display this help"
	echo -e  "\nwritten by annhe 20140509 i@annhe.net"
}



#检查参数
[ $# -eq 0 ] && { PrintHelp; exit 1; }
[ $1 != "-d" ] && [ $1 != "-h" ] && [ $1 != "-c" ] || [ $1 = "--help" ] && { PrintHelp; exit 1;}

if [ $1 = "-d" ]; then 
	[ $# -eq 1 ] && { echo -e "Please specify the resourcefile. examples can be found at conf/network.conf. \nExample: ./init_pxeserver.sh -h conf/network.conf"; exit 1;} 
	[ ! -f $2 ] && { echo -e "resourcefile error! please check resourcefile path\n"; exit 1;}
fi

if [ $1 = "-h" ]; then
	[ $# -eq 1 ] && { echo -e "Please specify the resourcefile. examples can be found at conf/network.conf. \nExample: ./init_pxeserver.sh -h conf/network.conf"; exit 1;}
	[ ! -f $2 ] && { echo -e "resourcefile error! please check resourcefile path\n"; exit 1;}
fi

if [ $1 = "-c" ]; then
	[ $# -ne 3 ] && { echo -e "Please specify the resourcefile and mysql root password. resourcefile examples can be found at conf/network.conf. \nExample: ./init_pxeserver.sh -c conf/network.conf root123"; exit 1;}
	[ ! -f $2 ] && { echo -e "resourcefile error! please check resourcefile path\n"; exit 1;}
fi

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo -e "\033[31m[ERRO]: Error: You must be root to run this script! \033[0m"
    exit 1
fi

#检查网络
ping -c 2 baidu.com &>/dev/null && r=0 || r=1
[ $r -eq 1 ] && { echo -e "\033[31m[ERRO]: Network error! Please ensure you have connected the network....exit  \033[0m"; exit 1; }


#开启必要服务
echo -e "\033[33m[INFO]: start ntpd... \033[0m" && chkconfig ntpd on && /etc/init.d/ntpd start &>/dev/null
echo -e "\033[33m[INFO]: synchronizaion time... \033[0m" && chkconfig ntpdate on && ntpdate -u pool.ntp.org &>/dev/null

#配置Installer 公钥
[ ! -f $HOMEDIR/.ssh/id_dsa ] && ssh-keygen -t dsa -P '' -f $HOMEDIR/.ssh/id_dsa
KEY=`cat /root/.ssh/id_dsa.pub`

#执行函数
rm -f /tmp/init_pxeserver.log
Initialize 2>&1 | tee -a /tmp/init_pxeserver.log
ConfigDHCPD 2>&1 | tee -a /tmp/init_pxeserver.log
ConfigHTTPD 2>&1 | tee -a /tmp/init_pxeserver.log
ConfigTFTPD 2>&1 | tee -a /tmp/init_pxeserver.log

[ $1 = "-h" ] && HadoopKS 2>&1 | tee -a /tmp/init_pxeserver.log
[ $1 = "-c" ] && CloudStackKS 2>&1 | tee -a /tmp/init_pxeserver.log
#ConfigRepo 2>&1 | tee -a /tmp/init_pxeserver.log
ConfigRsync 2>&1 | tee -a /tmp/init_pxeserver.log
SaltStack 2>&1 | tee -a /tmp/init_pxeserver.log
StartAll 2>&1 | tee -a /tmp/init_pxeserver.log
