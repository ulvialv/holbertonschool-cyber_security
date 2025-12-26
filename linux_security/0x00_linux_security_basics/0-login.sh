#!/bin/bash

# Check if script is run as root
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

echo "Last 5 login sessions:"
echo "----------------------"

# Display last 5 login records with date and time
last -n 5
