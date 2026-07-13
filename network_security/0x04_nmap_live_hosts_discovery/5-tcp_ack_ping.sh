#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_host_discovery "-PA22,80,443" "$1"
