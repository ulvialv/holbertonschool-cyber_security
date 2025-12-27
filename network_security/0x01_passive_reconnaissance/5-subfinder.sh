#!/bin/bash
subfinder -d $1 -silent | while read h; do echo "$h,$(dig +short $h | head -n1)"; done > $1.txt
