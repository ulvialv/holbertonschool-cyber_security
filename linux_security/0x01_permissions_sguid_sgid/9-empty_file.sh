#!/bin/bash
# Use 644 instead of 777 — world-writable/executable empty files are a risk
find "$1" -type f -empty -exec chmod 644 {} \; 2>/dev/null
