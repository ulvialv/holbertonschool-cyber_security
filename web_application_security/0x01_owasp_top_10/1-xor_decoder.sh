#!/bin/sh

if [ -z "$1" ]; then
  exit 1
fi

HASH=$(echo "$1" | sed 's/^{xor}//')
DECODED=$(echo "$HASH" | base64 -d 2>/dev/null)
KEY=90

RESULT=""

echo "$DECODED" | od -An -t u1 | while read -r c; do
  RESULT=$(printf "%s%s" "$RESULT" "$(printf "\\$(printf '%03o' $((c ^ KEY)))")")
done

printf "%s\n" "$RESULT"
