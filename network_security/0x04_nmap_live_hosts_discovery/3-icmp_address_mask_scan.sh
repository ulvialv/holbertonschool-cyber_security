#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_host_discovery "-PM" "$1"
