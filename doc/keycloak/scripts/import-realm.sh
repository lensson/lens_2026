#!/bin/bash
# Import realm-lens.json to Keycloak
# This script imports the local realm configuration to Keycloak
# WARNING: This will overwrite the existing realm configuration in Keycloak!

set -e

KEYCLOAK_URL="${KEYCLOAK_URL:-http://172.28.0.1:28080}"
REALM="${KEYCLOAK_REALM:-lens}"
ADMIN_USER="${KEYCLOAK_ADMIN_USERNAME:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:-admin}"
INPUT_FILE="../realm-lens.json"

echo "=========================================="
echo "  Import Realm Configuration to Keycloak"
echo "=========================================="
echo ""
echo "⚠️  WARNING: This will update the realm configuration in Keycloak!"
echo ""
echo "Keycloak: $KEYCLOAK_URL"
echo "Realm: $REALM"
echo "Input: $INPUT_FILE"
echo ""

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
  echo "❌ File not found: $INPUT_FILE"
  exit 1
fi

# Validate JSON
echo "Validating JSON file..."
jq empty "$INPUT_FILE" 2>/dev/null
if [ $? -ne 0 ]; then
  echo "❌ Invalid JSON file: $INPUT_FILE"
  exit 1
fi
echo "✅ JSON file is valid"
echo ""

# Confirm action
read -p "Continue with import? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  echo "Import cancelled"
  exit 0
fi
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
  echo "Please check Keycloak is running and credentials are correct"
  exit 1
fi

echo "✅ Admin token obtained"
echo ""

# Step 2: Import realm configuration
echo "Step 2: Importing realm configuration..."

# Read the realm configuration
REALM_CONFIG=$(cat "$INPUT_FILE")

# Update the realm (partial import)
UPDATE_RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT "$KEYCLOAK_URL/admin/realms/$REALM" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$REALM_CONFIG")

HTTP_CODE=$(echo "$UPDATE_RESPONSE" | tail -n1)

if [ "$HTTP_CODE" = "204" ] || [ "$HTTP_CODE" = "200" ]; then
  echo "✅ Realm configuration imported successfully"
else
  echo "❌ Failed to import configuration (HTTP $HTTP_CODE)"
  echo "$UPDATE_RESPONSE" | head -n -1
  exit 1
fi

echo ""
echo "=========================================="
echo "  Import Complete"
echo "=========================================="
echo ""
echo "✅ realm-lens.json has been imported to Keycloak!"
echo ""
echo "Note: You may need to restart services or clear browser cache"
echo "      for changes to take effect."
echo ""
