#!/bin/bash
#
# Get OAuth2 Token from Keycloak
# Usage:
#   ./get-token.sh [client_id] [username]           # Password grant
#   ./get-token.sh [client_id] --client-credentials # Client credentials grant
#

set -e

# Default configuration
KEYCLOAK_URL="${KEYCLOAK_URL:-http://172.28.0.1:28080}"
REALM="${KEYCLOAK_REALM:-lens}"
CLIENT_ID="${1:-lens-client}"
USERNAME="${2}"
CLIENT_SECRET="${3:-x6lEH0DMcT27eop2cszIP3Brc2sDQHLb}"

# Check if client_credentials grant is requested
USE_CLIENT_CREDENTIALS=false
if [ "$USERNAME" = "--client-credentials" ] || [ "$USERNAME" = "-c" ]; then
  USE_CLIENT_CREDENTIALS=true
  USERNAME=""
fi

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "  Keycloak Token Retrieval"
echo "========================================"
echo ""
echo "Server: $KEYCLOAK_URL"
echo "Realm:  $REALM"
echo "Client: $CLIENT_ID"
echo ""

# Get username if not provided and not using client_credentials
if [ "$USE_CLIENT_CREDENTIALS" = false ] && [ -z "$USERNAME" ]; then
  read -p "Username: " USERNAME
fi

# Get password only for password grant
if [ "$USE_CLIENT_CREDENTIALS" = false ]; then
  read -sp "Password: " PASSWORD
  echo ""
fi

echo ""
echo "Getting token..."

# Use appropriate grant type
if [ "$USE_CLIENT_CREDENTIALS" = true ]; then
  echo "Using client_credentials grant (service-to-service)..."
  RESPONSE=$(curl -s -X POST "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "grant_type=client_credentials")
else
  echo "Using password grant (user login)..."
  RESPONSE=$(curl -s -X POST "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "username=$USERNAME" \
    -d "password=$PASSWORD" \
    -d "grant_type=password")
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
  echo -e "${RED}✗ jq is not installed. Install it with: sudo apt install jq${NC}"
  echo ""
  echo "Raw response:"
  echo "$RESPONSE"
  exit 1
fi

# Extract tokens
ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token')
REFRESH_TOKEN=$(echo "$RESPONSE" | jq -r '.refresh_token')
EXPIRES_IN=$(echo "$RESPONSE" | jq -r '.expires_in')
ERROR=$(echo "$RESPONSE" | jq -r '.error // empty')

if [ -n "$ERROR" ]; then
  ERROR_DESC=$(echo "$RESPONSE" | jq -r '.error_description // empty')
  echo -e "${RED}✗ Failed to get token!${NC}"
  echo ""
  echo "Error: $ERROR"
  echo "Description: $ERROR_DESC"
  exit 1
fi

if [ "$ACCESS_TOKEN" = "null" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo -e "${RED}✗ Failed to get token!${NC}"
  echo ""
  echo "Response:"
  echo "$RESPONSE" | jq .
  exit 1
fi

echo -e "${GREEN}✓ Token obtained successfully!${NC}"
echo ""
echo "========================================"
echo "  Token Information"
echo "========================================"
echo "Expires in: ${EXPIRES_IN} seconds ($(($EXPIRES_IN / 60)) minutes)"
echo ""
echo "Access Token (first 80 chars):"
echo "${ACCESS_TOKEN:0:80}..."
echo ""

# Decode and show token claims
echo "========================================"
echo "  Token Claims"
echo "========================================"
PAYLOAD=$(echo "$ACCESS_TOKEN" | cut -d'.' -f2)
# Add padding if needed
PADDING=$((4 - ${#PAYLOAD} % 4))
if [ $PADDING -ne 4 ]; then
  PAYLOAD="${PAYLOAD}$(printf '=%.0s' $(seq 1 $PADDING))"
fi
echo "$PAYLOAD" | base64 -d 2>/dev/null | jq . || echo "Could not decode token"
echo ""

# Export to environment
export TOKEN="$ACCESS_TOKEN"
export REFRESH_TOKEN="$REFRESH_TOKEN"

echo "========================================"
echo "  Usage Examples"
echo "========================================"
echo ""
echo "Token exported to \$TOKEN variable. Use it like:"
echo ""
echo -e "${YELLOW}# Test Gateway public endpoint:${NC}"
echo "curl http://localhost:8050/actuator/health"
echo ""
echo -e "${YELLOW}# Test Gateway protected endpoint:${NC}"
echo "curl -H \"Authorization: Bearer \$TOKEN\" \\"
echo "  http://localhost:8050/v2/lens/platform/auth/test"
echo ""
echo -e "${YELLOW}# Save token to file:${NC}"
echo "echo \$TOKEN > token.txt"
echo ""
echo -e "${YELLOW}# Use in environment:${NC}"
echo "export TOKEN='$ACCESS_TOKEN'"
echo ""
echo "========================================"
echo ""
echo -e "${GREEN}Full access token:${NC}"
echo "$ACCESS_TOKEN"
echo ""
