#!/bin/bash
. "$(dirname "$0")/../shared/hash_utils.sh"
crack_with_john "$1" "Raw-SHA256" "6-password.txt"
