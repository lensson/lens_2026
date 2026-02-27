#!/bin/bash
# Quick token getter for Keycloak
# Usage: ./quick-token.sh

KEYCLOAK_URL="http://172.28.0.1:28080"
REALM="lens"
CLIENT_ID="lens-client"
CLIENT_SECRET="x6lEH0DMcT27eop2cszIP3Brc2sDQHLb"

echo "Getting token using client_credentials grant..."
TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials" \
  | jq -r '.access_token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "❌ Failed to get token"
  exit 1
fi

export TOKEN
echo "✅ Token obtained and exported to \$TOKEN"
echo ""
echo "Token: $TOKEN"
echo ""
echo "To use the token:"
echo "  source ./scripts/quick-token.sh"
echo "  curl -H \"Authorization: Bearer \$TOKEN\" http://localhost:8050/v2/lens/platform/auth/test"
echo ""
echo "Or copy this command:"
echo "  export TOKEN='$TOKEN'"
