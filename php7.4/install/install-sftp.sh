#!/usr/bin/env bash
# 
# INSTALL: SFTP
# This script installs the service sftp
#

# ------------------------------------------------

# install ftp service
sudo yum install -y vsftpd

# start the ftp program on boot
sudo systemctl enable vsftpd

# start the new sftp servers
# CHECK IF THIS IS NEEDED...
sudo service vsftpd start

# add new sftp group
# this group will be used for all FTP accounts
sudo groupadd sftp

# ------------------------------------------------

# DEFAULT SFTP CONFIG
# Download the default config
# wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/config/vsftpd.conf

# move default config to location
# mv -f vsftpd.conf /etc/vsftpd/vsftpd.conf

# Restart FTP.
# sudo systemctl restart vsftpd

# ------------------------------------------------