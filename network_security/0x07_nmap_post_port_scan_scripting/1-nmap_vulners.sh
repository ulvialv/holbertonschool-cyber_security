#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap -sV --script vulners -p 80,443 "$1"
