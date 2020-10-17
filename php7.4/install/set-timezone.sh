#!/usr/bin/env bash
# 
# SERVER TIME
# This script changes the default server time
#

# ------------------------------------------------

# Change the default server time to use EST (New_York)
\cp -rf /usr/share/zoneinfo/America/New_York /etc/localtime

# ------------------------------------------------