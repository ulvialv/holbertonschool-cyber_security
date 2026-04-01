#!/bin/bash
sudo nmap -scanflags URGACKPSHRSTSYNFIN -p $2 -oN custom.txt $1 > /dev/null 2>&1
mv custom.txt custom_scan.txt
