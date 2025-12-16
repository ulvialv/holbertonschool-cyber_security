#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <key_name>"
    exit 1
fi

ssh-keygen -t rsa -b 4096 -f "$1" -N ""
