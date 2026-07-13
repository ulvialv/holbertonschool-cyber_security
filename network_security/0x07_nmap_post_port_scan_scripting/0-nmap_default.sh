#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_script_scan "default" "$1"
