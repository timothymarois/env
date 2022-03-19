#!/bin/bash

# exit when any command fails
set -e

datetime=$(date +"%s")

cd /home

for userDir in */ ; do

    # echo "$d"

    cd ${userDir}

    for domainDir in */ ; do

        echo "$domainDir"

    done

done

# create a backup of project files
# cp -r ${directory}/apps/${domain} ${directory}/backups/${domain}/${datetime}

# go into the backup diretory and delete all by 10
# cd ${directory}/backups && rm -rf `ls -t | tail -n +11`