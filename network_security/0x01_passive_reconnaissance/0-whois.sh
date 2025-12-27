#!/bin/bash
whois "$1" | awk -F': ' '/^(Registrant|Admin|Tech)/{k=$1;v=$2; if(k~/(Phone Ext|Fax Ext)/) print k", "; else print k", "v}' > "$1.csv"
