#!/bin/bash


# Example:
# 
# sh deploy.sh username repoName domain
#
#


# exit when any command fails
set -e

username=$1
repopath=$2
domain=$3

userpath=/home/${username}
stagingpath=${userpath}/staging/${repopath}
domainpath=${userpath}/apps/${domain}
publicpath=${domainpath}

rsync -av -X -A  \
--exclude '.env' \
--exclude '.htpasswd' \
--exclude 'storage/app/*' \
--exclude 'storage/framework/cache/*' \
--exclude 'storage/framework/testing/*' \
--exclude 'storage/framework/views/*' \
--exclude 'storage/framework/sessions/*' \
--exclude 'storage/logs/*' \
--exclude 'storage/oauth-private.key' \
--exclude 'storage/oauth-public.key' \
--delete-after \
${stagingpath}/ ${publicpath}

sudo chmod -R 0775 ${domainpath}
sudo chgrp -R apache ${domainpath}
sudo chown -R apache ${domainpath}