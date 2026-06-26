#!/bin/bash
# Shared hash generation utilities for cryptography scripts.
# Source this file: . "$(dirname "$0")/../shared/hash_utils.sh"

generate_hash() {
  local algorithm="$1"
  local input="$2"
  local output_file="$3"
  echo -n "$input" | "${algorithm}sum" | cut -d' ' -f1 > "$output_file"
}

crack_with_john() {
  local hash_file="$1"
  local format="$2"
  local output_file="$3"
  local wordlist="${4:-/usr/share/wordlists/rockyou.txt}"
  john --wordlist="$wordlist" --format="$format" "$hash_file" && \
    john --show --format="$format" "$hash_file" | head -n -2 | cut -d: -f2 > "$output_file"
}

crack_with_hashcat() {
  local mode="$1"
  local hash_file="$2"
  local output_file="$3"
  local wordlist="${4:-/usr/share/wordlists/rockyou.txt}"
  hashcat -m "$mode" "$hash_file" "$wordlist" --force && \
    hashcat -m "$mode" "$hash_file" --show | cut -d: -f2 > "$output_file"
}
