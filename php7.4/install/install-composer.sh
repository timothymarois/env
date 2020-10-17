#!/usr/bin/env bash
# 
# INSTALL: PHP Composer
# This script installs php composer for dependency manager
#

# ------------------------------------------------

# go to tmp directory
cd /tmp

# Download recent composer installer and run php
curl -sS https://getcomposer.org/installer | sudo php

# move composer to bin (allowing it to run globally)
sudo mv composer.phar /usr/local/bin/composer

# create a symlink here
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# ------------------------------------------------