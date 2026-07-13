#!/bin/bash
. "$(dirname "$0")/../shared/hash_utils.sh"
generate_hash "sha256" "$1" "1_hash.txt"
