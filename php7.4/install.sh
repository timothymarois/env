#!/usr/bin/env bash
# Upgrade an Amazon Linux EC2 to PHP 7.4
#
# Must be ran as sudo:
#     sudo sh install.sh
#

# exit when any command fails
# set -e

# first, lets go into root
cd /root

# ------------------------------------------------

# Change the default server time to use EST (New_York)
\cp -rf /usr/share/zoneinfo/America/New_York /etc/localtime

# ------------------------------------------------

# update the linux repo
sudo yum -y update

# ------------------------------------------------

# install ftp service for user manage
sudo yum install -y vsftpd

# start the ftp program on boot
sudo systemctl enable vsftpd

# add new sftp group
groupadd sftp

# ------------------------------------------------

# Install Git
sudo yum install -y git 

# Install development tools
sudo yum install -y gcc-c++

# Install Llibsodium (this will be installed via the php ext)
# sudo yum install -y libsodium

# ------------------------------------------------

# Install Apache 2.4 + PHP 7.4
sudo yum install -y httpd
sudo amazon-linux-extras install -y php7.4

# These are already installed by the php install:
# yum install -y php-json
# yum install -y php-common
# yum install -y php-process
# yum install -y php-cli

# Install the extras:
sudo yum install -y php-bcmath
sudo yum install -y php-mbstring
sudo yum install -y php-opcache
sudo yum install -y php-soap
sudo yum install -y php-gd
sudo yum install -y php-xml
sudo yum install -y php-pgsql
# somtimes this is required
sudo yum install -y php-sodium
sudo yum install -y php-posix

# Restart Apache.
sudo systemctl restart httpd

# Enable httpd (apache) on boot
sudo systemctl enable httpd

# ------------------------------------------------

# go to tmp directory
cd /tmp

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# ------------------------------------------------

# Install certbot for SSL
wget -O epel.rpm –nv \
https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel.rpm
sudo yum install -y python2-certbot-apache.noarch
sudo yum install -y php-devel php-pear gcc zlib-devel

# ------------------------------------------------

# Install supervisor
sudo yum install -y supervisor

# start up the supervisor system
sudo systemctl start supervisord

# start suoervisor on boot
sudo systemctl enable supervisord

# ------------------------------------------------

# VSFTPD
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/vsftpd.conf
mv -f vsftpd.conf /etc/vsftpd/vsftpd.conf

# Restart FTP.
service vsftpd restart

# ------------------------------------------------

# Create the default directory
mkdir /var/www/html/default

# add apache and ec2-user to group
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www/html

# ------------------------------------------------

# APACHE CONFIG
# Download the httpd.conf
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/httpd.conf
mv -f httpd.conf /etc/httpd/conf/httpd.conf

# Restart Apache.
sudo systemctl restart httpd

# ------------------------------------------------

# PHP CONFIG
# Download the php.ini
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/php.ini
mv -f php.ini /etc/php.ini

# Restart Apache.
sudo systemctl restart httpd

# then restart the php-fpm modules
sudo systemctl restart php-fpm

# ------------------------------------------------

# ALLOW ROOT ACCESS
# Download the sshd config
# and replace the existing sshd_config
# This will allow you to login via root access
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/sshd_config
mv -f sshd_config /etc/ssh/sshd_config

# Restart the sshd service
sudo mkdir -p /root/.ssh
sudo cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/
sudo service sshd reload

# ------------------------------------------------

# CRON CONFIG
# Download the crontab
# and replace the existing crontab
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/crontab
mv -f crontab /etc/crontab

# Restart the cron service
sudo systemctl restart crond

# ------------------------------------------------

# VIRTUAL HOST (DEFAULT)
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/vhosts/default.conf
mv -f default.conf /etc/httpd/conf.d/001-default.conf 

# Restart Apache.
sudo systemctl restart httpd

# ------------------------------------------------

# go back into roo
cd /root

# create the env repo directory
mkdir env
cd /root/env

# clone the repo
git clone https://github.com/timothymarois/env.git .

# store the credentials on this repo
git config credential.helper store

# double check
git pull

# ------------------------------------------------

# go back into roo
cd /root

# create a shortcut to tools
ln -sf /root/env/php7.4/tools tools

# create shortcut directory
mkdir shortcuts

# setup shortcuts
ln -sf /etc/httpd shortcuts/httpd
ln -sf /etc shortcuts/etc
ln -sf /etc/php.ini shortcuts/php.ini
ln -sf /etc/crontab shortcuts/crontab
ln -sf /etc/logrotate.conf shortcuts/logrotate.conf
ln -sf /var/lib shortcuts/var_lib
ln -sf /var/log shortcuts/log
ln -sf /etc/logrotate.d shortcuts/logrotate
ln -sf /etc/supervisord.conf shortcuts/supervisord.conf
ln -sf /etc/php-fpm.d shortcuts/php-fpm

# ------------------------------------------------