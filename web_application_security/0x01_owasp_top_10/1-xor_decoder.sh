#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {xor}HASH"
    exit 1
fi

# Remove the {xor} prefix if it exists
ENCODED_STRING="${1#\{xor\}}"

# 1. Base64 decode the string
# 2. Use 'od' to get decimal values of bytes
# 3. Use 'awk' to XOR each value with 95 and convert back to characters
echo "$ENCODED_STRING" | base64 -d | od -v -An -t u1 | awk '{
    for (i=1; i<=NF; i++) {
        # XOR with 95 (0x5f)
        printf "%c", bitwise_xor($i, 95)
    }
}
function bitwise_xor(a, b,   r, i, res) {
    res = 0
    for (i=0; i<8; i++) {
        if ((a%2) != (b%2)) res += 2^i
        a = int(a/2)
        b = int(b/2)
    }
    return res
}
END { printf "\n" }'
