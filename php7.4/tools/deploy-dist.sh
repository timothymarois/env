#!/bin/bash


# Example:
# 
# sh deploy-dist.sh username repopath domain
#
# sh deploy-dist.sh tmarois myrepo mydomain.com
#


# exit when any command fails
set -e

username=$1
repopath=$2
domain=$3

userpath=/home/${username}
stagingpath=${userpath}/staging/${repopath}
domainpath=${userpath}/apps/${domain}
publicpath=${domainpath}/public

rsync -av -X -A  \
--exclude '.env' \
--delete-after \
${stagingpath}/dist/ ${publicpath}

sudo chmod -R 0775 ${domainpath}
sudo chgrp -R apache ${domainpath}
sudo chown -R apache ${domainpath}