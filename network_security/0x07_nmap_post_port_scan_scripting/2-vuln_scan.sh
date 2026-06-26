#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_script_scan "http-vuln-cve2017-5638" "$1" "vuln_scan_results.txt"
