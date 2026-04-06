#!/bin/bash
grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' logs.txt | awk '{print $1}' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}'
