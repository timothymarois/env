#!/usr/bin/env bash
# Upgrade an Amazon Linux EC2 to PHP 7.3
#
# Must be ran as sudo:
#     sudo sh install.sh
#

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

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# Create env directories
mkdir /var/www/html/staging
mkdir /var/www/html/develop
mkdir /var/www/html/production

# Download the httpd.conf
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/httpd.conf?token=AAS7X5PHVAW4POAEXVQUR5K52GNDE
mv -f httpd.conf?token=AAS7X5PHVAW4POAEXVQUR5K52GNDE /etc/httpd/conf/httpd.conf


# Download the php-7.3.ini
# and replace the existing config
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/php-7.3.ini?token=AAS7X5POLHUA2N4UZSAB4Q252GNUU
mv -f php-7.3.ini?token=AAS7X5POLHUA2N4UZSAB4Q252GNUU /etc/php-7.3.ini

# Restart Apache.
service httpd restart

# Download the Lets Encrypt SSL cert
# plus test the install
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
./certbot-auto renew --debug

# Download the crontab
# and replace the existing crontab
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.3/crontab?token=AAS7X5KNUGOY3WPGKNXS3CK52GSAK
mv -f crontab?token=AAS7X5KNUGOY3WPGKNXS3CK52GSAK /etc/crontab

# Restart the cron service
service crond restart