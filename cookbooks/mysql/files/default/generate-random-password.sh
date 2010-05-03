#!/bin/bash -e

# USAGE: generate-random-password.sh [number of characters]
# Generates a random password with a specified length
# [number of characters] - default is 20


if [ "$1" == "" ]; then
  NUMBER_OF_CHARACTERS=20
else
  NUMBER_OF_CHARACTERS=$1
fi
</dev/urandom tr -dc A-Za-z0-9|head -c $NUMBER_OF_CHARACTERS
