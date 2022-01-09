#!/bin/bash

# exit when any command fails
set -e

username=$1
directory=$2

userpath=/home/${username}
stagingpath=${userpath}/staging/${directory} 

# go into repo directory
cd ${stagingpath}

# make sure we're in the master branch
# git checkout master

# pull the lastest repo
git pull
# gitoutput=$(git pull 2>&1)