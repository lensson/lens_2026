#!/bin/bash
# Quick test for auth endpoints with token

# Get token
echo "Getting token..."
TOKEN=$(curl -s -X POST "http://172.28.0.1:28080/realms/lens/protocol/openid-connect/token" \
  -d "client_id=lens-client" \
  -d "client_secret=x6lEH0DMcT27eop2cszIP3Brc2sDQHLb" \
  -d "grant_type=client_credentials" \
  | jq -r '.access_token')

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  echo "❌ Failed to get token"
  exit 1
fi

echo "✅ Token: ${TOKEN:0:50}..."
echo ""

# Test endpoints
GATEWAY="http://localhost:8050/v2/lens/platform/auth"

echo "Testing Auth Endpoints:"
echo ""

echo "1. GET /echo"
curl -s -H "Authorization: Bearer $TOKEN" "$GATEWAY/echo"
echo ""
echo ""

echo "2. GET /caller/ping"
curl -s -H "Authorization: Bearer $TOKEN" "$GATEWAY/caller/ping"
echo ""
echo ""

echo "3. GET /actuator/health (public)"
curl -s "http://localhost:8041/actuator/health" | jq -r '.status'
echo ""
