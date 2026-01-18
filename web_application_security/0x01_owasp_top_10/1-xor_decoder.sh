#!/bin/sh
[ -z "$1" ] && exit 1
HASH=$(echo "$1" | sed 's/^{xor}//')
DECODED=$(echo "$HASH" | base64 -d 2>/dev/null)
KEY=90
RESULT=""

echo "$DECODED" | od -An -t u1 | tr -s ' ' '\n' | while read c; do
  printf "\\$(printf '%03o' $((c ^ KEY)))"
done

echo
