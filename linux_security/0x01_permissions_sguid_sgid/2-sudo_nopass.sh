#!/bin/bash
# Validate username: allow only alphanumeric, underscore, hyphen, and dot
if [[ ! "$1" =~ ^[a-zA-Z0-9._-]+$ ]]; then
  echo "Error: invalid username '$1'" >&2
  exit 1
fi
echo "$1 ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/"$1" > /dev/null
