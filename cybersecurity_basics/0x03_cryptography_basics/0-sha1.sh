#!/bin/bash
. "$(dirname "$0")/../shared/hash_utils.sh"
generate_hash "sha1" "$1" "0_hash.txt"
