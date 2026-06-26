#!/bin/bash
. "$(dirname "$0")/../shared/hash_utils.sh"
crack_with_hashcat "0" "$1" "9-password.txt" "wordlist3.txt"
