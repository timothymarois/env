#!/bin/bash

# Example:
# 
# sh add-git.sh username directory repoName
#
# add-git.sh USERNAME DIRECTORY GITHUB_LINK
#

username=$1
directory=$2
github=$3

userpath=/home/${username}
stagingpage=${userpath}/staging

# go into root folder
cd ${stagingpage}

# make site directory
mkdir ./${directory}

# got into directory
cd ./${directory}

# copy the example
# example: https://USERNAME:GITKEY@github.com/${github}.git
git clone ${github} .

# store the credentials on this repo
git config credential.helper store

# double check
git pull