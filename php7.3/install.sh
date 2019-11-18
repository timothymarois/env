#!/usr/bin/env bash
# Upgrade an Amazon Linux EC2 to PHP 7.3
#
# Must be ran as sudo:
#     sudo sh install.sh
#

# first, be God.
# sudo su
cd /root

# update the linux repo
yum -y update

# Change the default server time to use EST (New_York)
\cp -rf /usr/share/zoneinfo/America/New_York /etc/localtime

# Install Git
yum install -y git 

# Install Apache 2.4 + PHP 7.3
yum install -y httpd24 mod24_ssl
yum install -y php73

# These are already installed by the php73 install:
# yum install -y php73-json
# yum install -y php73-common
# yum install -y php73-process
# yum install -y php73-cli
# yum install -y php73-xml

# Install the extras:
yum install -y php73-bcmath
yum install -y php73-imap
yum install -y php73-mbstring
yum install -y php73-mysqlnd
yum install -y php73-pdo
yum install -y php73-opcache
yum install -y php73-soap
yum install -y php73-gd

# Restart Apache.
service httpd restart

# Make sure apache starts on reboot
chkconfig httpd on

# Download composer
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# Create env directories
mkdir /var/www/html/scripts
mkdir /var/www/html/backups
mkdir /var/www/html/staging
mkdir /var/www/html/develop
mkdir /var/www/html/production

# ADDING EXAMPLE SYNC FILE
# Download the sync file
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/example-sync.sh
mv -f example-sync.sh /var/www/html/scripts/example.sh

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
