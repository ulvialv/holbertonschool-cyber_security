#!/bin/bash

# Eğer argüman verilmezse hata ver
if [ -z "$1" ]; then
    echo "Kullanım: $0 <host>"
    exit 1
fi

# NULL scan çalıştır
sudo nmap -sN -p 20-25 "$1"
