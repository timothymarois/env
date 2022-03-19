#!/bin/bash

# exit when any command fails
set -e

datetime=$(date +"%s")

cd /home

for d in */ ; do

    echo "$d"

done

# create a backup of project files
# cp -r ${directory}/apps/${domain} ${directory}/backups/${domain}/${datetime}

# go into the backup diretory and delete all by 10
# cd ${directory}/backups && rm -rf `ls -t | tail -n +11`