#!/bin/bash
. "$(dirname "$0")/../shared/hash_utils.sh"
generate_hash "md5" "$1" "2_hash.txt"
