#! /bin/bash -e
echo "$1" | ftpasswd opts --stdin --hash | awk '{print $2}'
