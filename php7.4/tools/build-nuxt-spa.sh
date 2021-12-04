#!/bin/bash

# exit when any command fails
set -e

username=$1
directory=$2

userpath=/home/${username}
stagingpath=${userpath}/staging/${directory}

# go into repo directory
cd ${stagingpath}

# nuxt build-spa html content (/dist)
npm run build

# nuxt generate the html files
npm run generate