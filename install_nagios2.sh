#!/bin/bash

function set_environment()
{
	sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
	setenforce 0
	
	firewall-cmd --zone=public --add-port=80/tcp
	firewall-cmd --zone=public --add-port=80/tcp --permanent
	systemctl stop firewalld.service 
	systemctl disable firewalld.service 
}

function install_nagios()
{
    
yum install -y gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix  make net-snmp 
cd /tmp/

#wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.0.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.1.tar.gz
tar xzf nagioscore.tar.gz

cd /tmp/nagioscore-nagios-4.4.1/
./configure
make all
make install-groups-users
usermod -a -G nagios apache
make install

#make install-commandmode
make install-daemoninit
systemctl enable httpd.service

make install-config
make install-webconf
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

systemctl restart httpd.service
systemctl restart nagios.service

curl http://10.25.5.143/nagios


yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
yum install -y perl-Net-SNMP

cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz
 
cd /tmp/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install

curl http://10.25.5.143/nagios

systemctl start nagios.service
systemctl stop nagios.service
systemctl restart nagios.service
systemctl status nagios.service

}
