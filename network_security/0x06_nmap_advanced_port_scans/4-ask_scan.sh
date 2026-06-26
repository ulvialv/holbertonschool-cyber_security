#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_scan "-sA -p $2 --reason --host-timeout 1000ms" "$1"
