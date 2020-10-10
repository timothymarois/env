#!/bin/bash

# Automatically setup and add SFTP user
# Script creates new user and setups permissions

newUser=$1
newPW=$2
userDirectory="/home/"

if grep -q ${newUser} /etc/passwd ;then
        echo ${newUser} Already exsists. Aborting!
        exit 1
else
        mkdir -p ${userDirectory}${newUser}
        mkdir -p ${userDirectory}${newUser}/apps
        mkdir -p ${userDirectory}${newUser}/storage
        useradd -g apache -d ${userDirectory}/${newUser} -s /sbin/nologin ${newUser}
        passwd ${newPW}
        chown -R ${newUser}:apache ${userDirectory}${newUser}
fi
