#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_scan "-sW -p $2 --exclude-ports $3" "$1"
