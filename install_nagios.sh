#!/bin/bash


function install_nagios()
{

yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp unzip
cd /tmp/
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.2.0.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagios,nagcmd apache
tar zxvf nagios-4.2.0.tar.gz
cd nagios-4.2.0/
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf
cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
/etc/init.d/nagios start
/etc/init.d/httpd start
systemctl status httpd
systemctl enable httpd
systemctl start httpd
systemctl status httpd
htpasswd –c /usr/local/nagios/etc/htpasswd.users nagiosadmin
systemctl restart httpd


cd ../
tar zxvf nagios-plugins-2.1.2.tar.gz
cd /tmp/nagios-plugins-2.1.2
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install


chkconfig --add nagios
chkconfig --level 35 nagios on
#chkconfig --add httpd
#chkconfig --level 35 httpd on
}

install_nagios

