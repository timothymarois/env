#!/bin/bash

username=$1
directory=$2
github=$3

userpath=/home/${username}
stagingpath=${userpath}/staging

# go into staging directory
cd ${stagingpath}

# make site directory
mkdir ./${directory}

# got into directory
cd ./${directory}

# copy the example
# just supply the git directory "timothymarois/oak-directory"
git clone https://USERNAME:PASSWORD@github.com/${github}.git .

# store the credentials on this repo
git config credential.helper store

# double check
git pull