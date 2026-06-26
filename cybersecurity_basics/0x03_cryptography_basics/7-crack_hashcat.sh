#!/bin/bash
. "$(dirname "$0")/../shared/hash_utils.sh"
crack_with_hashcat "0" "$1" "7-password.txt"
