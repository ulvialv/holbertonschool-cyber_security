#!/bin/bash
# WebSphere XOR Password Decoder
# Decodes passwords in format: {xor}BASE64_ENCODED

# Get input
INPUT="$1"

# Remove {xor} prefix
ENCODED="${INPUT#\{xor\}}"

# Base64 decode
DECODED=$(echo "$ENCODED" | base64 -d 2>/dev/null)

# XOR decode with key 0x5F (WebSphere default)
RESULT=""
for (( i=0; i<${#DECODED}; i++ )); do
    # Get byte
    BYTE="${DECODED:$i:1}"
    # Get ASCII value
    ASCII=$(printf "%d" "'$BYTE")
    # XOR with 0x5F
    XOR_RESULT=$((ASCII ^ 0x5F))
    # Append character
    RESULT+=$(printf "\\$(printf '%03o' $XOR_RESULT)")
done

# Output result
echo -e "$RESULT"
