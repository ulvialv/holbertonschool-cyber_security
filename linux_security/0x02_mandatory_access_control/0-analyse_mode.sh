#!/bin/bash

# SELinux kurulu mu kontrol et
if command -v getenforce &> /dev/null; then
    MODE=$(getenforce)

    # Çıktıyı küçük harfe çeviriyoruz (örnek çıktıyla uyumlu olsun diye)
    MODE_LOWER=$(echo "$MODE" | tr '[:upper:]' '[:lower:]')

    echo "SELinux status:                 $MODE_LOWER"
else
    echo "SELinux status:                 disabled"
fi
