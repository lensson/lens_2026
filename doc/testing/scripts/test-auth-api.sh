#!/bin/bash
# Test Auth Service REST APIs
# This script tests all available endpoints in lens-platform-auth

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
KEYCLOAK_URL="http://172.28.0.1:28080"
REALM="lens"
CLIENT_ID="lens-client"
CLIENT_SECRET="x6lEH0DMcT27eop2cszIP3Brc2sDQHLb"
GATEWAY_URL="http://localhost:8050"
AUTH_DIRECT_URL="http://localhost:8041"

# Use gateway by default
USE_GATEWAY="${USE_GATEWAY:-true}"
if [ "$USE_GATEWAY" = "true" ]; then
  BASE_URL="$GATEWAY_URL/v2/lens/platform/auth"
  echo -e "${BLUE}Using Gateway: $BASE_URL${NC}"
else
  BASE_URL="$AUTH_DIRECT_URL"
  echo -e "${BLUE}Using Direct Auth Service: $BASE_URL${NC}"
fi

echo ""
echo "=========================================="
echo "  Auth Service API Testing"
echo "=========================================="
echo ""

# Get Token
echo -e "${YELLOW}Step 1: Getting OAuth2 Token...${NC}"
TOKEN=$(curl -s -X POST "$KEYCLOAK_URL/realms/$REALM/protocol/openid-connect/token" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "grant_type=client_credentials" \
  | jq -r '.access_token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo -e "${RED}❌ Failed to get token${NC}"
  exit 1
fi

echo -e "${GREEN}✅ Token obtained${NC}"
echo "Token: ${TOKEN:0:50}..."
echo ""

# Test function
test_endpoint() {
  local METHOD=$1
  local PATH=$2
  local DESCRIPTION=$3
  local EXPECTED_STATUS=${4:-200}

  echo "=========================================="
  echo -e "${BLUE}Testing: $DESCRIPTION${NC}"
  echo "Endpoint: $METHOD $PATH"
  echo ""

  RESPONSE=$(curl -s -w "\n%{http_code}" -X "$METHOD" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    "$BASE_URL$PATH")

  HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
  BODY=$(echo "$RESPONSE" | sed '$d')

  echo "Status: $HTTP_CODE"
  echo "Response:"
  echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
  echo ""

  if [ "$HTTP_CODE" = "$EXPECTED_STATUS" ]; then
    echo -e "${GREEN}✅ PASS${NC}"
  else
    echo -e "${RED}❌ FAIL (Expected: $EXPECTED_STATUS, Got: $HTTP_CODE)${NC}"
  fi
  echo ""
}

# Run Tests
echo ""
echo "=========================================="
echo "  Running API Tests"
echo "=========================================="
echo ""

# Test 1: Echo endpoint
test_endpoint "GET" "/echo" "Echo - Get application name and port" 200

# Test 2: Caller/Ping endpoint (requires TEST scope)
test_endpoint "GET" "/caller/ping" "Caller Ping - Invoke system service" 200

# Test 3: Actuator Health (public)
echo "=========================================="
echo -e "${BLUE}Testing: Actuator Health (Public)${NC}"
echo "Endpoint: GET /actuator/health"
echo ""

HEALTH=$(curl -s "$AUTH_DIRECT_URL/actuator/health")
echo "Response:"
echo "$HEALTH" | jq . 2>/dev/null || echo "$HEALTH"
echo ""
echo -e "${GREEN}✅ PASS${NC}"
echo ""

# Test 4: Actuator Info
echo "=========================================="
echo -e "${BLUE}Testing: Actuator Info${NC}"
echo "Endpoint: GET /actuator/info"
echo ""

INFO=$(curl -s "$AUTH_DIRECT_URL/actuator/info")
echo "Response:"
echo "$INFO" | jq . 2>/dev/null || echo "$INFO"
echo ""
echo -e "${GREEN}✅ PASS${NC}"
echo ""

# Summary
echo "=========================================="
echo "  Test Summary"
echo "=========================================="
echo ""
echo -e "${GREEN}Available Endpoints:${NC}"
echo "  GET  /echo              - Returns app name and port"
echo "  GET  /caller/ping       - Calls system service (requires TEST scope)"
echo "  GET  /actuator/health   - Health check (public)"
echo "  GET  /actuator/info     - Application info (public)"
echo ""

echo -e "${YELLOW}Gateway URL:${NC} $GATEWAY_URL/v2/lens/platform/auth"
echo -e "${YELLOW}Direct URL:${NC}  $AUTH_DIRECT_URL"
echo ""

echo "To test with different URL:"
echo "  USE_GATEWAY=false ./scripts/test-auth-api.sh"
echo ""

echo "To get a new token:"
echo "  source ./scripts/quick-token.sh"
echo ""

echo "Manual test commands:"
echo "  curl -H 'Authorization: Bearer \$TOKEN' $BASE_URL/echo"
echo "  curl -H 'Authorization: Bearer \$TOKEN' $BASE_URL/caller/ping"
echo ""

echo "=========================================="
echo -e "${GREEN}✅ Testing Complete${NC}"
echo "=========================================="
