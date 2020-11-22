#!/bin/bash


# Example:
# 
# sh publish-dist.sh username repopath domain
#
# sh publish-dist.sh tmarois myrepo mydomain.com
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
--exclude '.htaccess' \
--delete-after \
${stagingpath}/dist/ ${publicpath}

sudo chmod -R 0775 ${domainpath}
sudo chgrp -R apache ${domainpath}
sudo chown -R apache ${domainpath}


# sh nuxt-static-update.sh oakadmin oak-directory
# sh publish-dist.sh oakadmin oak-directory directory.oakoverseas.com