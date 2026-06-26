#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_scan "-sN -p 20-25" "$1"
