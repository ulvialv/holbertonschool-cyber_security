#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_host_discovery "-PU53,161,162" "$1"
