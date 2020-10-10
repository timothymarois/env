#!/usr/bin/env bash
# Upgrade an Amazon Linux EC2 to PHP 7.3
#
# Must be ran as sudo:
#     sudo sh install.sh
#

# exit when any command fails
# set -e

# first, lets go into root
cd /root

# ------------------------------------------------

# update the linux repo
yum -y update

# ------------------------------------------------

# Change the default server time to use EST (New_York)
\cp -rf /usr/share/zoneinfo/America/New_York /etc/localtime

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

# ------------------------------------------------

# Install Apache 2.4 + PHP 7.3
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
service httpd restart

# ------------------------------------------------

# PHP CONFIG
# Download the php.ini
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/php.ini
mv -f php.ini /etc/php.ini

# Restart Apache.
service httpd restart

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
service crond restart

# ------------------------------------------------

# VIRTUAL HOST (DEFAULT)
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/vhosts/default.conf
mv -f default.conf /etc/httpd/conf.d/001-default.conf 

# VIRTUAL HOST (SITES)
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/vhosts/example.conf
# mv -f example.conf /etc/httpd/conf.d/example.conf

# Restart Apache.
service httpd restart


# make the tools directory
mkdir /root/tools
# go into directory
cd /root/tools

# add user tools
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/tools/add-site.sh
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/tools/add-user.sh
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/tools/remove-site.sh
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/tools/remove-user.sh
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/tools/add-ssl.sh

# go back to tmp
cd /tmp

# if doesnt eixst... create it
# mkdir /usr/local/etc/
# wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/GeoIP.conf
# mv -f GeoIP.conf /usr/local/etc/GeoIP.conf

# Install new version of geoip 4
# wget https://github.com/maxmind/geoipupdate/releases/download/v4.3.0/geoipupdate_4.3.0_linux_386.tar.gz
# tar -xf geoipupdate_4.3.0_linux_386.tar.gz

# replace existing version...
# mv -f ./geoipupdate_4.3.0_linux_386/geoipupdate /bin/geoipupdate

# mkdir for geoip databases
# mkdir /usr/local/share/GeoIP

# run the update command
# geoipupdate

# Install NVM "nvm"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

# Load nvm now
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Install node
nvm install node