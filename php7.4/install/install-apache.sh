#!/usr/bin/env bash
# 
# INSTALL: APACHE + PHP
# This script installs apache and php 7.4
#

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

# Restart Apache.
sudo systemctl restart httpd

# Enable httpd (apache) on boot
sudo systemctl enable httpd

# ------------------------------------------------

# Create the default directory
mkdir /var/www/html/default

# add apache and ec2-user to group
sudo usermod -a -G apache ec2-user

# both ec2-user and apache to manage the default directory 
sudo chown -R ec2-user:apache /var/www/html

# ------------------------------------------------

# DEFAULT APACHE CONFIG
# Download the httpd.conf
# and replace the existing config
# wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/httpd.conf

# move default config to location
# mv -f httpd.conf /etc/httpd/conf/httpd.conf

# Restart Apache.
# sudo systemctl restart httpd

# ------------------------------------------------

# DEFAULT PHP CONFIG
# Download the php.ini
# and replace the existing config
# wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/php.ini

# move default config to location
# mv -f php.ini /etc/php.ini

# Restart Apache.
# service httpd restart

# then restart the php-fpm modules
# restart php-fpm.service

# ------------------------------------------------