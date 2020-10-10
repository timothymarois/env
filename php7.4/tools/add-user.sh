#!/bin/bash

# Automatically setup and add SFTP user
# Script creates new user and setups permissions

username=$1
userDirectory="/home/"

# generate a secure FTP password
pw=`openssl rand -base64 16`

if grep -q ${username} /etc/passwd ;then
	echo ${username} Already exsists. Aborting!
	exit 1
else
	useradd -d ${userDirectory}/${username} ${username}; echo -e "${pw}\n${pw}" | passwd ${username}
	usermod -a -G sftp,apache ${username}
	mkdir -p ${userDirectory}${username}
	mkdir -p ${userDirectory}${username}/apps
	mkdir -p ${userDirectory}${username}/storage
	mkdir -p ${userDirectory}${username}/logs
	chown -R ${username}:apache ${userDirectory}${username}
	chmod -R 0775 ${userDirectory}${username}

	echo "--------------------------------"
	echo "${username} has been created."
	echo "PASSWORD:"
	echo "--------------------------------"
	echo ${pw}
	echo "--------------------------------"
fi