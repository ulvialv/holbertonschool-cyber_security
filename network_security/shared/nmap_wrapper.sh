#!/bin/bash
# Shared nmap wrapper utilities for network security scripts.
# Source this file: . "$(dirname "$0")/../shared/nmap_wrapper.sh"

nmap_scan() {
  local scan_flags="$1"
  local target="$2"
  sudo nmap $scan_flags "$target"
}

nmap_host_discovery() {
  local discovery_flag="$1"
  local target="$2"
  sudo nmap -sn "$discovery_flag" "$target"
}

nmap_script_scan() {
  local scripts="$1"
  local target="$2"
  local output_file="$3"
  if [ -n "$output_file" ]; then
    nmap --script "$scripts" "$target" -oN "$output_file"
  else
    nmap --script "$scripts" "$target"
  fi
}
