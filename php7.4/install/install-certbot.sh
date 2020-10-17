#!/usr/bin/env bash
# 
# INSTALL: Certbot (SSL)
# This script installs certbot from the additional fedora packages
#

# ------------------------------------------------

# go to tmp directory
cd /tmp

# download latest additional fedora package manager 
wget -O epel.rpm –nv \
https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# install additional package manager
sudo yum install -y ./epel.rpm

# install the certbot apache package
sudo yum install -y python2-certbot-apache.noarch

# ------------------------------------------------