#!/bin/bash

# Check if a password argument is provided
if [ -z "$1" ]; then
    exit 1
fi

# Hash the password using SHA-1 and store the result
echo -n "$1" | sha1sum | awk '{print $1}' > 0_hash.txt
