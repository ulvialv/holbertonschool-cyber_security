#!/bin/bash
# domain değişkeni
domain=$1

# subfinder ile subdomainleri çek, her satırı host olarak al
subfinder -d "$domain" -silent | while read host; do
    # her host için IP çözümlemesi
    ip=$(dig +short "$host" | head -n1)
    # host,IP formatında dosyaya yaz
    echo "$host,$ip"
done > "$domain".txt
