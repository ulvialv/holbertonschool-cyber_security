#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_scan "-sX -p 440-450 --open --packet-trace --reason" "$1"
