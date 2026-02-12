#!/bin/bash

# Tüm tabloları (filter, nat, mangle, raw, security) line number ile göster

tables=("filter" "nat" "mangle" "raw" "security")

for table in "${tables[@]}"; do
    echo "=============================="
    echo "Table: $table"
    echo "=============================="
    sudo iptables -t $table -L -v -n --line-numbers 2>/dev/null
    echo ""
done
