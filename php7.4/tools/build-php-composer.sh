#!/bin/bash

# Example:
# 
# sh build-php-composer.sh userName repoName
#

# exit when any command fails
set -e

username=$1
directory=$2

userpath=/home/${username}
stagingpath=${userpath}/staging/${directory}

# run the git pull (be sure we're up to date)
sh /root/tools/git-pull.sh ${username} ${directory}

# go into repo directory
cd ${stagingpath}

# safe from composer-lock.js if included in repo
composer install