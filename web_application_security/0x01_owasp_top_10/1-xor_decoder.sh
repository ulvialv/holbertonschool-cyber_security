#!/bin/bash

if [ -z "$1" ]; then
  exit 1
fi

HASH="${1#\{xor\}}"

DECODED=$(echo "$HASH" | base64 -d 2>/dev/null)

RESULT=""
for (( i=0; i<${#DECODED}; i++ )); do
  char=$(printf "%d" "'${DECODED:$i:1}")
  RESULT+=$(printf "\\$(printf '%03o' $((char ^ 0x5A)))")
done

echo "$RESULT"
