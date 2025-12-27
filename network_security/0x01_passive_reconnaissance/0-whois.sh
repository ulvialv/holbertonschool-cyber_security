#!/bin/bash

domain="$1"
output="${domain}.csv"

whois "$domain" | awk -F: '
BEGIN {
    section=""
}

# Detect sections
/^Registrant / { section="Registrant" }
/^Admin /      { section="Admin" }
/^Tech /       { section="Tech" }

# Common fields
/Name:/ {
    if (section != "")
        print section " Name," substr($0, index($0,$2))
}
/Organization:/ {
    if (section != "")
        print section " Organization," substr($0, index($0,$2))
}
/Street:/ {
    if (section != "")
        print section " Street," substr($0, index($0,$2)) " "
}
/City:/ {
    if (section != "")
        print section " City," substr($0, index($0,$2))
}
/State\/Province:/ {
    if (section != "")
        print section " State/Province," substr($0, index($0,$2))
}
/Postal Code:/ {
    if (section != "")
        print section " Postal Code," substr($0, index($0,$2))
}
/Country:/ {
    if (section != "")
        print section " Country," substr($0, index($0,$2))
}
/Phone:/ {
    if (section != "")
        print section " Phone," substr($0, index($0,$2))
}
/Phone Ext:/ {
    if (section != "")
        print section " Phone Ext:,";
}
/Fax:/ {
    if (section != "")
        print section " Fax," substr($0, index($0,$2))
}
/Fax Ext:/ {
    if (section != "")
        print section " Fax Ext:,";
}
/Email:/ {
    if (section != "")
        print section " Email," substr($0, index($0,$2))
}
' > "$output"
