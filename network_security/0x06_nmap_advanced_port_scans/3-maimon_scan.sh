#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_scan "-sM -p http,https,ftp,ssh,telnet -vv" "$1"
