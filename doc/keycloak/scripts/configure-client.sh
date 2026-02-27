#!/bin/bash
# Update Keycloak client configuration for OAuth2 login redirect
# This script adds the proper redirect URIs for the gateway

set -e

KEYCLOAK_URL="http://172.28.0.1:28080"
REALM="lens"
CLIENT_ID="lens-client"
ADMIN_USER="admin"
ADMIN_PASSWORD="admin"

echo "=========================================="
echo "  Updating Keycloak Client Configuration"
echo "=========================================="
echo ""
echo "Keycloak: $KEYCLOAK_URL"
echo "Realm: $REALM"
echo "Client: $CLIENT_ID"
echo ""

# Step 1: Get admin token
echo "Step 1: Getting admin token..."
ADMIN_TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" \
  -d "client_id=admin-cli" \
  -d "username=$ADMIN_USER" \
  -d "password=$ADMIN_PASSWORD" \
  -d "grant_type=password" \
  | jq -r '.access_token')

if [ -z "$ADMIN_TOKEN" ] || [ "$ADMIN_TOKEN" = "null" ]; then
  echo "❌ Failed to get admin token"
  exit 1
fi

echo "✅ Admin token obtained"
echo ""

# Step 2: Get client UUID
echo "Step 2: Getting client UUID..."
CLIENT_UUID=$(curl -s -X GET "$KEYCLOAK_URL/admin/realms/$REALM/clients" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  | jq -r ".[] | select(.clientId==\"$CLIENT_ID\") | .id")

if [ -z "$CLIENT_UUID" ] || [ "$CLIENT_UUID" = "null" ]; then
  echo "❌ Failed to find client: $CLIENT_ID"
  exit 1
fi

echo "✅ Client UUID: $CLIENT_UUID"
echo ""

# Step 3: Get current client configuration
echo "Step 3: Getting current client configuration..."
CURRENT_CONFIG=$(curl -s -X GET "$KEYCLOAK_URL/admin/realms/$REALM/clients/$CLIENT_UUID" \
  -H "Authorization: Bearer $ADMIN_TOKEN")

echo "Current configuration retrieved"
echo ""

# Step 4: Update client with proper redirect URIs
echo "Step 4: Updating client configuration..."

# Create updated configuration
UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq '. + {
  "redirectUris": [
    "http://localhost:8050/*",
    "http://localhost:8050/login/oauth2/code/*",
    "http://localhost:8050/login/oauth2/code/keycloak",
    "http://172.28.0.1:8050/*",
    "http://172.28.0.1:8050/login/oauth2/code/*",
    "http://172.28.0.1:8050/login/oauth2/code/keycloak"
  ],
  "webOrigins": [
    "http://localhost:8050",
    "http://172.28.0.1:8050",
    "+"
  ],
  "standardFlowEnabled": true,
  "directAccessGrantsEnabled": true,
  "publicClient": false
}')

# Update client
UPDATE_RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT "$KEYCLOAK_URL/admin/realms/$REALM/clients/$CLIENT_UUID" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$UPDATED_CONFIG")

HTTP_CODE=$(echo "$UPDATE_RESPONSE" | tail -n1)

if [ "$HTTP_CODE" = "204" ] || [ "$HTTP_CODE" = "200" ]; then
  echo "✅ Client configuration updated successfully"
else
  echo "❌ Failed to update client (HTTP $HTTP_CODE)"
  echo "$UPDATE_RESPONSE"
  exit 1
fi

echo ""
echo "=========================================="
echo "  Configuration Update Complete"
echo "=========================================="
echo ""
echo "Updated settings:"
echo "  - Redirect URIs: http://localhost:8050/login/oauth2/code/keycloak"
echo "  - Web Origins: http://localhost:8050"
echo "  - Standard Flow: Enabled"
echo "  - Direct Access Grants: Enabled"
echo ""
echo "Now you can access:"
echo "  http://localhost:8050/v2/lens/platform/auth/echo"
echo ""
echo "You will be redirected to Keycloak login page."
echo ""
