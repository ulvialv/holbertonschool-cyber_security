#!/bin/bash
. "$(dirname "$0")/../shared/nmap_wrapper.sh"
nmap_script_scan "http-vuln-cve2017-5638,ssl-enum-ciphers,ftp-anon" "$1" "comprehensive_scan_results.txt"
