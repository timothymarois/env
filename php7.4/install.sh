#!/usr/bin/env bash
# Upgrade an Amazon Linux EC2 to PHP 7.3
#
# Must be ran as sudo:
#     sudo sh install.sh
#

# exit when any command fails
set -e

# first, be God.
sudo su
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

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# Install certbot for SSL
cd /tmp
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

sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www

# APACHE CONFIG
# Download the httpd.conf
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/httpd.conf
mv -f httpd.conf /etc/httpd/conf/httpd.conf

# PHP CONFIG
# Download the php-7.3.ini
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/php-7.3.ini
mv -f php-7.3.ini /etc/php-7.3.ini

# VIRTUAL HOST (SITES)
# Download the php-7.3.ini
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/sites.conf
mv -f sites.conf /etc/httpd/conf.d/sites.conf

# Restart Apache.
service httpd restart

# ALLOW ROOT ACCESS
# Download the sshd config
# and replace the existing sshd_config
# This will allow you to login via root access
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/sshd_config
mv -f sshd_config /etc/ssh/sshd_config

# Restart the sshd service
sudo mkdir -p /root/.ssh
sudo cp /home/ec2-user/.ssh/authorized_keys /root/.ssh/
sudo service sshd reload

# SSL/LETS ENCRYPT
# Download the Lets Encrypt SSL cert
# plus test the install
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
./certbot-auto renew --debug

# CRON CONFIG
# Download the crontab
# and replace the existing crontab
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/crontab
mv -f crontab /etc/crontab

# Restart the cron service
service crond restart
