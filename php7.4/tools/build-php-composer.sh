#!/bin/bash

# Example:
# 
# sh build-php-composer.sh username repo branch
#
#

# exit when any command fails
set -e

username=$1
directory=$2
branch=$3

userpath=/home/${username}
stagingpath=${userpath}/staging/${directory}

# go into repo directory
cd ${stagingpath}

# run the git pull (be sure we're up to date)
sh /root/tools/git-pull.sh ${username} ${directory} ${branch}

# safe from composer-lock.js if included in repo
composer install
