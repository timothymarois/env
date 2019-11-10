#!/usr/bin/env bash
# Upgrade an Amazon Linux EC2 to PHP 7.3
#
# Must be ran as sudo:
#     sudo sh env-setup.sh
#

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

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# Create env directories
mkdir /var/www/html/staging
mkdir /var/www/html/develop
mkdir /var/www/html/production