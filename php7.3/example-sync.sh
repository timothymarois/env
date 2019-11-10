#!/bin/bash

# $(date '+%y%m%d%H%M')
DATETIME=$(date +"%s")
PROJECT="projectName"
SITE="project.com"
# either "develop" or "production"
ENV="develop"


# make the back up directory if does not exist
mkdir -p /var/www/html/backups/$SITE

# go into the backup diretory and delete all by 10
cd /var/www/html/backups/$SITE && rm -rf `ls -t | tail -n +11`

# create a backup of project files
cp -r /var/www/html/$ENV/$SITE /var/www/html/backups/$SITE/$DATETIME


# enter the project files and pull in the git repo
cd /var/www/html/staging/$PROJECT && git checkout master && git pull

# give apache access to modify storage files
sudo chmod -R 0775 /var/www/html/staging/$PROJECT/storage
sudo chgrp -R apache /var/www/html/staging/$PROJECT/storage
sudo chown -R apache /var/www/html/staging/$PROJECT/storage

rsync -av -X -A  \
--exclude 'error_log' \
--exclude '.env' \
--exclude 'storage/framework/*' \
--exclude 'storage/logs/*' \
--exclude 'storage/debugbar/*' \
--delete-after \
/var/www/html/staging/$PROJECT/ /var/www/html/$ENV/$SITE

# give apache access to modify storage files
sudo chmod -R 0775 /var/www/html/$ENV/$SITE/storage
sudo chgrp -R apache /var/www/html/$ENV/$SITE/storage
sudo chown -R apache /var/www/html/$ENV/$SITE/storage

# optimize laravel routes
cd /var/www/html/$ENV/$SITE
php artisan optimize
