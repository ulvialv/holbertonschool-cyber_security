#!/bin/sh
[ -z "$1" ] && exit 1
printf '%s' "$1" | sed 's/^{xor}//' | base64 -d | awk '{
  for (i = 1; i <= length($0); i++)
    printf "%c", xor(ord(substr($0,i,1)), 90)
  print ""
}
function ord(c){return index("\
\1\2\3\4\5\6\7\10\11\12\13\14\15\16\17\
\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37\
 !\"#$%&'\''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~",c)-1}
function xor(a,b){return a^b}'
