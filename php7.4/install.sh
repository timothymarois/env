#!/usr/bin/env bash
# Upgrade an Amazon Linux EC2 to PHP 7.3
#
# Must be ran as sudo:
#     sudo sh install.sh
#

# exit when any command fails
# set -e

# first, be God.
# sudo su
cd /root

# update the linux repo
yum -y update

# Change the default server time to use EST (New_York)
\cp -rf /usr/share/zoneinfo/America/New_York /etc/localtime

# Install Git
sudo yum install -y git 

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

# stay in tmp directory
cd /tmp

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# Install certbot for SSL
wget -O epel.rpm –nv \
https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ./epel.rpm
sudo yum install -y python2-certbot-apache.noarch

# Create env directories
mkdir /var/www/html/staging
mkdir /var/www/html/develop
mkdir /var/www/html/production
mkdir /var/www/html/backups
mkdir /var/www/html/scripts
mkdir /var/www/html/production/default

sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www

# APACHE CONFIG
# Download the httpd.conf
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/httpd.conf
mv -f httpd.conf /etc/httpd/conf/httpd.conf

# PHP CONFIG
# Download the php.ini
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/php.ini
mv -f php.ini /etc/php.ini

# APACHE CACHE (GZIP)
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/apache-cache.conf
mv -f apache-cache.conf /etc/httpd/conf.d/apache-cache.conf

# APACHE CACHE (workers update)
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/apache-workers.conf
mv -f apache-workers.conf /etc/httpd/conf.d/apache-workers.conf

# VIRTUAL HOST (DEFAULT)
# Download the sites-a.conf
# and add to apache conf
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/sites-a.conf
mv -f sites-a.conf /etc/httpd/conf.d/sites-a.conf

# VIRTUAL HOST (SITES)
# Download the sites-a.conf
# and add to apache conf
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/sites-b.conf
mv -f sites-b.conf /etc/httpd/conf.d/sites-b.conf

# Restart Apache.
service httpd restart

# ALLOW ROOT ACCESS
# Download the sshd config
# and replace the existing sshd_config
# This will allow you to login via root access
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/sshd_config
mv -f sshd_config /etc/ssh/sshd_config

# Restart the sshd service
sudo mkdir -p /root/.ssh
sudo cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/
sudo service sshd reload

# CRON CONFIG
# Download the crontab
# and replace the existing crontab
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/crontab
mv -f crontab /etc/crontab

# Restart the cron service
service crond restart

# if doesnt eixst... create it
# mkdir /usr/local/etc/
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/GeoIP.conf
mv -f GeoIP.conf /usr/local/etc/GeoIP.conf

# Install new version of geoip 4
wget https://github.com/maxmind/geoipupdate/releases/download/v4.3.0/geoipupdate_4.3.0_linux_386.tar.gz
tar -xf geoipupdate_4.3.0_linux_386.tar.gz

# replace existing version...
mv -f ./geoipupdate_4.3.0_linux_386/geoipupdate /bin/geoipupdate

# mkdir for geoip databases
mkdir /usr/local/share/GeoIP

# run the update command
geoipupdate