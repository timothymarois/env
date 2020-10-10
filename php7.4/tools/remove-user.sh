#!/bin/bash

# Automatically delete user
# Script creates new user and setups permissions

username=$1

if id "$username" &>/dev/null; then
    userdel -r ${username}
    echo ${username} has been removed!
else
    echo ${username} Does not exist. Aborting!
    exit 1
fi