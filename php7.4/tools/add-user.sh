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

	# store all public sites/apps here
	mkdir -p ${userDirectory}${username}/apps
	# used for storage/resources
	mkdir -p ${userDirectory}${username}/storage
	# used for apache/error logs
	mkdir -p ${userDirectory}${username}/logs

	# set the permissions to the folder
	chown -R ${username}:apache ${userDirectory}${username}
	chmod -R 0775 ${userDirectory}${username}

	# add the staging directory (but dont give permissions to user)
	mkdir -p ${userDirectory}${username}/staging

	echo "--------------------------------"
	echo "${username} has been created."
	echo "PASSWORD:"
	echo "--------------------------------"
	echo ${pw}
	echo "--------------------------------"
fi