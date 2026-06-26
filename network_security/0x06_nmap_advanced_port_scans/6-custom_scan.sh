#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_scan "--scanflags -p $2 -oN custom_scan.txt" "$1" >/dev/null 2>&1
