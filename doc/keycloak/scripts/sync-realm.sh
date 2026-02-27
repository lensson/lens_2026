#!/bin/bash
# Sync realm-lens.json with Keycloak
# This script exports the current realm configuration from Keycloak and saves it locally

set -e

KEYCLOAK_URL="${KEYCLOAK_URL:-http://172.28.0.1:28080}"
REALM="${KEYCLOAK_REALM:-lens}"
ADMIN_USER="${KEYCLOAK_ADMIN_USERNAME:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:-admin}"
OUTPUT_FILE="../realm-lens.json"

echo "=========================================="
echo "  Sync Keycloak Realm Configuration"
echo "=========================================="
echo ""
echo "Keycloak: $KEYCLOAK_URL"
echo "Realm: $REALM"
echo "Output: $OUTPUT_FILE"
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

# Step 2: Export realm configuration
echo "Step 2: Exporting realm configuration..."
REALM_CONFIG=$(curl -s -X GET "$KEYCLOAK_URL/admin/realms/$REALM" \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Accept: application/json")

if [ -z "$REALM_CONFIG" ]; then
  echo "❌ Failed to export realm configuration"
  exit 1
fi

# Check if the response is valid JSON
echo "$REALM_CONFIG" | jq empty 2>/dev/null
if [ $? -ne 0 ]; then
  echo "❌ Invalid JSON response from Keycloak"
  echo "$REALM_CONFIG"
  exit 1
fi

echo "✅ Realm configuration exported"
echo ""

# Step 3: Backup existing file
if [ -f "$OUTPUT_FILE" ]; then
  BACKUP_FILE="${OUTPUT_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
  echo "Step 3: Backing up existing file..."
  cp "$OUTPUT_FILE" "$BACKUP_FILE"
  echo "✅ Backup created: $BACKUP_FILE"
  echo ""
fi

# Step 4: Save new configuration
echo "Step 4: Saving configuration..."
echo "$REALM_CONFIG" | jq '.' > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
  echo "✅ Configuration saved to $OUTPUT_FILE"
else
  echo "❌ Failed to save configuration"
  exit 1
fi

echo ""

# Step 5: Show summary
echo "=========================================="
echo "  Synchronization Complete"
echo "=========================================="
echo ""
echo "Realm: $REALM"
echo "File: $OUTPUT_FILE"
echo ""

# Count some key elements
NUM_CLIENTS=$(echo "$REALM_CONFIG" | jq '.clients | length' 2>/dev/null || echo "N/A")
NUM_USERS=$(echo "$REALM_CONFIG" | jq '.users | length' 2>/dev/null || echo "N/A")
NUM_ROLES=$(echo "$REALM_CONFIG" | jq '.roles.realm | length' 2>/dev/null || echo "N/A")

echo "Summary:"
echo "  - Clients: $NUM_CLIENTS"
echo "  - Users: $NUM_USERS"
echo "  - Realm Roles: $NUM_ROLES"
echo ""

if [ -f "$BACKUP_FILE" ]; then
  echo "Previous configuration backed up to:"
  echo "  $BACKUP_FILE"
  echo ""
fi

echo "✅ realm-lens.json is now synchronized with Keycloak!"
echo ""
