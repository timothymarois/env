#!/bin/bash

# exit when any command fails
set -e

username=$1
directory=$2

userpath=/home/${username}
stagingpath=${userpath}/staging/${directory}

# go into repo directory
cd ${stagingpath}

# pull the lastest repo
git pull

# install npm
npm install

# nuxt build html content (/dist)
npm run build-spa