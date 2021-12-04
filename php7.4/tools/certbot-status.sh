#!/bin/bash

# exit when any command fails
set -e

output="$(certbot certificates | jq -Rs . | cut -c 2- | rev | cut -c 2- | rev)"

# NEED TO OUTPUT THIS...