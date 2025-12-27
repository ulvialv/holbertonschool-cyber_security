#!/bin/bash
whois "$1" | awk -F': ' '/^(Registrant|Admin|Tech)/ {gsub(/^[ \t]+/,"",$2); if ($1 ~ /Street/) print $1","$2" "; else if ($1 ~ /Phone Ext|Fax Ext/) print $1":,"; else print $1","$2}'
