#!/bin/bash

# Arg check
if [ -z "$1" ]; then
  exit 1
fi

# Remove {xor} prefix
HASH="${1#\{xor\}}"

# Base64 decode
DECODED=$(echo "$HASH" | base64 -d 2>/dev/null)

# XOR decode (WebSphere uses 0x5A)
RESULT=""

for (( i=0; i<${#DECODED}; i++ )); do
  char=$(printf "%d" "'${DECODED:$i:1}")
  RESULT+=$(printf "\\$(printf '%03o' $((char ^ 0x5A)))")
done

# Output
echo "$RESULT"
