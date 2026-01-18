#!/bin/bash

if [ -z "$1" ]; then
  exit 1
fi

HASH=${1#\{xor\}}
DECODED=$(echo "$HASH" | base64 -d)

KEY=90
RESULT=""

for ((i=0; i<${#DECODED}; i++)); do
  c=$(printf "%d" "'${DECODED:i:1}")
  RESULT+=$(printf "\\$(printf '%03o' $((c ^ KEY)))")
done

echo "$RESULT"
