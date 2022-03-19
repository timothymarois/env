#!/bin/bash
#
# This script will run through all the user accounts
# then through each domain within the account
# then it will run the backup script of each
#

# exit when any command fails
set -e

datetime=$(date +"%s")

cd /home

for userDir in */ ; do

    appsDirectory="/home/${userDir}apps"
    backupsDirectory="/home/${userDir}backups"

    # if backup directory does not exist, lets create it
    if [ ! -d ${backupsDirectory} ]; then
        mkdir -p ${backupsDirectory}
    fi

    if [ -d ${appsDirectory} ]; then

        cd ${appsDirectory}

        for domain in */ ; do

            domainDirectory="${appsDirectory}/${domain}"

            # if backups exist, then remove all except recent 10
            if [ -d ${backupsDirectory}/${domain} ]; then
                cd ${backupsDirectory}/${domain} && rm -rf `ls -t | tail -n +11`
            fi

            if [ ! -d ${backupsDirectory}/${domain} ]; then
                mkdir -p ${backupsDirectory}/${domain}
            fi

            cp -r ${domainDirectory} ${backupsDirectory}/${domain}/${datetime}

        done
    fi

done

# create a backup of project files
# cp -r ${directory}/apps/${domain} ${directory}/backups/${domain}/${datetime}
