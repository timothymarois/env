#!/bin/bash

# Automatically setup and add SFTP user
# Script creates new user and setups permissions

username=$1
pass=$2
userDirectory="/home/"

if grep -q ${username} /etc/passwd ;then
	echo ${username} Already exsists. Aborting!
	exit 1
else
	useradd -d ${userDirectory}/${username} ${username}; echo -e "${pass}\n${pass}" | passwd ${username}
	usermod -a -G sftp,apache ${username}
	mkdir -p ${userDirectory}${username}
	mkdir -p ${userDirectory}${username}/apps
	mkdir -p ${userDirectory}${username}/storage
	mkdir -p ${userDirectory}${username}/logs
	chown -R ${username}:apache ${userDirectory}${username}
	chmod -R 0775 ${username}
fi