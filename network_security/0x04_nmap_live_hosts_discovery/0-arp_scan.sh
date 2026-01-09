#!/bin/bash

# Check if a subnet argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <subnet>"
    exit 1
fi

SUBNET="$1"

# Run ARP scan using nmap (host discovery only, no port scan)
sudo nmap -sn -PR "$SUBNET"
